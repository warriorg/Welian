/*
 * @Author: 1
 * @Date:   2014-12-11 17:08:09
 * @Last Modified by:   1
 * @Last Modified time: 2014-12-17 17:02:26
 */

define(function(require, exports, module) {
       var $ = require('zepto'),
       C = require('common'),
       M = require('activity/model'),
       V = require('activity/view'),
       N = require('activity/native'),
       detail = null,
       isEntryLoadEnd = false,
       isBuy = false,
       isEnd = false,
       cache = {},
       sessionId = '',
       entryListPageNum = 1, //报名列表读取列表页码
       clientHeight = $('body').height(), //文档高度
       headHeight = $('.app-bar').height(),
       statusHeight = $('.J_Status').height();
       
       require('iscroll');
       /**
        *  读取报名列表
        */
       function loadEntries() {
       var $entryList = $('.J_EntryList ul');
       //清空list
       if (entryListPageNum == 1) {
       $entryList.html('');
       }
       //删除没数据提示
       $entryList.children('.nodata').remove();
       //获取报名列表数据
       M.getEntries(detail.id, entryListPageNum, function(entries) {
                    //生产报名列表
                    V.setEntryPage(entries, function(isNodata) {
                                   if (isNodata) {
                                   $entryList.append('<li class="nodata">还没有人报名哦~</li>');
                                   } else {
                                   if (entries.length < 10) {
                                   $entryList.append('<li class="nodata">没有更多人了~</li>');
                                   } else {
                                   $entryList.append('<li class="nodata">点击加载更多</li>');
                                   $entryList.children('.nodata').tap(function() {
                                                                      loadEntries();
                                                                      });
                                   entryListPageNum++;
                                   }
                                   }
                                   });
                    new IScroll('.J_EntryList');
                    });
       }
       
       /**
        * 关闭报名页面，恢复到原始数据
        */
       function closeEntryPage() {
       //还原报名页码
       entryListPageNum = 1;
       //还原报名页面
       $('.J_EntryPage').removeClass('in');
       //隐藏报名页码蒙版
       $('.J_DetailDropBack').removeClass('in');
       $('.J_DetailDropBack').hide();
       }
       
       /**
        * 关闭详情页面
        * @return {[type]}
        */
       function closeDetail() {
       closeEntryPage();
       //清空票务信息
       $('.J_TicketView').html('');
       //隐藏票务页面蒙蔽
       $('.J_TicketDropback').hide();
       
       $('.J_TicketView').css('-webkit-transition', 'none');
       }
       
       
       /**
        * 返回上一页
        */
       function backToPrev(prevPage) {
       C.back('#pageDetail', prevPage, function() {
              closeDetail();
              setTimeout(function() {
                         $('.J_DetailContent div').html('');
                         }, 500);
              });
       }
       
       /**
        * 设置报名按钮
        */
       function setEntryButton() {
       isEnd = M.isActivityEnd(detail);
       $button = $('#J_EntryButton');
       $button.off('tap');
       $button.addClass('over');
       //是否结束
       if (isEnd) {
       $button.text('活动已结束');
       } else {
       //是否报名
       if (detail.userJoin == 1) {
       if (detail.ticket_type == 1) {
       $button.text('已购票');
       } else {
       $button.text('已报名');
       }
       } else {
       $button.removeClass('over');
       //是否免费
       if (detail.ticket_type == 1) {
       $button.addClass('over');
       $button.text('支付接口尚未开通');
       $button.tap(function() {
                   alert('请分享到微信里完成购票');
                   });
       //$button.text('我要购票');
       //$button.tap(showTickets);
       } else {
       $button.text('我要报名');
       $button.tap(sign);
       }
       }
       }
       }
       
       /**
        * 设置票务
        */
       function setTickets() {
       M.getTickts(detail.id, sessionId, function(tickets) {
                   if (isBuy) {
                   V.setBuyTicketsView(tickets.buy, function() {
                                       setTicketTopEvent();
                                       });
                   } else {
                   if (isEnd) return;
                   cacheData(tickets.list);
                   V.setNewTicketsView(tickets.list, function() {
                                       var $view = $('.J_TicketView');
                                       setTicketTopEvent();
                                       $view.find('.J_Plus').tap(function() {
                                                                 var num = Number($(this).prev().text());
                                                                 $(this).prev().text(++num);
                                                                 });
                                       $view.find('.J_Minus').tap(function() {
                                                                  var num = Number($(this).next().text());
                                                                  if (num > 0) {
                                                                  $(this).next().text(--num);
                                                                  }
                                                                  });
                                       });
                   }
                   });
       }
       
       function cacheData(tickets) {
       var newObj = {};
       for (var i = 0; i < tickets.length; i++) {
       var t = tickets[i];
       newObj[t.id] = t;
       };
       cache['new'] = newObj;
       }
       
       /**
        * 设置选择或者查看门票按钮事件
        */
       function setTicketTopEvent() {
       $('.J_TicketView .top').click(function() {
                                     $('.J_TicketView').css('-webkit-transition', '-webkit-transform .5s');
                                     var $this = $(this),
                                     check = $this.attr('check');
                                     if (check == 'up') {
                                     showTickets();
                                     } else {
                                     hideTickets();
                                     }
                                     });
       }
       
       /**
        * 显示门票
        * @return {[type]}
        */
       function showTickets() {
       $button = $('#J_EntryButton');
       $('.J_TicketDropback').show();
       $('.J_TicketView .top span').addClass('fa-angle-double-down');
       $('.J_TicketView .top span').removeClass('fa-angle-double-up');
       $('.J_TicketView').css('-webkit-transform', 'translateY(0px)');
       $('.J_TicketView .top').attr('check', 'down');
       if (!isBuy) {
       $button.off('tap');
       $button.text('确认购票');
       $button.tap(buy);
       }
       }
       
       /**
        * 隐藏门票
        */
       function hideTickets() {
       $button = $('#J_EntryButton');
       $('.J_TicketDropback').hide();
       var y = $('.J_TicketView ul').height();
       $('.J_TicketView .top span').addClass('fa-angle-double-up');
       $('.J_TicketView .top span').removeClass('fa-angle-double-down');
       $('.J_TicketView').css('-webkit-transform', 'translateY(' + (y + 1) + 'px)');
       $('.J_TicketView .top').attr('check', 'up');
       if (!isBuy) {
       $button.off('tap');
       $button.text('我要购票');
       $button.tap(showTickets);
       }
       }
       
       /**
        * 购买门票
        */
       function buy() {
       var total = 0,
       totalMoney = 0,
       menu = {
       total: {},
       list: []
       };
       $('.J_TicketView .list li').each(function(i, item) {
                                        $item = $(item)
                                        var num = Number($item.find('.J_TicketNum').text());
                                        if (num > 0) {
                                        var id = $item.attr('data-id');
                                        var t = cache['new'][id];
                                        total += num;
                                        totalMoney += num * t.price;
                                        menu.list.push({
                                                       id: t.id,
                                                       name: t.name,
                                                       num: num,
                                                       price: t.price
                                                       });
                                        }
                                        });
       if (total <= 0) {
       alert('请至少选一张票');
       } else {
       menu.total.number = total;
       menu.total.money = totalMoney;
       var order = require('activity/order');
       order.init(menu, function() {
                  C.go('#pageDetail', '#pageOrder');
                  });
       }
       }
       
       function shareContent() {
       var obj = C.formatDate(detail.start_time);
       var title = '活动 | ' + detail.title;
       var img = detail.pic_url;
       var link = 'http://my.welian.com/event/info/' + detail.id;
       var content = '中国 · ' + detail.city_name + '\n' + obj.date + '(' + obj.week + ')\n' + detail.address;
       return {
       friend: {
       title: title,
       img: img,
       link: link,
       desc: content
       },
       friendCircle: {
       title: '活动 · ' + detail.city_name + '| ' + detail.title,
       img: img,
       link: link,
       desc: content
       }
       }
       }
       
       /**
        * 报名
        * @return {[type]} [description]
        */
       function sign() {
       N.getSessionId(function(sid) {
                      M.joinActive(sid, detail.id, function(state) {
                                   if (state == 1) {
                                   alert('报名成功');
                                   signSuccess();
                                   } else {
                                   alert('报名失败');
                                   }
                                   });
                      });
       }
       
       /**
        * 报名成功
        */
       function signSuccess() {
       $button = $('#J_EntryButton');
       $button.off('tap');
       $button.addClass('over');
       $button.text('已报名');
       M.activities[detail.id].userJoin = 1;
       M.activities[detail.id].join = 1;
       var num = $('.J_EntryNum').text();
       num = Number(num);
       $('.J_EntryNum').text(num + 1);
       }
       
       /**
        *  显示报名列表
        * @return {[type]}
        */
       function showEntryList() {
       $('.J_EntryPage').addClass('in');
       $('.J_DetailDropBack').show();
       setTimeout(function() {
                  $('.J_DetailDropBack').addClass('in');
                  }, 40);
       $('.J_DetailContent').parent().css('overflow', 'hidden');
       //读取
       loadEntries(detail.id);
       }
       
       /**
        * 获取活动ID
        * @return {[type]}
        */
       function getActivityId() {
       var urls = window.location.href.split('?');
       return urls[1];
       }
       
       /**
        * 设置部分节点高度
        */
       function setDomHeight() {
       var bodyHeight = clientHeight - headHeight;
       //设置详情内容元素高度
       $('.J_DetailContent').height(clientHeight - headHeight - statusHeight);
       //设置报名列表高度
       $('.J_EntryList').height(bodyHeight - $('.J_EntryPage .head').height());
       $('.J_EntryPage').css('top', headHeight + 'px');
       $('.J_DetailDropBack').css('top', headHeight + 'px');
       $('.J_TicketDropback').css('top', headHeight + 'px');       }
       
       /**
        * 读取详情页
        * @param  {[type]} id [description]
        * @return {[type]}    [description]
        */
       function loadDetail(id, callback) {
       if (!id) return;
       N.getSessionId(function(sid) {
                      sessionId = sid;
                      M.getDetail(id, sid, function(activity) {
                                  detail = activity;
                                  if (!detail || null == detail) {
                                  alert('活动不存在');
                                  return;
                                  }
                                  isBuy = detail.userJoin;
                                  //设置详情页面
                                  V.setDetailPage(detail, function() {
                                                  //实在报名按钮
                                                  setEntryButton(detail);
                                                  // 绑定报名点击事件
                                                  $('.J_DetailEntry').on('tap', function() {
                                                                         showEntryList();
                                                                         });
                                                  //设置页面滚动
                                                  new IScroll('.J_DetailContent');
                                                  //设置票务页码
                                                  if (detail.ticket_type == 1) {
                                                  //setTickets();
                                                  }
                                                  //修改报名人数
                                                  $('#J_EntryNum').text(detail.join);
                                                  $('#pageDetail .J_ShareBtn').tap(function() {
                                                                                   var shareObj = shareContent();
                                                                                   N.share(JSON.stringify(shareObj));
                                                                                   });
                                                  
                                                  callback && callback();
                                                  });
                                  });
                      });
       
       }
       
       /**
        * 初始化页面
        * @type {[type]}
        */
       exports.init = function(prevPage) {
       //有上一页
       if (prevPage) {
       N.getHeaderHeight(function(height) {
                         headHeight = height;
                         setDomHeight();
                         });
       //详情页返回列表页
       $('#pageDetail .J_BackBtn').tap(function(e) {
                                       backToPrev(prevPage);
                                       });
       }
       //独立的详情页，根据链接传递的活动ID获取页面
       else {
       //返回app的activity
       $('#pageDetail J_BackBtn').tap(function(e) {
                                      N.backToDiscover();
                                      });
       //读取活动信息
       var id = getActivityId();
       loadDetail(id);
       N.getHeaderHeight(function(height) {
                         
                         headHeight = height;
                         C.setHeadHeight(height);
                         setDomHeight();
                         });
       }
       //关闭报名列表
       $('.J_CloseEntryList').tap(function() {
                                  closeEntryPage();
                                  });
       //绑定蒙版背景点击事件
       $('.J_DetailDropBack').tap(function() {
                                  closeEntryPage();
                                  });
       
       if (C.getOs() == 2) {
       seajs.use(['plugins/back'], function() {
                 //绑定页面右滑返回事件
                 $('#pageDetail').back({
                                       beforePage: '#pageList',
                                       before: function() {
                                       closeDetail();
                                       }
                                       });
                 });
       }
       }
       exports.loadDetail = loadDetail;
       });
