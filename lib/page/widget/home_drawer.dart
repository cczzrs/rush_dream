import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rush_dream/common/config/config.dart';
import 'package:rush_dream/common/config/localization/default_localizations.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:rush_dream/common/local/local_storage.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:rush_dream/common/utils/navigator_utils.dart';
import 'package:rush_dream/page/widget/gsy_flex_button.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';

/// 我的主页 drawer
class HomeDrawer extends StatefulWidget {
    static final String sName = "home_drawer";

    @override
    _HomeDrawerState createState() => _HomeDrawerState();
}

/// 我的主页 drawer
class _HomeDrawerState extends State<HomeDrawer> with SingleTickerProviderStateMixin {
    TabController _tabController;

    /// 主题切换
    showThemeDialog(BuildContext context, Store store) {
        List<String> list = [
            CommonUtils.getLocale(context).home_theme_default,
            CommonUtils.getLocale(context).home_theme_1,
            CommonUtils.getLocale(context).home_theme_2,
            CommonUtils.getLocale(context).home_theme_3,
            CommonUtils.getLocale(context).home_theme_4,
            CommonUtils.getLocale(context).home_theme_5,
            CommonUtils.getLocale(context).home_theme_6,
        ];
        CommonUtils.showCommitOptionDialog(context, list, (index) {
            CommonUtils.pushTheme(store, index);
            LocalStorage.save(Config.THEME_COLOR, index.toString());
        }, colorList: CommonUtils.getThemeListColor());
    }

    /// 语言切换
    showLanguageDialog(BuildContext context, Store store) {
        List<String> list = [
            CommonUtils.getLocale(context).home_language_default,
            CommonUtils.getLocale(context).home_language_zh,
            CommonUtils.getLocale(context).home_language_en,
        ];
        CommonUtils.showCommitOptionDialog(context, list, (index) {
            CommonUtils.changeLocale(store, index);
            LocalStorage.save(Config.LOCALE, index.toString());
        }, height: 150.0);
    }

    /// 关于
    showAboutDialog(BuildContext context, String versionName) {
        versionName ??= "Null";
        showDialog(
            context: context,
            builder: (BuildContext context) => AboutDialog(
                applicationName: CommonUtils.getLocale(context).app_name,
                applicationVersion: CommonUtils.getLocale(context).app_version + ": " + versionName,
                applicationIcon: new Image(image: new AssetImage(GSYICons.DEFAULT_USER_ICON), width: 50.0, height: 50.0),
                applicationLegalese: "http://github.com/cczzrs",
            ));
    }

    @override
    Widget build(BuildContext context) {
        return Material(
            color: Colors.red,
            child: Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: AssetImage(
                            "static/images/bjt-13.png",
                        ),
                        fit: BoxFit.cover,
                    ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: AlignmentDirectional.centerStart,
//            margin: new EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                child: Container(
                    decoration: new BoxDecoration(
                        //用一个BoxDecoration装饰器提供背景图片
                        color: Colors.transparent,
                    ),
                    margin: const EdgeInsets.only(left: 0.0),
                    width: 130.0,
                    height: 594.0,
//                    margin: new EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                    child: StoreBuilder<FMState>(builder: (context, store) {
                        Map user = store.state.userInfo;
                        var c_height = 50.0;
                        // 组件包装
                        tsm(decoration, icon, text, onTap){
                            return Container(
                                height: c_height,
                                decoration: decoration,//FMContainer.decoration_ts,
                                child: ListTile(
                                    contentPadding: EdgeInsets.all(0.0),
                                    title: Row(
                                        children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(left:8.0, right: 10.0),
                                                child: icon,//Icon(Icons.account_balance_wallet),
                                            ),
                                            Text(
                                                text,// CommonUtils.getLocale(context).home_change_theme
                                                style: GSYConstant.normalText,
                                            )
                                        ],
                                    ),
                                    onTap: onTap,
                                ),
                            );
                        }
                        List<Widget> showList = [
                            new UserAccountsDrawerHeader(
                                decoration: FMContainer.decoration,
                                currentAccountPicture: new GestureDetector(
                                    //用户头像
                                    child: new Image.network(user["avatar"] ?? GSYICons.DEFAULT_REMOTE_PIC, height: 180.0, width: 180.0),
                                    onTap: () {},
                                ),
                                accountName: new Text(
                                    user["username"] ?? "---",
                                    style: GSYConstant.normalTextLight,
                                ),
                                accountEmail: new Text(
                                    user["email"] ?? user["name"] ?? "---",
                                    style: GSYConstant.normalTextLight,
                                ),
                            ),
                            new Container(
                                decoration: FMContainer.decoration,
                                child: Column(
                                    children: [
                                        tsm(FMContainer.decoration_ts_start, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).home_history,(){
                                        }),
                                        tsm(FMContainer.decoration_ts, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).home_user_info,(){
//                                            NavigatorUtils.gotoUserProfileInfo(context);
                                        }),
                                        tsm(FMContainer.decoration_ts, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).home_change_theme,(){
                                            showThemeDialog(context, store);
                                        }),
                                        tsm(FMContainer.decoration_ts, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).home_change_language,(){
                                            showLanguageDialog(context, store);
                                        }),
                                        tsm(FMContainer.decoration_ts, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).home_check_update,(){
//                                            ReposDao.getNewsVersion(context, true);
                                        }),
                                        tsm(FMContainer.decoration_ts, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).home_about,(){
                                            PackageInfo.fromPlatform().then((value) {
                                                print(value);
                                                showAboutDialog(context, value.version);
                                            });
                                        }),
                                        tsm(FMContainer.decoration_ts, Icon(Icons.account_balance_wallet), "账号安全",(){
                                            PackageInfo.fromPlatform().then((value) {
                                                print(value);
                                                showAboutDialog(context, value.version);
                                            });
                                        }),
                                        tsm(FMContainer.decoration_ts_end, Icon(Icons.account_balance_wallet), CommonUtils.getLocale(context).Login_out,(){
//                                            UserDao.clearAll(store);
//                                            SqlManager.close();
                                            NavigatorUtils.goLogin(context);
                                        }),
                                    ],
                                ),
                            ),
                        ];
                        Offset _offset = Offset(0.4, 0.7); // new
                        return new Container(
//                            decoration: FMContainer.decoration,
//                constraints: new BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                            child: new Column(children: showList),
                        );
                    }),
                ),
            ),
        );
    }
}
