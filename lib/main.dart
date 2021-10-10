import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();

  CollectionReference groceries =
      FirebaseFirestore.instance.collection('groceries');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Example'),
        backgroundColor: Colors.orangeAccent[400],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: textController,
            decoration: InputDecoration(
              icon: Icon(Icons.restaurant),
              labelText: 'Groceries',
            ),
          ),

          //
          //Widget that builds itself based on the latest snapshot of interaction with a Stream.
          //A source of asynchronous data events.
          //
          StreamBuilder(
            // A Stream provides a way to receive a sequence of events.
            // Each event is either a data event, also called an element of the stream,
            // or an error event, which is a notification that something has failed.
            // When a stream has emitted all its event,
            // a single "done" event will notify the listener that the end has been reached.
            stream: groceries.orderBy('name').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return ListView(
                children: snapshot.data!.docs.map((grocery) {
                  return Center(
                    child: ListTile(
                      title: Text(grocery['name']),
                      onLongPress: () {
                        grocery.reference.delete();
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent[400],
        onPressed: () {
          groceries.add({
            'name': textController.text,
          });
          textController.clear();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
