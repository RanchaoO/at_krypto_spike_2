import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'uploads.dart';
import 'block.dart';
import 'dart:collection';
import 'dart:convert';

class Blockchain {
  final List<Block> _chain;
  final List<Upload> _currentUploaded;

  Blockchain()
      : _chain = [],
        _currentUploaded = [] {
    // create genesis block
    newBlock("1");
  }

  Block newBlock(String previousHash) {
    if (previousHash == null) {
      previousHash = hash(_chain.last);
    }

    var block = new Block(
      _chain.length,
      new DateTime.now().millisecondsSinceEpoch,
      _currentUploaded,
      previousHash,
    );

    _chain.add(block);

    return block;
  }

  int newUpload(String sender, String data) {
    _currentUploaded.add(new Upload(sender, data));
    return lastBlock.index + 1;
  }

  Block get lastBlock {
    return _chain.last;
  }

  Map<String,dynamic> printChain() {
    var m = new LinkedHashMap<String, dynamic>();

    m['chain'] = _chain.map((t) => t.toJson()).toList();
    m['length'] = _chain.length;

    // for (Block b in _chain) {
    //   print(b.toJson().toString());
    // }
    return m;
  }

  String hash(Block block) {
    var blockStr = json.encode(block.toJson());
    var bytes = utf8.encode(blockStr);
    var converted = sha512.convert(bytes).bytes;
    return HEX.encode(converted);
  }

}
