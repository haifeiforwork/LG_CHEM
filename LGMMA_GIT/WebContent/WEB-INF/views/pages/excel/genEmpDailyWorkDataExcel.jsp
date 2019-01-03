<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="java.util.Vector" %> 
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>  
          
<%    
    String searchDay    = WebUtil.nvl((String)request.getAttribute("E_YYYYMON"));           //대상년월
    String dayCnt       = WebUtil.nvl((String)request.getAttribute("E_DAY_CNT"), "28");     //일자수
    Vector F43DeptDayTitle_vt = (Vector)request.getAttribute("F43DeptDayTitle_vt");         //제목
    Vector F43DeptDayData_vt  = (Vector)request.getAttribute("F43DeptDayData_vt");          //내용
    
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setContentType("Application/Msexcel;charset=UTF-8"); 
    response.setHeader("Content-Disposition", "ATTachment; Filename=DeptDayWorkCondition.xls"); 
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
<form name="form1" method="post">      
  
<% 
    //부서명, 조회된 건수.
    if ( F43DeptDayTitle_vt != null && F43DeptDayTitle_vt.size() > 0 ) {
        F43DeptDayTitleWorkConditionData titleData = (F43DeptDayTitleWorkConditionData)F43DeptDayTitle_vt.get(0);
        
        //대상년월 폼 변경.
        if( !searchDay.equals("") )
            searchDay = searchDay.substring(0, 4)+"."+searchDay.substring(4, 6);
%>
<table width="2040" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="16">&nbsp;</td>
    <td colspan="15">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr >
          <td colspan="15" class="title02">* 일간 근태 집계표</td>
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
    <td  width="16">&nbsp;</td>
  </tr> 
  
<%               
        String tempDept = "";
        for( int j = 0; j < F43DeptDayData_vt.size(); j++ ){
            F43DeptDayDataWorkConditionData deptData = (F43DeptDayDataWorkConditionData)F43DeptDayData_vt.get(j);
            
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
          <td width="60" rowspan="2" class="td03">성명</td>
          <td width="60" rowspan="2" class="td03">사번</td>
          <td width="60" rowspan="2" class="td03">잔여<br/>휴가</td>
          <td width="60" rowspan="2" class="td03">잔여<br/>보상<br/>휴가</td>
          <td colspan="<%=dayCnt%>" class="td03">일일근태내용(<%=titleData.BEGDA%>~<%=titleData.ENDDA%>)</td>
        </tr>
        <tr> 
          <td width="60" class="td03"><%= titleData.D1  %></td>
          <td width="60" class="td03"><%= titleData.D2  %></td>
          <td width="60" class="td03"><%= titleData.D3  %></td>
          <td width="60" class="td03"><%= titleData.D4  %></td>
          <td width="60" class="td03"><%= titleData.D5  %></td>
          <td width="60" class="td03"><%= titleData.D6  %></td>
          <td width="60" class="td03"><%= titleData.D7  %></td>
          <td width="60" class="td03"><%= titleData.D8  %></td>
          <td width="60" class="td03"><%= titleData.D9  %></td>
          <td width="60" class="td03"><%= titleData.D10 %></td>
          <td width="60" class="td03"><%= titleData.D11 %></td>
          <td width="60" class="td03"><%= titleData.D12 %></td>
          <td width="60" class="td03"><%= titleData.D13 %></td>
          <td width="60" class="td03"><%= titleData.D14 %></td>
          <td width="60" class="td03"><%= titleData.D15 %></td>
          <td width="60" class="td03"><%= titleData.D16 %></td>
          <td width="60" class="td03"><%= titleData.D17 %></td>
          <td width="60" class="td03"><%= titleData.D18 %></td>
          <td width="60" class="td03"><%= titleData.D19 %></td>
          <td width="60" class="td03"><%= titleData.D20 %></td>
          <td width="60" class="td03"><%= titleData.D21 %></td>
          <td width="60" class="td03"><%= titleData.D22 %></td>
          <td width="60" class="td03"><%= titleData.D23 %></td>
          <td width="60" class="td03"><%= titleData.D24 %></td>
          <td width="60" class="td03"><%= titleData.D25 %></td>
          <td width="60" class="td03"><%= titleData.D26 %></td>
          <td width="60" class="td03"><%= titleData.D27 %></td>
          <td width="60" class="td03"><%= titleData.D28 %></td>
          <%= titleData.D29.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D29+"</td>" %>
          <%= titleData.D30.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D30+"</td>" %>
          <%= titleData.D31.equals("00") ? "" : "<td width=60 class=td03>"+titleData.D31+"</td>" %>
        </tr>
<%
				for( int i = j; i < F43DeptDayData_vt.size(); i++ ){
				    F43DeptDayDataWorkConditionData data = (F43DeptDayDataWorkConditionData)F43DeptDayData_vt.get(i);
				    if( data.ORGEH.equals(deptData.ORGEH) ){				 
%>
        <tr> 
                    <td class="td04"><%=data.ENAME%></td>
          <td class="td04"><%=data.PERNR.length() == 8 ? data.PERNR.substring(3, 8) : data.PERNR%></td>
          <td class="td04"><%=data.REMA_HUGA%></td>
          <td class="td04"><%=data.REMA_RWHUGA%></td>
          <td class="td04"><%=data.D1 %></td>
          <td class="td04"><%=data.D2 %></td>
          <td class="td04"><%=data.D3 %></td>
          <td class="td04"><%=data.D4 %></td>
          <td class="td04"><%=data.D5 %></td>
          <td class="td04"><%=data.D6 %></td>
          <td class="td04"><%=data.D7 %></td>
          <td class="td04"><%=data.D8 %></td>
          <td class="td04"><%=data.D9 %></td>
          <td class="td04"><%=data.D10%></td>
          <td class="td04"><%=data.D11%></td>
          <td class="td04"><%=data.D12%></td>
          <td class="td04"><%=data.D13%></td>
          <td class="td04"><%=data.D14%></td>
          <td class="td04"><%=data.D15%></td>
          <td class="td04"><%=data.D16%></td>
          <td class="td04"><%=data.D17%></td>
          <td class="td04"><%=data.D18%></td>
          <td class="td04"><%=data.D19%></td>
          <td class="td04"><%=data.D20%></td>
          <td class="td04"><%=data.D21%></td>
          <td class="td04"><%=data.D22%></td>
          <td class="td04"><%=data.D23%></td>
          <td class="td04"><%=data.D24%></td>
          <td class="td04"><%=data.D25%></td>
          <td class="td04"><%=data.D26%></td>
          <td class="td04"><%=data.D27%></td>
          <td class="td04"><%=data.D28%></td>
          <%= titleData.D29.equals("00") ? "" : "<td class=td04>"+data.D29+"</td>" %>
          <%= titleData.D30.equals("00") ? "" : "<td class=td04>"+data.D30+"</td>" %>
          <%= titleData.D31.equals("00") ? "" : "<td class=td04>"+data.D31+"</td>" %>
        </tr>  
                    
<%		            
                    }//end if
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
        <tr> 
          <td colspan="15" style="padding-bottom:2px">＊근태유형 및 단위 </td>
        </tr>
        <tr> 
          <td colspan="35">
            <table width="100%" border="1" cellpadding="0" cellspacing="1" class="table01">
              <tr class="td07"> 
                <td width="100">&nbsp;</td>
                <td colspan="7">시간</td>
                <td colspan="7">일수</td>
                <td colspan="4" width="200">횟수</td>
              </tr>
              <tr> 
                <td class="td07">비근무</td>
                <td colspan="7" class="td09">L:시간공가 U:휴일근무 V:비근무 W :모성보호휴가</td>
                <td colspan="7" class="td09">
                D:반일휴가(이전) E:반일휴가(전반) F:반일휴가(후반)<br/>
				BC:전일휴가(보상) BE:반일휴가(보상,전반) BF:반일휴가(보상,후반)<br/>
				P1:난임휴가(유급) P2:난임휴가(무급)<br/>
                C:전일휴가 G:경조공가 H:하계휴가 I:보건휴가<br/>
                I:보건휴가 J:산전산후휴가 K:전일공가<br/>
                M:유급결근 N:무급결근 X:배우자출산휴가(유급)<br/>
                Y:배우자출산휴가(무급) Z:무급휴일<br/>
                1:무급휴일, 3:무급자녀출산휴가, K:전일공가</td>
                <td colspan="4" class="td09">O:지각 P:조퇴 Q:조기조퇴(무단)</td>
              </tr>
              <tr> 
                <td class="td07">근무</td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="7" class="td09">A:교육(근무시간내) B:출장</td>
                <td colspan="4" class="td09">&nbsp;</td>
              </tr>
              <tr> 
                <td class="td07">초과근무</td>
                <td colspan="7" class="td09">OA:휴일특근 OC:명절특근 OE:휴일연장<br/>
                  OF:연장근로 OG:야간근로</td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="4" class="td09">&nbsp;</td>
              </tr>
              <tr> 
                <td class="td07">기타</td>
                <td colspan="7" class="td09">EA:교육(분임조) EB:교육(근무시간외) EC:당직</td>
                <td colspan="7" class="td09">&nbsp;</td>
                <td colspan="4" class="td09">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table> 
    <td colspan="15"  width="16">&nbsp;</td>
  </tr>      
  <tr><td colspan="15"  height="16"></td></tr>   
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
</form>
</body>
</html>
