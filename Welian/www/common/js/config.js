seajs.config({
    base: './',
    charset: 'utf-8',
    paths: {
        'common': 'common/js',
        'activity': 'activity/js',
        'plugins': 'common/plugins'
    },
    alias: {
        'zepto': 'common/zepto.min.js',
        'common': 'common/common.js',
        'backbone': 'common/backbone.min.js',
        'iscroll': 'plugins/iscroll.js',
        'iscroll-probe': 'plugins/iscroll-probe.js',
        'cordova': 'common/cordova.js',
        'appjs': 'common/app.min.js',
        'json': 'common/json.js'
    },
    vars: {
        'apiUrl' : 'http://testmy.welian.com/apistore/event/',
        'TYPE_GET_ACTIVITY_LIST' : 'loadActives',
        'TYPE_GET_ENTRIES': 'loadActiveJoins',
        'TYPE_GET_ACTIVITY_CITY': 'loadActiveCity',
        'TYPE_JOIN_ACTIVITY': 'joinActive',
        'TYPE_GET_TICKETS': 'getTickets',
        'TYPE_GET_ACTIVITY': 'loadOneActive',
        'SERVICE': 'Welian',
        'ACTION_SHARE': 'share',
        'ACTION_PAGE_LOAD_COMPLETE': 'pageOnComplete',
        'ACTION_BACK_TO_DISCOVER': 'backToDiscover',
        'ACTION_GET_SESSIONID': 'getSessionId',
        'ACTION_GET_HEADER_HEIGHT': 'getHeadHeight',
        'ACTION_WECHAT_PAY': 'wechatpay',
        'ACTION_GET_USERINFO': 'getUserInfo',
    }
});
