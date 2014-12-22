define(function(require, exports, module) {
    var $ = require('zepto'),
        C = require('common');

    var $spilt = $('<div class="split">以下为历史活动</div>');

    /**
     * 给UL中添加li
     * @param   selector  ul选择器
     * @param   list      数据列表
     */
    function appendLis(className, list) {
        for (var i = 0; i < list.length; i++) {
            var act = list[i],
                $li = $('<li class="item ' + className + ' J_ActivityItem" id="' + act.id + '"></li>'),
                tpl = formatTpl(act);

            $li.append(tpl);
            $('.J_ActivityList ul').append($li);
        };
    }

    /**
     * 将时间字符串格式化
     * @param  {[type]} str [description]
     * @return {[type]}     [description]
     */
    function formatDate(str) {
        var obj = C.parseDate(str),
            weeks = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

        var times = str.split(' ')[1].split(':');
        return {
            date: (obj.getMonth() + 1) + '/' + obj.getDate(),
            week: weeks[obj.getDay()],
            hour: times[0] + ':' + times[1]
        };
    }

    /**
     * 格式化模板
     * @param   act 活动数据
     */
    function formatTpl(act) {
        var hasEntry = '<div class="selected">已报名</div>';
        var entryNumber = '';
        var tpl = '<div class="poster">{{hasEntry}}<img src="{{poster}}"></div><div class="title"><h3>{{title}}</h3></div><div class="data"><span class="date"><span class="fa fa-clock-o"></span><b>{{date}}</b>{{week}}</span><span class="city"><span class="fa fa-map-marker"></span>{{city}}</span><span class="entry">{{entryNumber}}</span></div>';
        if (act.userJoin == 0) {
            hasEntry = '';
        }
        if (Number(act.limitNum) == 0 || Number(act.limitNum) > Number(act.join)) {
            entryNumber = '<b>' + act.join + '</b>报名';
        } else {
            entryNumber = '已报满';
        }
        var format = formatDate(act.start_time);
        tpl = tpl.replace(/{{hasEntry}}/g, hasEntry);
        tpl = tpl.replace(/{{poster}}/g, act.orig_pic_url);
        tpl = tpl.replace(/{{title}}/g, act.title);
        tpl = tpl.replace(/{{date}}/g, format.date);
        tpl = tpl.replace(/{{week}}/g, format.week);
        tpl = tpl.replace(/{{city}}/g, act.city_name);
        tpl = tpl.replace(/{{entryNumber}}/g, entryNumber);
        return tpl;
    }

    /**
     * 格式化详情页面
     * @param  {[type]} tpl    [description]
     * @param  {[type]} detail [description]
     * @return {[type]}        [description]
     */
    function formatDetailTpl(detail) {
        var tpl = '<div class="box poster">\
                        <img src="{{detailPoster}}">\
                        <div class="title">\
                            <h3>{{detailTitle}}</h3>\
                        </div>\
                    </div>\
                    <div class="box state">\
                        <div class="property time">\
                            <i class="fa fa-clock-o"></i>\
                            <span>{{date}}</span>\
                            <span>{{week}}</span>\
                            <span>{{startTime}}~{{endTime}}</span>\
                        </div>\
                        <div class="property address">\
                            <i class="fa fa-map-marker"></i>\
                            <span>{{address}}</span>\
                            <!--<span class="fa fa-chevron-right"></span>-->\
                        </div>\
                        <div class="property status J_DetailEntry">\
                            <i class="fa fa-users"></i>{{entry}}\
                            <span class="fa fa-chevron-right"></span>\
                        </div>\
                    </div>\
                    <div class="box context">{{detailContent}}</div>\
                    {{guests}}';
        //时间模板
        var sFormat = formatDate(detail.start_time);
        var eFormat = formatDate(detail.end_time);
        //报名模板
        var entry = '已报名<label class="J_EntryNum">' + detail.join + '</label>人';
        if (Number(detail.limitNum) > 0) {
            entry += '<span>/</span>限额<label>' + detail.limitNum + '</label>人';
        }
        //嘉宾模板
        var guestTpl = formatGuestTpl(detail.guest);
        //替换模板
        tpl = tpl.replace(/{{detailPoster}}/g, detail.orig_pic_url);
        tpl = tpl.replace(/{{detailTitle}}/g, detail.title);
        tpl = tpl.replace(/{{detailContent}}/g, detail.content);
        tpl = tpl.replace(/{{date}}/g, sFormat.date);
        tpl = tpl.replace(/{{week}}/g, sFormat.week);
        tpl = tpl.replace(/{{startTime}}/g, sFormat.hour);
        tpl = tpl.replace(/{{endTime}}/g, eFormat.hour);
        tpl = tpl.replace(/{{address}}/g, detail.address);
        tpl = tpl.replace(/{{entry}}/g, entry);
        tpl = tpl.replace(/{{guests}}/g, guestTpl);
        return tpl;
    }

    /**
     * 格式化嘉宾列表
     * @param  {[type]} guests [description]
     * @return {[type]}        [description]
     */
    function formatGuestTpl(guests) {
        var html = '';
        if (guests && guests.length > 0) {
            var tpls = '';
            for (var i = 0; i < guests.length; i++) {
                var tpl = '<li class="item"><img src="{{guestAvatar}}" class="avatar"><div class="guest-name">{{guestName}}</div><div class="guest-company"><span>{{guestCompany}}</span><span>{{guestPosition}}</span></div></li>';
                var g = guests[i];
                tpl = tpl.replace(/{{guestAvatar}}/g, g.avatar);
                tpl = tpl.replace(/{{guestName}}/g, g.name);
                tpl = tpl.replace(/{{guestCompany}}/g, g.unit);
                tpl = tpl.replace(/{{guestPosition}}/g, g.position);
                tpls += tpl;
            };
            html = '<div class="box guest"><h4>嘉宾</h4><div class="guest-list"><ul>' + tpls + '</ul></div></div>';
        }
        return html;
    }

    /**
     * 格式化报名人员列表
     * @param  {[type]} guests [description]
     * @return {[type]}        [description]
     */
    function formatEntryTpl(entries) {
        var html = '';
        if (entries && entries.length > 0) {
            for (var i = 0; i < entries.length; i++) {
                var tpl = '<li class="item"><img src="{{guestAvatar}}" class="avatar"><div class="guest-name">{{guestName}}</div><div class="guest-company"><span>{{guestCompany}}</span><span>{{guestPosition}}</span></div></li>';
                var g = entries[i];
                tpl = tpl.replace(/{{guestAvatar}}/g, g.avatar);
                tpl = tpl.replace(/{{guestName}}/g, g.name);
                tpl = tpl.replace(/{{guestCompany}}/g, g.unit);
                tpl = tpl.replace(/{{guestPosition}}/g, g.position);
                html += tpl;
            };
        }
        return html;
    }

    /**
     * 设置活动详情里面的图片，限制去宽度在页面以内
     * @param {[type]} $image   [description]
     * @param {[type]} maxWidth [description]
     */
    function setImage($image, maxWidth) {
        var oWidth = $image.width();
        var oHeight = $image.height();
        if (oWidth > maxWidth) {
            var newHeight = oHeight * (maxWidth / oWidth);
            $image.width(maxWidth);
            $image.height(newHeight);
        }
    }


    function setNewTickets(tickets) {
        var $ul = $('<ul class="list"></ul>');
        for (var i = 0; i < tickets.length; i++) {
            var t = tickets[i];
            var tpl = '<li data-id="' + t.id + '">\
                    <div class="type">\
                        <h4>{{name}}</h4>\
                        <p>{{intro}}</p>\
                    </div>\
                    <div class="num">\
                        <span class="J_Minus"><i class="fa fa-minus"></i></span><span class="J_TicketNum">0</span><span class="J_Plus"><i class="fa fa-plus"></i></span>\
                    </div>\
                    <div class="price">\
                        <span>{{price}}</span><span>元</span>\
                    </div>\
                </li>';
            tpl = tpl.replace(/{{name}}/g, t.name);
            tpl = tpl.replace(/{{intro}}/g, t.intro);
            tpl = tpl.replace(/{{price}}/g, t.price);
            $ul.append(tpl);
        };
        return $ul;
    }

    /**
     * 设置已经购买票的列表
     */
    function setBuyTickets(obj) {
        var $ul = $('<ul class="buy-list"></ul>');
        $ul.append('<li class="password"><div class="left">取票密码：</div><div class="right">' + obj.password + '</div></li>');
        for (var i = obj.tickets.length - 1; i >= 0; i--) {
            var t = obj.tickets[i];
            var tpl = '<li class="card">\
                        <div class="left">\
                            <div class="card-left"></div>\
                            <div class="card-center">\
                                <div class="type">\
                                    <h4>{{name}}</h4>\
                                    <p>{{intro}}</p>\
                                </div>\
                                <div class="price">\
                                    <span>{{price}}</span><span>元</span>\
                                </div>\
                            </div>\
                            <div class="card-right"></div>\
                        </div>\
                        <div class="right">x{{num}}</div>\
                    </li>';
            tpl = tpl.replace(/{{name}}/g, t.name);
            tpl = tpl.replace(/{{intro}}/g, t.intro);
            tpl = tpl.replace(/{{price}}/g, t.price);
            tpl = tpl.replace(/{{num}}/g, t.num);
            $ul.append(tpl);
        };
        return $ul;
    }

    /**
     * 设置门票页面
     * @param {[type]}
     * @param {[type]}
     * @param {Function}
     */
    function setTicketsView(topHtml, $ul, callback) {
        var $view = $('.J_TicketView');
        $view.append(topHtml);
        $view.append($ul);
        $view.css('-webkit-transform', 'translateY(' + ($ul.height() + 1) + 'px)');
        callback && callback();
    }

    /**
     * 创建活动列表节点
     * @type {[type]}
     */
    exports.createDom = function(currentList, historyList) {
        if (null != currentList && currentList.length > 0) {
            appendLis('current', currentList);
        };
        if (null != historyList && historyList.length > 0) {
            if ($('.J_ActivityList .split').length <= 0) {
                $('.J_ActivityList ul').append('<li class="item split">以下为历史活动</li>');
            }
            appendLis('history', historyList);
        };
    };

    /**
     * 设置详情页
     * @type {[type]}
     */
    exports.setDetailPage = function(detail, callback) {
        var html = formatDetailTpl(detail),
            maxWidth = $('.J_DetailContent').width() - 30;
        $('.J_DetailContent div').html(html);

        var $context = $('.J_DetailContent div').children('.context');
        //修改图片大小
        $context.find('img').each(function(i, item) {
            setImage($(item), maxWidth);
        });
        //屏蔽所有连接跳转
        $context.find('a').each(function(i, item) {
            $(item).on('click', function() {
                return false;
            });
        });
        callback && callback();
    }

    /**
     * 设置报名列表页面
     */
    exports.setEntryPage = function(entries, callback) {
        var nodata = true;
        if (entries && 　entries.length > 0) {
            var html = formatEntryTpl(entries);
            $('.J_EntryList ul').append(html);
            nodata = false;
        }
        callback && callback(nodata);
    }

    /**
     * 设置城市列表
     */
    exports.setCityList = function(cities) {
        if (!cities || cities.length <= 0)
            return false;
        for (var i = 0; i < cities.length; i++) {
            var city = cities[i];
            var tpl = '<li data-cid="' + city.city_id + '">' + city.name + '<span class="fa fa-check"></span></li>';
            $('.J_CityFilterList ul').append(tpl);
        };
    }

    /**
     * 设置门票菜单
     * @param {[type]}
     * @param {Function}
     */
    exports.setNewTicketsView = function(tickets, callback) {
        var topHtml = '<div class="top" check="up">选择门票种类<span class="fa fa-angle-double-up"></span></div>',
            $ul = setNewTickets(tickets);

        setTicketsView(topHtml, $ul, callback);
    }

    /**
     * 设置已购门票列表
     * @param {[type]}
     * @param {Function}
     */
    exports.setBuyTicketsView = function(obj, callback) {
        var topHtml = '<div class="top" check="up">查看我的门票<span class="fa fa-angle-double-up"></span></div>';
        $ul = setBuyTickets(obj);
        setTicketsView(topHtml, $ul, callback);
    }

    /**
     * 设置订单列表
     * @param  {[type]}
     * @return {[type]}
     */
    exports.getOrderTable = function(menu) {
        var $table = $('<table class="table"><tbody></tbody></table>');
        for (var i = 0; i < menu.list.length; i++) {
            var t = menu.list[i];
            var tpl = '<tr>\
                        <td>{{name}}</td>\
                        <td>x{{num}}</td>\
                        <td>\
                            <label>{{money}}</label>元\
                        </td >\
                    </tr>';
            tpl = tpl.replace(/{{name}}/g, t.name);
            tpl = tpl.replace(/{{num}}/g, t.num);
            tpl = tpl.replace(/{{money}}/g, t.num * t.price);
            $table.children('tbody').append(tpl);
        };
        var lastTr = '<tr><td></td><td>共<span>' + menu.total.number + '</span>张</td><td>总计<span class="total-money">' + menu.total.money + '</span>元</td></tr>';
        $table.children('tbody').append(lastTr);
        return $table;
    }
});
