
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewModels/main_view_model.dart';






class CreateHouse extends StatelessWidget {
  const CreateHouse({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                     Provider.of<MainViewModel>(context).createHouse(name.value.text, information.value.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Create',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}