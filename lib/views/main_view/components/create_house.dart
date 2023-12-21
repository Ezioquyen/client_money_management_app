import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../viewmodels/controller/main_view_vm.dart';



class CreateHouse extends StatelessWidget {
  final MainViewVModel mainViewVModel;


  const CreateHouse({Key? key, required this.mainViewVModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController information = TextEditingController();
    return Container(
      height: MediaQuery.of(context).size.height*0.75,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                  icon: Icon(Icons.house_outlined), hintText: 'House\'s name'),
            ),
            TextFormField(
              controller: information,
              decoration: const InputDecoration(
                  icon: Icon(Icons.info_outline_rounded),
                  hintText: 'Information'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (name.value.text != '') {
                    mainViewVModel.createHouse(name.value.text, information.value.text);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}