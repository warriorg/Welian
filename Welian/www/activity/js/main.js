define(function(require, exports, module) {
    var $ = require('zepto'),
        C = require('common'),
        M = require('activity/model'),
        V = require('activity/view'),
        N = require('activity/native'),
        detail = require('activity/detail'),
        lastAid = -1, //最后的活动id
        newAid = 0, //最新的活动id
        cityId = '', //查询用的城市id
        timeId = 'all', //查询用的时间id
        sessionId = '', //服务器同步的session_id
        isDataEnd = false, //判断活动列表是否加载完毕
        clientHeight = $('body').height(), //文档高度
        headHeight = 0,
        filterHeight = $('.J_Filter').height(),
        isDropBackShow = false, //判断背景是否显示
        listScroll = null,
        $list = $('.J_ActivityList'),
        $pageList = $('#pageList'),
        isFresh = true,
        isLoadData = false;

    require('iscroll');
    /**
     * 没有数据时显示没有数据的提示
     */
    function noData() {
        $list.children('ul').append('<li class="nodata">没有更多数据</li>');
        isDataEnd = true;
    }

    function loadData() {
        N.getSessionId(function(sid) {
            sessionId = sid;
            loadList();
        });
    }

    /**
     * 读取数据
     */
    function loadList() {
        var aid = 0;

        //下拉更多数据是没有数据
        if (!isFresh && isDataEnd) return false;
        if (!isFresh) aid = lastAid;
        if (isFresh) aid = -1;
        M.getList({
            aid: aid,
            sessionId: sessionId,
            timeId: timeId,
            cityId: cityId
        }, function(res) {
            isLoadData = false;
            //刷新到新数据时重新加载数据
            if (isFresh) {
                $list.children('ul').children().remove();
                if (res.newAid != newAid) {
                    newAid = res.newAid;
                    lastAid = res.lastAid;
                }
                V.createDom(res.cList, res.hList);
            }
            //拉取到更多数据时填充数据
            else {
                if (res.lastAid != 0 && res.lastAid != lastAid) {
                    lastAid = res.lastAid;
                    V.createDom(res.cList, res.hList);
                } else {
                    noData();
                }
            }
            //返回异常或者数据没有10条时就表示没有数据了
            if (null == res.cList || null == res.hList || (res.cList.length + res.hList.length < 10)) {
                noData();
            }
            //绑定去详情页的事件
            $('.J_ActivityItem').tap(function() {
                var id = $(this).attr('id');
                detail.loadDetail(id, function() {
                    C.go('#pageList', '#pageDetail');
                });
            });
            if (null == listScroll) {
                listScroll = new IScroll('.J_ActivityList', {
                    probeType: 3
                });
                setScrollEvent();
            } else {
                listScroll.refresh();
            }
            hideLoading();
        });
    }

    function setScrollEvent() {
        require('iscroll-probe');
        listScroll.on('scroll', function() {
            if (this.y >= 0) {
                isFresh = true;
                isLoadData = true;
                addLoadingDom();
            }
            if (Math.abs(this.y) > (this.scrollerHeight - this.wrapperHeight)) {
                isFresh = false;
                isLoadData = true;
                addLoadingDom();
            }
        });
        listScroll.on('scrollEnd', function() {
            if (isFresh || (isLoadData && !isDataEnd)) {
                loadData();
            }
        });
    }

    /**
     * 隐藏内容加载动画
     * @return {[type]} [description]
     */
    function hideLoading() {
        $loading = $list.find('.app-loading');
        $loading.height(0);
        setTimeout(function() {
            $loading.remove();
        }, 300);
    }

    function addLoadingDom(action) {
        var li = '<li class="app-loading"><img src="img/loading.png"/></li>',
            $ul = $list.children('ul');
        if ($ul.children('.app-loading').length > 0) {
            return false;
        }
        if (isFresh) {
            $($ul.children('li').get(0)).before(li);
        } else {
            if (!isDataEnd) {
                $ul.append(li);
            }
        }
    }

    /**
     * 显示背景蒙版
     */
    function showDropBack(selector, callback) {
        if (!isDropBackShow) {
            $(selector).show();
            setTimeout(function() {
                $(selector).addClass('in');
            }, 40);

            $(selector).on('tap', function() {
                hideDropback(selector, callback);
            });
        }
        isDropBackShow = true;
    }

    /**
     * 隐藏背景模板
     */
    function hideDropback(selector, callback) {
        if (isDropBackShow) {
            $(selector).removeClass('in');
            setTimeout(function() {
                $(selector).hide();
                $('.J_Filter div').removeClass('wasClick');
                isDropBackShow = false;
            }, 400);
            $(selector).off('tap');
            callback && callback();
        }
    }

    /**
     * 绑定筛选项目的事件
     */
    function bindFilterItemEvent(selector, callback) {
        $(selector).tap(function() {
            $(selector).removeClass('selected');
            $(this).addClass('selected');
            callback && callback($(this));
            loadData();
            hideDropback('.J_ListDropBack', hideFilterList);
        });
    }

    /**
     * 初始化城市列表
     * @return {[type]} [description]
     */
    function initCityList() {
        M.getCities(function(cities) {
            V.setCityList(cities);
            bindFilterItemEvent('.J_CityFilterList li', function($node) {
                cityId = $node.attr('data-cid');
                $('#J_CitySign').text($node.text());
            });
            var CityListScroll = new IScroll('.J_CityFilterList');
        });
    }

    /**
     * 设置时间项的事件
     */
    function setTimeItemEvent() {
        bindFilterItemEvent('.J_TimeFilterList li', function($node) {
            timeId = $node.attr('data-tid');
        });
    }

    /**
     * 显示筛选列表面板
     */
    function showFilterList(timeLeft, cityLeft) {
        showDropBack('.J_ListDropBack', hideFilterList);
        $('.J_TimeFilterList').css('-webkit-transform', 'translateX(' + timeLeft + ')');
        $('.J_CityFilterList').css('-webkit-transform', 'translateX(' + cityLeft + ')');
    }

    /**
     * 隐藏筛选列表面板
     */
    function hideFilterList() {
        $('.J_TimeFilterList').css('-webkit-transform', 'translateX(-100%)');
        $('.J_CityFilterList').css('-webkit-transform', 'translateX(100%)');
    }

    /**
     * 绑定筛选按钮事件
     */
    function bindFilterButtonEvent(selector, callback) {
        $(selector).tap(function() {
            if ($(this).hasClass('wasClick')) {
                hideDropback('.J_ListDropBack', hideFilterList);
                $(this).removeClass('wasClick');
            } else {
                callback && callback();
                $('.J_Filter div').removeClass('wasClick');
                $(this).addClass('wasClick');
            }
        });
    }

    /**
     * 设置筛选节点
     */
    function setFilterDom() {
        //绑定时间筛选事件
        bindFilterButtonEvent('.J_FilterTime', function() {
            showFilterList('0', '100%');
        });
        //绑定城市筛选事件
        bindFilterButtonEvent('.J_FilterCity', function() {
            showFilterList('-100%', '0');
        });
        //设置时间选项的事件
        setTimeItemEvent();

        $('#pageList .J_ShareBtn').tap(function() {
            var msg = [
                '活动列表',
                '这里有很多活动',
                '',
                'http://my.welian.com/event/lists'
            ];
            N.share(msg);
        });
    }

    /**
     * 设置部分节点高度
     */
    function setDomHeight() {
        var listHeight = clientHeight - headHeight - filterHeight;
        //设置大背景高度
        $('.app-wrap').height($(window).height());
        //设置头高度
        C.setHeadHeight(headHeight);
        //设置列表节点的高度
        $('.J_ActivityList').height(listHeight);
        $('.J_ActivityList ul').css('min-height', listHeight  + 'px');
        var top = Number(headHeight) + Number(filterHeight);
        $('.filterlist').css('top', top + 'px');
        $('.filterlist').css('max-height', listHeight  + 'px');
        $('.J_ListDropBack').css('top', top + 'px');
    }

    exports.refreshList = function() {
        loadData();
    }

    /**
     * 初始化
     */
    exports.init = function() {
        $(document).on('touchmove', function(e) {
            e.preventDefault();
        });
        addLoadingDom();
        //设置部分节点高度
        N.getHeaderHeight(function(height) {
            headHeight = height;
            setDomHeight();
        });
        //加载活动列表
        loadData();
        //设置筛选节点
        setFilterDom();
        //加载城市列表
        initCityList();
        //初始化详情页
        detail.init('#pageList');
        //返回发现栏目
        $('#pageList .J_BackBtn').tap(function() {
            N.backToDiscover();
        });
        N.pageLoadComplete();
    }

});
