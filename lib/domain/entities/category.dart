import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? image;
  final int count;

  const Category({
    required this.id,
    required this.name,
    this.image,
    this.count = 0,
  });

  @override
  List<Object?> get props => [id, name, image, count];
}