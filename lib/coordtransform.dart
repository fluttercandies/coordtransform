library coordtransform;

import 'dart:math';

// WGS84坐标系：即地球坐标系，国际上通用的坐标系。
// GCJ02坐标系：即火星坐标系，WGS84坐标系经加密后的坐标系。Google Maps，高德在用。
// BD09坐标系：即百度坐标系，GCJ02坐标系经加密后的坐标系。

const double X_PI = pi * 3000.0 / 180.0;
const double OFFSET = 0.00669342162296594323;
const double AXIS = 6378245.0;

/// Coord Transform Result
class CoordResult {
  double lon, lat;

  CoordResult(this.lon, this.lat);
}

class _TransformTmp {
  double x, y;

  _TransformTmp(this.x, this.y);
}

/// CoordTransform.
class CoordTransform {
  const CoordTransform._();

  /// transform BD09 to GCJ02 百度坐标系->火星坐标系
  static CoordResult transformBD09toGCJ02(double lon, double lat) {
    double x = lon - 0.0065;
    double y = lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * X_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * X_PI);
    return CoordResult(z * cos(theta), z * sin(theta));
  }

  /// transform GCJ02 to BD09 火星坐标系->百度坐标系
  static CoordResult transformGCJ02toBD09(double lon, double lat) {
    double z = sqrt(lon * lon + lat * lat) + 0.00002 * sin(lat * X_PI);
    double theta = atan2(lat, lon) + 0.000003 * cos(lon * X_PI);
    return CoordResult(z * cos(theta) + 0.0065, z * sin(theta) + 0.006);
  }

  /// transform WGS84 to GCJ02 WGS84坐标系->火星坐标系
  static CoordResult transformWGS84toGCJ02(double lon, double lat) {
    return isOutOFChina(lon, lat) ? CoordResult(lon, lat) : delta(lon, lat);
  }

  /// transform GCJ02 to WGS84 火星坐标系->WGS84坐标系
  static CoordResult transformGCJ02toWGS84(double lon, double lat) {
    if (isOutOFChina(lon, lat)) return CoordResult(lon, lat);
    CoordResult _res = delta(lon, lat);
    return CoordResult(lon * 2 - _res.lon, lat * 2 - _res.lat);
  }

  /// transform BD09 to WGS84 百度坐标系->WGS84坐标系
  static CoordResult transformBD09toWGS84(double lon, double lat) {
    CoordResult _tmp = transformBD09toGCJ02(lon, lat);
    return transformGCJ02toWGS84(_tmp.lon, _tmp.lat);
  }

  /// transform WGS84 to BD09 WGS84坐标系->百度坐标系
  static CoordResult transformWGS84toBD09(double lon, double lat) {
    CoordResult _tmp = transformWGS84toGCJ02(lon, lat);
    return transformGCJ02toBD09(_tmp.lon, _tmp.lat);
  }

  static CoordResult delta(double lon, double lat) {
    _TransformTmp _tmp = transform(lon - 105.0, lat - 35.0);
    double dlat = _tmp.x, dlon = _tmp.y;
    double radlat = lat / 180.0 * pi;
    double magic = sin(radlat);
    magic = 1 - OFFSET * magic * magic;
    double sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) / ((AXIS * (1 - OFFSET)) / (magic * sqrtmagic) * pi);
    dlon = (dlon * 180.0) / (AXIS / sqrtmagic * cos(radlat) * pi);
    return CoordResult(lon + dlon, lat + dlat);
  }

  static _TransformTmp transform(double lon, double lat) {
    double lonlat = lon * lat;
    var absX = sqrt(lon.abs());
    double lonPi = lon * pi, latPi = lat * pi;
    double d = 20.0 * sin(6.0 * lonPi) + 20.0 * sin(2.0 * lonPi);
    double x = d, y = d;
    x += 20.0 * sin(latPi) + 40.0 * sin(latPi / 3.0);
    y += 20.0 * sin(lonPi) + 40.0 * sin(lonPi / 3.0);
    x += 160.0 * sin(latPi / 12.0) + 320 * sin(latPi / 30.0);
    y += 150.0 * sin(lonPi / 12.0) + 300.0 * sin(lonPi / 30.0);
    x *= 2.0 / 3.0;
    y *= 2.0 / 3.0;
    x += -100.0 +
        2.0 * lon +
        3.0 * lat +
        0.2 * lat * lat +
        0.1 * lonlat +
        0.2 * absX;
    y += 300.0 + lon + 2.0 * lat + 0.1 * lon * lon + 0.1 * lonlat + 0.1 * absX;
    return _TransformTmp(x, y);
  }

  static bool isOutOFChina(double lon, double lat) {
    return !(lon > 72.004 && lon < 135.05 && lat > 3.86 && lat < 53.55);
  }
}
