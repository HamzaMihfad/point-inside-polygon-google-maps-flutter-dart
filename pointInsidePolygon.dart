import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// A Dart program to check if a given point
// lies inside a given polygon

// How to check if two given line segments intersect: https://www.youtube.com/watch?v=wCR48FqkI4w
// Refer https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
// for explanation of functions onSegment(),
// orientation() and doIntersect()

class PolygonPoint {
  // Define Infinite (Using INT_MAX
  // caused overflow problems)
  static const double infinity = 1.0 / 0.0;

  // Given three collinear points p, q, r,
  // the function checks if point q lies
  // on line segment 'pr'
  bool onSegment(LatLng p, LatLng q, LatLng r) {
    if (q.latitude <= max(p.latitude, r.latitude) &&
        q.latitude >= min(p.latitude, r.latitude) &&
        q.longitude <= max(p.longitude, r.longitude) &&
        q.longitude >= min(p.longitude, r.longitude)) {
      return true;
    }
    return false;
  }

  // To find orientation of ordered triplet (p, q, r).
  // The function returns following values
  // 0 --> p, q and r are collinear
  // 1 --> Clockwise
  // 2 --> Counterclockwise
  int orientation(LatLng p, LatLng q, LatLng r) {
    double val = (q.longitude - p.longitude) * (r.latitude - q.latitude) -
        (q.latitude - p.latitude) * (r.longitude - q.longitude);

    if (val == 0) {
      return 0; // collinear
    }
    return (val > 0) ? 1 : 2; // clock or counter clock wise
  }

  // The function that returns true if
  // line segment 'p1q1' and 'p2q2' intersect.
  bool doIntersect(LatLng p1, LatLng q1, LatLng p2, LatLng q2) {
    // Find the four orientations needed for
    // general and special cases
    int o1 = orientation(p1, q1, p2);
    int o2 = orientation(p1, q1, q2);
    int o3 = orientation(p2, q2, p1);
    int o4 = orientation(p2, q2, q1);

    // General case
    if (o1 != o2 && o3 != o4) {
      return true;
    }

    // Special Cases
    // p1, q1 and p2 are collinear and
    // p2 lies on segment p1q1
    if (o1 == 0 && onSegment(p1, p2, q1)) {
      return true;
    }

    // p1, q1 and p2 are collinear and
    // q2 lies on segment p1q1
    if (o2 == 0 && onSegment(p1, q2, q1)) {
      return true;
    }

    // p2, q2 and p1 are collinear and
    // p1 lies on segment p2q2
    if (o3 == 0 && onSegment(p2, p1, q2)) {
      return true;
    }

    // p2, q2 and q1 are collinear and
    // q1 lies on segment p2q2
    if (o4 == 0 && onSegment(p2, q1, q2)) {
      return true;
    }

    // Doesn't fall in any of the above cases
    return false;
  }

  // Returns true if the point p lies
  // inside the polygon with n vertices
  bool isInside(List<LatLng> polygon, LatLng p) {
    // There must be at least 3 vertices in polygon
    if (polygon.length < 3) {
      return false;
    }

    // Create a point for line segment from p to infinite
    LatLng extreme = LatLng(infinity, p.longitude);

    // Count intersections of the above line
    // with sides of polygon
    int count = 0, i = 0;
    do {
      int next = (i + 1) % polygon.length;

      // Check if the line segment from 'p' to
      // 'extreme' intersects with the line
      // segment from 'polygon[i]' to 'polygon[next]'
      if (doIntersect(polygon[i], polygon[next], p, extreme)) {
        // If the point 'p' is collinear with line
        // segment 'i-next', then check if it lies
        // on segment. If it lies, return true, otherwise false
        if (orientation(polygon[i], p, polygon[next]) == 0) {
          return onSegment(polygon[i], p, polygon[next]);
        }

        count++;
      }
      i = next;
    } while (i != 0);

    // Return true if count is odd, false otherwise
    return (count % 2 == 1); // Same as (count%2 == 1)
  }
}

// This code is contributed by Hamza Mihfad
