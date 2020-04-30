import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';

import 'package:keep_account/store/index.dart';
import 'package:keep_account/common/index.dart';
import 'package:keep_account/components/index.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
// import 'package:keep_account/pages/demo/sqflite.dart';

final counter = Counter();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController _scrollCtrl;
  // double opacity = 0;
  // bool isShowTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    // _scrollCtrl.addListener(() {
    //   double offset = _scrollCtrl.offset;
    //   setState(() {
    //     // opacity = min(1.0, max(0, offset - 300) / 100);
    //     isShowTitle = offset >= 200;
    //   });
    // });

    Future.delayed(Duration(seconds: 1), () {
      MyStore.billStore.getAll();
    });

    computeStr();
  }

  @override
  dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  computeStr() async {
    var str = await rootBundle.loadString('assets/1.txt');
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(
        ui.ParagraphStyle(fontSize: 16, textAlign: TextAlign.left));
    pb.pushStyle(ui.TextStyle(color: Colors.black));
    pb.addText(str);

    ui.ParagraphConstraints pc =
        ui.ParagraphConstraints(width: MediaQuery.of(context).size.width);
    ui.Paragraph p = pb.build()..layout(pc);
    List<ui.LineMetrics> lines = p.computeLineMetrics();
    print(lines.length);
  }

  Widget get renderTop {
    return Observer(
        builder: (_) => MyBox(
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(
                  horizontal: Adapt.px(24), vertical: Adapt.px(12)),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      MyPicker.showMonthPicker(
                        context: context,
                        onChange: (newMonth) {
                          print(newMonth);
                          MyStore.billStore.setDate(newMonth);
                        },
                        current: MyStore.billStore.date,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyText(
                          MyStore.billStore.year.toString() + '年',
                          color: Colors.white70,
                          size: 24,
                        ),
                        Row(
                          children: <Widget>[
                            MyText(
                              MyStore.billStore.month,
                              color: Colors.white,
                              size: 42,
                            ),
                            MyText(
                              ' 月',
                              color: Colors.white70,
                              size: 24,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: Adapt.px(64),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Adapt.px(1),
                    height: Adapt.px(16 * 4),
                    decoration: BoxDecoration(color: Colors.white70),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        _renderTopItem('收入', 0.00),
                        _renderTopItem('支出', 0.00),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Widget _renderTopItem(
    String text, [
    num price = 0.00,
  ]) {
    return Expanded(
      child: Column(
        children: <Widget>[
          MyText(
            text,
            color: Colors.white70,
            size: 24,
          ),
          Container(
            height: Adapt.px(12),
          ),
          MyText(
            price.toString(),
            color: Colors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('记账'),
        ),
        body: Column(
          children: <Widget>[
            renderTop,
            Expanded(
              child: EasyRefresh.custom(
                // header: PhoenixHeader(),
                // footer: PhoenixFooter(),
                // onRefresh: () async {
                //   // return true;
                // },
                // onLoad: () async {},
                scrollController: _scrollCtrl,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: renderTop,
                  ),
                ],
              ),
            ),
            // ...MyEnum.iconList.map((v) => Iconfont(v['icon'])),
            // Observer(builder: (_) => Text('${MyStore.counter.value}'),),
            // Observer(builder: (_) => Text('${MyStore.billStore.date}'),),
            // RaisedButton(child: Text('增加'), onPressed: counter.increment, color: Theme.of(context).primaryColor, textColor: Colors.white,),
            // RaisedButton(child: Text('初始化'), onPressed: counter.init,),
            // Icon(IconData(0xe6af, fontFamily: "iconfont", matchTextDirection: true), color: Colors.red, size: 16,),
            // SqfDemoPage(),
          ],
        ),
      ),
    );
  }
}
