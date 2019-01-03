<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
<%@ page import="hris.B.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    Vector      B03DevelopDetail_vt = (Vector)request.getAttribute("B03DevelopDetail_vt") ;
    Vector      B03DevelopDetail2_vt = (Vector)request.getAttribute("B03DevelopDetail2_vt") ;
	String      BEGDA				= (String)request.getAttribute("begDa");
	String		command				= (String)request.getAttribute("command");
    String      empNo				= (String)request.getAttribute("empNo");
    
    WebUserData user = WebUtil.getSessionUser(request);
    
    B03DevelopData data = (B03DevelopData)B03DevelopDetail_vt.get(Integer.parseInt(command));
    
%>

<html>
<head>
<title>ESS</title>
</head>
<center>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif')">
<form name="form1" method="" action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
        <!--리스트 테이블 시작-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
		  B03DevelopData developDetailData = (B03DevelopData)B03DevelopDetail_vt.get(Integer.parseInt(command));
%>
          <tr> 
            <td align=center><U><h2>육성책 협의결과 회신</h2></U></td>
          </tr>
          <tr> 
            <td align=center>&nbsp;</td>
          </tr>
          <tr>
            <td><b>* 대상자 : </b></td>
          </tr>
          <tr align=left> 
            <td>
              <table width="400" border="0" cellspacing="0" cellpadding="0">
                 <tr>
                   <td>
                     <table width="400" border="1" cellspacing="0" cellpadding="0">
                       <tr>
                         <td width=100 align=center>성명</td>
                         <td width=300>&nbsp;<%= user.ename %></td>
                       </tr>
                       <tr>
                         <td width=100 align=center>소속</td>
                         <td width=300>&nbsp;<%= user.e_orgtx %></td>
                       </tr>
                       <tr>
                         <td width=100 align=center>육성협의일</td>
                         <td width=300>&nbsp;<%= developDetailData.BEGDA %></td>
                       </tr>
                     </table>
                   </td>
                 </tr>
              </table>
            </td>
		  </tr>
		  <tr> 
            <td align=center>&nbsp;</td>
          </tr>
          <tr>
            <td><b>* 자기분석을 통한 자신의 능력, 사고, 행동특성 및 강점을 파악하고 장기적인 관점에서의<br> &nbsp;&nbsp;인재를 육성하기 위해 인재개발 위원회의 협의 결과를 알려드리오니 우수한점(강점)을<br> &nbsp;&nbsp;계속 살려나갈수 있도록 적극 노력하여 주시기 바랍니다.</b>
          </tr>
          <tr> 
            <td align=center>&nbsp;</td>
          </tr>
		  <tr>
		    <td>
		      <table width='700' border="1" cellspacing="0" cellpadding="0">
		        <tr>
		          <td width=70 align=center>종합의견</td>
		          <td width=130 align=center>우수한점</td>
		          <td width=500>&nbsp;<%= developDetailData.CMT1_TEXT %><br>
		                        &nbsp;<%= developDetailData.CMT2_TEXT %><br>
		                        &nbsp;<%= developDetailData.CMT3_TEXT %><br>
		                        &nbsp;<%= developDetailData.CMT4_TEXT %><br>
		                        &nbsp;<%= developDetailData.CMT5_TEXT %><br>
		                        &nbsp;<%= developDetailData.CMT6_TEXT %>
		          </td>
		        </tr>
		          <td width=70 rowspan=3 align=center>육성책</td>
		          <td width=130 align=center>육성방향</td>
		          <td width=500>&nbsp;<%= developDetailData.UPB1_CRSE %></td>
		        <tr>
		          <td width=130 align=center>직무이동</td>
		          <td width=500>&nbsp;
<%  for(int i = 0 ; i < B03DevelopDetail2_vt.size() ; i++) {          
    
      B03DevelopData2 data2 = (B03DevelopData2)B03DevelopDetail2_vt.get(i);
%>
<%                    if(data2.DEVP_TYPE.equals("01")) {              %>

                         &nbsp;<%= data2.DEVP_YEAR == null ? "" : data2.DEVP_YEAR %>년&nbsp;<% if(data2.DEVP_MNTH.equals("01")){ %>상반기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("02")){ %>하반기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("03")){ %>1/4분기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("04")){ %>2/4분기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("05")){ %>3/4분기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("06")){ %>4/4분기<% } %>
                         &nbsp;&nbsp;<%= data2.RMRK_TEXT == null ? "" : data2.RMRK_TEXT %><br>&nbsp;
<%                    }                                               %>
<%  }                                                                 %>		          
		          </td>
		        </tr>
		        <tr>
		          <td width=130 align=center>교육 및 자기개발</td>
		          <td width=500>&nbsp;
<%  for(int i = 0 ; i < B03DevelopDetail2_vt.size() ; i++) {          
    
      B03DevelopData2 data2 = (B03DevelopData2)B03DevelopDetail2_vt.get(i);
%>
<%                    if(data2.DEVP_TYPE.equals("02")) {              %>

                         &nbsp;<%= data2.DEVP_YEAR == null ? "" : data2.DEVP_YEAR %>년&nbsp;<% if(data2.DEVP_MNTH.equals("01")){ %>상반기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("02")){ %>하반기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("03")){ %>1/4분기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("04")){ %>2/4분기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("05")){ %>3/4분기<% } %>
							                                                                <% if(data2.DEVP_MNTH.equals("06")){ %>4/4분기<% } %>
                         &nbsp;&nbsp;<%= data2.RMRK_TEXT == null ? "" : data2.RMRK_TEXT %><br>&nbsp;
<%                    }                                               %>
<%  }                                                                 %>
		          </td>
		        </tr>
		        <tr>
		          <td colspan=2 align=center>기타사항</td>
		          <td>&nbsp;<%= developDetailData.ETC1_TEXT %><br>
		              &nbsp;<%= developDetailData.ETC2_TEXT %>
		          </td>
		        </tr>
		      </table>
		    </td>
		  </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td width="15">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td width="15">&nbsp; </td>
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
<%      if(developDetailData.COMM_TYPE.equals("01")) {           %>          
            <tr> 
              <td align=center><h2>전사 인재개발위원회 간사</h2></td>
            </tr>
<%      }else if(developDetailData.COMM_TYPE.equals("02")) {     %>
<%        if(developDetailData.SECT_COMM.equals("54200018")) {           %>    
            <tr> 
              <td align=center><h2>본사 인재개발소위원회 간사</h2></td>
            </tr>
<%        }else if(developDetailData.SECT_COMM.equals("54200019")){               %>  
            <tr> 
              <td align=center><h2>공장 인재개발소위원회 간사</h2></td>
            </tr>
<%        }                    %>          
<%      }else if(developDetailData.COMM_TYPE.equals("03")) {     %>
<%        if(developDetailData.SECT_COMM.equals("54300077") || developDetailData.SECT_COMM.equals("54300083")) {           %>
            <tr> 
              <td align=center><h2>공장 지원부분 인재개발분과위원회 간사</h2></td>
            </tr>
<%        }else if(developDetailData.SECT_COMM.equals("54300078") || developDetailData.SECT_COMM.equals("54300084")){               %>
            <tr> 
              <td align=center><h2>공장 지원부분 인재개발분과위원회 간사</h2></td>
            </tr>
<%        }else if(developDetailData.SECT_COMM.equals("54300079") || developDetailData.SECT_COMM.equals("54300085")){               %>
            <tr> 
              <td align=center><h2>공장 지원부분 인재개발분과위원회 간사</h2></td>
            </tr>
<%        }                    %>
            
<%      }         %>
        </table>
      </td>
    </tr>
  </table>
</form>

<%@ include file="/web/common/commonEnd.jsp" %>
</center>