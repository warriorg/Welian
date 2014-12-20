define(function(require, exports, module) {
    var startX, isBack,
        flag = $(document).width() / 3;

    /**
     * 取消
     * @param {Object} nodes
     */
    function canceTransition(nodes) {
        for (var i = 0; i < nodes.length; i++) {
            nodes[i].css('-webkit-transition', 'none');
        };
    }
    $.fn.back = function(options) {
        if (!options)
            return;
        var $beforePage = $(options.beforePage);
        return this.each(function() {
            var $this = $(this);
            $this.on('touchstart', function(e) {
                isBack = false;
                startX = e.touches[0].clientX;
                canceTransition([$this, $beforePage]);
            });
            $this.on('touchmove', function(e) {
                var x = e.touches[0].clientX - startX;
                if (startX < 30 && x > 0) {
                    $this.css('-webkit-transform', 'translateX(' + x / 1.5 + 'px)');
                    var moveX = $(document).width() - x;
                    $beforePage.css('-webkit-transform', 'translateX(-' + moveX / 2 + 'px)');
                    isBack = x > flag;
                }
            });
            $this.on('touchend', function(e) {
                $this.css('-webkit-transition', 'all .5s');
                $beforePage.css('-webkit-transition', 'all .5s');
                if (!$(e.target).hasClass('app-bar-btn')) {
                    setTimeout(function() {
                        if (isBack) {
                            options.before && options.before();
                            $this.css('-webkit-transform', 'translateX(100%)');
                            $beforePage.css('-webkit-transform', 'translateX(0)');
                        } else {
                            $this.css('-webkit-transform', 'translateX(0)');
                            $beforePage.css('-webkit-transform', 'translateX(-100%)');
                        }
                    }, 50);
                }
            });
        });
    }
});
