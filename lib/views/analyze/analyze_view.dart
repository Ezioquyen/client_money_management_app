import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewModels/anlyze_view_model.dart';
import 'package:untitled1/viewModels/main_view_model.dart';
import 'package:untitled1/views/analyze/components/chart.dart';

class AnalyzeView extends StatelessWidget {
  const AnalyzeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnalyzeViewModel(),
      child: _AnalyzeViewBody(),
    );
  }
}

class _AnalyzeViewBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnalyzeViewBodyState();
  }
}

class _AnalyzeViewBodyState extends State<_AnalyzeViewBody>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  TabBar get _tabBar => TabBar(
        controller: _tabController,
        tabs: const <Widget>[
          Tab(
            icon: Icon(Icons.calculate_outlined),
          ),
          Tab(
            icon: Icon(Icons.pie_chart),
          ),
          Tab(
            icon: Icon(Icons.area_chart),
          ),
        ],
        indicatorColor: Colors.deepPurple,
      );

  @override
  Widget build(BuildContext context) {
    AnalyzeViewModel analyzeViewModel =
        Provider.of<AnalyzeViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Row(
          children: [
            const Text(
              "Thống kê",
              style: TextStyle(color: Colors.white),
            ),
            Expanded(child: Container()),
            Selector<AnalyzeViewModel, List<String>>(
                selector: (context, myModel) => myModel.dateList,
                builder: (context, dateList, child) {
                  return Selector<AnalyzeViewModel, String>(
                      selector: (context, myModel) => myModel.selectedDate,
                      builder: (context, selectedDate, child) {
                        return DropdownButton<String>(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            value: selectedDate,
                            onChanged: (newValue) {
                              analyzeViewModel.updateDate(newValue);
                            },
                            items: dateList.map((String val) {
                              return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(
                                    val,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ));
                            }).toList());
                      });
                }),
          ],
        ),
        bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(color: Colors.white, child: _tabBar)),
      ),
      body: Selector<AnalyzeViewModel, String>(
          selector: (context, myModel) => myModel.selectedDate,
          builder: (context, selectedDate, child) {
            return TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 800,
                      child: Column(
                        children: [
                          const Text(
                            "Chuyển khoản",
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 30),
                          ),
                          Selector<AnalyzeViewModel,
                                  List<Map<String, dynamic>>>(
                              selector: (context, myModel) =>
                                  myModel.calculated,
                              builder: (context, calculated, child) {
                                return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple[50],
                                    ),
                                    height: 750,
                                    width: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: calculated.length,
                                        itemExtent: 80,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurple[50],
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: ListTile(
                                              title: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 110,
                                                    child: Text(
                                                      calculated[index]["from"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.deepPurple,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${NumberFormat('###,###').format(calculated[index]["transfer"])} VND ',
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_forward_outlined,
                                                        color:
                                                            Colors.deepPurple,
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(child: Container()),
                                                  SizedBox(
                                                    width: 110,
                                                    child: Text(
                                                      calculated[index]["to"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.deepPurple,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ));
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Selector<AnalyzeViewModel, List<Map<String, dynamic>>>(
                          selector: (context, myModel) =>
                              myModel.paidForByMonth,
                          builder: (context, paidForByMonth, child) {
                            return SizedBox(
                                height: 400,
                                width: 400,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                      child: Text(
                                        "Khoản chi",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 30),
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple[50]),
                                        height: 350,
                                        child: PieChartSample(paidForByMonth)),
                                  ],
                                ));
                          }),
                      Selector<AnalyzeViewModel, List<Map<String, dynamic>>>(
                          selector: (context, myModel) =>
                              myModel.feeFromByMonth,
                          builder: (context, feeFromByMonth, child) {
                            return Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                height: 400,
                                width: 400,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                      child: Text(
                                        "Khoản cần đóng",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 30),
                                      ),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple[50]),
                                        height: 350,
                                        child: PieChartSample(feeFromByMonth)),
                                  ],
                                ));
                          }),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 410,
                        width: 400,
                        child: Selector<AnalyzeViewModel,
                                List<Map<String, dynamic>>>(
                            selector: (context, myModel) =>
                                myModel.totalFeeByMonth,
                            builder: (context, totalFeeByMonth, child) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: 350,
                                        child:
                                            LineChartSample(totalFeeByMonth)),
                                    const SizedBox(
                                      height: 50,
                                      child: Text(
                                        "Khoản chi",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 410,
                        width: 400,
                        child: Selector<AnalyzeViewModel,
                                List<Map<String, dynamic>>>(
                            selector: (context, myModel) =>
                                myModel.totalPaidByMonth,
                            builder: (context, totalPaidByMonth, child) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: 350,
                                        child:
                                            LineChartSample(totalPaidByMonth)),
                                    const SizedBox(
                                      height: 50,
                                      child: Text(
                                        "Khoản cần đóng",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 30),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  Future<void> initData() async {
    await Provider.of<AnalyzeViewModel>(context, listen: false).initialize(
        Provider.of<MainViewModel>(context, listen: false).house,
        Provider.of<MainViewModel>(context, listen: false).user);
  }

  @override
  void initState() {
    super.initState();
    initData();

    _tabController = TabController(length: 3, vsync: this);
  }
}
