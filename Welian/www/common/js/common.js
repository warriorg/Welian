define(function(require, exports, module) {
    function getOs() {
        var u = navigator.userAgent;
        if (u.indexOf('Android') > -1 || u.indexOf('Linux') > -1) { //安卓手机
            return 1;
        } else if (u.indexOf('iPhone') > -1) { //苹果手机
            return 2;
        }
    }
    module.exports = {
        /**
         * 阻止事件传播
         * @type {[type]}
         */
        stopEvent: function(evt) {
            var evt = evt || window.event;
            if (evt.preventDefault) {
                evt.preventDefault();
                evt.stopPropagation();
            } else {
                evt.returnValue = false;
                evt.cancelBubble = true;
            }
        },
        /**
         * 将时间字符串转化成Date对象
         * @type 'yyyy-mm-dd hh:mm:ss'或者'yyyy/mm/dd hh:mm:ss'
         */
        parseDate: function(dateStr) {
            var timeStr = dateStr.replace(/-/g, '/');
            return new Date(timeStr);
        },
        back: function(currentPage, prevPage, callback) {
            //当前页面右移
            $(currentPage).css({
                '-webkit-transform': 'translateX(100%)',
            });
            //上一个页面右移
            $(prevPage).css({
                '-webkit-transform': 'translateX(0)',
            });
            //修改头部
            $('title').text($(prevPage).find('h1').text());

            callback && callback();
        },
        go: function(currentPage, nextPage) {
            //设置头部信息
            $('title').text($(nextPage).find('h1').text());
            $(nextPage).css({
                '-webkit-transform': 'translateX(0)',
            });
            $(currentPage).css({
                '-webkit-transform': 'translateX(-50%)',
            });
        },
        setHeadHeight: function(height) {
            var os = getOs();
            switch (os) {
                case 1:
                    $('.app-page .app-bar').css('height', height + 'px !important');
                    $('.app-page .app-bar h1').css('line-height', height + 'px !important');
                    break;
                case 2:
                    $('.app-page .app-bar').css('height', height + 'px !important');
                    $('.app-page .app-bar').css('paddingTop', '20px');
                    $('.app-page .app-bar-btn').css('paddingTop', '20px');
                    break;
            }
        },
        formatDate: function(str) {
            var obj = this.parseDate(str),
                weeks = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

            var times = str.split(' ')[1].split(':');
            return {
                date: (obj.getMonth() + 1) + '/' + obj.getDate(),
                week: weeks[obj.getDay()],
                hour: times[0] + ':' + times[1]
            };
        },
        getOs: getOs,
    }
});
