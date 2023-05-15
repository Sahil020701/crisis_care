import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt/main.dart';
import 'package:gpt/myform.dart';

class RequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
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
                                    items[index].requestedQuantity =
                                        int.parse(value);
                                  },
                                ),
                              ),
                              GestureDetector(
                                child: ElevatedButton(
                                  child: Text('Request'),
                                  onPressed: () {
                                    if (items[index].requestedQuantity <=
                                        items[index].availableQuantity) {
                                      FirebaseFirestore.instance
                                          .collection('items')
                                          .doc(snapshot.data?.docs[index].id)
                                          .update({
                                        'quantity': FieldValue.increment(
                                            -(items[index].requestedQuantity)),
                                      });
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'Requested quantity is greater than available quantity.\nAvailable Quantity = ${items[index].availableQuantity}'),
                                            actions: [
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
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
              ),
              ElevatedButton(
                child: Text(
                  'Done',
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
