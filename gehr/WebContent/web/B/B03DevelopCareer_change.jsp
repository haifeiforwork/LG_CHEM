<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발협의결과입력                                        */
/*   Program Name : 인재개발 협의결과 - 경력/교육개발                           */
/*   Program ID   : B03DevelogCareer_change.jsp                                 */
/*   Description  : 인재개발 협의결과 - 경력/교육개발 입력                      */
/*   Note         : 없음                                                        */
/*   Creation     : 최영호                                                      */
/*   Update       : 2005-01-26  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.B.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);

    Vector B03DevelopDetail2_vt = (Vector)request.getAttribute("B03DevelopDetail2_vt");

    String begDa      = (String)request.getAttribute("begDa");
    String empNo      = (String)request.getAttribute("empNo");
    String seqnr      = (String)request.getAttribute("seqnr");
    String item_index = (String)request.getAttribute("item_index");

    String ORGTX     = (String)request.getAttribute("ORGTX");
    String TITEL     = (String)request.getAttribute("TITEL");
    String TITL2     = (String)request.getAttribute("TITL2");
    String ENAME     = (String)request.getAttribute("ENAME");
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function goList(){
    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "first";
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.begDa.value = '<%= begDa %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.submit();
}

function goSave(){

    if( confirm( "입력된 육성책은 대상자에게\n 메일로 통보됩니다.") ){
        document.form1.jobid.value = "career_save";
        document.form1.perno.value = '<%= empNo %>';
        document.form1.begda.value = '<%= begDa %>';
        document.form1.seqnr.value = '<%= seqnr %>';
        document.form1.item_index.value = '<%= item_index %>';
        document.form1.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
        document.form1.method = 'get' ;
        document.form1.submit();
    }
}

function plus(){
    document.form2.ORGTX.value = document.form1.ORGTX.value;
    document.form2.TITEL.value = document.form1.TITEL.value;
    document.form2.TITL2.value = document.form1.TITL2.value;
    document.form2.ENAME.value = document.form1.ENAME.value;

    document.form2.jobid.value = "plus_career";
    document.form2.begDa.value = '<%= begDa %>';
    document.form2.empNo.value = '<%= empNo %>';
    document.form2.seqnr.value = '<%= seqnr %>';
    document.form2.action = '<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV' ;
    document.form2.method = 'get' ;
    document.form2.submit() ;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 - 경력/교육개발</h1></div>

    <div class="tableInquiry">
        <table>
            <tr>
                <th>선택구분</th>
                <td>
                    <select name="I_GUBUN" onChange="javascript:gubun_change()">
                        <option value="2" >성명별</option>
                        <option value="1" >사번별</option>
                    </select>
                    <input type="text"   name="I_VALUE1" size="10"  maxlength="10" value=""  onKeyDown = "javascript:EnterCheck();" onFocus="javascript:this.select();" style="ime-mode:active" >
                    <input type="hidden" name="jobid" value="">
                    <input type="hidden" name="empNo" value="">
                    <input type="hidden" name="I_DEPT"    value="">
                    <input type="hidden" name="E_RETIR"   value="">
                    <input type="hidden" name="retir_chk" value="">
                    <input type="hidden" name="page"      value="">
                    <input type="hidden" name="count"     value="">
                    <div class="tableBtnSearch tableBtnSearch2">
                        <a class="search" href="javascript:opensawon();"><span>사원찾기</span></a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="tableArea">
        <div class="table">
            <table class="tableGeneral perInfo">
                <tr>
                    <th>부서</th>
                    <td><input size="30" style="border-width:0;text-align:left" type="text" name="ORGTX" value="<%= ORGTX %>" readonly></td>
                    <th class="th02">직위</th>
                    <td><input size="20" style="border-width:0;text-align:left" type="text" name="TITEL" value="<%= TITEL %>" readonly></td>
                    <th class="th02">직책</th>
                    <td><input size="20" style="border-width:0;text-align:left" type="text" name="TITL2" value="<%= TITL2 %>" readonly></td>
                    <th class="th02">성명</th>
                    <td>
                        <input size="8" style="border-width:0;text-align:left" type="text" name="ENAME" value="<%= ENAME %>" readonly>
                        <input size="9" style="border-width:0;text-align:left" type="text" name="EMPNO2" value="<%= !empNo.equals("") ? "(" : "" %><%= empNo %><%= !empNo.equals("") ? ")" : "" %>" readonly>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!--리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table class="listTable">
                <tr>
                    <th>선택</th>
                    <th>구분</th>
                    <th>년도</th>
                    <th>시기</th>
                    <th>직무/교육명</th>
                    <th>상태</th>
                    <th class="lastCol">비고</th>
                </tr>
<%
      if( B03DevelopDetail2_vt.size() > 0 ) {
         for(int i = 0 ; i <  B03DevelopDetail2_vt.size()  ; i++) {
            B03DevelopData2 developDetailData = (B03DevelopData2)B03DevelopDetail2_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
                <tr class="<%=tr_class%>">
                    <td><input type="checkbox" name="checkbox" value=<%= i %>></td>
                    <td>
                        <select name="DEVP_TYPE<%= i %>" onChange="">
                            <option value="">-선택-</option>
                            <option value="01"<%= developDetailData.DEVP_TYPE.equals("01") ? "selected" : "" %>>경력</option>
                            <option value="02"<%= developDetailData.DEVP_TYPE.equals("02") ? "selected" : "" %>>교육</option>
                        </select>
                    </td>
                    <td>
                        <input type="text" name="DEVP_YEAR<%= i %>" value='<%= developDetailData.DEVP_YEAR %>' size="5">
                    </td>
                    <td>
                        <select name="DEVP_MNTH<%= i %>" onChange="">
                            <option value="">-선택-</option>
                            <option value="01"<%= developDetailData.DEVP_MNTH.equals("01") ? "selected" : ""%>>상반기</option>
                            <option value="02"<%= developDetailData.DEVP_MNTH.equals("02") ? "selected" : ""%>>하반기</option>
                            <option value="03"<%= developDetailData.DEVP_MNTH.equals("03") ? "selected" : ""%>>1/4분기</option>
                            <option value="04"<%= developDetailData.DEVP_MNTH.equals("04") ? "selected" : ""%>>2/4분기</option>
                            <option value="05"<%= developDetailData.DEVP_MNTH.equals("05") ? "selected" : ""%>>3/4분기</option>
                            <option value="06"<%= developDetailData.DEVP_MNTH.equals("06") ? "selected" : ""%>>4/4분기</option>
                        </select>
                    </td>
                    <td><input type="text" name="DEVP_TEXT<%= i %>" value='<%= developDetailData.DEVP_TEXT %>' size="27"></td>
                    <td>
                        <select name="DEVP_STAT<%= i %>" onChange="">
                            <option value="">-선택-</option>
                            <option value="01"<%= developDetailData.DEVP_STAT.equals("01") ? "selected" : ""%>>계획</option>
                            <option value="02"<%= developDetailData.DEVP_STAT.equals("02") ? "selected" : ""%>>현재</option>
                            <option value="03"<%= developDetailData.DEVP_STAT.equals("03") ? "selected" : ""%>>완료</option>
                        </select>
                    </td>
                    <td class="lastCol">
                        <input type="text" name="RMRK_TEXT<%= i %>" value='<%= developDetailData.RMRK_TEXT %>' size="27">
                    </td>
                </tr>
<%
        }
    }else{
%>
                <tr class="oddRow">
                    <td class="lastCol" colspan="7">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
    }
%>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:goList();"><span>목록</span></a></li>
            <li><a href="javascript:history.back();"><span>이전화면</span></a></li>
            <li><a href="javascript:goSave();"><span>저장</span></a></li>
            <li><a href="javascript:plus();"><span>추가</span></a></li>
        </ul>
    </div>

  </div>
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="perno" value="">
  <input type="hidden" name="begda" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="item_index" value="">
</form>
<form name="form2">
  <input type="hidden" name="jobid" value="">
  <input type="hidden" name="begDa" value="">
  <input type="hidden" name="empNo" value="">
  <input type="hidden" name="seqnr" value="">
  <input type="hidden" name="ORGTX" value="">
  <input type="hidden" name="TITEL" value="">
  <input type="hidden" name="TITL2" value="">
  <input type="hidden" name="ENAME" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>
