import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'uploads.dart';
import 'block.dart';
import 'dart:collection';
import 'dart:convert';

class Blockchain {
  final List<Block> _chain;
  final List<Upload> _currentUploaded;

  Blockchain(String rootBlock, String prehash)
      : _chain = [],
        _currentUploaded = [] {
    // create genesis block
    newBlock(rootBlock,prehash);
  }

  Block newBlock(String atSign,String previousHash) {
    if (previousHash == null) {
      previousHash = hash(_chain.last);
    }

    var block = new Block(
      atSign,
      // new DateTime.now().millisecondsSinceEpoch,
      _currentUploaded,
      previousHash,
    );

    _chain.add(block);

    return block;
  }


  List<Block> get chain => _chain;

  void newUpload(String sender, String data) {
    _currentUploaded.add(new Upload(sender, data));
  }

  Block get lastBlock {
    return _chain.last;
  }

  bool containAtSign(String atSign) {
    for(Block block in _chain){
      if(block.atSign == atSign){
        print('TEST ATSIGN'+block.atSign);
        return true;
      }
    }
    return false;
  }

  void removeBlock(String atSign) async {
    for(Block block in _chain){
      if(block.atSign == atSign){
        _chain.remove(block);
      }
    }
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
