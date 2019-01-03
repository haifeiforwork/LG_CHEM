<%@ tag language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="uploadURL" type="java.lang.String" %>

<style>
    .file-button {
        position: relative;
        overflow: hidden;
        /*display: inline-block;*/
    }
    .file-input {
        position: absolute;
        display: none;
        width: 0px;
        bottom: 0;
        left: 0;
        right: 0;
        opacity: 0.001;
        -ms-filter: 'alpha(opacity=0)';
        direction: ltr;
        cursor: pointer;
    }
    /* Fixes for IE < 8 */
    @media screen\9 {
        .file-button input {
            filter: alpha(opacity=0);
            font-size: 100%;
            height: 100%;
        }
    }
</style>
<script type="text/javascript" src="<c:url value="${g.image}js/jquery.form.js" />"></script>
<script type="text/javascript" src="<c:url value="${g.image}js/jquery.iframe-transport.js" />"></script>
<script type="text/javascript" src="<c:url value="${g.image}js/jquery.fileupload.js" />"></script>
<script>
    $(function() {
        $('.file-button').click(function() {
            $(this).parents("li").find(".file-input").trigger("click");
        });

        applyFileUpload($('.file-input'));
    });

    function applyFileUpload($obj) {
        if(_.isEmpty("${uploadURL}")) {
            return;
        }

        $obj.fileupload({
            url: '${uploadURL}',
            dataType: 'json',
            _target : $obj,
            autoUpload: true,
            multipart: false,


            errorprocess : function() {
                alert("upalod fail");
            },
            done: function (e, data) {
                var _$this = $(this);
                var _target = _$this.data('target');

                /*var _afterProcess = _$this.data('afterProcess');

                if(data.result.code == 'success') {

                    $('#' + _target + '-files').text(data.result.fileName);
                    $('#' + _target + '-fileName').val(data.result.fileName);
                    $('#' + _target + '-tempFileName').val(data.result.tempFileName);
                    _$this.parents("td:first").find(".-delete-button").show();

                    doMethod(afterUploadProcess, null, data.result);

                } else data.errorprocess(_target);*/
            },
            progressall: function (e, data) {
                var _button = $obj.parents("li").find(".file-button");
                _button.prop("disabled", true);    //???
                var $buttonText = _button.find("file-button-name");
                var _beforeText = $buttonText.text();

                var progress = parseInt(data.loaded / data.total * 100, 10);

                $buttonText.text(_beforeText + "(" + progress + '%' + ")");

            },
            error: function(jqXHR, textStatus, errorThrown) {
                this.errorprocess();
            }
        }).prop('disabled', !$.support.fileInput)
                .parent().addClass($.support.fileInput ? undefined : 'disabled');

    }


</script>
