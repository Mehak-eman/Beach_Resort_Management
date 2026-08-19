class FilterModel {
  final String? location;
  final double? maxPrice;
  final double? minRating;
  final String? category;

  const FilterModel({
    this.location,
    this.maxPrice,
    this.minRating,
    this.category,
  });

  FilterModel copyWith({
    String? location,
    double? maxPrice,
    double? minRating,
    String? category,
  }) {
    return FilterModel(
      location: location ?? this.location,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      category: category ?? this.category,
    );
  }
}