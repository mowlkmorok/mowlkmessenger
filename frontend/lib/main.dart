import 'package:flutter/material.dart';

import 'chatScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget
{
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/1': (context) => ChatScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Test msg1"),
      ),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async{
                  final _controller = TextEditingController();
                  final username = await showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Enter username"),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(hintText: "Username"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel")
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, '/1',
                                      arguments: {
                                        'table': '1',
                                        'user': _controller.text
                                      }
                                  );
                                },
                                child: Text("Ok")
                            )
                          ],
                        );
                      }
                  );
                },
                child: Text("Table 1")
            ),
            ElevatedButton(
                onPressed: () async{
                  final _controller = TextEditingController();
                  final username = await showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Enter username"),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(hintText: "Username"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel")
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                      context, '/1',
                                      arguments: {
                                        'table': '2',
                                        'user': _controller.text
                                      }
                                  );
                                },
                                child: Text("Ok")
                            )
                          ],
                        );
                      }
                  );
                },
                child: Text("Table 2")
            )
          ],
        ),
      ),
    );
  }

}