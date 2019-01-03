<%/******************************************************************************/
/*										*/
/*   System Name  : MSS								*/
/*   1Depth Name  : 신청							*/
/*   2Depth Name  : 부서근태							*/
/*   Program Name : 부서일일근태관리						*/
/*   Program ID   : D12Rotation|D12RotationDetail.jsp				*/
/*   Description  : 부서일일근태관리 화면					*/
/*   Note         : 								*/
/*   Creation     : 2009-02-10  LSA						*/
/*   Update       : 								*/
/*   Update       : 2009-10-26  CSR ID:1546748 여수공장 사유 목록화처리         */
/*   Update       : 2013-05-23  CSRID: Q20130422_76414                          */
/*                              경조휴가: 0130 자녀출산(무급) =>0370:임금유형변경*/
/*                              경조휴가: 자녀출산(유급)  =>0130                 */
/*										*/
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.D.D12Rotation.*" %>
<%@ page import="hris.D.D12Rotation.rfc.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="hris.E.E19Congra.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.D.D03Vocation.*" %>
<%@ page import="hris.D.D03Vocation.rfc.*" %>

<%
    String jobid      = (String)request.getAttribute("jobid");
	String e_rtn = (String)request.getAttribute("E_RETURN");
	String e_msg = (String)request.getAttribute("E_MESSAGE");

	String t_deptNm = (String)request.getAttribute("deptNm");
	if(t_deptNm == null)
		t_deptNm = "";
    Vector main_vt    = (Vector)request.getAttribute("main_vt");
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));          //부서코드
    String deptNm       = WebUtil.nvl(new String(request.getParameter("hdn_deptNm").getBytes("Cp1252"), "utf-8"));          //부서명
    String I_DATE  = WebUtil.nvl(request.getParameter("I_DATE"));          //기간
    String E_STATUS  = WebUtil.nvl(request.getParameter("E_STATUS"));          //승인완료=A 은, 수정 및 저장 불가
    if( I_DATE == null|| I_DATE.equals("")) {
        I_DATE = DataUtil.getCurrentDate();           //1번째 조회시
    }
    String rowCount   = (String)request.getAttribute("rowCount" );

    WebUserData user = WebUtil.getSessionUser(request);
    if(deptId == null || deptId.equals("")){
    	deptId = user.e_orgeh;
    }
    //int main_count = 8;
    //if( main_vt.size() > main_count ) {
    int  main_count = main_vt.size();
    //}

    String isPop = WebUtil.nvl(request.getParameter("hdn_isPop"));
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function init(){

}

function handleError (err, url, line) {
	   //alert('오류 : '+err + '\nURL : ' + url + '\n줄 : '+line);
	   alert('<%=g.getMessage("MSG.D.D12.0018")%> : '+err + '\nURL : ' + url + '\n<%=g.getMessage("MSG.D.D12.0019")%> : '+line);


   return true;
}
//-->
</script>
</head>

<%-- html body 안 헤더부분 - 타이틀 등
<jsp:include page="/include/body-header.jsp">
    <jsp:param name="title" value="LABEL.D.D12.0009"/>
</jsp:include> --%>

<body>
<form name="form1" method="post" onsubmit="return false">
<input type="hidden" name="hdn_isPop"   value="<%=WebUtil.nvl(request.getParameter("hdn_isPop"))%>">
<input type="hidden" name="hdn_gubun"   value="">
<input type="hidden" name="hdn_deptId"  value="<%=deptId%>">
<input type="hidden" name="hdn_deptNm"  value="<%=deptNm%>">
<input type="hidden" name="hdn_excel"   value="">
<input type="hidden" name="data98" value="<%=main_vt.toString()%>">

<div class="winPop">

	<div class="header">
		<span><!-- 부서 일일 근태 관리 --><%=g.getMessage("TAB.COMMON.0046")%></span>
		<a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
	</div>

<div class="body">
	<!-- 근태일자 Field Table Header 시작 -->

	<div class="tableArea">
		<div class="table">
          <table class="tableGeneral">
          	<colgroup>
          		<col width="20%" />
          		<col />
          	</colgroup>
            <tr>
              <th><!-- 기간 --><%=g.getMessage("LABEL.D.D12.0013")%></th>
              <td>
                <%= WebUtil.printDate(I_DATE) %>
                <input type="hidden" name="I_DATE" value="<%= I_DATE %>">
              </td>
            </tr>
          </table>
        </div>
	</div>
	<!-- 근태일자 Field Table Header 끝 -->

	<!-- 상단 입력 테이블 시작-->
	<div class="listArea">
		<div class="table">
			<table class="listTable">
			       	<colgroup>
       				<col width="3%" />
       				<col width="3%" />
       				<col width="8%" />
       				<col width="10%" />
       				<col width="8%" />
       				<col width="8%" />
       				<col width="8%" />
       				<col width="8%" />
       				<col width="6%" />
       				<col width="40%" />
       				<col />
                <thead>
                <tr>
                  <th rowspan="2"><!-- 삭제 --><%=g.getMessage("LABEL.D.D12.0016")%></th>
                  <th rowspan="2"><!-- 사원번호 --><%=g.getMessage("LABEL.D.D12.0017")%></th>
                  <th rowspan="2" nowrap><!-- 성명 --><%=g.getMessage("LABEL.D.D12.0018")%></th>
                  <th rowspan="2"><!-- 유형선택 --><%=g.getMessage("LABEL.D.D12.0019")%></th>
                  <th rowspan="2"><!-- 시작시간 --><%=g.getMessage("LABEL.D.D12.0020")%></th>
                  <th rowspan="2"><!-- 종료시간 --><%=g.getMessage("LABEL.D.D12.0021")%></th>
                  <th colspan="2"><!-- 휴게시간 --><%=g.getMessage("LABEL.D.D12.0022")%></th>
                  <th class="lastCol" rowspan="2"><!-- 사유 --><%=g.getMessage("LABEL.D.D12.0024")%></th>
                </tr>
                <tr>
                  <th><%=g.getMessage("LABEL.D.D12.0020")%></th>
                  <th><%=g.getMessage("LABEL.D.D12.0021")%></th>
                </tr>
                               </thead>

<!-- 아래, 위 프레임의 사이즈를 고정시킨다 -->
<%
    String Disable = "";
    D12AwartCodeRFC rfc_List         = new D12AwartCodeRFC();
    Vector D12AwartCode_vt = null;
    D12AwartCode_vt = rfc_List.getAwartCode();

    String DATUM     = DataUtil.getCurrentDate();
    for( int i = 0 ; i < main_vt.size() ; i++ ) {
        D12RotationData data = (D12RotationData)main_vt.get(i);

        String tr_class = "";

        if(i%2 == 0){
            tr_class="oddRow";
        }else{
            tr_class="";
        }


        //※CSRID: Q20130422_76414 경조휴가:0130 ,  자녀출산(무급) 9002  => 0370
        if( data.SUBTY.equals("0370") ) { //자녀출산(무급) 9002:0370 =>  경조휴가:0130
             data.SUBTY ="0130";
        }
        if( data.SUBTY.equals("0110")|| data.SUBTY.equals("0130") || data.SUBTY.equals("0140") ||
            data.SUBTY.equals("0150")|| data.SUBTY.equals("0170") || data.SUBTY.equals("0200") || data.SUBTY.equals("0340") ) {
            Disable ="disabled";
        }
        else{
            Disable ="";
        }
       data.BEGUZ =WebUtil.nvl(data.BEGUZ,"00:00");
       data.ENDUZ =WebUtil.nvl(data.ENDUZ,"00:00");
        //CSR ID:1546748
        Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode, data.PERNR, data.SUBTY,DATUM);
        String OVTM_NAME= "";
        for( int j = 0 ; j < D03VocationAReason_vt.size() ; j++ ){
            D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(j);

            if (data.OVTM_CODE.equals(old_data.SCODE)){
               OVTM_NAME =old_data.STEXT+":" ;
            }

        }

%>
                    <tr class="<%=tr_class%>">


                      <td>
                      <input type="hidden" name="use_flag<%=i%>"  value="Y" ><!--@v1.4-->
                      <input type="radio" name="radiobutton" value="<%=i%>"  <%= data.ADDYN.equals("N") ?  "disabled" : "" %>></td>
                      <td><%= data.PERNR %></td>
                      <td><%= data.ENAME %></td>
                      <td>

<%
 for( int j = 0 ; j < D12AwartCode_vt.size() ; j++ ) {
     D12AwartData data1 = (D12AwartData)D12AwartCode_vt.get(j);
     if(data.SUBTY.equals(data1.SUBTY)){
%>
     <%=data1.ATEXT%>
<%

     }
 }
%>
                      </td>
                       <td><%= data.BEGUZ.substring(0,5).equals("00:00")||data.BEGUZ.equals("")  ? "" :  data.BEGUZ.substring(0,2)+"시"+ data.BEGUZ.substring(3,5)+"분" %></td>
                      <td><%= data.ENDUZ.substring(0,5).equals("00:00")||data.ENDUZ.equals("") ? "" :  data.ENDUZ.substring(0,2)+"시"+ data.ENDUZ.substring(3,5)+"분" %></td>
                      <td><%= data.PBEG1.substring(0,5).equals("00:00") ? "" :  data.PBEG1.substring(0,2)+"시"+ data.PBEG1.substring(3,5)+"분" %></td>
                      <td><%= data.PEND1.substring(0,5).equals("00:00") ? "" :  data.PEND1.substring(0,2)+"시"+ data.PEND1.substring(3,5)+"분" %></td>

                      <td  class="lastCol">
                        <table border="0" width=100% height=100% cellspacing="0" cellpadding="0" topmargin=0>
                          <tr>

                             <td nowrap class="lastCol" ><%=OVTM_NAME%><%=data.REASON%></td>
                             <td id="Congjo2_<%= i %>" style="display:<%=data.SUBTY.equals("0130")? "block":"none"%>" class="lastCol">
                             </td>
                             <td  id="Congjo1_<%= i %>" class="font01" valign=middle height=20 width=113 style="display:<%=data.SUBTY.equals("0130")? "block":"none"%>" class="lastCol">

                             </td>

                          </tr>
                        </table>
                      </td>
                    </tr>

<%
    }

%>
			</table>
		</div>
	</div>

<!-----ADD ROW ---------------------------------->
<!---- ADD ROW ---------------------------------->

      <!-- 상단 입력 테이블 끝-->


</div>
</div>
<!-- HIDDEN  처리해야할 부분 시작 -->
      <input type="hidden" name="jobid"    value="">
      <input type="hidden" name="rowCount" value="<%= rowCount %>">
  <input type="hidden" name="main_count" value="<%= main_vt.size() %>">
<!-- HIDDEN  처리해야할 부분 끝   -->
</form>
<iframe name="ifHidden" width="0" height="0" />
<!-------hidden------------>
<jsp:include page="/include/body-footer.jsp" />
<jsp:include page="/include/footer.jsp" />