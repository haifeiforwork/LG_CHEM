<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="com.sns.jdf.util.WebUtil" %>

<tags:layout>
    <tags:script>
        <script>
            function view_detail(idx) {
                licn_code = eval("document.form1.LICN_CODE" + idx + ".value");
                flag      = eval("document.form1.FLAG"      + idx + ".value");

                if( flag == "X" ) {    // 자격수당이 있는 경우..
                    window.open('', 'essPopup', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=552,height=365,left=100,top=100");

                    document.form1.jobid2.value    = "license_pop";
                    document.form1.licn_code.value = licn_code;

                    document.form1.target = "essPopup";
                    document.form1.action = "${g.servlet}hris.A.A01SelfDetailSV_m";
                    document.form1.method = "post";
                    document.form1.submit();
                }
            }
        </script>
    </tags:script>

    <div class="subwrapper noMargin">
        <self:self-personal-mss />
    </div>
</tags:layout>






