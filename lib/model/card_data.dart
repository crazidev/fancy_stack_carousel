class CardData {
  const CardData({
    required this.id,
    required this.image,
    this.offset = 0,
    required this.artName,
    required this.artistName,
    required this.artistImage,
  });

  /// Identifier
  final int id;

  /// Asset
  final String image;

  final double offset;

  final String artName;

  final String artistName;

  final String artistImage;

  CardData copyWith({
    int? id,
    String? image,
    double? offset,
    String? artName,
    String? artistName,
    String? artistImage,
  }) {
    return CardData(
      id: id ?? this.id,
      image: image ?? this.image,
      offset: offset ?? this.offset,
      artName: artName ?? this.artName,
      artistName: artistName ?? this.artistName,
      artistImage: artistImage ?? this.artistImage,
    );
  }
}
