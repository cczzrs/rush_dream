import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rush_dream/common/config/config.dart';
import 'package:rush_dream/common/local/local_dao.dart';
import 'package:rush_dream/common/local/local_storage.dart';
import 'package:rush_dream/common/net/address.dart';
import 'package:rush_dream/common/net/code.dart';

import 'dart:collection';

import 'package:rush_dream/common/net/interceptors/error_interceptor.dart';
import 'package:rush_dream/common/net/interceptors/header_interceptor.dart';
import 'package:rush_dream/common/net/interceptors/log_interceptor.dart';

import 'package:rush_dream/common/net/interceptors/response_interceptor.dart';
import 'package:rush_dream/common/net/interceptors/token_interceptor.dart';
import 'package:rush_dream/common/net/net_data_model.dart';
import 'package:rush_dream/common/redux/user_redux.dart';
import 'package:rush_dream/common/utils/common_utils.dart';
import 'package:redux/redux.dart';

/// http请求
class HttpManager {
    static const CONTENT_TYPE_JSON = "application/json";
    static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

    Dio _dio = new Dio(); // 使用默认配置

    final TokenInterceptors _tokenInterceptors = new TokenInterceptors();

    HttpManager() {
        _dio.interceptors.add(new HeaderInterceptors());

        _dio.interceptors.add(_tokenInterceptors);

        _dio.interceptors.add(new LogsInterceptors());

        _dio.interceptors.add(new ErrorInterceptors(_dio));

        _dio.interceptors.add(new ResponseInterceptors());
    }

    /// 发起网络请求
    /// [ url] 请求url
    /// [ params] 请求参数
    /// [ header] 外加头
    /// [ option] 配置
    Future<ResultData> netFetch(url, params, Options option, {Map<String, dynamic> header, noTip = false}) async {
        option ??= new Options(method: "get");
        option.headers = new HashMap<String, dynamic>();
        option.headers["Content-Type"] = CONTENT_TYPE_JSON;
        if (header != null) {
            option.headers.addAll(header);
        }
        try {
            Response res = await _dio.request(url, data: params, options: option);
            return res.data;
        } on DioError catch (e) {
            Response errorResponse = e.response == null ? new Response(statusCode: 666) : e.response;
            if (e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {
                errorResponse.statusCode = Code.NETWORK_TIMEOUT;
            }
            return new ResultData(
                Code.errorHandleFunction(errorResponse.statusCode, e.response.data, noTip), false, errorResponse.statusCode);
        }
    }

    /// 获取授权token
    getAuthorization() async {
        return _tokenInterceptors.getAuthorization();
    }

    /// 清除授权
    clearAuthorization() {
        _tokenInterceptors.clearAuthorization();
    }
}

/// 使用实例
final HttpManager httpManager = new HttpManager();

/// 后台 url 请求 api
class API {
    /// 验证并更新本地授权 token
    static refreshToken() async {
        // 旧的授权 token 会被拦截器自动添加到请求头部中
        var res = await httpManager.netFetch(Address.refreshToken, null, Options(method: "post"), noTip: true);
        if (res != null) {
            if (Config.DEBUG) {
                print("++++API.refreshToken res:" + res.result.toString());
                print(res.data);
                print(res.data.toString());
            }
            if (res.result) {
                // 成功正确响应
                return new DataResult(res.data, res.result);
            }
            return new DataResult(res.data, res.result);
        }
        return new DataResult({
            "mobile": ["发起请求失败！"]
        }, false);
    }

    /// 获取当前用户信息
    static getMyUserInfo() async {
        var res = await httpManager.netFetch(Address.myUserInfo, null, Options(method: "get"), noTip: true);
        if (res != null) {
            if (Config.DEBUG) {
                print("++++API.getMyUserInfo res:" + res.result.toString());
                print(res.data);
                print(res.data.toString());
            }
            if (res.result) {
                // 成功正确响应
                LocalStorage.save(Config.USER_INFO, jsonEncode(res.data)); // 保存用户信息到本地
                return new DataResult(res.data, res.result);
            }
            return new DataResult(res.data, res.result);
        }
        return new DataResult({
            "mobile": ["发起请求失败！"]
        }, false);
    }

    /// 请求发送短信验证码
    static sendVerifyCode(String mobile) async {
//        httpManager.clearAuthorization(); // 清除本地 授权认证
        Map requestParams = {"mobile": mobile};
        var res = await httpManager.netFetch(Address.getVerifyCode, json.encode(requestParams), Options(method: "post"),
            noTip: true);
        if (res != null) {
            if (Config.DEBUG) {
                print("user result " + res.result.toString());
                print(res.data);
                print(res.data.toString());
            }
            if (res.result) {
                // 成功正确响应
                return new DataResult(res.data, res.result);
            }
            return new DataResult(res.data, res.result);
        }
        return new DataResult({
            "mobile": ["发起请求失败！"]
        }, false);
    }

    static login(String userName, String password, Store store) async {
        String type = userName + ":" + password;
        var bytes = utf8.encode(type);
        var base64Str = base64.encode(bytes);
        if (Config.DEBUG) {
            print("base64Str login " + base64Str);
        }
        await LocalStorage.save(Config.USER_NAME_KEY, userName);

        Map requestParams = {
            "username": userName,
            "password": password,
//      "client_id": Config.CLIENT_ID,
//      "client_secret": NetConfig.CLIENT_SECRET
        };
        httpManager.clearAuthorization(); // 清除授权认证

        var res =
        await httpManager.netFetch(Address.login, json.encode(requestParams), Options(method: "post"), noTip: true);
        if (res != null) {
            if (res.result) {
                if (Config.DEBUG) {
                    print("user result " + res.result.toString());
                    print(res.data);
                    print(res.data.toString());
                }
                if (password.toString().length > 4) {
                    // 密码本地化-  <= 4位为短信验证码，不本地化
                    LocalStorage.save(Config.PW_KEY, password);
                }
                LocalStorage.save(Config.USER_INFO, jsonEncode(res.data));
//        resultData = Local.getUserInfoLocal();
                store.dispatch(new UpdateUserAction(res.data));
                return new DataResult(res.data, true);
            }
            return new DataResult({"error": res.data["non_field_errors"]}, false);
        }
        return new DataResult({
            "error": ["发起请求失败！"]
        }, false);
    }

    /// 验证并更新本地授权 token ， 初始化用户信息
    static initUserInfo(Store store) async {
        var res = await getRefreshToken(); // 验证并更新本地授权 token 并获取本地用户信息
        var token = await LocalStorage.get(Config.TOKEN_KEY); // 获取本地新授权 token

        if (res != null && res.result && token != null) {
            store.dispatch(UpdateUserAction(res.data));
        } else {
            // 无法提供认证，请去登陆
            return new DataResult(null, false);
        }

        /// 读取主题
        String themeIndex = await LocalStorage.get(Config.THEME_COLOR);
        if (themeIndex != null && themeIndex.length != 0) {
            CommonUtils.pushTheme(store, int.parse(themeIndex));
        }

        /// 切换语言
        String localeIndex = await LocalStorage.get(Config.LOCALE);
        if (localeIndex != null && localeIndex.length != 0) {
            CommonUtils.changeLocale(store, int.parse(localeIndex));
        }

        return new DataResult(res.data, true);
    }

    /// 验证并更新本地授权 token 并获取本地用户信息
    static getRefreshToken() async {
        var res = await refreshToken(); // 验证并更新本地授权 token
        if (res != null && res.result) {
            // 验证并更新本地授权 token 成功
            var localUser = await LocalStorage.get(Config.USER_INFO); // 获取本地用户信息
            if (localUser != null) {
                return new DataResult(json.decode(localUser), true);
            } else {
                var user = await getMyUserInfo(); // 更新本地用户信息
                return new DataResult(json.decode(user.data), true);
            }
        } else {
            // 认证失败，无法提供认证
            return new DataResult(null, false);
        }
    }
}
