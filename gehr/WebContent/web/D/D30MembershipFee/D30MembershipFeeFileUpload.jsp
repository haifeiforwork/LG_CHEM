<%@ page import="com.common.Utils" %><%--
  Created by IntelliJ IDEA.
  User: manyjung
  Date: 2016-10-24
  Time: 오후 2:02
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tags-emp-pay" tagdir="/WEB-INF/tags/D/D15" %>
<%@ include file="/web/common/popupPorcess.jsp" %>

<c:set var="g" value="<%=Utils.getBean("global")%>"/>


<tags-emp-pay:emp-upload-layout uploadURL="${g.servlet}hris.D.D30MembershipFee.D30MembershipFeeExcelUpload"/>
