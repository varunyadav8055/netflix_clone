import 'package:html/parser.dart' as html_parser;
class Show {
  final int id;
  final String name;
  final String type;
  final String language;
  final List<String> genres;
  final String status;
  final int runtime;
  final String premiered;
  final String? officialSite;
  final double? rating;
  final String summary;
  final String? imageUrl;

  Show({
    required this.id,
    required this.name,
    required this.type,
    required this.language,
    required this.genres,
    required this.status,
    required this.runtime,
    required this.premiered,
    this.officialSite,
    this.rating,
    required this.summary,
    this.imageUrl,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      name: json['name'],
      type: json['type'] ?? 'Unknown',
      language: json['language'] ?? 'Unknown',
      genres: List<String>.from(json['genres'] ?? []),
      status: json['status'] ?? 'Unknown',
      runtime: json['runtime'] ?? 0,
      premiered: json['premiered'] ?? 'Unknown',
      officialSite: json['officialSite'],
      rating: (json['rating']?['average'] as num?)?.toDouble(),
      summary: json['summary'] ?? 'No summary available.',
      imageUrl: json['image']?['medium'],
    );
  }

  // Public method to remove HTML tags from the summary
  String removeHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';  // Extract text content
  }
}