(function($) {
if (typeof $ === 'function') {

function isDefined(t) {
    return typeof t !== 'undefined' && t != null;
}

var win, logger;
try {
    win = top || parent || window;
    logger = isDefined(win.$) ? win.$.LOGGER : null;

} catch(e) {
    win = window;
    logger = null;

}

$.LOGGER = isDefined(logger) ? logger : (function() {

var isLoggerEnabled = true, isDebugEnabled = true, isInfoEnabled = true, isErrorEnabled = true, history = [],

getTime = !moment || typeof moment !== 'function' ? 
function() {
    var today = new Date();
    return [
        [today.getFullYear(), today.getMonth() + 1, today.getDate()].join('.0'),
        [today.getHours(), today.getMinutes(), today.getSeconds()].join(':0')
    ].join(' ').replace(/0(?=\d{2})/g, '');
} :
function() {
    return moment().format('YYYY.MM.DD HH:mm:ss');
};

function isConsoleEnabled(cs) {
    return isDefined(cs) && isDefined(cs.log) && isDefined(cs.info) && isDefined(cs.error);
}

function getConsole() {
    try {
        return isConsoleEnabled(win.console) ? win.console : {log: function() {}, info: function() {}, error: function() {}};
    } catch (e) {
        return {log: function() {}, info: function() {}, error: function() {}};
    }
}

function addToHistory(l, t, d, v) {
    history.push({'0 level': l, '1 time': t, '2 description': d, '3 object': v});
//    .scrollTop(function() { return $(this).prop('scrollHeight'); });
//    Array.prototype.slice.call(args)
}

return {
    enableLogger: function() {
        isLoggerEnabled = true;
    },
    disableLogger: function() {
        isLoggerEnabled = false;
    },
    enableDebug: function() {
        isDebugEnabled = true;
    },
    disableDebug: function() {
        isDebugEnabled = false;
    },
    enableInfo: function() {
        isInfoEnabled = true;
    },
    disableInfo: function() {
        isInfoEnabled = false;
    },
    enableError: function() {
        isErrorEnabled = true;
    },
    disableError: function() {
        isErrorEnabled = false;
    },
    getHistory: function() {
        return [].concat(history);
    },
    showHistory: function() {
        $('<textarea class="log-box" data-name="log-box" readonly="readonly"></textarea>')
            .dblclick(function() {
                $(this).remove();
            })
            .val(history.join('\n')).appendTo('body');
    },
    closeHistory: function() {
        $('textarea[data-name="log-box"]').remove();
    },
    clearHistory: function() {
        history = [];
    },
    setup:function(o) {
        var p = $.extend(true, {
            enable: {
                log: true,
                debug: true,
                info: true,
                error: true
            }
        }, o);

        isLoggerEnabled = p.enable.log;
        isDebugEnabled = p.enable.debug;
        isInfoEnabled = p.enable.info;
        isErrorEnabled = p.enable.error;
    },

    debug: function(description, target) {
        var time = getTime(), target = $.isFunction(target) ? target() : !isDefined(target) || target == null ? '' : target;
        addToHistory('[DEBUG]', time, description, target);
        if (isLoggerEnabled && isDebugEnabled) {
            setTimeout(function() {
                getConsole().log({
                    '0 level': '[DEBUG]',
                    '1 time': time,
                    '2 description': description,
                    '3 object': target
                });
            }, 0);
        }
    },
    info: function(description, target) {
        var time = getTime(), target = $.isFunction(target) ? target() : !isDefined(target) || target == null ? '' : target;
        addToHistory('[ INFO]', time, description, target);
        if (isLoggerEnabled && isInfoEnabled) {
            setTimeout(function() {
                getConsole().info({
                    '0 level': '[ INFO]',
                    '1 time': time,
                    '2 description': description,
                    '3 object': target
                });
            }, 0);
        }
    },
    error: function(description, target) {
        var time = getTime(), target = $.isFunction(target) ? target() : !isDefined(target) || target == null ? '' : target;
        addToHistory('[ERROR]', time, description, target);
        if (isLoggerEnabled && isErrorEnabled) {
            setTimeout(function() {
                getConsole().error({
                    '0 level': '[ERROR]',
                    '1 time': time,
                    '2 description': description,
                    '3 object': target
                });
            }, 0);
        }
    }
};
})();

try {
    win.$.LOGGER = isDefined(logger) ? logger : $.LOGGER;
} catch(e) {}

}
})(jQuery)