import 'package:rush_dream/common/config/config.dart';

/// 地址数据
class Address {
    static const String host = "http://192.168.0.105/";
    static const String hostWeb = "https://github.com/";
    static const String downloadUrl = 'https://www.pgyer.com/GSYGithubApp';
    static const String graphicHost = 'https://ghchart.rshah.org/';
    static const String updateUrl = 'https://www.pgyer.com/vj2B';

    ///处理分页参数
    static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
        if (page != null) {
            if (pageSize != null) {
                return "${tab}page=$page&per_page=$pageSize";
            } else {
                return "${tab}page=$page";
            }
        } else {
            return "";
        }
    }

    /// 验证并更新本地授权 token
    static final refreshToken = host + "api-token-refresh/";

    /// 获取用户信息
    static final myUserInfo = host + "userInfo/1/";

    /// 获取短信验证码
    static final getVerifyCode = host + "code/";

    /// 登录获取授权 token
    static final login = host + "login/";

}
