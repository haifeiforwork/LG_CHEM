<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="com.common.Utils" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<script type="text/javascript">

    $(function () {
        $("a,.unloading").click(function() {
            if(!$(this).hasClass("loading")) {
                window.onbeforeunload = null;
                setTimeout(setBeforeUnload, 1000);
            }
        });
    });

    setBeforeUnload();


    //alert("<spring:message code='script.validate.required2' arguments='"+validText+"' />");


</script>
</html>
