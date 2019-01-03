<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 가족관계변경시                                              */
/*   Program Name : 가족관계변경시                                              */
/*   Program ID   : A12HiddenSubtyChange.jsp                                    */
/*   Description  : 가족관계변경시                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2008-04-02                                                  */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.A.A12Family.*" %>
<%@ page import="hris.A.A12Family.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String SUBTY = request.getParameter("SUBTY");
    
    Vector A12FamilyRelation_vt  = (new A12FamilyRelationRFC()).getFamilyRelation(SUBTY); 
%>

<form name="form1">
<%
    for( int i = 0 ; i < A12FamilyRelation_vt.size() ; i++ ) {
            com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)A12FamilyRelation_vt.get(i);
%>
            <input type="hidden" name="P_code<%= i %>" value="<%= ck.code %>">
            <input type="hidden" name="P_value<%= i %>" value="<%= ck.value %>">
<%
    }  // end for
%>
</form>
<script>      
    parent.document.form1.KDSVH.length = <%= A12FamilyRelation_vt.size()+1 %>;
<%        
    int inx = 0;
    for( int i = 0 ; i < A12FamilyRelation_vt.size() ; i++ ) {
        com.sns.jdf.util.CodeEntity ck = (com.sns.jdf.util.CodeEntity)A12FamilyRelation_vt.get(i);
        inx++;
        if ( i ==0) {
%>
        parent.document.form1.KDSVH[<%= inx-1 %>].value = "";
        parent.document.form1.KDSVH[<%= inx-1 %>].text  = "-------------------";
<%      
        inx = inx +1;
  
        }
%>        
        parent.document.form1.KDSVH[<%= inx-1 %>].value = "<%=ck.code%>";
        parent.document.form1.KDSVH[<%= inx-1 %>].text  = "<%=ck.value%>";
<%

    }
    
    if ( A12FamilyRelation_vt.size() == 0 ) {
%>
        parent.document.form1.KDSVH[<%= inx-1 %>].value = "";
        parent.document.form1.KDSVH[<%= inx-1 %>].text  = "-------------------";

       // alert("DATA가 존재하지 않습니다");
<%  } 
%>  
    parent.document.form1.KDSVH[0].selected = true;

 
</script>