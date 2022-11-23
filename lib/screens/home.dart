import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:monkey_finances/provider/google_sign_in.dart';
import 'package:monkey_finances/screens/login.dart';
import 'package:monkey_finances/screens/register_salary.dart';
import 'package:monkey_finances/utilities/constants.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class WalletRegister {
  String? id;
  final String? nameType;
  final double? value;
  final String? tipo;

  WalletRegister({this.id = '', required this.nameType,required this.value, required this.tipo});

  Map<String, dynamic> toJson() => {'id': id, 'nameType': nameType,'value': value, 'tipo': tipo};
}

class _HomeScreenState extends State<HomeScreen> {
  Future createSalary(WalletRegister salary) async {
    final docUser = FirebaseFirestore.instance.collection('wallet').doc();

    salary.id = docUser.id;

    final json = salary.toJson();

    await docUser.set(json);
  }

  var dbRef;

  final _form = GlobalKey<FormState>();

  @override
  void initialState() {
    super.initState();
    pegarUsusario();
  }

  Widget _monkey_image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/logo.png', width: 200.0, height: 200.0),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: const TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBackToLogin() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.to(() => LoginScreen(),
              transition: Transition.leftToRight,
              duration: const Duration(milliseconds: 350));
        },
        child: const Text(
          'Voltar ao Login',
          style: kLabelStyle,
        ),
      ),
    );
  }

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // user logado normal
  final _firebaseAuth = FirebaseAuth.instance;
  String nome = "";
  String email = "";

  pegarUsusario() async{
    User? usuario = await _firebaseAuth.currentUser;
    if(usuario != null) {
      setState(() {
        nome = usuario.displayName!;
        email = usuario.email!;
      });
    }
  }

  @override


  //componente pra usuario do google

  var user = FirebaseAuth.instance.currentUser;

  var nomeGenerico = "brenno";
  var emailGenerico = "brenno@example.com";
  var fotoGenerica =
      "https://images.unsplash.com/photo-1547721064-da6cfb341d50";

  List<String> items = ['Lucro', 'Gasto'];
  String? selectedItem = 'Lucro';

  Widget dropdown() {
    return SizedBox(
      width: 240,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 3, color: Colors.blue),
          ),
        ),
        value: controllerTipo,
        items: items
            .map((item) => DropdownMenuItem<String>(
                value: item, child: Text(item, style: TextStyle(fontSize: 24))))
            .toList(),
        onChanged: (item) => setState(() {
          selectedItem = item;
          controllerTipo = selectedItem;
        }),
      ),
    );
  }

  Widget _userProfile() {
    return Container(
      child: Flexible(
          child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
            Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Perfil",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 150),
                user?.photoURL != null
                    ? CircleAvatar(
                  minRadius: 50,
                  maxRadius: 50,
                  backgroundImage: NetworkImage(user?.photoURL ?? ""),
                )
                    :    const Icon(Icons.account_circle, size: 100, color: Colors.grey,)
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                const SizedBox(height: 12),
                Text("Email: ${user?.email ?? email}",
                    style: const TextStyle(color: Colors.black, fontSize: 18))
              ],
            )
          ])),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Stream<List<WalletRegister>> readWallet() {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("movies").doc();

    return docRef
        .snapshots()
        .map((dados) => dados.data() as List<WalletRegister>);
  }
  final controllerSalary = TextEditingController();
  final controllerNameType = TextEditingController();
  String? controllerTipo;

  @override
  Widget build(BuildContext context) {
    double? sumTotal = 0.0;

    double? valorPositivo = 0.0;
    double? valorNegativo = 0.0;

    //parte do positivo
    double? sumTotalPositivo = 0.0;
    double? sumTotalNegativo = 0.0;
    double? valorPositivoNew = 0.0;

    final List<Widget> widgetOptions = <Widget>[
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection("wallet").orderBy("value", descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(

              children: snapshot.data!.docs.map((document) {
                DocumentReference<Map<String, dynamic>>;
                return ListTile(
                  leading: document["tipo"] == "Lucro"
                  ? const Icon(Icons.expand_less, color: Colors.green, size: 40)
                  : const Icon(Icons.expand_more, color: Colors.red, size: 40),
                  title: Text(
                    document['nameType'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    document['value'].toString(),
                    style: document['tipo'] == "Lucro"
                        ? TextStyle(color: Colors.green)
                        : TextStyle(color: Colors.red),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(children: <Widget>[
                      IconButton(
                        onPressed: () {
                          controllerNameType.text = document['nameType'];
                          controllerTipo = document['tipo'];
                          controllerSalary.text = document['value'].toString();

                          showDialog(context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Form(
                                              key: _form,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(height: 50),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white, border: Border.all(color: Colors.grey),
                                                    ),
                                                    child: TextField(
                                                      controller: controllerNameType,
                                                      style: TextStyle(color: Colors.black),
                                                      decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                          labelText: "Nome do item",
                                                          labelStyle: TextStyle(color: Colors.black),
                                                          border: InputBorder.none
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 50,),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white, border: Border.all(color: Colors.grey),
                                                    ),
                                                    child: TextField(
                                                      controller: controllerSalary,
                                                      style: TextStyle(color: Colors.black),
                                                      decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                          labelText: "Valor",
                                                          labelStyle: TextStyle(color: Colors.black),
                                                          border: InputBorder.none
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 50),
                                                  dropdown(),
                                                  SizedBox(height: 50),
                                                  ElevatedButton(onPressed: () {
                                                    final docUser = FirebaseFirestore.instance
                                                        .collection("wallet")
                                                        .doc(document['id']);

                                                    docUser.update({
                                                      "nameType": controllerNameType.text,
                                                      "value": double.parse(controllerSalary.text!),
                                                      "tipo": controllerTipo
                                                    }).whenComplete(() => Navigator.pop(context));

                                                    Navigator.pop(context);
                                                  },
                                                      child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Text("Alterar")
                                                  )

                                                  ),
                                                  SizedBox(height: 50),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                      child: Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text("Voltar")
                                                      )

                                                  ),

                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                        icon: const Icon(Icons.edit),
                        color: Colors.blue,
                      ),
                      IconButton(
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection("wallet")
                              .doc(document['id']);

                          docUser.delete();
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ]),
                  ),
                );
              }).toList(),
            );
          }),
      Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 18),
              Text(
                'Bem Vindo, ${user?.displayName ?? nomeGenerico}!',
                style: optionStyle,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 150,
                child: Card(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('wallet').get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> querySnapshot) {
                      if (querySnapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (querySnapshot.connectionState == ConnectionState.done) {
                        querySnapshot.data!.docs.forEach((doc) {
                          if (doc['tipo'] == "Lucro") {
                            valorPositivo = valorPositivo! + doc['value'];
                          } else {
                            valorNegativo = valorNegativo! + doc['value'];
                          }
                          sumTotal = valorPositivo! - valorNegativo!;
                        });
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total: ",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "R\$ ${sumTotal}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 150,
                      child: Card(
                        child: FutureBuilder(
                          future:
                              FirebaseFirestore.instance.collection('wallet').get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> querySnapshot) {
                            if (querySnapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (querySnapshot.connectionState ==
                                ConnectionState.done) {
                              querySnapshot.data!.docs.forEach((positivo) {
                                sumTotalPositivo = valorPositivo;
                              });
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Lucros: ",
                                    style: const TextStyle(
                                        fontSize: 30, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "R\$ ${valorPositivo}",
                                    style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 300,
                      height: 150,
                      child: Card(
                        child: FutureBuilder(
                          future:
                              FirebaseFirestore.instance.collection('wallet').get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> querySnapshot) {
                            if (querySnapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (querySnapshot.connectionState ==
                                ConnectionState.done) {
                              querySnapshot.data!.docs.forEach((negativo) {
                                sumTotalNegativo = valorNegativo;
                              });
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Gastos: ",
                                    style: const TextStyle(
                                        fontSize: 30, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "R\$ ${valorNegativo}",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );;
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_userProfile()]))
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();

              Get.to(() => LoginScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 350));
            },
            icon: const Icon(Icons.logout)),
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- SEE HERE
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => RegisterSalary(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 350));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(child: widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2062E6),
        onTap: _onItemTapped,
      ),
    );
  }
}
