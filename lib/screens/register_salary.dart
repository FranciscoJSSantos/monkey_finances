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
  String? controllerTipo;

  List<String> items = ['Lucro', 'Gasto'];
  String? selectedItem = 'Lucro';

  final _form = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    Widget dropdown() {
      return SizedBox(
        width: 500,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 3, color: Colors.blue),
            ),
          ),
          value: selectedItem,
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
        title: const Text("Preenchimento de salário"),
        backgroundColor: const Color(0xFF2062E6),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                final salary = WalletRegister(
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

              SizedBox(
                width: 500,
                child: TextFormField(
                  controller: controllerSalary,
                  decoration: const InputDecoration(

                    labelText: 'Salário',
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(
                        width: 0,
                      ),
                    ),
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