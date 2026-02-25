import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdamsgtest1/messageModel.dart';
import 'package:pdamsgtest1/user.dart';
import 'package:pdamsgtest1/webSocketConnect.dart';
import 'package:pdamsgtest1/websocket_utils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget
{
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen>
{
  final TextEditingController _controller = TextEditingController();
  final List<MessageModel> messages = [];
  late User user;
  WebSocketChannel? channel;
  late WebSocketConnect ws;

  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      user = User(username: args['user'], message: "");
      String uri = 'ws://localhost:8080/table/' + args['table'];
      channel = createChannel(uri);
      ws = WebSocketConnect(channel!);






      ws.listen((data){
        print(data);
        Map<String, dynamic> jsonMap = jsonDecode(data);
        print('${jsonMap['username'] ?? 'SYSTEM'}: ${jsonMap['message']}');
        if (jsonMap['type'] == 'SYSTEM') {
          setState(() {
            messages.add(
              MessageModel(
                user: 'SYSTEM',
                text: jsonMap['message'],
                isSystem: true,
              ),
            );
          });
        } else {
          setState(() {
            messages.add(
              MessageModel(
                user: jsonMap['username'],
                text: jsonMap['message'],
              ),
            );
          });
        }

      });
      print(uri);
      final payload = jsonEncode({
        'username': args['user']
      });

      ws.send(payload);
    });

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  void sendMessage(String msg)
  {
    if (channel == null) {
      print("Channel is not initialized");
      return;
    }
    final payload = jsonEncode({
      'message': msg
    });
    channel!.sink.add(payload);


    _controller.clear();

  }
  @override
  void dispose()
  {
    super.dispose();
    channel?.sink.close();
  }

  @override
  Widget build(BuildContext context)
  {




  final args = ModalRoute.of(context)!.settings.arguments as Map;







  return Scaffold(
        appBar: AppBar(
          title: Text("Table1"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index){
                  final message = messages[index];

                  if (message.isSystem){
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  final isMe = message.user == user.username;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                        ),
                        color: isMe ? Colors.green[300] : Colors.cyan[300],
                      ),
                      padding: EdgeInsets.all(11),
                      child: isMe ? Text(message.text) :
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message.user,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          ),
                          Text(message.text),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: "Type the message...",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () => sendMessage(_controller.text),
                        icon: Icon(Icons.send))
                ),
              ),
            )
          ],
        )
    );
  }

}