import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rush_dream/page/home_page.dart';
import 'package:rush_dream/page/widget/home_drawer.dart';
import 'package:rush_dream/test/v.dart';

/// 我的主页
class MyHomePage extends StatefulWidget {
  static final String sName = "myhome";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/// 首页 State
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  /// X 轴旋转影响的参数是 6、7、10、11
  /// Y 轴旋转影响的参数是 1、3、9、11
  /// Z 轴旋转影响的参数是 1、2、5、6
  var m4F = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  Matrix4 m4;
//    m4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 30, 0, 0, 1);

  /// X 轴
//    m4 = Matrix4(1, 0, 0, 0, 0, cos(pi / 6), sin(pi / 6), 0, 0, -sin(pi / 6), cos(pi / 6), 0, 0, 0, 0, 1);

  /// Y 轴
//    m4 = Matrix4(cos(pi / 6), 0, pi / 6, 0, 0, 1, 0, 0, sin(pi / 6), 0, cos(pi / 6), 0, 0, 0, 0, 1);

  /// Z 轴
//    m4 = Matrix4(cos(pi / 6), sin(pi / 6), 0, 0, -sin(pi / 6), cos(pi / 6), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

  /// test math.pi / 2
//    m4 = Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(pi / 6);
//        m4._m4storage[1] = math.tan(beta);
//        m4._m4storage[4] = math.tan(alpha);
//        Matrix4.skew(pi/6,0);

  @override
  void initState() {
    super.initState();
    initHomeStyle();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  /// 初始化默认页面
  void initHomeStyle() {
//        setState(() {
//            m4 = m4F;
//        });
  }

  /// 后台应用
  Future<bool> _dialogExitApp(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent =
          AndroidIntent(action: 'android.intent.action.MAIN', category: "android.intent.category.HOME");
      await intent.launch();
    }
    return Future.value(false);
  }

  /// 首页
  @override
  Widget build(BuildContext context) {
//    SlideStack(
//      child: SlideContainer(
//        key: _slideKey,
//        child: Container(
//          /// widget mian.
//        ),
//        slideDirection: SlideDirection.top,
//        onSlide: onSlide,
//        drawerSize: maxSlideDistance,
//        transform: transform,
//      ),
//      drawer: Container(
//        /// widget drawer.
//      ),
//    );
    return getBuild(context);

    /// 设置动画页面
    return WillPopScope(
      /// 返回按键触发后，后台应用
      onWillPop: () {
//                if(m4 == m4F){
        return _dialogExitApp(context);
//                }else{
//                    initHomeStyle();/// 初始化默认页面
//                }
      },
      child: getBuild(context),

      /// 设置动画页面
//            new Transform(
//                 Transform widget
//                transform: m4, /// 设置动画操作
//                alignment: FractionalOffset.centerRight, /// 设置动画操作轴
//                child:
//                getBuild(context), /// 设置动画页面
//            ),
    );
  }

  /// 顶部 tabs
  List<Widget> tabs = [
    Tab(text: "视频"),
    Tab(text: "精选"),
    Tab(text: "test2"),
    Tab(text: "问答"),
    Tab(text: "说说"),
//            _renderTab(GSYICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic),
//            _renderTab(GSYICons.MAIN_QS, CommonUtils.getLocale(context).home_trend),
//            _renderTab(GSYICons.MAIN_MY, CommonUtils.getLocale(context).home_my),
  ];

  /// 主体内容
  List<Widget> bodys = [
    V1Widget(s: "视频..."),
    V1Widget(s: "精选..."),
    V1Widget(s: "test2..."),
    V1Widget(s: "问答..."),
    V1Widget(s: "说说..."),
  ];

  _renderTab(icon, text) {
    return new Tab(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Icon(icon, size: 16.0), new Text(text)]));
  }

  /// 点击头像事件
  void leadingPressed() {
//                        NavigatorUtils.goMyHomeDrawer(context);
    setState(() {
      m4 = Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(pi / 2.8);

      /// 带参数的路由跳转，并且监听返回
//            Navigator.push(context, new MaterialPageRoute(builder: (context) =>
//            new Transform(
//                // Transform widget
//                transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(pi / 2.8), /// 设置动画操作
//                alignment: FractionalOffset.centerLeft, /// 设置动画操作轴
//                child: HomeDrawer(), /// 设置动画页面
//            ),
//            )).then((res) {
//                /// 获取返回处理
//                print("HomeDrawer=========back");
//                initHomeStyle();/// 初始化默认页面
//            });
    });

    Scaffold.of(context).openDrawer();
  }

  /// 首页结构
  Widget getBuild(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
//                color: Colors.transparent,
        //用一个BoxDecoration装饰器提供背景图片
//                borderRadius: BorderRadius.all(Radius.circular(4.0)),
        image: new DecorationImage(
          image: AssetImage(
            "static/images/bjt-13.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        // Opacity
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              //用一个BoxDecoration装饰器提供背景图片
              color: Colors.transparent,
            ),
            child: new HomeDrawer(),
            width: 130.0,
            height: 594.0,
            margin: new EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
          ),
          new Container(
            child: new Container(
              child: new HomePage(),
              width: 150.0,
              height: 250.0,
            ),
            width: 220.0,
            height: 450.0,
            margin: new EdgeInsets.only(right: 0.0, bottom: 0.0),
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
    return Scaffold(
      // currentAccountPicture
//            drawer: new HomeDrawer(),
      appBar: new AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
                icon: new CircleAvatar(backgroundImage: AssetImage("static/images/touxiang.jpg")),
                onPressed: () {
                  setState(() {
//                                Scaffold.of(context).openDrawer();
                    m4 = Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(pi / 2.8);

                    /// 带参数的路由跳转，并且监听返回
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new Transform(
                                // Transform widget
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(pi / 2.8),

                                /// 设置动画操作
                                alignment: FractionalOffset.centerLeft,

                                /// 设置动画操作轴
                                child: HomeDrawer(),

                                /// 设置动画页面
                              ),
                        )).then((res) {
                      /// 获取返回处理
                      print("HomeDrawer=========back");
                      initHomeStyle();

                      /// 初始化默认页面
                    });
                  });
                },
              ),
        ),
        title: new TabBar(
          controller: _tabController,
          tabs: tabs,
          indicatorColor: Colors.grey[400],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[400],
        ),
      ),
//            body: new TabBarView(
//                controller: _tabController,
//                children: bodys,
//            ),
      body: new Container(
        color: Colors.black,
        child: new Stack(
          children: <Widget>[
//                            new Center(child: new Image.asset("static/images/touxiang.jpg"), heightFactor: 180.0, widthFactor: 180.0),
            new Center(child: new HomeDrawer(), heightFactor: 180.0, widthFactor: 180.0),
//                            new Center(child: new SpinKitFoldingCube(color: Colors.white30, size: 60.0)),
          ],
        ),
      ),
    );

//        return new ListView(
//            children: <Widget>[
////                new HomeDrawer(),
//                homePage,
//            ],
//        );
  }
}
