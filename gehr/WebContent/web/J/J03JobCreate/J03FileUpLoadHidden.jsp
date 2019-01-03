<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/popupPorcess.jsp" %> 

<%@ page import="java.io.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);

// 처음 jsp 에서 받는 부분
    String i_sobid    = request.getParameter("SOBID");
    String i_filename = request.getParameter("FILENAME1");
    String i_begda    = request.getParameter("BEGDA");        //Job 시작일
    int    i_wkid     = Integer.parseInt(request.getParameter("wkid")); 
// 작업구분 3 4 는 실제 생성 확인 
// 작업구분 5 6 은 이름 존재확인   
    i_wkid = i_wkid + 2;

    J03FileUpLoadRFC rfc           = new J03FileUpLoadRFC();
    Vector           ret           = new Vector();
    Vector           j03Message_vt = new Vector();
    String           E_SUBRC       = "0";
    int              count_E       = 0;

    ret = rfc.UpLoad(Integer.toString(i_wkid), i_sobid, i_filename, i_begda, user.empNo);
    Logger.debug.println(this, "이름첵크:" + i_wkid+ i_sobid+ i_filename +i_begda );                  
    j03Message_vt = (Vector)ret.get(0);
    E_SUBRC       = (String)ret.get(1);
    count_E       = j03Message_vt.size();
%>     
<form name="form1" method="post" action="" >
<!-- 생성 Error시 메시지 받아서 보여주기 -->
  <input type="hidden" name="count_E" value="<%= count_E %>">     <!-- BDC MESSAGE TEXT        -->
<%
    for( int i = 0 ; i < count_E ; i++ ) {
        J03MessageData errData = (J03MessageData)j03Message_vt.get(i);  
%>
  <input type="hidden" name="MSGSPRA<%= i %>" value='<%= errData.MSGSPRA %>'>     <!-- 메세지 언어 ID          -->
  <input type="hidden" name="MSGID<%= i %>"   value='<%= errData.MSGID   %>'>     <!-- Batch 입력 메세지 ID    -->
  <input type="hidden" name="MSGNR<%= i %>"   value='<%= errData.MSGNR   %>'>     <!-- Batch 입력 메세지번호   -->
  <input type="hidden" name="MSGTEXT<%= i %>" value='<%= errData.MSGTEXT %>'>     <!-- BDC MESSAGE TEXT        -->
<%
    }
%>
</form>

<script language="JavaScript">  
<%
    if ( E_SUBRC.equals("0")) {
%>    
       parent.UpPopMain.goUpLoad2();
<%       
    } else if ( !E_SUBRC.equals("0") ) {
%>  
    error_window=window.open("","errorWindow","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=480,height=380,left=100,top=100");
    error_window.focus();
    document.form1.action = "<%= WebUtil.JspURL %>J/J03JobCreate/J03ErrorWindow.jsp";
    document.form1.target = "errorWindow";
    document.form1.submit();
    
    parent.self.close();
<%
   } 
%>
</script>

