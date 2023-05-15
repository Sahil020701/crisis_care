import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpt/signn.dart';
import 'package:gpt/myform.dart';
import 'package:gpt/requestPage.dart';

void saveRequestToDatabase(
    String name, String phoneNumber, String email, String city) {
  // get a reference to the "requests" collection in Firestore
  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  // add the request data to a new document in the collection
  requestsCollection
      .add({
        'name': name,
        'phone_number': phoneNumber,
        'email': email,
        'city': city,
      })
      .then((value) => print('Request added successfully!'))
      .catchError((error) => print('Failed to add request: $error'));
}

Stream<QuerySnapshot> getItems() {
  return FirebaseFirestore.instance.collection('items').snapshots();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Crisis Care',
      home: SignInPage(),
    );
  }
}

class Item {
  final String name;
  int quantity;
  int requestedQuantity;

  Item(
      {required this.name, required this.quantity, this.requestedQuantity = 0});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  int get availableQuantity => quantity;

  void donate(int donatedQuantity) {
    quantity += donatedQuantity;
  }

  bool request(int requestedQuantity) {
    if (requestedQuantity <= availableQuantity) {
      quantity -= requestedQuantity;
      return true;
    } else {
      return false;
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final List<String> visionItems = [
  'Our vision is to create a Crisis Care app that leverages technology to provide a reliable and efficient platform for the government to manage and coordinate disaster response efforts. Our app will ensure that only verified users are allowed to access the request and donation pages, thereby eliminating any possibility of fraudulent activities. We aim to empower the government with real-time information and analytics to enable them to make informed decisions during times of crisis. Our goal is to minimize the impact of disasters on people and communities by providing a platform that connects those in need with those who can help.'
];

final List<String> missionItems = [
  'Our Crisis Care app aims to provide a reliable platform for verified government officials to coordinate relief efforts during times of crisis. By ensuring that only verified users can access the app, we strive to maintain the integrity of the platform and prevent any misinformation or fraudulent activity.'
];

final List<String> precautions = [
  '1. Stay tuned to local emergency broadcasts and follow instructions from local officials.',
  '2. Avoid entering damaged buildings or areas until it has been cleared as safe to do so.',
  '3. Avoid using tap water until it has been declared safe to drink by local authorities.',
  '4. Keep an eye out for downed power lines and avoid touching them or any objects that are touching them.',
  '5. If you smell gas, leave the area immediately and report it to the authorities.',
  '6. Keep emergency supplies on hand, such as food, water, first aid kits, and flashlights.'
];

final List<String> Developer = [
  'Contact Details:',
  'Name : Prathmesh Deshpande',
  'Email:prathmesh.22010619@viit.ac.in',
  'Name : Sahil Gobade',
  'Email:sahil.22010187@viit.ac.in',
  'Name : Md Zaid Bhaldar',
  'Email:mdzaid.22010377@viit.ac.in',
];

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.deepPurple,
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Crisis Care : A one stop place for all your needs',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFE6F9F7),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Vision',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      children: visionItems
                          .map((item) => Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                    ),
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    primary: false,
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Mission',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: missionItems
                          .map((item) => Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                    ),
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    primary: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    DonateScreen(),
    MyFormScreen(onSubmitted: () {  },),
    // RequestScreen(),
    Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFE6F9F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Precautions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008080),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      children: precautions
                          .map((item) => Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF444444),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    primary: false,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Developer Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008080),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: Developer.map((item) => Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF444444),
                                ),
                              ),
                            )).toList(),
                      ),
                    ),
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    primary: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
    User? user = FirebaseAuth.instance.currentUser;
    //print('$user');
    runApp(new MaterialApp(
      home: new SignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crisis Care'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.blueGrey,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            backgroundColor: Colors.blueGrey,
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            backgroundColor: Colors.blueGrey,
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            backgroundColor: Colors.blueGrey,
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}


class DonateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Item> items = [];
        if (snapshot.hasData) {
          items = snapshot.data!.docs
              .map((doc) =>
                  Item.fromJson(doc.data()! as Map<String, dynamic>? ?? {}))
              .toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Donate'),
          ),
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          items[index].name,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(
                          width: 100.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter quantity',
                            ),
                            onChanged: (value) {
                              int quantity = int.tryParse(value) ?? 0;
                              quantity = quantity.abs();
                              items[index].quantity = quantity;
                            },
                          ),
                        ),
                        GestureDetector(
                          child: ElevatedButton(
                            child: Text('Donate'),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(snapshot.data?.docs[index].id)
                                  .update({
                                'quantity':
                                    FieldValue.increment(items[index].quantity),
                              });
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

