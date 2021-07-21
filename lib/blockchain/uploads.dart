class Upload {
  String sender = "";
  String data = "";
  // int proof;
  // String prevHash;

  Upload(this.sender, this.data);

  Map<String, dynamic> toJson() {
    return <String,dynamic>{
      "uploader": sender,
      "data": data,
      // "proof": proof,
      // "prevHash": prevHash,
    };
  }
}