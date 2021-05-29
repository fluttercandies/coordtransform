# coordtransform

Coord transform tool

提供百度坐标系(BD-09)、火星坐标系(国测局坐标系、GCJ02)、WGS84坐标系的相互转换。

## Getting Started
```dart
    CoordResult result;
    result = CoordTransform.transformBD09toGCJ02(116.404, 39.915);
    print("BD09toGCJ02 ${result.lon} ${result.lat}");
    result = CoordTransform.transformGCJ02toBD09(116.404, 39.915);
    print("GCJ02toBD09 ${result.lon} ${result.lat}");
    result = CoordTransform.transformWGS84toGCJ02(116.404, 39.915);
    print("WGS84toGCJ02 ${result.lon} ${result.lat}");
    result = CoordTransform.transformGCJ02toWGS84(116.404, 39.915);
    print("GCJ02toWGS84 ${result.lon} ${result.lat}");
    result = CoordTransform.transformBD09toWGS84(116.404, 39.915);
    print("BD09toWGS84 ${result.lon} ${result.lat}");
    result = CoordTransform.transformWGS84toBD09(116.404, 39.915);
    print("WGS84toBD09 ${result.lon} ${result.lat}");
```
