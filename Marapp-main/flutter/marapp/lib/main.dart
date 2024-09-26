import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Inizializza Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData() async {
    await _firestore.collection('users').add({
      'name': 'Marco',
      'age': 25,
    });
  }

  Stream<QuerySnapshot> readData() {
    return _firestore.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: addData,
            child: Text('Add Data'),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: readData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final docs = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name']),
                      subtitle: Text('Age: ${data['age']}'),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}