import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String citizenName, citizenVillage, citizenAddress;
  int citizenId;

  getCitizenName(name) {
    this.citizenName = name;
  }

  getCitizenId(id) {
    this.citizenId = int.parse(id);
  }

  getCitizenVillage(village) {
    this.citizenVillage = village;
  }

  getCitizenAddress(address) {
    this.citizenAddress = address;
  }

  createData() {
    DocumentReference documentReference =
        Firestore.instance.collection("CitizenData").document(citizenName);

    Map<String, dynamic> citizen = {
      "citizenName": citizenName,
      "citizenId": citizenId,
      "citizenVillage": citizenVillage,
      "citizenAddress": citizenAddress,
    };
    documentReference.setData(citizen).whenComplete(() {
      print("$citizenName created");
    });
  }

  editData() {
    DocumentReference documentReference =
        Firestore.instance.collection("CitizenData").document(citizenName);

    Map<String, dynamic> citizen = {
      "citizenName": citizenName,
      "citizenId": citizenId,
      "citizenVillage": citizenVillage,
      "citizenAddress": citizenAddress,
    };
    documentReference.setData(citizen).whenComplete(() {
      print("$citizenName updated");
    });
  }

  deleteData() {
    DocumentReference documentReference =
        Firestore.instance.collection("CitizenData").document(citizenName);

    documentReference.delete().whenComplete(() {
      print("$citizenName deleted");
    });
  }

  readData() {
    DocumentReference documentReference =
        Firestore.instance.collection("CitizenData").document(citizenName);

    documentReference.get().then((datasnapshot) {
      print(datasnapshot.data["citizenName"]);
      print(datasnapshot.data["citizenId"]);
      print(datasnapshot.data["citizenVillage"]);
      print(datasnapshot.data["citizenAddress"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Penduduk Sederhana"),
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Nama",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String name) {
                  getCitizenName(name);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "NIK",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String id) {
                  getCitizenId(id);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Tempat Lahir",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String village) {
                  getCitizenVillage(village);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Alamat",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue, width: 2.0))),
                onChanged: (String address) {
                  getCitizenAddress(address);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    onPressed: () => {
                      createData(),
                    },
                  ),
                  FloatingActionButton(
                    child: Text("Read"),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    onPressed: () => {
                      readData(),
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.edit),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    onPressed: () => {
                      editData(),
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.delete),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    onPressed: () => {
                      deleteData(),
                    },
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: Firestore.instance.collection("CitizenData").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data.documents[index];
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(documentSnapshot["citizenName"]),
                          ),
                          Expanded(
                            child:
                                Text(documentSnapshot["citizenId"].toString()),
                          ),
                          Expanded(
                            child: Text(documentSnapshot["citizenVillage"]),
                          ),
                          Expanded(
                            child: Text(documentSnapshot["citizenAddress"]),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
            // StreamBuilder(
            //   stream: Firestore.instance.collection("CitizenData").snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return ListView.builder(
            //         itemCount: snapshot.data.documents.length,
            //         itemBuilder: (context, index) {
            //           DocumentSnapshot documentSnapshot =
            //               snapshot.data.documents[index];
            //           return Row(
            //             children: <Widget>[
            //               Expanded(
            //                 child: Text(documentSnapshot["citizenName"]),
            //               ),
            //               Expanded(
            //                 child:
            //                     Text(documentSnapshot["citizenId"].toString()),
            //               ),
            //               Expanded(
            //                 child: Text(documentSnapshot["citizenVillage"]),
            //               ),
            //               Expanded(
            //                 child: Text(documentSnapshot["citizenAddress"]),
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     } else {
            //       return Align(
            //         alignment: FractionalOffset.bottomCenter,
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
