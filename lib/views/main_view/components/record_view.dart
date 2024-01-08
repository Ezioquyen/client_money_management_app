import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/record.dart';

import 'package:untitled1/views/houseControl/member_group.dart';

import '../../../models/user/user.dart';
import '../../../viewModels/main_view_model.dart';
import '../../../viewModels/record_view_model.dart';

class RecordView extends StatelessWidget {
  final RecordPayment recordPayment;

  const RecordView({super.key, required this.recordPayment});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RecordViewModel(
            Provider.of<MainViewModel>(context, listen: false), recordPayment),
        child: const ViewRecordChild());
  }
}

class ViewRecordChild extends StatefulWidget {
  const ViewRecordChild({super.key});

  @override
  State<StatefulWidget> createState() {
    return RecordViewState();
  }
}

class RecordViewState extends State<ViewRecordChild> {
  @override
  Widget build(BuildContext context) {
    RecordViewModel createRecordModel = Provider.of<RecordViewModel>(context);
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
                      'Người chi: ${createRecordModel.recordPayment.payer.username}'),
                  Expanded(child: Container()),
                  ElevatedButton(
                      onPressed: createRecordModel.payerChecker
                          ? () async {
                              await createRecordModel.createRecord();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text('Lưu'))
                ],
              ),
              TextFormField(
                readOnly: !createRecordModel.payerChecker,
                onChanged: (value) =>
                    createRecordModel.recordPayment.information = value,
                initialValue: createRecordModel.recordPayment.information,
                decoration: const InputDecoration(hintText: 'Nội dung'),
              ),
              TextFormField(
                readOnly: !createRecordModel.payerChecker,
                initialValue: createRecordModel.recordPayment.money == 0
                    ? ''
                    : createRecordModel.recordPayment.money.toString(),
                onChanged: (value) =>
                    createRecordModel.recordPayment.money = int.parse(value),
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
                    onPressed: createRecordModel.payerChecker
                        ? () => _selectDate(context)
                        : null,
                    child: Selector<RecordViewModel, DateTime>(
                        selector: (context, myModel) => myModel.dateTime,
                        builder: (context, dateTime, child) {
                          return Text(
                              DateFormat('yyyy-MM-dd').format(dateTime));
                        }),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Chọn đối tượng'),
                  Expanded(child: Container()),
                  Selector<RecordViewModel, MemberGroup>(
                      selector: (context, myModel) => myModel.memberGroup,
                      builder: (context, memberGroup, child) {
                        return DropdownButton<MemberGroup>(
                            value: memberGroup,
                            onChanged: createRecordModel.payerChecker
                                ? (newValue) {
                                    createRecordModel
                                        .updateMemberGroup(newValue);
                                  }
                                : null,
                            items: MemberGroup.values
                                .map((MemberGroup memberGroup) {
                              return DropdownMenuItem<MemberGroup>(
                                  value: memberGroup,
                                  child: Text(
                                      memberGroup.toString().split('.')[1]));
                            }).toList());
                      }),
                ],
              ),
              Selector<RecordViewModel, MemberGroup>(
                  selector: (context, myModel) => myModel.memberGroup,
                  builder: (context, memberGroup, child) {
                    return memberGroup == MemberGroup.member
                        ? SizedBox(
                            height: 200,
                            child: Selector<RecordViewModel, RecordPayment>(
                                selector: (context, myModel) =>
                                    myModel.recordPayment,
                                builder: (context, recordPayment, child) {
                                  return Selector<RecordViewModel, List<User>>(
                                      selector: (context, myModel) =>
                                          myModel.users,
                                      builder: (context, users, child) {
                                        return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: users.length,
                                            itemExtent: 50,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.person),
                                                      title: Text(
                                                          createRecordModel
                                                              .users[index]
                                                              .username),
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                  Checkbox(
                                                      value: createRecordModel
                                                          .recordPayment
                                                          .participantIds
                                                          .contains(
                                                              createRecordModel
                                                                  .users[index]
                                                                  .id),
                                                      onChanged:
                                                          createRecordModel
                                                                  .payerChecker
                                                              ? (value) {
                                                                  createRecordModel
                                                                      .updateParticipant(
                                                                          value,
                                                                          index);
                                                                }
                                                              : null)
                                                ],
                                              );
                                            });
                                      });
                                }))
                        : memberGroup == MemberGroup.group
                            ? SizedBox(
                                height: 300,
                                child: Selector<RecordViewModel, PaymentGroup>(
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
                                                  .mainViewModel.groups.isEmpty
                                              ? null
                                              : RadioListTile<PaymentGroup>(
                                                  title: Text(createRecordModel
                                                      .mainViewModel
                                                      .groups[index]
                                                      .name),
                                                  value: createRecordModel
                                                      .mainViewModel
                                                      .groups[index],
                                                  groupValue: group,
                                                  onChanged: createRecordModel
                                                          .payerChecker
                                                      ? (value) {
                                                          createRecordModel
                                                              .updateGroup(
                                                                  value);
                                                        }
                                                      : null,
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
        initialDate:
            Provider.of<RecordViewModel>(context, listen: false).dateTime,
        firstDate: DateTime(2021, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      if (!context.mounted) return;
      Provider.of<RecordViewModel>(context, listen: false)
          .updateDateTime(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<RecordViewModel>(context, listen: false).updateUsers();
  }
}
