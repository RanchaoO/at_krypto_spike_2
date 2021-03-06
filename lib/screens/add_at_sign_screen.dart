import 'dart:developer';

import 'package:at_chat_flutter/at_chat_flutter.dart';
import 'package:flutter/material.dart';
import '../service/client_sdk_service.dart';
// import 'third_screen.dart';
import '../utils/constants.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:at_commons/at_commons.dart';
import 'package:at_chat_flutter/models/message_model.dart';
import 'package:chefcookbook/service/client_sdk_service.dart';
import '../blockchain/block.dart';
import '../blockchain/blockchain.dart';
import '../blockchain/uploads.dart';



class AddAtSignScreen extends StatefulWidget {
  static final String id = 'second';
  @override
  _AddAtSignScreenState createState() => _AddAtSignScreenState();
}

class _AddAtSignScreenState extends State<AddAtSignScreen> {
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String activeAtSign = '';
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<String>?  atSigns;
  String?  chatWithAtSign;
  bool showOptions = false;
  bool isEnabled = true;
  String atSign = ClientSdkService.getInstance().getAtSign().toString();


  final String blockchainKey = 'blockchain';

  @override
  void initState() {
    // TODO: Call function to initialize chat service.
    getAtSignAndInitializeChat();
    scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                'Welcome $activeAtSign!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     showDialog(
            //         barrierDismissible: true,
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             title: Row(
            //               children: [Text('Delete $activeAtSign')],
            //             ),
            //             content: Text('Press Yes to confirm'),
            //             actions: <Widget>[
            //               // TextButton(
            //               //   // onPressed: () async {
            //               //   //   await ClientSdkService.getInstance()
            //               //   //       .deleteAtSignFromKeyChain();
            //               //   //   await Navigator.pushNamedAndRemoveUntil(
            //               //   //       context,
            //               //   //       FirstScreen.id,
            //               //   //           (Route<dynamic> route) => false);
            //               //   // },
            //               //   child: Text('Yes'),
            //               // ),
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.pop(context);
            //                 },
            //                 child: Text('No'),
            //               )
            //             ],
            //           );
            //         });
            //   },
            //   child: Text('Remove $activeAtSign'),
            // ),
            SizedBox(
              height: 20.0,
            ),
            Text('Choose an @sign to join the blockchain'),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextField(
                decoration:
                InputDecoration(hintText: 'Enter an @sign for the new block'),
                onChanged: (value) {
                  chatWithAtSign = value;
                },
              ),

              // child: DropdownButton<String>(
              //   hint:  Text('\tPick an @sign'),
              //   icon: Icon(
              //     Icons.keyboard_arrow_down,
              //   ),
              //   iconSize: 24,
              //   elevation: 16,
              //   style: TextStyle(
              //       fontSize: 20.0,
              //       color: Colors.black87
              //   ),
              //   underline: Container(
              //     height: 2,
              //     color: Colors.deepOrange,
              //   ),
              //   onChanged: isEnabled ? (String newValue) {
              //     setState(() {
              //       chatWithAtSign = newValue;
              //       isEnabled = false;
              //     });
              //   } : null,
              //   disabledHint: chatWithAtSign != null ? Text(chatWithAtSign)
              //     : null,
              //   value: chatWithAtSign != null ? chatWithAtSign : null,
              //   items: atSigns == null ? null : atSigns
              //     .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //   }).toList(),
              // ),
            ),
            SizedBox(
              height: 50.0,
            ),
            showOptions
                ? Column(
              children: [
                SizedBox(height: 20.0),
                // TextButton(
                //   onPressed: () {
                //     var _res = checkForValidAtsignAndSet();
                //     if (_res == true)
                //       scaffoldKey!.currentState!
                //           .showBottomSheet((context) => ChatScreen());
                //   },
                //   child: Container(
                //     height: 40,
                //     child: Text('Open chat in bottom sheet'),
                //   ),
                // ),
                TextButton(
                  onPressed: () {
                    var _res = checkForValidAtsignAndSet();
                    // if (_res == true){
                    //   Navigator.pushNamed(context, ThirdScreen.id);}
                  },
                  child: Container(
                    height: 40,
                    child: Text('Add to blockchain'),
                  ),
                )
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    if (chatWithAtSign != null &&
                        chatWithAtSign!.trim() != '') {
                      // TODO: Call function to set receiver's @sign
                      setAtsignToChatWith();
                      setState(() {
                        showOptions = true;
                      });
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Row(
                                children: [Text('@sign Missing!')],
                              ),
                              content: Text('Please enter an @sign'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            );
                          });
                    }
                  },
                  child: Container(
                    height: 40,
                    child: Text('Blockchain options'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  checkForValidAtsignAndSet() {
    if (chatWithAtSign != null && chatWithAtSign!.trim() != '') {
      // TODO: Call function to set receiver's @sign
      setAtsignToChatWith();
      setState(() {
        showOptions = true;
      });
      return true;
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [Text('@sign Missing!')],
              ),
              content: Text('Please enter an @sign'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                )
              ],
            );
          });
    }
  }

  // TODO: Write function to initialize the chatting service
  getAtSignAndInitializeChat() async {
    String? currentAtSign = await clientSdkService.getAtSign();
    setState(() {
      activeAtSign = currentAtSign!;
    });
    // List<String> allAtSigns = at_demo_data.allAtsigns;
    // allAtSigns.remove(activeAtSign);
    // setState(() {
    //   atSigns = allAtSigns;
    // });
    initializeChatService(
        clientSdkService.atClientServiceInstance!.atClient!, activeAtSign,
        rootDomain: MixedConstants.ROOT_DOMAIN);
  }

  // TODO: Write function that determines whom you are chatting with
  setAtsignToChatWith() {
    // print(activeAtSign);
    // print(chatWithAtSign);
    // setChatWithAtSign(chatWithAtSign);
    sendBlockChain();
  }


  Future<void> sendBlockChain() async {
    // await setChatHistory(Message(
    //     message: message,
    //     sender: currentAtSign,
    //     time: DateTime.now().millisecondsSinceEpoch,
    //     type: MessageType.OUTGOING));

    Blockchain temp = clientSdkService.getBlockchain();
    String checkAtSign = '@'+chatWithAtSign!;
    var check = temp.containAtSign(checkAtSign);
    if(check == true){
      temp.removeBlock(checkAtSign);
      temp.newBlock('@' + chatWithAtSign!, temp.hash(temp.lastBlock));
    }else {
      temp.newBlock('@' + chatWithAtSign!, temp.hash(temp.lastBlock));
    }
    String message = temp.printChain().toString();

    clientSdkService.setBlockChain(temp);
    log("MESSAGE: $message");

    var atKey = AtKey()
      ..metadata = Metadata()
      ..metadata?.ttr = -1
      ..key = blockchainKey +  DateTime.now().millisecondsSinceEpoch.toString();
    atKey.sharedWith = chatWithAtSign;
    atKey.sharedBy = atSign;
    var result = await clientSdkService.put(atKey, message);
    print('send notification => $result');
  }
}
