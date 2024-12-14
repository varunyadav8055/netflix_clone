import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intern_varun/ModelShow.dart';

class ShowDetailsPage extends StatelessWidget {
  final Show show;

  ShowDetailsPage({required this.show});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,  // Set background color to black
      appBar: AppBar(
        title: Text(show.name),
        backgroundColor: Colors.black,  // Set app bar background color to black
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Align all content to the left
          children: [
            Center(  // Center the image
              child: (show.imageUrl != null)
                  ? Image.network(
                      show.imageUrl!,
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.6,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.image_not_supported, size: screenHeight * 0.3, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              show.name,
              style: TextStyle(
                fontSize: screenWidth * 0.095,  // Decreased the font size slightly
                fontWeight: FontWeight.bold,
                color: Colors.white,  // Set text color to white
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _launchURL(show.officialSite!);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight*0.02, horizontal: screenWidth*0.2),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Play',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Type: ${show.type}",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            Text(
              "Language: ${show.language}",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            Text(
              "Genres: ${show.genres.join(', ')}",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            Text(
              "Premiered: ${show.premiered}",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            Text(
              "Status: ${show.status}",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            Text(
              "Runtime: ${show.runtime} minutes",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            SizedBox(height: 8),
            Text(
              "Rating: ${show.rating != null ? show.rating.toString() : 'N/A'}",
              style: TextStyle(fontSize: screenWidth * 0.048, color: Colors.white),  // Decreased font size
            ),
            SizedBox(height: 16),
            if (show.officialSite != null) ...[
              Text(
                "Official Site: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.048,  // Decreased font size
                  color: Colors.white,
                ),
              ),
            ],
            SizedBox(height: 16),
            Text(
              "Summary",
              style: TextStyle(
                fontSize: screenWidth * 0.058,  // Decreased font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              show.removeHtmlTags(show.summary),
              style: TextStyle(fontSize: screenWidth * 0.038, color: Colors.white),  // Decreased font size
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // Implement opening the URL here, using url_launcher package
  }
}
