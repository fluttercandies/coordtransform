import 'coordtransform.dart';

void main() {
  CoordResult result;
  result = CoordTransform.transformBD09toGCJ02(116.404, 39.915);
  print("${result.lon} ${result.lat}");
  result = CoordTransform.transformGCJ02toBD09(116.404, 39.915);
  print("${result.lon} ${result.lat}");
  result = CoordTransform.transformWGS84toGCJ02(116.404, 39.915);
  print("${result.lon} ${result.lat}");
  result = CoordTransform.transformGCJ02toWGS84(116.404, 39.915);
  print("${result.lon} ${result.lat}");
  result = CoordTransform.transformBD09toWGS84(116.404, 39.915);
  print("${result.lon} ${result.lat}");
  result = CoordTransform.transformWGS84toBD09(116.404, 39.915);
  print("${result.lon} ${result.lat}");
}
