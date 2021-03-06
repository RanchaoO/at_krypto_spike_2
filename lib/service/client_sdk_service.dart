// import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_commons/at_commons.dart';
// import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import '../utils/constants.dart' as conf;
// import 'package:at_client/src/util/encryption_util.dart';

import '../blockchain/block.dart';
import '../blockchain/blockchain.dart';
import '../blockchain/uploads.dart';
import 'dart:convert';


class ClientSdkService {
  static final ClientSdkService _singleton = ClientSdkService._internal();

  static List<Blockchain> blockchains = [];
  static Blockchain blockchain = new Blockchain(ClientSdkService.getInstance().getAtSign().toString(),"1");

  ClientSdkService._internal();

  // addBlock(){
  //   blockchain.newBlock();
  // }
  //

  getBlockchain(){
    return blockchain;
  }

  setBlockChain(Blockchain bc) {
    blockchain = bc;
  }

  decodeJSON(String inputStr){
    log('TEST INPUTSTR: '+ inputStr);
    // String modifiedText = inputStr.replaceAll("\\b(\\p{L}+)\\b", "\"$1");

    // JsonCodec codec = new JsonCodec();
    // var body = codec.decode(inputStr);

    List<String> body = inputStr.split("{");
    int count = 0;
    for(String str in body){
      print('String TEST: $count:::: '+str);
      count++;
    }
    var atSignStr;
    var atSignStrs = [];
    var prevHashs = [];
    for(String str in body){

      if(str.contains("atSign")){
        var StrArr1 = str.split(" ");
        atSignStr = StrArr1[1].substring(0, StrArr1[1].length - 1);
        atSignStrs.add(atSignStr);
        print(" atSignStr:::::: $atSignStr");
      }

      if(str.contains("prevHash")){
        var strArr2 = str.split("prevHash: ");
        print(" prevHash:::::: "+strArr2[1].substring(0, strArr2[1].indexOf('}')));
        prevHashs.add(strArr2[1].substring(0, strArr2[1].indexOf('}')));
      }
    }

    for(var i=0; i<atSignStrs.length;i++){
      var check =blockchain.containAtSign(atSignStrs[i]);
      if(check!=true) {
        blockchain.newBlock(atSignStrs[i], prevHashs[i]);
      }
    }

    print(" atSignStrs SIZE::::::" +atSignStrs.length.toString());


    print(" blockchain_local::::::" + blockchain.printChain().toString());


    // log('TEST BODY: '+ body.toString());

    // if(body['chain']){
    //   for(var sub in body){
    //     log('TEST SUB: '+ blockchain.printChain().toString());
    //     var sub_json = jsonDecode(sub);
    //     blockchain.newBlock(sub_json['atSign'], sub_json['prevHash']);
    //     var uploads  = jsonDecode(sub_json['uploads']) as List;
    //     for(var upload in sub['uploads']){
    //       var upload_json = jsonDecode(upload);
    //       blockchain.newUpload(upload_json['uploader'], upload_json['data']);
    //     }
    //   }

      // log('TEST DECODE: '+ blockchain.printChain().toString());
    // }
  }

  factory ClientSdkService.getInstance() {
    return _singleton;
  }

  AtClientService? atClientServiceInstance;
  AtClientImpl? atClientInstance;
  Map<String?, AtClientService> atClientServiceMap = {};
  String? atsign;

  _reset() {
    atClientServiceInstance = null;
    atClientInstance = null;
    atClientServiceMap = {};
    atsign = null;
  }

  _sync() async {
    await _getAtClientForAtsign()!.getSyncManager()!.sync();
  }

  AtClientImpl? _getAtClientForAtsign({String? atsign}) {
    atsign ??= this.atsign;
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign]!.atClient;
    }
    return null;
  }

  AtClientService _getClientServiceForAtSign(String? atsign) {
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign]!;
    }
    return AtClientService();
  }

  Future<AtClientPreference> getAtClientPreference({String? cramSecret}) async {
    final appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    var _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = conf.MixedConstants.NAMESPACE
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = conf.MixedConstants.ROOT_DOMAIN
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  _checkAtSignStatus(String atsign) async {
    var atStatusImpl = AtStatusImpl(rootUrl: conf.MixedConstants.ROOT_DOMAIN);
    var status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  ///Returns `false` if fails in authenticating [atsign] with [cramSecret]/[privateKey].
  //

  // String encryptKeyPairs(String atsign) {
  //   var encryptedPkamPublicKey = EncryptionUtil.encryptValue(
  //       at_demo_data.pkamPublicKeyMap[atsign], at_demo_data.aesKeyMap[atsign]);
  //   var encryptedPkamPrivateKey = EncryptionUtil.encryptValue(
  //       at_demo_data.pkamPrivateKeyMap[atsign], at_demo_data.aesKeyMap[atsign]);
  //   var aesencryptedPkamPublicKey = EncryptionUtil.encryptValue(
  //       at_demo_data.encryptionPublicKeyMap[atsign],
  //       at_demo_data.aesKeyMap[atsign]);
  //   var aesencryptedPkamPrivateKey = EncryptionUtil.encryptValue(
  //       at_demo_data.encryptionPrivateKeyMap[atsign],
  //       at_demo_data.aesKeyMap[atsign]);
  //   var aesEncryptedKeys = {};
  //   aesEncryptedKeys[BackupKeyConstants.AES_PKAM_PUBLIC_KEY] =
  //       encryptedPkamPublicKey;
  //
  //   aesEncryptedKeys[BackupKeyConstants.AES_PKAM_PRIVATE_KEY] =
  //       encryptedPkamPrivateKey;
  //
  //   aesEncryptedKeys[BackupKeyConstants.AES_ENCRYPTION_PUBLIC_KEY] =
  //       aesencryptedPkamPublicKey;
  //
  //   aesEncryptedKeys[BackupKeyConstants.AES_ENCRYPTION_PRIVATE_KEY] =
  //       aesencryptedPkamPrivateKey;
  //
  //   var keyString = jsonEncode(Map<String, String>.from(aesEncryptedKeys));
  //   return keyString;
  // }

  Future<String> get(AtKey atKey) async {
    var result = await _getAtClientForAtsign()!.get(atKey);
    return result.value;
  }

  Future<bool> put(AtKey atKey, String value) async {
    return await _getAtClientForAtsign()!.put(atKey, value);
  }

  Future<bool> delete(AtKey atKey) async {
    return await _getAtClientForAtsign()!.delete(atKey);
  }

  Future<List<AtKey>> getAtKeys(String regex, {String? sharedBy}) async {
    return await _getAtClientForAtsign()!
        .getAtKeys(regex: conf.MixedConstants.NAMESPACE, sharedBy: sharedBy);
  }

  ///Fetches atsign from device keychain.
  Future<String?> getAtSign() async {
    return await atClientServiceInstance!.getAtSign();
  }

  deleteAtSignFromKeyChain() async {
    // List<String> atSignList = await getAtsignList();
    String atsign = atClientServiceInstance!.atClient!.currentAtSign!;

    await atClientServiceMap[atsign]!.deleteAtSignFromKeychain(atsign);

    _reset();
  }

  Future<bool> notify(
      AtKey atKey, String value, OperationEnum operation) async {
    return await _getAtClientForAtsign()!.notify(atKey, value, operation);
  }
}
