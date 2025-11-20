// Used to ensure that classes used with extensions of BaseDao objects have the necessary toMap method

abstract class Storable {
  int? id;
  Map<String, Object?> toMap();
}