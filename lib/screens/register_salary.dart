import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'home.dart';

class RegisterSalary extends StatefulWidget {
  @override
  _RegisterSalaryState createState() => _RegisterSalaryState();
}

class _RegisterSalaryState extends State<RegisterSalary>{

  Future createSalary(WalletRegister salary) async {
    final docUser = FirebaseFirestore.instance.collection('wallet').doc();

    salary.id = docUser.id;

    final json = salary.toJson();

    await docUser.set(json);
  }

  final controllerSalary = TextEditingController();
  final controllerNameType = TextEditingController();
  String? controllerTipo;

  List<String> items = ['Lucro', 'Gasto'];
  String? selectedItem = 'Lucro';

  final _form = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    Widget dropdown() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
              labelText: "Tipo",
            labelStyle: TextStyle(color: Colors.black),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black),
            ),

          ),
          items: items
              .map((item) =>
              DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 24)))).toList(),
          onChanged: (item) => setState(() {
            selectedItem = item;
            controllerTipo = selectedItem;
          }),

        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Preenchimento de custo"),
        backgroundColor: const Color(0xFF2062E6),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                final salary = WalletRegister(
                  nameType: controllerNameType.text,
                    value: double.parse(controllerSalary.text!),
                    tipo: controllerTipo);

                createSalary(salary);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Padding(
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
              dropdown()
            ],
          ),
        ),
      ),
    );
  }

}