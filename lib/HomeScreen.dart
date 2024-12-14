import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intern_varun/ModelShow.dart';
import 'package:intern_varun/ShowDetails.dart';

class ShowListScreen extends StatefulWidget {
  @override
  _ShowListScreenState createState() => _ShowListScreenState();
}

class _ShowListScreenState extends State<ShowListScreen> {
  List<Show> _shows = [];
  bool _isLoading = true;
  bool _isFetching = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchShows();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchShows({String query = 'all'}) async {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _shows = data.map((item) => Show.fromJson(item['show'])).toList();
          _isLoading = false;
          _isFetching = false;
        });
      } else {
        throw Exception('Failed to load shows');
      }
    } catch (e) {
      setState(() {
        _isFetching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchShows(); // Fetch more data when reaching the bottom
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching search results
      _shows.clear(); // Clear current shows
    });
    _fetchShows(query: query); // Fetch shows with the new search query
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("TV Shows"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ShowSearchDelegate());
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.6,
              ),
              itemCount: _shows.length + 1,
              itemBuilder: (context, index) {
                if (index == _shows.length) {
                  return _isFetching
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }

                final show = _shows[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowDetailsPage(show: show),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (show.imageUrl != null)
                            ? Image.network(
                                show.imageUrl!,
                                width: double.infinity,
                                height: screenHeight * 0.25,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 100),
                              )
                            : Icon(Icons.image_not_supported, size: 100),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            show.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: screenHeight * 0.014,
                                color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            show.summary.length > 80
                                ? show.removeHtmlTags(show.summary) + '...'
                                : show.removeHtmlTags(show.summary),
                            style: TextStyle(
                              fontSize: screenHeight * 0.01,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ShowSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search Shows...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _fetchShows(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching results'));
        }

        final List<Show> shows = snapshot.data as List<Show>;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6,
          ),
          itemCount: shows.length,
          itemBuilder: (context, index) {
            final show = shows[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowDetailsPage(show: show),
                  ),
                );
              },
              child: Card(
                elevation: 4.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (show.imageUrl != null)
                        ? Image.network(
                            show.imageUrl!,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 100),
                          )
                        : Icon(Icons.image_not_supported, size: 100),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        show.name,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Show>> _fetchShows(String query) async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Show.fromJson(item['show'])).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(child: Text('Search for TV shows'));
  }
}
