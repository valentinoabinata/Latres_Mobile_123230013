class ShowModel {
  final int id;
  final String name;
  final String? imageUrl;
  final double? rating;
  final List<String> genres;
  final String? summary;
  final String? network;
  final String? status;
  final String? premiered;
  final String? url;

  ShowModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.rating,
    required this.genres,
    this.summary,
    this.network,
    this.status,
    this.premiered,
    this.url,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    // Ekstrak field nested dari JSON
    final image = json['image'] != null ? json['image']['medium'] as String? : null;
    final avgRating = json['rating'] != null ? json['rating']['average'] : null;
    final networkName = json['network'] != null ? json['network']['name'] as String? : null;

    return ShowModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '-',
      imageUrl: image,
      // Konversi rating ke double
      rating: avgRating != null ? (avgRating as num).toDouble() : null,
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      summary: json['summary'] as String?,
      network: networkName,
      status: json['status'] as String?,
      premiered: json['premiered'] as String?,
      url: json['url'] as String?,
    );
  }
}
