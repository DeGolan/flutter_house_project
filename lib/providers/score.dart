class Score implements Comparable {
  final String _name;
  final int _points;
  int get points {
    return _points;
  }

  String get name {
    return _name;
  }

  Score(this._name, this._points);
  @override
  int compareTo(other) {
    if (other == null) {
      return 0;
    }
    if (_points < other.points) {
      return -1;
    }
    return 1;
  }
}
