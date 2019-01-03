<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태집계표 												*/
/*   Program Name	:   근태집계표 - 월간 프린트								*/
/*   Program ID		: D40MonthStatePrint.jsp								*/
/*   Description		: 근태집계표 - 월간	 프린트								*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>
<%@ page import="hris.N.AES.AESgenerUtil"%>

<%
	WebUserData user = (WebUserData)session.getAttribute("user");
	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자
	String deptId		= WebUtil.nvl(request.getParameter("hdn_deptId"));  					//부서코드
	String deptNm		= WebUtil.nvl(request.getParameter("hdn_deptNm"));  				//부서명
	String I_SCHKZ =  WebUtil.nvl(request.getParameter("I_SCHKZ"));

	String E_INFO    = (String)request.getAttribute("E_INFO");	//문구
	String E_RETURN    = (String)request.getAttribute("E_RETURN");	//리턴코드
	String E_MESSAGE    = (String)request.getAttribute("E_MESSAGE");	//리턴메세지
	Vector T_SCHKZ    = (Vector)request.getAttribute("T_SCHKZ");	//계획근무
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTC    = (Vector)request.getAttribute("T_EXPORTC");	//월간근태집계표
	String E_DAY_CNT    = (String)request.getAttribute("E_DAY_CNT");	//

	String I_PERNR    = WebUtil.nvl((String)request.getAttribute("I_PERNR"));	//조회사번
	String I_ENAME    = WebUtil.nvl((String)request.getAttribute("I_ENAME"));	//조회이름
	String I_DATUM    = (String)request.getAttribute("I_DATUM");	//선택날짜

	String I_BEGDA    = (String)request.getAttribute("I_BEGDA");	//선택날짜
	String I_ENDDA    = (String)request.getAttribute("I_ENDDA");	//선택날짜
	String gubun    = (String)request.getAttribute("gubun");	//선택날짜
	String p_gubun    = (String)request.getAttribute("p_gubun");	//선택날짜
%>

<jsp:include page="/include/header.jsp" />
<!-- Page Skip 해서 프린트 하기 -->
<style type = "text/css">
P.breakhere {page-break-before: always}
</style>


<jsp:include page="/include/header.jsp" />
<style type="text/css">
P.breakhere {
	page-break-before: always
}
</style>

<SCRIPT LANGUAGE="JavaScript">
<!--
function prevDetail() {
  switch (location.hash)  {
    case "#page2":
      location.hash ="#page1";
    break;
  } // end switch
}

function nextDetail() {
  switch (location.hash)  {
    case "":
    case "#page1":
      location.hash ="#page2";
    break;
  } // end switch
}

function click() {
    if (event.button==2) {
      //alert('마우스 오른쪽 버튼은 사용할수 없습니다.');
      //alert('오른쪽 버튼은 사용할수 없습니다.');
      alert('<%=g.getMessage("MSG.F.F41.0006")%>');

   return false;
    }
  }

 function keypressed() {
      //alert('키를 사용할 수 없습니다.');
       return false;
  }

  document.onmousedown=click;
  document.onkeydown=keypressed;


//-->
</SCRIPT>

<jsp:include page="/include/body-header.jsp">
	<jsp:param name="click" value="Y"/>
</jsp:include>

<form name="form1" method="post">


	<div class="winPop">
		<div class="header">
			<span><!-- 월간 근태 집계표--><%=g.getMessage("TAB.D.D40.0016")%></span>
			<a href=""onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
		</div>
	</div>

<%
		//부서명, 조회된 건수.
// 		D40DailStateData titleData = (D40DailStateData) T_EXPORTA.get(0);

		String tempDept = "";

		for (int j = 0; j < T_EXPORTC.size(); j++) {
			D40DailStateData deptData = (D40DailStateData) T_EXPORTC.get(j);
			//하위부서를 선택했을 경우 부서 비교.
			if (!deptData.ORGEH.equals(tempDept)) {
%>

	<div class="listArea">
		<div class="listTop">
	  		<span class="listCnt">
	  			<h2 class="subtitle"><!-- 부서명--><%=g.getMessage("LABEL.F.F41.0002")%> :	<%=deptData.STEXT%> [<%=deptData.ORGEH%>]</h2>
	  		</span>
	  		<div style="position:relative; display:block; text-align:right; margin-right: 8px;margin-left: 2px;top:8px; ">
	  			<%=g.getMessage("LABEL.D.D40.0120")%> : <%=currentDate %>
	  		</div>
		</div>

		<div class="table">
  			<div class="wideTable">
      			<table class="listTable">
      				<thead>
        				<tr>
							<th rowspan="3" ><!-- 이름--><%=g.getMessage("LABEL.D.D12.0018")%></th>
							<th rowspan="3" ><!-- 사번--><%=g.getMessage("LABEL.F.F41.0004")%></th>
							<th rowspan="3" ><!-- 잔여휴가--><%=g.getMessage("LABEL.F.F42.0004")%></th>
							<th colspan="23" ><!-- 근태집계--><%=g.getMessage("LABEL.F.F42.0005")%></th>
							<th class="lastCol"  rowspan="3" ><!-- 서명--><%=g.getMessage("LABEL.F.F42.0054")%></th>
						</tr>
						<tr>
						  	<th colspan="11" ><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0006")%></th>
							<th colspan="2" ><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%></th>
							<th colspan="6" ><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%></th>
							<th colspan="2" ><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></th>
							<th colspan="2" ><!-- 공수--><%=g.getMessage("LABEL.F.F42.0010")%></th>
						</tr>
						<tr>
							<th><!-- 연차--><%=g.getMessage("LABEL.F.F41.0011")%></th>
							<th><!-- 경조--><%=g.getMessage("LABEL.F.F42.0012")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
							<th><!-- 하계--><%=g.getMessage("LABEL.F.F42.0013")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
							<th><!-- 보건--><%=g.getMessage("LABEL.F.F42.0014")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
							<th><!-- 모성--><%=g.getMessage("LABEL.F.F42.0015")%><br/><!--보호--><%=g.getMessage("LABEL.F.F42.0017")%><br/><!-- 휴가--><%=g.getMessage("LABEL.F.F42.0011")%></th>
							<th><!-- 공가--><%=g.getMessage("LABEL.F.F42.0016")%></th>
							<th><!-- 결근--><%=g.getMessage("LABEL.F.F42.0018")%></th>
							<th><!-- 지각--><%=g.getMessage("LABEL.F.F42.0019")%></th>
							<th><!-- 조퇴--><%=g.getMessage("LABEL.F.F42.0020")%></th>
							<th><!-- 외출--><%=g.getMessage("LABEL.F.F42.0021")%></th>
							<th><!-- 무노동--><%=g.getMessage("LABEL.F.F42.0022")%><br/><!-- 무임금--><%=g.getMessage("LABEL.F.F42.0023")%> </th>
							<th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%></th>
							<th><!-- 출장--><%=g.getMessage("LABEL.F.F42.0025")%></th>
							<th><!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%></th>
							<th><!-- 명절--><%=g.getMessage("LABEL.F.F42.0029")%><br><!-- 특근--><%=g.getMessage("LABEL.F.F42.0027")%><br /> </th>
							<th> <!-- 휴일--><%=g.getMessage("LABEL.F.F42.0026")%><br><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%></th>
							<th><!-- 연장--><%=g.getMessage("LABEL.F.F42.0031")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
							<th><!--야간--><%=g.getMessage("LABEL.F.F42.0033")%><br><!-- 근로--><%=g.getMessage("LABEL.F.F42.0032")%></th>
							<th><!-- 당직--><%=g.getMessage("LABEL.F.F42.0034")%></th>
							<th><!-- 항군--><%=g.getMessage("LABEL.F.F42.0035")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%></th>
							<th><!-- 교육--><%=g.getMessage("LABEL.F.F42.0024")%><br><!-- (근무외)--><%=g.getMessage("LABEL.F.F42.0036")%>  </th>
							<th><!-- 금액--><%=g.getMessage("LABEL.F.F42.0037")%></th>
							<th><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></th>
						</tr>
					</thead>
<%
					String preEmpNo = "";
					int cnt = 0;
					for (int i = j; i < T_EXPORTC.size(); i++) {
						D40DailStateData data = (D40DailStateData) T_EXPORTC.get(i);
						String tr_class = "";
// 						if (data.ORGEH.equals(deptData.ORGEH)) {
						if (cnt % 2 == 0) {
							tr_class = "oddRow";
						} else {
							tr_class = "";
						}
						cnt++;

						//합계부분에 명수 보여주는 부분.
	                    if (data.ENAME.equals("TOTAL")) {
	                        for (int h = 0; h < 8; h++) {
	                            if( !data.PERNR.substring(h, h+1).equals("0") ){
	                                data.PERNR = "( "+ data.PERNR.substring(h, 8) + " )"+g.getMessage("LABEL.F.F42.0058");
	                                break;
	                            }
	                        }
	                    }
%>
					<tbody>
						<tr class="<%=tr_class%>">
							<td nowrap><%=data.ENAME    %></td>
            				<td ><%=data.PERNR    %></td>
							<td><%=WebUtil.printNumFormat(data.REMA_HUGA, 2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.HUGA     ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.KHUGA    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.HHUGA    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.BHUG     ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.MHUG     ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.GONGA    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.KYULKN   ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.JIGAK    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.JOTAE    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.WECHUL   ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.MUNO     ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.GOYUK    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.CHULJANG ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.HTKGUN   ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.MTKGUN   ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.HYUNJANG ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.YUNJANG  ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.YAGAN    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.DANGJIC  ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.HYANGUN  ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.KOYUK    ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.KONGSU   ,2)%></td>
				            <td ><%=WebUtil.printNumFormat(data.KONGSU_HOUR,2)%></td>
				            <td class="lastCol" <%if (!"TOTAL".equals(data.ENAME)){ %>style="color: #EAEAEA" <%} %>>
				            	<%if (!"TOTAL".equals(data.ENAME)){ out.print(data.ENAME);  }%>
				            </td>
						</tr>
					</tbody>
<%                  //마자막 합계 데이터 일 경우.
                    if (data.ENAME.equals("TOTAL")) {
                        break;
                    }
                } //end for...
%>
				</table>
			</div>
		</div>

		<div class="commentImportant">
      <!-- ＊공수 = 실출근일수 + 유급휴일수 + (초과근로 + 기타) * 가중시수 반영<br/>
           ＊초과근로 + 기타 = (연장 + 야간 + 특근 + 근무시간외 교육, 향군)/ 8h-->
      <p><%=g.getMessage("LABEL.F.F42.0039")%></p>
    </div>

    <h2 class="subtitle"><!-- 근태유형 및 단위--><%=g.getMessage("LABEL.F.F42.0040")%></h2></td>

    <div class="listArea">
		<div class="table">
        	<table class="listTable">
            	<thead>
              		<tr>
		                <th colspan="2"><!-- 근태유형--><%=g.getMessage("LABEL.F.F42.0041")%> </th>
		                <th><!-- 비근무--><%=g.getMessage("LABEL.F.F42.0084")%></th>
		                <th><!-- 근무--><%=g.getMessage("LABEL.F.F42.0007")%> </th>
		                <th><!-- 초과근무--><%=g.getMessage("LABEL.F.F42.0008")%> </th>
		                <th class="lastCol"><!-- 기타--><%=g.getMessage("LABEL.F.F42.0009")%></th>
              		</tr>
              	</thead>
              		<tr class="borderRow">
		            	<td rowspan="3"><!-- 단위--><%=g.getMessage("LABEL.F.F42.0042")%></td>
		                <td><!-- 시간--><%=g.getMessage("LABEL.F.F42.0038")%></td>
		                <td style="text-align: left; padding-left: 20px;"><!-- 시간공가, 휴일비근무, 비근무<br>모성보호휴가 --><%=g.getMessage("LABEL.F.F42.0043")%></td>
		                <td rowspan="3"><!-- 교육, 출장 --><%=g.getMessage("LABEL.F.F42.0044")%></td>
		                <td style="text-align: left; padding-left: 20px;"><!-- 휴일특근, 토요특근, 명절특근, 명절특근(토), <br>
		                  휴일연장,연장근로, 야간근로, 야간근로(명절) --><%=g.getMessage("LABEL.D.D40.0056")%> </td>
		                <td style="text-align: left; padding-left: 20px;"><!-- 향군(근무시간외),<br />
		                  교육(근무시간외) --> <%=g.getMessage("LABEL.F.F42.0046")%></td>
              		</tr>
              		<tr class="borderRow">
                		<td><!-- 일수 --><%=g.getMessage("LABEL.F.F42.0047")%></td>
                		<td style="text-align: left; padding-left: 20px;"><!-- 반일휴가(전반/후반), 토요휴가, 전일휴가,<br>
                  경조휴가, 하계휴가,보건휴가, 출산전후휴가,<br>전일공가, 유급결근, 무급결근, 전일공가 --><%=g.getMessage("LABEL.F.F42.0048")%></td>
                		<td>&nbsp;</td>
                		<td>&nbsp;</td>
              		</tr>
              		<tr class="borderRow">
                		<td><!-- 횟수 --><%=g.getMessage("LABEL.F.F42.0049")%></td>
                		<td style="text-align: left; padding-left: 20px;"><!-- 지각, 조퇴, 외출 --><%=g.getMessage("LABEL.F.F42.0050")%></td>
                		<td>&nbsp;</td>
                		<td>&nbsp;</td>
              		</tr>
        		</table>
      		</div>
    	</div>
		<div style="page-break-before:always"></div>

<%
                //부서코드 비교를 위한 값.
                tempDept = deptData.ORGEH;
			}//end if
		}//end for
%>
	</div>

</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
