function errorCallback() {

}

function successCallback() {

}
var Native = {
    getSessionId: function(callback) {
        this.ready(function() {
            cordova.exec(callback, errorCallback, configs.SERVICE, configs.ACTION_GET_SESSIONID, []);
        });
    },
    getUserInfo: function(callback) {
        this.ready(function() {
            cordova.exec(callback, errorCallback, configs.SERVICE, configs.ACTION_GET_USERINFO, []);
        });
    },
    showDialog: function(msg) {
        this.ready(function() {
            cordova.exec(successCallback, errorCallback, configs.SERVICE, configs.ACTION_SHOW_DIALOG, [msg]);
        });
    },
    showEntry: function(aid) {
        this.ready(function() {
            cordova.exec(successCallback, errorCallback, configs.SERVICE, configs.ACTION_SHOW_ENTRY, [aid]);
        });
    },
    goToDetail: function(aid) {
        this.ready(function() {
            cordova.exec(successCallback, errorCallback, configs.SERVICE, configs.ACTION_GOTO_DETAIL, [aid]);
        });
    },
    goToOrder: function(aid, order) {
        this.ready(function() {
            cordova.exec(successCallback, errorCallback, configs.SERVICE, configs.ACTION_GOTO_ORDER, [aid, order]);
        });
    },
    wechatpay: function(callback) {
        this.ready(function() {
            cordova.exec(callback, errorCallback, configs.SERVICE, configs.ACTION_WECHAT_PAY, [aid]);
        });
    },
    goToMap: function(city, address) {
        this.ready(function() {
            cordova.exec(successCallback, errorCallback, configs.SERVICE, configs.ACTION_GOTO_MAP, [city, address]);
        });
    },
    getOrderInfo: function(callback) {
        this.ready(function() {
            cordova.exec(callback, errorCallback, configs.SERVICE, configs.ACTION_GET_ORDERINFO, []);
        });
    },
    ready: function(callback) {
        callback();
    }
};
