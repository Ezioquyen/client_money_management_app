import 'package:flutter/material.dart';

class HomeControlView extends StatelessWidget {
  const HomeControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your house'),
      ),
      body: const HomeControlBodyWidget(),
    );
  }
}

class HomeControlBodyWidget extends StatefulWidget {
  const HomeControlBodyWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeControlBodyState();
  }
}

class HomeControlBodyState extends State<HomeControlBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ElevatedButton(onPressed: null, child: Text('Chi tieu chung')),
        ElevatedButton(onPressed: null, child: Text('Chi tieu cua ban')),
        ElevatedButton(onPressed: null, child: Text('Xem chi tieu cua ban'))
      ],
    );
  }
}
