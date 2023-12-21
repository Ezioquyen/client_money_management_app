import 'package:flutter/material.dart';

import '../../../viewmodels/controller/main_view_vm.dart';

class JoinHouse extends StatelessWidget {
  final MainViewVModel mainViewVModel;


  const JoinHouse({Key? key, required this.mainViewVModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController code = TextEditingController();
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
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
              controller: code,
              decoration: const InputDecoration(
                  icon: Icon(Icons.tag), hintText: 'Code'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (code.value.text != '') {
                   mainViewVModel.joinHouse(false, code.value.text);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Join',
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