import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const FortuneWheelState(),
    );
  }
}

class FortuneWheelState extends StatefulWidget {
  const FortuneWheelState({super.key});

  @override
  State<FortuneWheelState> createState() => _FortuneWheelStateState();
}

class _FortuneWheelStateState extends State<FortuneWheelState> {
  /// Roulette values
  List<String> Item = [];

  /// Result of roulette
  List<String> results = [];
  int? selectedIndex;
  StreamController<int> selected = StreamController<int>();

  /// Initalize ItemList
  @override
  initState() {
    super.initState();
    Item = generateItemList();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette!!!'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: 450,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FortuneWheel(
                  animateFirst: false,
                  selected: selected.stream,
                  items:
                      Item.map((e) => FortuneItem(child: Text('$e'))).toList(),
                  onAnimationStart: () {
                    showSnackBar(context, 'Start Roulette!!');
                  },
                  onAnimationEnd: () {
                    /// 選択された値があれば結果に追加する
                    if (selectedIndex != null) {
                      setState(() {
                        /// 選択された値をresultsに追加する
                        results.add(Item[selectedIndex!]);
                        /// 次のスピンに備えてnullにする
                        selectedIndex = null;
                      });
                    }
                    showSnackBar(context, 'End Roulette!!');
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        /// ここでどのindexの値が選ばれたかを取得する
                        final int index = Fortune.randomInt(0, Item.length);
                        selectedIndex = index;
                        selected.add(index);
                      },
                      child: Container(
                        width: 50,
                        height: 35,
                        color: Colors.blue,
                        child: Center(
                          child: Text('Spin'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          Item = regenereateItemList();
                          results = [];
                        });
                      },
                      child: Container(
                        height: 50,
                        color: Colors.blue,
                        child: Center(
                          child: Text('regenerate valeus'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Results: '),
                  for (String result in results) Text(result + ','),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Itemlist generator
List<String> generateItemList() {
  int listLength = Random().nextInt(10) + 1;
  String item = '';
  List<String> itemList = [];

  for (int i = 0; i < listLength + 1; i++) {
    item += Random().nextInt(10).toString();
    itemList.add(item);
  }
  return itemList;
}

/// Show SnackBar
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

/// Regenerate ItemList
List<String> regenereateItemList() {
  return generateItemList();
}
