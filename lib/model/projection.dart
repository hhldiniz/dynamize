class Projection {
  ProjectionType projectionType;
  List<String> nonKeyAttributes;

  Projection(this.projectionType, this.nonKeyAttributes);

}

enum ProjectionType {
  include,
  all,
  keysOnly
}