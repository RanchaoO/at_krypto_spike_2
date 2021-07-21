import 'dart:collection';
import 'uploads.dart';

class Block {
  final int index;
  final int timestamp;
  final List<Upload> uploads;
  final String prevHash;
  Block(this.index, this.timestamp, this.uploads, this.prevHash);

  Map<String, dynamic> toJson() {
    // keys must be ordered for consistent hashing
    var m = new LinkedHashMap<String, dynamic>();

    m['index'] = index;
    m['timestamp'] = timestamp;
    m['uploads'] = uploads.map((t) => t.toJson()).toList();
    m['prevHash'] = prevHash;
    return m;
  }

}