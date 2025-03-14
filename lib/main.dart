// ไปที่ https://pub.dev/packages/flutter_slidable
// ติดตั้งและ import "flutter_slidable"

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './addForm.dart';
import './updateForm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int screenIndex = 0;

  //------ หน้าจอแต่ละหน้า ------
  final mobileScreens = [
    home(),
    search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'Example SQLite',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      //------ เรียกหน้าจอแต่ละหน้าตาม Index ------
      body: mobileScreens[screenIndex],

      //------ floatingActionButton ------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            screenIndex = 1;
          });
          //------ ไปหน้า addForm ------
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => addForm()))
              .then((_) {
            setState(() {
              screenIndex = 0;
            });
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //------ bottomNavigationBar ------
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(99, 136, 137, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  //------ ถ้า Index = 0 ให้ไอคอนสีเขียวเข้ม ถ้าไม่ใช้ไอคอนสีขาว ------
                  color: screenIndex == 0
                      ? Color.fromRGBO(18, 55, 42, 1)
                      : Colors.white,
                  // color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    screenIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: screenIndex == 1
                      ? Color.fromRGBO(18, 55, 42, 1)
                      : Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.widgets,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}

//------------- Home page -------------
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  CollectionReference weatherCollection =
      FirebaseFirestore.instance.collection('Weather');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: weatherCollection.snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    var weatherData = snapshot.data!.docs[index];
                    //------------ สไลด์เมนู Slidable ------------
                    return Slidable(
                      //------ startActionPane สไลด์จากด้านซ้ายมือ ------
                      startActionPane:
                          //------ DrawerMotion รูปแบบการสไลด์ ------
                          //รูปแบบการสไลด์เพิ่มเติมที่ https://pub.dev/packages/flutter_slidable
                          ActionPane(motion: DrawerMotion(), children: [
                        //------ SlidableAction เมนูที่สไลด์เปิด ------
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.blue,
                          icon: Icons.share,
                          label: 'แชร์',
                        )
                      ]),
                      //------ endActionPane สไลด์จากด้านขวามือ ------
                      endActionPane:
                          //------ StretchMotion รูปแบบการสไลด์ ------
                          ActionPane(motion: StretchMotion(), children: [
                        //------ SlidableAction เมนูที่สไลด์เปิด ------
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateForm(),
                                    settings:
                                        RouteSettings(arguments: weatherData)));
                          },
                          backgroundColor: Colors.green,
                          icon: Icons.edit,
                          label: 'แก้ไข',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            weatherCollection.doc(weatherData.id).delete();
                          },
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'ลบ',
                        ),
                      ]),
                      child: ListTile(
                        title: Text(weatherData['city']),
                        subtitle: Text(
                            'Temperature: ${weatherData['temperature']}°C'),
                      ),
                    );
                  }));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          })),
    );
  }
}

//------------- Search page -------------
class search extends StatelessWidget {
  const search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Search')],
        ),
      ),
    );
  }
}
