import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rush_dream/common/config/config.dart';
import 'package:rush_dream/common/config/style/gsy_style.dart';
import 'package:rush_dream/common/local/local_storage.dart';
import 'package:rush_dream/common/net/api.dart';
import 'package:rush_dream/common/redux/fm_state.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:rush_dream/common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rush_dream/page/widget/gsy_flex_button.dart';

/// 登录/注册页
class LoginPage extends StatefulWidget {
  static final String sName = "login";

  @override
  State createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _userName = "";
  var _password = "";

  // 输入框字段
  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwCodeController = new TextEditingController();

  // 输入框的键盘焦点对象
  FocusNode focusPhone = new FocusNode();
  FocusNode focusCode = new FocusNode();

  // 输入框错误提示信息
  String _correctPhoneErrorText;
  String _correctPhoneCodeErrorText;

  var store;
  _LoginPageState() : super();

  @override
  void initState() {
    super.initState();
    initParams();
  }

  // 初始化，本地用户名和密码 数据
  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwCodeController.value = new TextEditingValue(text: _password ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<FMState>(builder: (context, store) {
      this.store = store;
      return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: new Container(
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
//            color: Theme.of(context).primaryColor,
            child: new Align(
              alignment: const Alignment(1.0, 0.5),
              //防止overFlow的现象
              child: SafeArea(
                child: SingleChildScrollView(
                  child: new Card(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    color: Colors.white70,
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: new Padding(
                      padding: new EdgeInsets.only(left: 30.0, top: 0.0, right: 30.0, bottom: 0.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
//                          new Image(image: new AssetImage(GSYICons.DEFAULT_USER_ICON), width: 90.0, height: 90.0),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          // 账号、手机号、邮箱输入框
                          new TextField(
                            controller: userController,
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.black,
                            focusNode: focusPhone,
                            decoration: InputDecoration(
                              hintText: CommonUtils.getLocale(context).login_username_hint_text,
                              errorText: _correctPhoneErrorText,
                              icon: new Icon(GSYICons.LOGIN_USER, color: Colors.black),
//                              filled: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                            onChanged: (value) {
                              _phoneChanged(value);
                            },
                            onEditingComplete: () {
                              print('onEditingComplete');
                            },
                            onSubmitted: (value) {
                              _checkInput();
                            },
                            onTap: () {
                              print('=======TODO=======onTap');
                            },
                          ),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          // 密码输入框
                          new TextField(
                            controller: pwCodeController,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            cursorColor: Colors.black,
                            focusNode: focusCode,
                            decoration: new InputDecoration(
                              hintText: CommonUtils.getLocale(context).login_password_hint_text,
                              errorText: _correctPhoneCodeErrorText,
                              icon: new Icon(GSYICons.LOGIN_PW, color: Colors.black),
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                            onSubmitted: (value) {
                              _checkInput();
                            },
                          ),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                          // 按钮
                          new Row(children: <Widget>[
                            // 获取短信验证码按钮
                            Expanded(
                              flex: 30,
                              child: new GSYFlexButton(
                                text: CommonUtils.getLocale(context).hqyzm_text,
                                color: Theme.of(context).primaryColor, // 跟随主体颜色
                                textColor: Color(GSYColors.textWhite),
                                onPress: _getVerifyCode,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Padding(padding: new EdgeInsets.all(0.0)),
                            ),
                            // 登录按钮
                            Expanded(
                              flex: 30,
                              child: new GSYFlexButton(
                                text: CommonUtils.getLocale(context).login_text,
                                color: Theme.of(context).primaryColor,
                                textColor: Color(GSYColors.textWhite),
                                onPress: _handleSubmitted,
                              ),
                            ),
                          ]),
                          new Padding(padding: new EdgeInsets.all(10.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _openSignUp() {
    setState(() {
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) {
//          return new SignUpPage();
        },
      )).then((onValue) {
        if (onValue != null) {
          // 登录
          userController.text = onValue['mobile'];
        }
      });
    });
  }

  bool sendVerifyCoded = false; // 是否成功发送了验证码
  // 获取短信验证码 - 异步
  void _getVerifyCode() async {
    if (!_checkInput_phone()) {
      setState(() {});
      return;
    }

    CommonUtils.showLoadingDialog(context); // 显示加载中窗口
    // 请求后台
//    var value = {'result': true, 'error': ['ErroR!!',]}; // await HttpUtil.Pcode(phonenumber: userController.text);
    // 请求后台
    API.sendVerifyCode(userController.text).then((res) {
      Navigator.pop(context);
      if (res != null && res.result) {
        sendVerifyCoded = true;
        // 定位光标到验证码输入框
        FocusScope.of(context).requestFocus(focusCode);
        Fluttertoast.showToast(msg: "短信验证码已发送！", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 3, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
      } else {
        Fluttertoast.showToast(msg: res.data['mobile'][0], toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 3, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
      }
    }).catchError((e) {
//      Navigator.pop(context);
      Fluttertoast.showToast(msg: "耶，竟然错误了！", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
    });
  }

  /// 登录或注册事件
  Future _handleSubmitted() async {
    if (!_checkInput()) {
      return;
    }

//      value = {
//        "result": true,
//        "user_id": response.data["id"],
//        "user_name": response.data["username"],
//        "token": response.data['token']
//      }
    // 请求后台
//    var value = await HttpUtil.login(
//      phonenumber: userController.text,
//      password: pwCodeController.text,
//    );

    CommonUtils.showLoadingDialog(context); // 显示加载中窗口
    API.login(userController.text.trim(), pwCodeController.text.trim(), store).then((res) {
      Navigator.pop(context);

      if (res != null && res.result) {
        Fluttertoast.showToast(msg: "登录成功！", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
        var onBackInfo = {"result": res.data["result"], "user_id": res.data["user_id"], "user_name": res.data["user_name"], "token": res.data["token"]};

        new Future.delayed(const Duration(seconds: 1), () {
          NavigatorUtils.goHome(context);
          return true;
        });
        return true;
      } else {
        if (res.data != null && res.data["error"] != null) {
          Fluttertoast.showToast(msg: res.data["error"][0], toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
        } else {
          Fluttertoast.showToast(msg: "登录失败！请检查您的网络！", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 1, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
        }
        // 是否成功发送了验证码
        if (sendVerifyCoded) {
          setState(() {
            _correctPhoneCodeErrorText = "验证码或密码错误！"; // 验证码或密码错误信息
          });
        } else {}
      }
    }).catchError((e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "系统异常！", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIos: 10, backgroundColor: Color(0xffe74c3c), textColor: Color(0xffffffff));
      return false;
    });
  }

  // 检查输入框信息
  bool _checkInput() {
    bool ret = true;
    setState(() {
      ret = (_checkInput_phone() && _checkInput_code());
    });
    return ret;
  }

  // 手机号码输入实时检查
  void _phoneChanged(value) {
//    // 手机号码输入达到11为时，自动触发发送验证码并定位光标到验证码输入框
//    if (userController.text.trim().length == 11) {
//      // 验证是否为手机号  "^1[345678]\d{9}$"
//      if(new RegExp("^1[345678]\\d{9}\$").hasMatch(userController.text)){
//
//      }
//      // 获取短信验证码 - 异步
//      _getVerifyCode();
//      // 定位光标到验证码输入框
//      FocusScope.of(context).requestFocus(focusCode);
//    }
  }

  // 检查手机号码
  bool _checkInput_phone() {
    bool ret = true;
    if (userController.text.isEmpty) {
      _correctPhoneErrorText = '请输入手机号码';
      ret = false;
    } else if (userController.text.trim().length != 11) {
      _correctPhoneErrorText = '请保证手机号码长度为11位';
      ret = false;
    } else if (!new RegExp("^1[345678]\\d{9}\$").hasMatch(userController.text)) {
      _correctPhoneErrorText = '手机号码格式错误';
      ret = false;
    } else {
      // 验证通过
      _correctPhoneErrorText = null;
    }
    return ret;
  }

  // 检查短信验证码
  bool _checkInput_code() {
    bool ret = true;
    // 检查短信验证码
    if (pwCodeController.text.isEmpty) {
      _correctPhoneCodeErrorText = '请输入短信验证码';
      ret = false;
    } else if (pwCodeController.text.trim().length != 4) {
      _correctPhoneCodeErrorText = '请保证验证码长度为4位';
      ret = false;
    } else {
      _correctPhoneCodeErrorText = null;
    }
    return ret;
  }
}
