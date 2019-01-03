<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="hris.J.J01JobMatrix.*" %>
<%@ page import="hris.J.J01JobMatrix.rfc.*" %>
<%@ page import="hris.J.J03JobCreate.*" %>
<%@ page import="hris.J.J03JobCreate.rfc.*" %>  

<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.*" %>
<%

     String    i_objid  = request.getParameter("objid"); 
     String    i_stext  = request.getParameter("stext");       
     String    i_rows   = request.getParameter("rows");         
     String    i_QKid   = request.getParameter("QKID");              
     J01CompetencyDetailRFC rfc            = new J01CompetencyDetailRFC();
     Vector                 j02Result_vt   = new Vector();
     Vector                 j02Result_D_vt = new Vector();
     Vector ret            = rfc.getDetail(i_objid, DataUtil.getCurrentDate() );
     j02Result_vt   = (Vector)ret.get(0);
     j02Result_D_vt = (Vector)ret.get(1);
     
     StringBuffer subtype1 = new StringBuffer();
     StringBuffer subtype2 = new StringBuffer();
     StringBuffer subtype3 = new StringBuffer();
     StringBuffer subtype4 = new StringBuffer();
        
    for( int i = 0 ; i < j02Result_D_vt.size() ; i++ ) {
        J01CompetencyDetailData data_D = (J01CompetencyDetailData)j02Result_D_vt.get(i);    
        if( data_D.SUBTY.equals("0001") ) {
            subtype1.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("0002") ) {
            subtype2.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("0003") ) {
            subtype3.append(data_D.TLINE+"<br>");
        } else if( data_D.SUBTY.equals("0004") ) {
            subtype4.append(data_D.TLINE+"<br>");
        } 
    }  
    
    Vector   j03RequireLevel          = new Vector();    
    J03RequireLevelRFC rfc_l          = new J03RequireLevelRFC();
    Vector   ret2                     = rfc_l.getDetail();
    j03RequireLevel                   = (Vector)ret2.get(0);
%>

<script language="JavaScript">
  var htmlSTEXT_Q_S  = "", htmlZLEVEL_S = "", htmlSTEXT_KEY_S = "", htmlTLINE_S = ""; htmlBUTTON_S = "";
  
  htmlSTEXT_Q_S += "<table cellspacing=0 cellpadding=0 border=0 width=67><tr><td class=ct1><%= i_stext %></td></tr></table>"
                +  "<input type=hidden name='SOBID<%= i_rows %>' value='<%= i_objid %>'>"
                +  "<input type=hidden name='STEXT_Q<%= i_rows %>' value='<%= i_stext %>'>";

  htmlBUTTON_S += "<a href='javascript:setCompetency(<%= i_QKid %>,<%= i_rows %>);'><img src='<%= WebUtil.ImageURL %>jms/btn_points.gif' border=0 hspace=3 alt='지정'></a><br><img src='<%= WebUtil.ImageURL %>jms/spacer.gif' width=10 height=3><br>"
               +  "<a href='javascript:delCompetency(<%= i_QKid %>,<%= i_rows %>);'><img src='<%= WebUtil.ImageURL %>jms/btn_deletes.gif' border=0 hspace=3 alt='삭제'></a>";
          
  htmlSTEXT_KEY_S += "<table cellspacing=0 cellpadding=0 border=0 width=75><tr><td id='STEXT_KEY_T<%=i_rows %>'></td></tr></table>";
  htmlTLINE_S     += "<table cellspacing=0 cellpadding=0 border=0 width=450><tr><td id='TLINE_T<%=i_rows %>'></td></tr></table>"; 
<%
  for ( int i = 0; i < j02Result_vt.size(); i++){
     J01CompetencyDetailData data = (J01CompetencyDetailData)j02Result_vt.get(i);
%>  
      htmlZLEVEL_S    += "<input type=hidden name='ZLEVEL_S<%= i_rows %><%=i%>' value='<%=data.ZLEVEL %>'>";   
      htmlSTEXT_KEY_S += "<input type=hidden name='STEXT_KEY_S<%= i_rows %><%=i%>' value='<%= data.STEXT_KEY %>'>";
      htmlTLINE_S     += "<input type=hidden name='TLINE_S<%= i_rows %><%=i%>' <% if( data.ZLEVEL_RAT.equals("1") ) { %> value='<%= subtype1.toString()%>'>";<% } else if( data.ZLEVEL_RAT.equals("2") ) { %> value='<%= subtype2.toString()%>'>"; <% } else if( data.ZLEVEL_RAT.equals("3") ) {%> value='<%= subtype3.toString()%>'>"; <% } else if( data.ZLEVEL_RAT.equals("4") ) { %> value='<%= subtype4.toString()%>'>";
<%}
  }
%>  
  htmlZLEVEL_S += "<select onChange='javascript:changeContents(<%= i_rows %>);' name='LEVEL_D<%= i_rows %>'><option value='' selected>--</option><%for( int m = 0 ; m < j03RequireLevel.size(); m++){ J03RequireLevelData data_L = (J03RequireLevelData)j03RequireLevel.get(m); %> <option value='<%= m %>'><%= data_L.PSTEXT %></option> <% } %> </select>"
               +  "<input type=hidden name='SELECTED<%= i_rows %>' value='9'>";

<!-- 이미 선택한 Competency 일경우 메시지를 보여준다. -------------------------------->
  var p_SOBID = "";
  var set_OK  = "";

  var line_cnt = Number(parent.parent.opener.document.form1.comm_size.value) + Number(parent.parent.opener.document.form1.spec_size.value);
  for( i = 0 ; i < line_cnt ; i++ ) {
    p_SOBID = eval("parent.parent.opener.document.form1.SOBID"+i+".value");
    if( p_SOBID == "<%= i_objid %>" ) {
      set_OK = "Y";
    }
  }

  if( set_OK == "Y" ) {
    alert("이미 선택된 Competency 입니다.");
  } else {  
<!-- 이미 선택한 Competency 일경우 메시지를 보여준다. -------------------------------->
    parent.parent.opener.STEXT_Q_S<%=i_rows%>.innerHTML         = htmlSTEXT_Q_S;
    parent.parent.opener.ZLEVEL_S<%=i_rows%>.innerHTML          = htmlZLEVEL_S;
    parent.parent.opener.STEXT_KEY_S<%=i_rows%>.innerHTML       = htmlSTEXT_KEY_S;
    parent.parent.opener.TLINE_S<%=i_rows%>.innerHTML           = htmlTLINE_S;
    parent.parent.opener.BUTTON_S<%=i_rows%>.innerHTML          = htmlBUTTON_S;  
    parent.parent.opener.document.form1.D_EXIT<%=i_rows%>.value = "Y";
    parent.self.close();
  }
</script>