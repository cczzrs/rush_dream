import 'package:flutter/material.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/**
 * 通知消息
 * Created by guoshuyu
 * Date: 2018-07-24
 */

class NotifyPage extends StatefulWidget {
  NotifyPage();

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final SlidableController slidableController = new SlidableController();

  int selectIndex = 0;

  _NotifyPageState();

  _renderItem(index) {
//    Model.Notification notification = pullLoadWidgetControl.dataList[index];
//    if (selectIndex != 0) {
//      return _renderEventItem(notification);
//    }
//    return new Slidable(
//      controller: slidableController,
//      delegate: new SlidableDrawerDelegate(),
//      actionExtentRatio: 0.25,
//      child: _renderEventItem(notification),
//      secondaryActions: <Widget>[
//        new IconSlideAction(
//          caption: CommonUtils.getLocale(context).notify_readed,
//          color: Colors.redAccent,
//          icon: Icons.delete,
//          onTap: () {
//            UserDao.setNotificationAsReadDao(notification.id.toString()).then((res) {
//              showRefreshLoading();
//            });
//          },
//        ),
//      ],
//    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(GSYColors.mainBackgroundColor),
      appBar: new AppBar(
//        title: GSYTitleBar(
//          CommonUtils.getLocale(context).notify_title,
//          iconData: GSYICons.NOTIFY_ALL_READ,
//          needRightLocalIcon: true,
//          onPressed: () {
//            CommonUtils.showLoadingDialog(context);
//          },
//        ),
    )
    );
  }
}
