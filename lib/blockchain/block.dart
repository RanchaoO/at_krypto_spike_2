import 'dart:collection';
import 'uploads.dart';

class Block {
  final String atSign;
  final int timestamp;
  final List<Upload> uploads;
  final String prevHash;
  Block(this.atSign, this.timestamp, this.uploads, this.prevHash);

  Map<String, dynamic> toJson() {
    // keys must be ordered for consistent hashing
    var m = new LinkedHashMap<String, dynamic>();

    m['atSign'] = atSign;
    m['timestamp'] = timestamp;
    m['uploads'] = uploads.map((t) => t.toJson()).toList();
    m['prevHash'] = prevHash;
    return m;
  }

}