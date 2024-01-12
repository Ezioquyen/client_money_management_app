import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/payment_group.dart';
import 'package:untitled1/models/record.dart';
import 'package:untitled1/models/user/user.dart';
import 'package:untitled1/providers/user_provider.dart';
import 'package:untitled1/views/recordManagement/record_filter.dart';
import '../../viewModels/main_view_model.dart';
import '../../viewModels/record_management_view_model.dart';
import '../main_view/components/record_view.dart';

class RecordManagementView extends StatelessWidget {
  const RecordManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecordManagementViewModel(),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: RecordManagementBody(),
      ),
    );
  }
}

class RecordManagementBody extends StatefulWidget {
  const RecordManagementBody({super.key});

  @override
  State<StatefulWidget> createState() {
    return RecordManagementBodyState();
  }
}

class RecordManagementBodyState extends State<RecordManagementBody> {
  @override
  Widget build(BuildContext context) {
    RecordManagementViewModel recordManagementViewModel =
        Provider.of<RecordManagementViewModel>(context);
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.house),
                  tooltip: "Your house",
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              const SizedBox(
                width: 200,
              ),
              const IconButton(
                  icon: Icon(Icons.stacked_line_chart),
                  tooltip: "Static",
                  onPressed: null),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        onPress: () async {
          await showModalBottomSheet(
              builder: (BuildContext buildContext) => RecordView(
                    recordPayment:
                        RecordPayment(payer: User(), participantIds: []),
                  ),
              context: context);
          print("test");
          initialData();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text(
          'Bản ghi chi tiêu - ${Provider.of<MainViewModel>(context, listen: false).house.name}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white70,
                ),
                child: Selector<RecordManagementViewModel, List<dynamic>>(
                  selector: (context, myModel) => myModel.dateList,
                  builder: (context, dateList, child) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Provider.of<RecordManagementViewModel>(context)
                          .dateList
                          .length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => Provider.of<RecordManagementViewModel>(
                                    context,
                                    listen: false)
                                .updateDate(dateList[index]),
                            child: Column(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.deepPurple[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      Provider.of<RecordManagementViewModel>(
                                              context)
                                          .dateList[index]
                                          .toString()
                                          .split('/')[0],
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                  ),
                                ),
                                Text(Provider.of<RecordManagementViewModel>(
                                        context)
                                    .dateList[index]
                                    .toString()),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 550,
              decoration: const BoxDecoration(
                color: Colors.white70,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Selector<RecordManagementViewModel, RecordFilter>(
                            selector: (context, myModel) =>
                                myModel.recordFilter,
                            builder: (context, recordFilter, child) {
                              return SizedBox(
                                width: 180,
                                child: Row(
                                  children: [
                                    DropdownButton<RecordFilter>(
                                        value: recordFilter,
                                        onChanged: (newValue) {
                                          recordManagementViewModel
                                              .updateRecordFilter(newValue!);
                                        },
                                        items: RecordFilter.values
                                            .map((RecordFilter recordFilter) {
                                          return DropdownMenuItem<RecordFilter>(
                                              value: recordFilter,
                                              child: Text(recordFilter
                                                  .toString()
                                                  .split('.')[1]));
                                        }).toList()),
                                    (recordManagementViewModel
                                                .groups.isNotEmpty &&
                                            recordFilter == RecordFilter.group)
                                        ? Selector<RecordManagementViewModel,
                                                PaymentGroup>(
                                            selector: (context, myModel) =>
                                                myModel.selectedGroup,
                                            builder: (context, selectedGroup,
                                                child) {
                                              return DropdownButton<
                                                      PaymentGroup>(
                                                  value:
                                                      recordManagementViewModel
                                                          .selectedGroup,
                                                  onChanged: (newValue) {
                                                    recordManagementViewModel
                                                        .updateGroup(newValue!);
                                                  },
                                                  items: recordManagementViewModel
                                                      .groups
                                                      .map<
                                                              DropdownMenuItem<
                                                                  PaymentGroup>>(
                                                          (PaymentGroup group) {
                                                    return DropdownMenuItem<
                                                            PaymentGroup>(
                                                        value: group,
                                                        child:
                                                            Text(group.name));
                                                  }).toList());
                                            })
                                        : Container(),
                                  ],
                                ),
                              );
                            }),
                        Expanded(child: Container()),
                        SizedBox(
                            width: 180,
                            child: Row(
                              children: [
                                Checkbox(
                                    value:
                                        recordManagementViewModel.payerChecker,
                                    onChanged: (value) {
                                      recordManagementViewModel
                                          .updatePayerChecker(value);
                                    }),
                                const Text('Chi tiêu của bạn')
                              ],
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 470,
                        child: Selector<RecordManagementViewModel,
                            List<RecordPayment>>(
                          selector: (context, myModel) => myModel.records,
                          builder: (context, records, child) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemExtent: 80,
                                itemCount:
                                    Provider.of<RecordManagementViewModel>(
                                            context)
                                        .records
                                        .length,
                                itemBuilder: (context, index) {
                                  return Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .id ==
                                          records[index].payer.id
                                      ? Slidable(
                                          key: UniqueKey(),
                                          endActionPane: ActionPane(
                                            dismissible: DismissiblePane(
                                              onDismissed: () async {
                                                await recordManagementViewModel
                                                    .removeRecord(
                                                        records[index]);
                                              },
                                            ),
                                            motion: const DrawerMotion(),
                                            extentRatio: 0.25,
                                            children: [
                                              SlidableAction(
                                                label: 'Delete',
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete,
                                                onPressed: (context) async {
                                                  await recordManagementViewModel
                                                      .removeRecord(
                                                          records[index]);
                                                },
                                              ),
                                            ],
                                          ),
                                          child: ListTile(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    builder: (BuildContext
                                                            builderContext) =>
                                                        RecordView(
                                                          recordPayment:
                                                              records[index],
                                                        ),
                                                    context: context);
                                              },
                                              title: recordBar(records[index])),
                                        )
                                      : ListTile(
                                          onTap: () {
                                            showModalBottomSheet(
                                                builder: (BuildContext
                                                        builderContext) =>
                                                    RecordView(
                                                      recordPayment:
                                                          records[index],
                                                    ),
                                                context: context);
                                          },
                                          title: recordBar(records[index]));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recordBar(RecordPayment recordPayment) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline_rounded),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recordPayment.payer.username,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent),
                  ),
                  Text(
                    '${recordPayment.money} đ - ${recordPayment.information}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  Text(recordPayment.date.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initialData() async {
    await Provider.of<RecordManagementViewModel>(context, listen: false)
        .initialModel(Provider.of<MainViewModel>(context, listen: false));
  }

  @override
  void initState() {
    super.initState();
    initialData();
  }
}
