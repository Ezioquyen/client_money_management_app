import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewModels/main_view_model.dart';






class JoinHouse extends StatelessWidget {
  const JoinHouse({super.key});



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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
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
                    style: const ButtonStyle(backgroundColor:  MaterialStatePropertyAll<Color>(Colors.purple)),
                    onPressed: () {
                      if (code.value.text != '') {
                       Provider.of<MainViewModel>(context,listen: false).joinHouse(false, code.value.text);
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
        ),
      ),
    );
  }
}