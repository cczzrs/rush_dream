import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:rush_dream/common/utils/navigator_utils.dart';
import 'package:rush_dream/page/home.dart';
import 'package:rush_dream/page/widget/gsy_tabbar_widget.dart';
import 'package:rush_dream/page/widget/home_drawer.dart';
import 'package:rush_dream/test/v.dart';

/**
 * 主页
 * Created by guoshuyu
 * Date: 2018-07-16
 */
/// 我的主页
class HomePage extends StatefulWidget {
    static final String sName = "home";

    final VoidCallback tapDrawer;
    HomePage({Key key, this.tapDrawer}) : super(key: key);
    @override
    _HomePageState createState() => _HomePageState(this.tapDrawer);
}

/// 首页 State
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
    TabController _tabController;
    final VoidCallback tapDrawer;
    _HomePageState(this.tapDrawer);

    /// 顶部 tabs
    List<Widget> tabs = [
        Tab(text: "视频"),
        Tab(text: "精选"),
        Tab(text: "test"),
        Tab(text: "问答"),
        Tab(text: "说说"),
    ];

    /// 主体内容
    List<Widget> bodys = [
        V1Widget(s: "视频..."),
        V1Widget(s: "精选..."),
        V1Widget(s: "test..."),
        V1Widget(s: "问答..."),
        V1Widget(s: "说说..."),
    ];

    @override
    void initState() {
        super.initState();
        initHomeStyle();
        _tabController = new TabController(vsync: this, length: tabs.length);
    }

    /// 初始化默认页面
    void initHomeStyle() {}

    /// 后台应用
    Future<bool> _dialogExitApp(BuildContext context) async {
        if (Platform.isAndroid) {
            AndroidIntent intent =
            AndroidIntent(action: 'android.intent.action.MAIN', category: "android.intent.category.HOME");
            await intent.launch();
        }
        return Future.value(false);
    }

    /// 点击头像事件
    void leadingPressed(context) {
        tapDrawer();
    }

    /// 首页
    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            /// 返回按键触发后，后台应用
            onWillPop: () {
                return _dialogExitApp(context);
            },
            child: StoreBuilder<FMState>(builder: (context, store) {
                Map user = store.state.userInfo;
                return new Scaffold(
//        drawer: new HomeDrawer(),// 已自定义，无需配置
                    appBar: new AppBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        leading: Builder(
                            builder: (context) => IconButton(
                                icon: CircleAvatar(backgroundImage: NetworkImage(user["avatar"] ?? GSYICons.DEFAULT_REMOTE_PIC)),
                                onPressed: () => leadingPressed(context),
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
                    body: new PageView(
//        controller: _pageController,
                        children: bodys,
                        onPageChanged: (index) {
                            _tabController.animateTo(index);
                            ////            _onPageChanged?.call(index);
                        },
                    ),
//        new TabBarView(
//        controller: _tabController,
//        children: bodys,
//      ),
                );
            }
            ),
        );

    }
}
