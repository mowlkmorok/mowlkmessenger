class MessageModel {

  final String user;

  final String text;

  final bool isSystem;


  MessageModel({

    required this.user,

    required this.text,

    this.isSystem = false
  });

}