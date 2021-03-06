import 'dart:developer';

import 'package:chefcookbook/blockchain/blockchain.dart';
import 'package:chefcookbook/components/rounded_button.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:chefcookbook/constants.dart' as constant;
import 'package:flutter/material.dart';
import 'package:chefcookbook/service/client_sdk_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../blockchain/block.dart';
import '../blockchain/blockchain.dart';
import '../blockchain/uploads.dart';


// ignore: must_be_immutable
class DishScreen extends StatelessWidget {
  static final String id = "add_dish";
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String? _content;


  final String blockchainKey = 'blockchain';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Upload'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        // child: Hero(
                        //   tag: 'choice chef',
                        //   child: SizedBox(
                        //     height: 120,
                        //     child: Image.asset(
                        //       'assets/chef.png',
                        //     ),
                        //   ),
                        // ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.approval),
                          hintText: 'Input string',
                          labelText: 'Content',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Empty' : null,
                        onChanged: (value) {
                          _content = value;
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      RoundedButton(
                        text: 'Upload',
                        color: Color(0XFF7B3F00),
                        path: () => _update(context),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  // Add a key/value pair to the logged-in secondary server.
  // Passing multiple key values to be cached in a secondary server
  _update(BuildContext context) async {
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    String? atSign = clientSdkService.atsign;

    Blockchain blockChain = clientSdkService.getBlockchain();
    blockChain.newUpload(atSign!, _content!);
    // clientSdkService.setBlockChain(blockChain);
    print(blockChain.printChain().toString());


    // If all of the necessary text form fields have been properly
    // populated
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      // The information inputted by the authenticated atsign
      // Each field's value is separated by a constant.splitter
      // which is defined as @_@ so when a recipe is shared and received by
      // another secondary server, the at_cookbook app will understand how to
      // distribute the values correctly into their respectful fields
      // String _values = _description! + constant.splitter + _ingredients!;

      // If the authenticated atsign did not provide an image URL,
      // we automatically add the image with the question mark as
      // an image is required to be passed through
      // if (_imageURL != null) {
      //   _values += constant.splitter + _imageURL!;
      // }

      // Instantiating an AtKey object and specifying its attributes with the
      // recipe title and the atsign that created it
      AtKey atKey = AtKey();
      atKey.key = _content;
      atKey.sharedWith = atSign;

      // Utilizing the put method to take the AtKey object and its values
      // and 'put' it on the secondary server of the authenticated atsign
      // (the atsign currently logged in)
      await clientSdkService.put(atKey, _content!);

      AtKey atKey_blockChain = AtKey();
      atKey_blockChain.key = blockChain.printChain().toString();
      atKey_blockChain.sharedWith = atSign;


      await clientSdkService.put(atKey_blockChain, blockChain.printChain().toString());

      sendBlockChain();
      // This will take the authenticated atsign from the add_dish page back
      // to the home screen
      Navigator.pop(context);
    } else {
      // If the authenticated atsign has not properly populated the
      // text form fields, this statement will be printed
      print('Not all text fields have been completed!');
    }
  }


  Future<void> sendBlockChain() async {
    // await setChatHistory(Message(
    //     message: message,
    //     sender: currentAtSign,
    //     time: DateTime.now().millisecondsSinceEpoch,
    //     type: MessageType.OUTGOING));
    ClientSdkService clientSdkService = ClientSdkService.getInstance();
    Blockchain temp = clientSdkService.getBlockchain();

    List<String> allAtSigns = [];

    String message = temp.printChain().toString();

    log("SEND BLOCKCHAIN MESSAGE: $message");
    for(Block block in temp.chain){
      allAtSigns.add(block.atSign);
    }

    log("SEND BLOCKCHAIN ALLATSIGNS:" + allAtSigns.toString());


    for(String chatWithAtSign in allAtSigns) {
      var atKey = AtKey()
        ..metadata = Metadata()
        ..metadata?.ttr = -1
        ..key = blockchainKey +  DateTime.now().millisecondsSinceEpoch.toString();
      atKey.sharedWith = chatWithAtSign;
      atKey.sharedBy = clientSdkService.getAtSign() as String?;

      log("SEND BLOCKCHAIN KEY:"+atKey.key!);

      var result = await clientSdkService.put(atKey, message);
      print('send notification => $result');
    }
  }
}
