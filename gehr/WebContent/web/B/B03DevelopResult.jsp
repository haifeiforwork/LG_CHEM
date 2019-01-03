<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발 협의결과 조회                                      */
/*   Program Name : 인재개발 협의결과 조회                                      */
/*   Program ID   : B03DevelopResult.jsp                                        */
/*   Description  : 인재개발 협의결과 Print                                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2003-06-23  최영호                                          */
/*                  2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>
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
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
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
<%      if(developDetailData.COMM_TYPE.equals("01")) {           %>          
          <tr> 
            <td align=center><U><h2>人材開發委員會 論義 結果</h2></U></td>
          </tr>
<%      }else if(developDetailData.COMM_TYPE.equals("02")) {     %>
          <tr> 
            <td align=center><U><h2>人材開發小委員會 論義 結果</h2></U></td>
          </tr>
<%      }else if(developDetailData.COMM_TYPE.equals("03")) {     %>
          <tr> 
            <td align=center><U><h2>人材開發分科委員會 論義 結果</h2></U></td>
          </tr>
<%      }         %>
          <tr> 
            <td align=left valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B><font style="font-size:14pt;">수신</font></B>&nbsp;:&nbsp; <input type="text" name="text"  size="25" maxlength='25' style="font-size: 12pt; border: 1 solid #F5F5F5 "> &nbsp;<B><font style="font-size:14pt;">귀하</font></B></td>
          </tr>
          <tr>
            <td valign=top width=400><hr width=350 align=center></hr></td>
          </tr>
          <tr> 
            <td align=center>&nbsp;</td>
          </tr>
          <tr align=center> 
            <td>
              <table>
                 <tr>
                   <td width="700" align=left>
                    <B>"<%= developDetailData.SECT_TEXT %>에서 논의된 아래의 결과를 아래와 같이 회신드리오니 인재육성의 관점에서
                                         Ownership을 발휘하시어 정하여진 일정대로 육성안이 실질적으로 진행될 수 있도록
                                         적극적인 관심과 지원 바랍니다." </B>
                   </td>
                 </tr>
              </table>
            </td>
		  </tr>
		  <tr> 
            <td align=center>&nbsp;</td>
          </tr>
		  <tr>
            <td align=center>
               <table width='80%' border='1' cellspacing="0" cellpadding="0">
                 <tr>
                   <td>
                      <table>
                         <tr>
                           <td>&nbsp;</td>
                         </tr>
                         <tr>
                           <td align=left>   
                               &nbsp;<B>1. 육성 대상자</B>&nbsp;:&nbsp;<%= developDetailData.ENAME %>&nbsp;&nbsp;<%= developDetailData.TITEL %><br><br>
                               &nbsp;<B>2. 육성 논의일자</B>&nbsp;:&nbsp;<%= developDetailData.BEGDA %><br><br>
                   <% if (user.companyCode.equals("C100")) { %> 
                               &nbsp;<B>3. 육성 POST</B>&nbsp;:&nbsp;<%= developDetailData.UPBR_POST %><br><br>
                   <% }else{ %>
                               &nbsp;<B>3. 육성 육성방향</B>&nbsp;:&nbsp;<%= developDetailData.UPB1_CRSE %><br><br>
                   <% } %> 
                               &nbsp;<B>4. 종합 Comments</B><br><br>
                               &nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;<%= developDetailData.CMT1_TEXT %><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= developDetailData.CMT2_TEXT %><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= developDetailData.CMT3_TEXT %><br>
                               &nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;<%= developDetailData.CMT4_TEXT %><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= developDetailData.CMT5_TEXT %><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= developDetailData.CMT6_TEXT %><br><br>
                   
                               &nbsp;<B>5. 육성계획</B>
                           </td>
                         </tr>
                       </table>
                       <table align=center>
                         <tr> 
                           <td align=center> 
                             <table width='700' border='1' cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="100" align=center>구 분</td>
                                <td width="250" align=center>주요 논의 결정사항</td>
                                <td width="150" align=center>세부일정</td>
                                <td width="200" align=center>비 고</td>
                              </tr>
<%  for(int i = 0 ; i < B03DevelopDetail2_vt.size() ; i++) {          
    
      B03DevelopData2 data2 = (B03DevelopData2)B03DevelopDetail2_vt.get(i);
%>
<%                    if(data2.DEVP_TYPE.equals("01")) {              %>
                              <tr>
                                <td align=center>경력개발</td>
                                <td>&nbsp;<%= data2.DEVP_TEXT == null ? "" : data2.DEVP_TEXT %></td>
                                <td>&nbsp;<%= data2.DEVP_YEAR == null ? "" : data2.DEVP_YEAR %>&nbsp;-&nbsp;<% if(data2.DEVP_MNTH.equals("01")){ %>상반기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("02")){ %>하반기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("03")){ %>1/4분기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("04")){ %>2/4분기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("05")){ %>3/4분기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("06")){ %>4/4분기<% } %></td>
                                <td>&nbsp;<%= data2.RMRK_TEXT == null ? "" : data2.RMRK_TEXT %></td>
                              </tr>
<%                    }else if(data2.DEVP_TYPE.equals("02")) {         %>
                              <tr>
                                <td align=center>교육개발</td>
                                <td>&nbsp;<%= data2.DEVP_TEXT == null ? "" : data2.DEVP_TEXT %></td>
                                <td>&nbsp;<%= data2.DEVP_YEAR == null ? "" : data2.DEVP_YEAR %>&nbsp;-&nbsp;<% if(data2.DEVP_MNTH.equals("01")){ %>상반기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("02")){ %>하반기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("03")){ %>1/4분기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("04")){ %>2/4분기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("05")){ %>3/4분기<% } %>
							                                                                                <% if(data2.DEVP_MNTH.equals("06")){ %>4/4분기<% } %></td>
                                <td>&nbsp;<%= data2.RMRK_TEXT == null ? "" : data2.RMRK_TEXT %></td>
                              </tr>
<%                    }                                               %>
<%  }  %> 
                             </table>           
                           </td>
                         </tr>
                         <tr>
                          <td>&nbsp;</td>
                         </tr>
                       </table>
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
          <tr> 
            <td class="td04" align="center">
			  <input type="text" name="text"  size="16" maxlength='16' style="font-size: 18pt; border:1 solid #F5F5F5 ; text-align: center">
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</form>
<form name="form2">
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="begDa" value="">
    <input type="hidden" name="seqnr" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>
</center>