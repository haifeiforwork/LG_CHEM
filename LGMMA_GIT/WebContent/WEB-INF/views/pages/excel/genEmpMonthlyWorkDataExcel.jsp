<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="java.util.Vector" %> 
<%@ page import="hris.F.F42DeptMonthWorkConditionData" %>
<%@ page import="hris.common.WebUserData"%>
<%    
	WebUserData user = (WebUserData) (request.getSession().getValue("user"));
    String searchDay    = WebUtil.nvl((String)request.getAttribute("yymmdd"));   //대상년월
    Vector F42DeptMonthWorkCondition_vt = (Vector)request.getAttribute("F42DeptMonthWorkCondition_vt");
    
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setContentType("Application/Msexcel;charset=UTF-8"); 
    response.setHeader("Content-Disposition", "ATTachment; Filename=DeptMonthWorkCondition.xls"); 
    /*----------------------------------------------------------------------------- */        
%>
 
<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=UTF-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<% 
    //부서명, 조회된 건수.
    if ( F42DeptMonthWorkCondition_vt != null && F42DeptMonthWorkCondition_vt.size() > 0 ) {
        //대상년월 폼 변경.
        if( !searchDay.equals("") )
            searchDay = searchDay.substring(0, 4)+"."+searchDay.substring(4, 6);
%>
<table width="1380" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* 월간 근태 집계표</td>
        </tr>       
	    <tr><td colspan="15" height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>         
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="15" class="td09">
            &nbsp;구분 : 월누계&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;대상년월 : <%=searchDay%>                  
          </td>
          <td colspan="15"></td>
        </tr> 
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr> 
  
<%               
        String tempDept = "";
        for( int j = 0; j < F42DeptMonthWorkCondition_vt.size(); j++ ){
            F42DeptMonthWorkConditionData deptData = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(j);
            
            //하위부서를 선택했을 경우 부서 비교. 
            if( !deptData.ORGEH.equals(tempDept) ){
%>   
  <tr><td colspan="15" height="10"></td></tr>       
  <tr>
    <td width="16">&nbsp;</td> 
    <td class="td09">&nbsp;부서명 : <%=deptData.STEXT%></td>
    <td class="td08">&nbsp;</td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16">&nbsp;</td> 
    <td colspan="2" valign="top">
      <table border="1" cellpadding="0" cellspacing="1" class="table02">
        <tr> 
          <td width="60" rowspan="3" class="td03">성명</td>
          <td width="80" rowspan="3" class="td03">사번</td>
          <td width="60" rowspan="3" class="td03">잔여<br/>휴가</td>
          <td width="60" rowspan="3" class="td03">잔여<br/>보상<br/>휴가</td>
<%
	if(!user.e_kyejang.equals("Y")){
%>		
          <td colspan="24" class="td03">근태집계</td>
<%
	} else {
%>		
          <td colspan="22" class="td03">근태집계</td>
<%
	}
%>		
        </tr>
        <tr> 
          <td colspan="12" class="td03">비근무</td>
          <td colspan="2" class="td03">근무</td>
          <td colspan="6" class="td03">초과근무</td>
          <td colspan="2" class="td03">기타</td>
<%
	if(!user.e_kyejang.equals("Y")){
%>		
          <td colspan="2" class="td03">공수</td>
<%
	}
%>		
        </tr>
        <tr> 
          <td width="50" class="td03">휴가</td>
          <td width="50" class="td03">보상<br/>휴가</td>
          <td width="50" class="td03">경조<br/>휴가</td>
          <td width="50" class="td03">하계<br/>휴가</td>
          <td width="50" class="td03">보건<br/>휴가</td>
          <td width="50" class="td03">모성<br/>보호<br/>휴가</td>
          <td width="50" class="td03">공가</td>
          <td width="50" class="td03">결근</td>
          <td width="50" class="td03">지각</td>
          <td width="50" class="td03">조퇴</td>
          <td width="50" class="td03">외출</td>
          <td width="50" class="td03">조기조퇴<br/>(무단조퇴)</td>
          <td width="50" class="td03">교육</td>
          <td width="50" class="td03">출장</td>
          <td width="50" class="td03">휴일<br>특근</td>
          <td width="50" class="td03">명절<br>특근<br /> </td>
          <td width="50" class="td03">휴일<br>연장</td>
          <td width="50" class="td03">연장<br>근로</td>
          <td width="50" class="td03">야간<br>근로</td>
          <td width="50" class="td03">당직</td>
          <td width="50" class="td03">항군<br>(근무외) </td>
          <td width="50" class="td03">교육<br>(근무외) </td>
<%
	if(!user.e_kyejang.equals("Y")){
%>		
          <td width="50" class="td03">금액</td>
          <td width="50" class="td03">시간</td>
<%
	}
%>		
        </tr>

<%
                for( int i = j; i < F42DeptMonthWorkCondition_vt.size(); i++ ){
                    F42DeptMonthWorkConditionData data = (F42DeptMonthWorkConditionData)F42DeptMonthWorkCondition_vt.get(i);

                    //합계부분에 명수 보여주는 부분.
                    if (data.ENAME.equals("TOTAL")) {
                        for (int h = 0; h < 8; h++) {
                            if( !data.PERNR.substring(h, h+1).equals("0") ){
                                data.PERNR = "( "+ data.PERNR.substring(h, 8) + " )명";
                                break;
                            }
                        }
                    }
%>
        <tr> 
          <td class="td04"><%=data.ENAME    %></td>
          <td class="td04"><%=data.PERNR    %></td>
          <td class="td05"><%=data.REMA_HUGA%></td>
          <td class="td05"><%=data.REMA_RWHUGA%></td>
          <td class="td05"><%=data.HUGA     %></td>
          <td class="td05"><%=data.RWHUGA   %></td>
          <td class="td05"><%=data.KHUGA    %></td>
          <td class="td05"><%=data.HHUGA    %></td>
          <td class="td05"><%=data.BHUG     %></td>
          <td class="td05"><%=data.MHUG     %></td>
          <td class="td05"><%=data.GONGA    %></td>
          <td class="td05"><%=data.KYULKN   %></td>
          <td class="td05"><%=data.JIGAK    %></td>
          <td class="td05"><%=data.JOTAE    %></td>
          <td class="td05"><%=data.WECHUL   %></td>
          <td class="td05"><%=data.MUNO     %></td>
          <td class="td05"><%=data.GOYUK    %></td>
          <td class="td05"><%=data.CHULJANG %></td>
          <td class="td05"><%=data.HTKGUN   %></td>
          <td class="td05"><%=data.MTKGUN   %></td>
          <td class="td05"><%=data.HYUNJANG %></td>
          <td class="td05"><%=data.YUNJANG  %></td>
          <td class="td05"><%=data.YAGAN    %></td>
          <td class="td05"><%=data.DANGJIC  %></td>
          <td class="td05"><%=data.HYANGUN  %></td>
          <td class="td05"><%=data.KOYUK    %></td>
<%
	if(!user.e_kyejang.equals("Y")){
%>		
          <td class="td05"><%=data.KONGSU   %></td>
          <td class="td05"><%=data.KONGSU_HOUR%></td>
<%
	}
%>		
        </tr>  
<%                  //마자막 합계 데이터 일 경우.
                    if (data.ENAME.equals("TOTAL")) {
                        break;
                    }
                } //end for...
%>                     
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>  
<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
            }//end if
        }//end for
%>     
  <tr><td colspan="15" height="15"></td></tr>       
  <tr> 
    <td width="16">&nbsp;</td>
    <td colspan="15" >
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
<%
	if(!user.e_kyejang.equals("Y")){
%>		
        <tr> 
          <td colspan="15">＊공수 = 실출근일수 + 유급휴일수 + (초과근로 + 기타) * 가중시수 반영<br/>
                           ＊초과근로 + 기타 = (연장 + 야간 + 특근 + 근무시간외 교육, 향군)/ 8h</td>
        </tr>
<%
	}
%>		
        <tr> 
          <td colspan="15">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="15" style="padding-bottom:2px">＊근태유형 및 단위 </td>
        </tr>
        <tr> 
          <td colspan="35">
            <table border="1" cellspacing="1" cellpadding="0" class="table01">
              <tr class="td07"> 
                <td colspan="2">근태유형</td>
                <td colspan="7">비근무</td>
                <td width="100" >근무</td>
                <td colspan="7">초과근무</td>
                <td colspan="5" width="200" >기타</td>
              </tr>
              <tr> 
                <td width="60" rowspan="3" class="td04">단위</td>
                <td width="60" class="td04">시간</td>
                <td colspan="7" class="td09">시간공가, 휴일비근무, 비근무<br>모성보호휴가</td>
                <td width="100" rowspan="3" class="td04">교육, 출장</td>
                <td colspan="7" class="td09">휴일특근, 명절특근, 휴일연장, 연장근로, 야간근로 <br />
                  </td>
                <td colspan="5" class="td09">교육(근무 외), 당직<br />
                  </td>
              </tr>
              <tr> 
                <td class="td04">일수</td>
                <td colspan="7" class="td09">반일휴가(전반/후반), 보상휴가(전일/반일(전/후반)),<br/>
                  전일휴가, 경조휴가, 하계휴가, 보건휴가, 난임휴가,<br/>
                  산전산후휴가, 전일공가, 유급결근, 무급결근, 전일공가 </td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="5" class="td09">&nbsp;</td>
              </tr>
              <tr> 
                <td class="td04">횟수</td>
                <td colspan="7" class="td09">지각, 조퇴,조기조퇴(무단)</td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="5" class="td09">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table> 
    <td colspan="15" width="16">&nbsp;</td>
  </tr>      
  <tr><td colspan="15" height="16"></td></tr>   
</table> 

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center"> 
    <td  class="td04" align="center" height="25" >해당하는 데이터가 존재하지 않습니다.</td>
  </tr>
</table>  
<%
    } //end if...
%>      
</body>
</html>
