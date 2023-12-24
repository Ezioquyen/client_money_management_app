import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/record.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/viewModels/controller/create_record_model.dart';
import 'package:untitled1/views/houseControl/member_group.dart';

import '../../../viewModels/controller/main_view_model.dart';

class CreateRecord extends StatelessWidget {
  const CreateRecord({super.key, required this.mainViewModel});

  final MainViewModel mainViewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CreateRecordModel(mainViewModel),
        child: const CreateRecordChild());
  }
}

class CreateRecordChild extends StatefulWidget {
  const CreateRecordChild({super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateRecordState();
  }
}

class CreateRecordState extends State<CreateRecordChild> {
  TextEditingController information = TextEditingController();
  TextEditingController money = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CreateRecordModel createRecordModel =
        Provider.of<CreateRecordModel>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 1.5,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      child: Padding(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                      'Người chi: ${Provider.of<UserProvider>(context).username}'),
                  Expanded(child: Container()),
                  ElevatedButton(onPressed: () async {
                    createRecordModel.recordPayment.money = int.parse(money.text.toString());
                    createRecordModel.recordPayment.information = information.text.toString();
                   await  createRecordModel.createRecord();
                   if(!context.mounted) return;
                    Navigator.pop(context);
                  }, child: Text('Tạo'))
                ],
              ),
              TextFormField(
                controller: information,
                decoration: const InputDecoration(hintText: 'Nội dung'),
              ),
              TextFormField(
                controller: money,
                decoration: const InputDecoration(hintText: 'Money'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Row(
                children: [
                  const Text('Ngày chi'),
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Selector<CreateRecordModel, DateTime>(
                        selector: (context, myModel) => myModel.dateTime,
                        builder: (context, dateTime, child) {
                          return Text(DateFormat('d/M/y').format(dateTime));
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Chọn đối tượng'),
                  Expanded(child: Container()),
                  Selector<CreateRecordModel, MemberGroup>(
                      selector: (context, myModel) => myModel.memberGroup,
                      builder: (context, memberGroup, child) {
                        return DropdownButton<MemberGroup>(
                            value: memberGroup,
                            onChanged: (newValue) {
                              createRecordModel.updateMemberGroup(newValue);
                            },
                            items: MemberGroup.values.map((MemberGroup memberGroup) {
                              return DropdownMenuItem<MemberGroup>(
                                  value: memberGroup,
                                  child: Text(memberGroup.toString().split('.')[1]));
                            }).toList());
                      })
                  ,
                ],
              ),
              Selector<CreateRecordModel, MemberGroup>(
                  selector: (context, myModel) => myModel.memberGroup,
                  builder: (context, memberGroup, child) {
                    return memberGroup == MemberGroup.member
                        ? SizedBox(
                            height: 300,
                            child: Selector<CreateRecordModel, RecordPayment>(
                                selector: (context, myModel) =>
                                myModel.recordPayment,
                                builder: (context, recordPayment, child) {
                                  return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: createRecordModel
                                          .users.isNotEmpty
                                          ? createRecordModel
                                          .users.length
                                          : 1,
                                      itemExtent: 50,
                                      itemBuilder: (context, index) {
                                        return createRecordModel
                                            .users.isEmpty
                                            ? null
                                            : Row(
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: ListTile(
                                                leading:
                                                const Icon(Icons.person),
                                                title: Text(createRecordModel
                                                    .mainViewModel
                                                    .users[index]
                                                    .username),
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Checkbox(
                                                value: recordPayment.participantIds.contains(createRecordModel
                                                    .users[index].id),
                                                onChanged: (value) {
                                                    createRecordModel.updateParticipant(value, index);
                                                })
                                          ],
                                        );
                                      });})
                                )
                        : memberGroup == MemberGroup.group
                            ? SizedBox(
                                height: 300,
                                child:
                                    Selector<CreateRecordModel, PaymentGroup>(
                                        selector: (context, myModel) =>
                                            myModel.group,
                                        builder: (context, group, child) {
                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: createRecordModel
                                                .mainViewModel.groups.length,
                                            itemExtent: 50,
                                            itemBuilder: (context, index) {
                                              return createRecordModel
                                                      .mainViewModel
                                                      .groups
                                                      .isEmpty
                                                  ? null
                                                  : RadioListTile<PaymentGroup>(
                                                      title: Text(
                                                          createRecordModel
                                                              .mainViewModel
                                                              .groups[index]
                                                              .name),
                                                      value: createRecordModel
                                                          .mainViewModel
                                                          .groups[index],
                                                      groupValue: group,
                                                      onChanged: (value) {
                                                        createRecordModel.updateGroup(value);
                                                      },
                                                    );
                                            },
                                          );
                                        }))
                            : Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: Provider.of<CreateRecordModel>(context,listen: false).dateTime,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      if (!context.mounted) return;
      Provider.of<CreateRecordModel>(context,listen: false).updateDateTime(picked);
    }
  }
}
