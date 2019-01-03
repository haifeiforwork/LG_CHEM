<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<!-- Page title start -->
<div class="title">
    <h1>SAP JCO</h1>
    <div class="titleRight">
        <ul class="pageLocation">
            <li><span><a href="#">Home</a></span></li>
            <li><span><a href="#">System 관리</a></span></li>
            <li><span><a href="#">SAP JCO</a></span></li>
            <li class="lastLocation"><span><a href="#">SAP JCO</a></span></li>
        </ul>
    </div>
</div>
<!--// Page title end -->

<!-- layout body start -->
<div class="tableArea">
    <h2 class="subtitle">SAP JCO administration</h2>
    <div class="table">
        <table class="worktime btn_crud button-nested">
            <colgroup>
                <col />
                <col />
            </colgroup>
            <thead>
                <tr>
                    <th>기능</th>
                    <th>설명</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th><a href="#" data-url="/admin/initJCO"><span>SAP server 연결 초기화</span></a></th>
                    <td>
<pre>
SAP server 접속 정보가 변경된 경우 Java WAS 또는 web application을 shutdown 시키지않고 적용시킬 수 있는 기능
ehr.properties의 SAP server 정보만 변경한 후 이 button을 누르면 다시 읽어들인다. 
</pre>
                    </td>
                </tr>
                <tr>
                    <th><a href="#" data-url="/admin/clearJCOCache"><span>JCO cache 삭제</span></a></th>
                    <td>
<pre>
RFC meta data cache를 삭제하는 기능
SAP에 RFC function이나 function의 parameter 또는 structure가 추가, 변경, 삭제된 경우에
이 button을 누르면 meta data cache를 삭제하여 변경된 meta data를 읽어들이도록 한다.
</pre>
                    </td>
                </tr>
                <tr>
                    <th><a href="#" data-url="/admin/setAbapDebug?debug=true"><span>ABAP debug 활성화</span></a></th>
                    <td rowspan="2">
<pre>
Web에서 RFC가 호출될 때 debugging을 활성화 또는 비활성화하는 기능
RFC가 호출되면 SAP-GUI가 자동으로 실행되어 debugging 모드가 실행되는데 현재는 이 기능이 동작하지 않음(이유는 알아내지 못함)
</pre>
                    </td>
                </tr>
                <tr>
                    <th><a href="#" data-url="/admin/setAbapDebug?debug=false"><span>ABAP debug 비활성화</span></a></th>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<!-- layout body end -->

<!-- script start -->
<script type="text/javascript" src="/web-resource/js/worktime52/moment-with-locales.min.js"></script>
<script type="text/javascript" src="/web-resource/js/worktime52/jquery-ext-logger.js?v=${CACHE_VERSION}"></script>
<script type="text/javascript">
$(function() {
    $('.button-nested a').click(function() {
        var anchor = $(this), url = anchor.data('url'), text = anchor.find('span').text();
        if (!confirm(text + '를 실행하시겠습니까?')) return;

        $.getJSON(url, function(response) {
            $.LOGGER.debug(url, response);

            if (response.success) {
                alert(text + ' 실행 완료되었습니다.');
            } else {
                alert(text + ' 실행중 오류가 발생하였습니다.\n\n' + response.message);
            }
        });
    });
});
</script>
<!--// script end -->