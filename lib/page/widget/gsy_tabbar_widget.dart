import 'package:flutter/material.dart';

/// 支持顶部和顶部的TabBar控件
/// 配合AutomaticKeepAliveClientMixin可以keep住
class GSYTabBarWidget extends StatefulWidget {
  /// 顶部模式

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final ValueChanged onPageChanged;

  GSYTabBarWidget({
    Key key,
    this.tabItems,
    this.tabViews,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _GSYTabBarState createState() => new _GSYTabBarState(
    tabItems,
        tabViews,

        onPageChanged,
      );
}

class _GSYTabBarState extends State<GSYTabBarWidget> with SingleTickerProviderStateMixin {

  final List<Widget> tabs;

  final List<Widget> bodys;


  final PageController _pageController = PageController();

  final ValueChanged<int> leadingPressed;

  _GSYTabBarState(
    this.tabs,
    this.bodys,
    this.leadingPressed,
  ) : super();

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: tabs.length);
  }

  ///整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      ///顶部tab bar
      return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: new CircleAvatar(
                  backgroundImage: AssetImage("static/images/touxiang.jpg")),
                  onPressed: (){

                  },
            ),
          ),
          title: new TabBar(
            controller: tabController,
            tabs: tabs,
            indicatorColor: Colors.grey[400],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[400],
          ),
        ),
        body: new PageView(
          controller: _pageController,
          children: bodys,
          onPageChanged: (index) {
            tabController.animateTo(index);
//            _onPageChanged?.call(index);
          },
        ),
      );

  }
}

class TarWidgetControl {
  List<Widget> footerButton = [];
}
