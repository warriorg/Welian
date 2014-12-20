/* 
 * @Author: 1
 * @Date:   2014-12-12 10:43:06
 * @Last Modified by:   1
 * @Last Modified time: 2014-12-17 15:25:13
 */

define(function(require, exports, module) {
    var config = seajs.data.vars;
    /**
     * 调取失败的通用方法
     * @param  {[type]} err [description]
     * @return {[type]}     [description]
     */
    function errorCallback(err) {
        alert(err);
    }

    /**
     * 调取成功的通用方法
     * @param  {[type]} msg [description]
     * @return {[type]}     [description]
     */
    function successCallback(msg) {}

    /**
     * 获取sessionid
     */
    exports.getSessionId = function(callback) {
        cordova.exec(callback, errorCallback, config.SERVICE, config.ACTION_GET_SESSIONID, []);

    }

    /**
     * 获取头部高度
     */
    exports.getHeaderHeight = function(callback) {
        cordova.exec(callback, errorCallback, config.SERVICE, config.ACTION_GET_HEADER_HEIGHT, []);
    }

    /**
     * 调取app分享组件
     * @return {[type]} [description]
     */
    exports.share = function(msg) {
        cordova.exec(successCallback, errorCallback, config.SERVICE, config.ACTION_SHARE, [msg]);
    }

    /**
     * 微信支付
     * @param  {[type]} money [description]
     * @return {[type]}       [description]
     */
    exports.wechatPay = function(money, callback) {
        cordova.exec(callback, errorCallback, config.SERVICE, config.ACTION_SHARE, money);
    }

    /**
     * 获取用户信息
     * @param  {Function} callback [description]
     * @return {[type]}            [description]
     */
    exports.getUserinfo = function(callback) {
       cordova.exec(callback, errorCallback, config.SERVICE, config.ACTION_GET_USERINFO, []);
    }
       
/**
 * 页面加载完毕通知app
 * @return {[type]} [description]
 */
exports.pageLoadComplete = function() {
    cordova.exec(successCallback, errorCallback, config.SERVICE, config.ACTION_PAGE_LOAD_COMPLETE, []);
}

/**
 * 返回上一页
 */
exports.backToDiscover = function() {
    cordova.exec(successCallback, errorCallback, config.SERVICE, config.ACTION_BACK_TO_DISCOVER, []);
}
});
