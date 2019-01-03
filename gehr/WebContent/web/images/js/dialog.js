/**
 * Created by manyJung on 2016-09-05
 */
$(function() {
    $.customDialog = {};

    $.fn.makeDialg = function() {
        var $this = $(this);
        var _id = $this.attr("id");
        return new Promise(function(resolve) {
            /* jquery 하단 버튼 사용 안함 */
            $.customDialog[_id] = $this.dialog(_.extend({autoOpen: false}, $this.data()));

            $(".ui-dialog-titlebar").hide();

            $.customDialog[_id].find(".ui-dialog").css("borader", "none");
            //$(".ui-dialog-titlebar").addClass("titleBar")

            resolve();
        });
    };

    $(".-close-dialog").on('click', function() {
        $.fn.closeDialog($(this).parents(".-ui-dialog").attr("id"));
    });

    $.fn.getDialg = function(_id) {
        console.log("---- _id : " + _id);
        return $.customDialog[_id];
    };

    $.fn.openDialog = function(_id) {
        _id = _id || $(this).attr("id");
        if($.fn.getDialg(_id)) return $.fn.getDialg(_id).dialog("open");
    }

    $.fn.closeDialog = function(_id) {
        _id = _id || $(this).attr("id");
        console.log("$.fn.getDialg(_id) " +  $.fn.getDialg(_id));
        if($.fn.getDialg(_id)) $.fn.getDialg(_id).dialog("close");
    }

    $(".-ui-dialog").each(function(){
        $(this).makeDialg();
    });

});
