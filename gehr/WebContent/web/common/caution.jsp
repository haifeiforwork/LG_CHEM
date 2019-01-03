<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="commonProcess.jsp" %>
<!-- header 부 선언 html js, css, header 부 선언 -->
<%
    String msg = (String)request.getAttribute("msg");
    String url = (String)request.getAttribute("url");
    String message = "";
    boolean flag = true;
    msg = msg.toLowerCase();
    if (StringUtils.indexOf(msg, "msg") == 0) {

        if( msg.equals("msg001") ) {
            message = g.getMessage("MSG.COMMON.0001");  //신청 되었습니다.
        } else if( msg.equals("msg002") ) {
            message = g.getMessage("MSG.COMMON.0002");  //수정 되었습니다.
        } else if( msg.equals("msg003") ) {
            message = g.getMessage("MSG.COMMON.0003");  //삭제 되었습니다.
        } else if( msg.equals("msg004") ) {
            message = g.getMessage("MSG.COMMON.0004");  //해당하는 데이타가 존재하지 않습니다.
        } else if( msg.equals("msg005") ) {
            message = g.getMessage("MSG.COMMON.0005");  //결재가 진행중 입니다.
        } else if( msg.equals("msg006") ) {
            message = g.getMessage("MSG.COMMON.0006");  //계좌번호가 등록되어 있지 않습니다.
        }  else if( msg.equals("msg015") ) {
            message = g.getMessage("MSG.COMMON.0060");//@웹취약성 메시지 추가  //해당 페이지에 권한이 없습니다.
        } else if( msg.equals("msg020") ) {
            message = g.getMessage("MSG.COMMON.0062");//@웹취약성 메시지 추가  //결재자 지정 오류입니다.
        }

    } else {
      message = msg;
    }

    if ( url == null || url.equals("") ){
        flag = false;
    }

%>


<jsp:include page="/include/header.jsp" />
<SCRIPT LANGUAGE="JavaScript">
    <!--
    function runScript(){
        <%
          if(flag){
        %>
        <%= url %>
        <%
          }
        %>
    }
    //-->
</SCRIPT>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr>
      <td width="15">&nbsp; </td>
      <td>
        <!--주의사항 테이블 시작-->
        <table width="750" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <table width="420" border="0" cellspacing="1" cellpadding="0" align="center">
                <tr>
                  <td class="tr01">
                    <table width="400" border="0" cellspacing="1" cellpadding="0" align="center" class="table03" style="height:160px">
                      <tr>
                        <td class="td03" height="30" style="height:30px"></td>
                      </tr>
                      <tr>
                        <td class="td04" height="100" style="height:100px"><%= message %></td>
                      </tr>
                      <tr>
                        <td class="td03" height="30" style="height:30px">
<%
    if(flag){
%>
                          <a href="javascript:runScript();">
                            <img src="<%= WebUtil.ImageURL %>btn_ok.gif" width="48" height="19" border="0" align="absmiddle"></a>
<%
     }
%>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
        <!--주의사항 테이블 끝-->
      </td>
    </tr>
  </table>
</form>
<jsp:include page="/include/footer.jsp" />
