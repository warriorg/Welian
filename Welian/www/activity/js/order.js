define(function(require, exports, module) {
    var $ = require('zepto'),
        C = require('common'),
        M = require('activity/model'),
        V = require('activity/view'),
        N = require('activity/native'),
        order = {
            aid: 0,
            session_id: '',
            amount: 0,
            ticket: [],
            join: {}
        },
        clientHeight = $('body').height(), //文档高度
        headHeight = $('.app-bar').height();
    require('iscroll');
    /**
     * 关闭订单页面
     * @return {[type]}
     */
    function closeOrderPage() {
        $('#pageOrder .tickets-info').html('');
    }

    /**
     * 设置订单表格
     * @param {[type]}
     */
    function setTable(menu) {
        $('.J_TotalMoney').text(menu.total.money);
        var $table = V.getOrderTable(menu);
        $('#pageOrder .tickets-info').append($table);
        $('#pageOrder .app-content').height(clientHeight - headHeight);
        new IScroll('#pageOrder .app-content');
    }

    /**
     * 读取用户信息
     * @return {[type]}
     */
    function loadUserInfo() {
        N.getUserinfo(function(user) {
            $('.J_UserName').html(user.name);
            $('.J_UserMobile').html(user.mobile);
            $('.J_UserCompany').html(user.company);
            $('.J_UserPosition').html(user.position);
        });
    }

    /**
     * 初始化
     */
    exports.init = function(menu, callback) {
        if (null != menu) {
            order.aid = $('#J_Aid').val();
            order.session_id = $('#J_WechatId').val();
            order.amount = menu.total.money;
            var arr = new Array();
            for (var i = 0; i < menu.list.length; i++) {
                var t = menu.list[i];
                arr.push({
                    tid: t.id,
                    num: t.num
                });
            };
            order.ticket = arr;
        }
        $('#pageOrder .J_BackBtn').tap(function(e) {
            C.back('#pageOrder', '#pageDetail', function() {
                closeOrderPage();
            });
        });
        $('.J_BtnPay').tap(function() {
            $('.J_BtnPay').tap(function() {
                var user = getUserInfo();
                if (user) {
                    order.join = user;
                }
            });
            N.wechatPay();
        });
        setTable(menu);
        loadUserInfo();
        callback();
    }
});
