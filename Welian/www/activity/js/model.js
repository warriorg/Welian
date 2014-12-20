define(function(require, exports, module) {
    var $ = require('zepto'),
        activities = new Object(),
        currentTime = new Date().getTime(),
        vars = seajs.data.vars,
        ajaxOptions = {
            type: 'POST',
            url: vars.apiUrl,
            dataType: 'json'
        };


    /**
     * 过滤活动列表，分成当前活动列表和历史活动列表
     * @param  list 所有活动的列表
     * @return 当前活动列表和历史活动列表
     */
    function filterList(list) {
        var currentList = new Array(),
            historyList = new Array();
        for (var i = 0; i < list.length; i++) {
            var item = list[i];
            if (isActivityEnd(item)) {
                historyList.push(item);
            } else {
                currentList.push(item);
            }
        };
        return {
            currentList: currentList,
            historyList: historyList
        };
    }

    /**
     * 检查活动是否结束
     * @param act 活动对象
     * @return true是结束 false是没结束
     */
    function isActivityEnd(act) {
        var timeStr = act.end_time.replace(/-/g, '/');
        var date = new Date(timeStr);
        var endTime = date.getTime();
        return endTime <= currentTime;
    }

    /**
     * 存储加载的数据
     * @param  加载得到的数据
     */
    function saveData(datas) {
        for (var i = 0; i < datas.length; i++) {
            var data = datas[i];
            activities[data.id] = data;
        }
    }


    /**
     * 获取活动列表，使用jsonp格式
     * @param options 活动查询对象
     * @param callback 请求完成后回调函数
     */
    exports.getList = function(options, callback) {
        var rObj = {
            cList: null,
            hList: null,
            lastAid: 0,
            newAid: 0
        }
        ajaxOptions.data = {
            type: vars.TYPE_GET_ACTIVITY_LIST,
            aid: options.aid,
            session_id: options.sessionId,
            date_type: options.timeId,
            city_id: options.cityId
        };
        ajaxOptions.success = function(res, status, xhr) {
            if (res.status == 1) {
                saveData(res.data);
                var list = filterList(res.data);
                rObj.cList = list.currentList;
                rObj.hList = list.historyList;
                rObj.lastAid = res.data[res.data.length - 1].id;
                rObj.newAid = res.data[0].id;
                callback(rObj);
            } else {
                callback(rObj);
            }
        };
        ajaxOptions.error = function(xhr, errorType, error) {
            callback(rObj);
        }
        $.ajax(ajaxOptions);
    }

    /**
     * 根据活动id拉取报名列表
     * @type {[type]}
     */
    exports.getEntries = function(aid, page, callback) {
        ajaxOptions.data = {
            type: vars.TYPE_GET_ENTRIES,
            aid: aid,
            page: page
        };
        ajaxOptions.success = function(res, status, xhr) {
            if (res.status == 1) {
                callback(res.data);
            } else {
                callback(null);
            }
        };
        ajaxOptions.error = function(xhr, errorType, error) {
            callback(null);
        }
        $.ajax(ajaxOptions);
    }

    /**
     * 根据ID获取活动详情
     * @type 活动ID
     */
    exports.getDetail = function(id, sid, callback) {
        var detail = activities[id];
        if (detail) {
            callback(detail);
        } else {
            ajaxOptions.data = {
                type: vars.TYPE_GET_ACTIVITY,
                aid: id,
                session_id:sid
            };
            ajaxOptions.success = function(res, status, xhr) {
                if (res.status == 1) {
                    callback(res.data);
                } else {
                    callback(null);
                }
            };
            ajaxOptions.error = function(xhr, errorType, error) {
                callback(null);
            }
            $.ajax(ajaxOptions);
        }
    }


    /**
     * 拉取城市列表信息
     */
    exports.getCities = function(callback) {
        ajaxOptions.data = {
            type: vars.TYPE_GET_ACTIVITY_CITY,
        };
        ajaxOptions.success = function(res, status, xhr) {
            if (res.status == 1) {
                callback(res.data);
            } else {
                callback(null);
            }
        };
        ajaxOptions.error = function(xhr, errorType, error) {
            callback(null);
        }
        $.ajax(ajaxOptions);
    }

    /**
     * 报名接口
     */
    exports.joinActive = function(sid, aid, callback) {
        ajaxOptions.data = {
            type: vars.TYPE_JOIN_ACTIVITY,
            session_id: sid,
            aid: aid,
        }
        ajaxOptions.success = function(res, status, xhr) {
            if (res.status == 1) {
                callback(res.status);
            } else {
                callback(-1);
            }
        };
        ajaxOptions.error = function(xhr, errorType, error) {
            callback(-1);
        }
        $.ajax(ajaxOptions);
    }

    /**
     * 抓取票种接口
     */
    exports.getTickts = function(aid, sid, callback) {
        ajaxOptions.data = {
            type: vars.TYPE_GET_TICKETS,
            aid: aid,
            session_id: sid
        }
        ajaxOptions.success = function(res, status, xhr) {
            if (res.status == 1) {
                callback(res.data);
            } else {
                callback(-1);
            }
        };
        ajaxOptions.error = function(xhr, errorType, error) {
            callback(-1);
        }
        $.ajax(ajaxOptions);
    }

    /**
     * 判断活动是否结束
     * @type {Boolean}
     */
    exports.isActivityEnd = isActivityEnd;
    exports.activities = activities;
});
