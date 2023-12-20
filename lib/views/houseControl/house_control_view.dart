import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewmodels/controller/house_control_view_model.dart';

import '../../providers/user_provider.dart';
import 'member_group.dart';

class HouseControlView extends StatelessWidget {
  const HouseControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HouseControlViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your house'),
        ),
        body: const HouseControlBodyWidget(),
      ),
    );
  }
}

class HouseControlBodyWidget extends StatefulWidget {
  const HouseControlBodyWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeControlBodyState();
  }
}

class HomeControlBodyState extends State<HouseControlBodyWidget> {
  @override
  Widget build(BuildContext context) {
    HouseControlViewModel houseControlViewModel =
        Provider.of<HouseControlViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: SegmentedButton<MemberGroup>(
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(Colors.blueAccent),
              ),
              segments: const <ButtonSegment<MemberGroup>>[
                ButtonSegment<MemberGroup>(
                    value: MemberGroup.member,
                    label: Text('Members'),
                    icon: Icon(Icons.person)),
                ButtonSegment<MemberGroup>(
                    value: MemberGroup.group,
                    label: Text('Groups'),
                    icon: Icon(Icons.group)),
              ],
              selected: <MemberGroup>{houseControlViewModel.memberGroup},
              onSelectionChanged: (Set<MemberGroup> newSelection) {
                houseControlViewModel.memberGroup = newSelection.first;
              },
            ),
          ),
          Consumer<HouseControlViewModel>(builder: (context, myModel, child) {
            return Container(
            child: ListView.builder(padding: EdgeInsets.zero,
              itemCount: Provider.of<UserProvider>(context)
                  .records
                  .isNotEmpty
                  ? Provider.of<UserProvider>(context).records.length
                  : 1,
              itemExtent: 70,
              itemBuilder: (context, index) {
                return null;
              },),
            );
          }),
          TextButton(onPressed: null, child: Text('Add')),
        ],
      ),
    );
  }
}
