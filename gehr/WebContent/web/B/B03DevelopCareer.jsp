<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.sns.jdf.util.*" %>
<%
    String perno        = ( String ) request.getAttribute("perno");
    String begda        = ( String ) request.getAttribute("m_begda");
    String seqnr        = ( String ) request.getAttribute("seqnr");

    WebUserData user = WebUtil.getSessionUser(request);
    int develop_count = 10;
%>

<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ess5.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function goSave(){

  if( confirm( "입력된 육성책은 대상자에게\n 메일로 통보됩니다.") ){

    document.form1.jobid.value = "develop_creat";
    document.form1.perno.value = '<%= perno %>';
    document.form1.begda.value = '<%= begda %>';
    document.form1.seqnr.value = '<%= seqnr %>';
    document.form1.action = "<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV";
    document.form1.method = "post";
    document.form1.submit();
  }
}

function goDelete() {
   for (var i=0 ; i < 1 ;i++) //document.form1.p_check.length
   {
            if ( document.form1.checkbox[i].checked )
            {
                eval("document.form1.DEVP_TYPE"+i+".selectedIndex = 0;");
                eval("document.form1.DEVP_YEAR"+i+".value = '';");
                eval("document.form1.DEVP_MNTH"+i+".selectedIndex = 0; ");
                eval("document.form1.DEVP_TEXT"+i+".value = ''; ");
                eval("document.form1.DEVP_STAT"+i+".selectedIndex = 0; ");
                eval("document.form1.RMRK_TEXT"+i+".value = ''; ");
                eval("document.form1.checkbox["+i+"].checked = false; ");
             }

    }
}
function moklok(){

  document.form2.jobid.value = "first";
  document.form2.empNo.value = '<%= perno %>';
  document.form2.action = "<%= WebUtil.ServletURL %>hris.B.B03DevelopList2SV";
  document.form2.method = "post";
  document.form2.submit();

}
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('<%= WebUtil.ImageURL %>icon_Darrow_next_o.gif','<%= WebUtil.ImageURL %>icon_arrow_next_o.gif','<%= WebUtil.ImageURL %>icon_Darrow_prev_o.gif','<%= WebUtil.ImageURL %>icon_arrow_prev_o.gif')">
<form name="form1" method="post" action="">

<div class="subWrapper">

    <div class="title"><h1>인재개발 협의결과 - 경력/교육개발</h1></div>

    <!--리스트 테이블 시작-->
    <div class="listArea">
        <div class="table">
            <table width="790" border="0" cellspacing="1" cellpadding="3" class="table02">
                <tr>
                    <th>선택</th>
                    <th>구분</th>
                    <th>년도</th>
                    <th>시기</th>
                    <th>직무/교육명</th>
                    <th>상태</th>
                    <th class="lastCol">비고</th>
                </tr>
<%      for(int i = 0 ; i <  10  ; i++) {

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
                        <option value="01">경력</option>
                        <option value="02">교육</option>
                      </select>
                    </td>
                    <td><input type="text" name="DEVP_YEAR<%= i %>" size="5"></td>
                    <td>
                      <select name="DEVP_MNTH<%= i %>" onChange="">
                        <option value="">-선택-</option>
                        <option value="01">상반기</option>
                        <option value="02">하반기</option>
                        <option value="03">1/4분기</option>
                        <option value="04">2/4분기</option>
                        <option value="05">3/4분기</option>
                        <option value="06">4/4분기</option>
                      </select>
                    </td>
                    <td><input type="text" name="DEVP_TEXT<%= i %>" size="27"></td>
                    <td>
                      <select name="DEVP_STAT<%= i %>" onChange="">
                        <option value="">-선택-</option>
                        <option value="01">계획</option>
                        <option value="02">현재</option>
                        <option value="03">완료</option>
                      </select>
                    </td>
                    <td class="lastCol">
                      <input type="text" name="RMRK_TEXT<%= i %>" size="27">
                    </td>
                </tr>
<%      }       %>
            </table>
        </div>
    </div>
    <!--리스트 테이블 끝-->

    <div class="buttonArea">
        <ul class="btn_crud">
            <li><a href="javascript:moklok();"><span>목록</span></a></li>
            <li><a class="darken" href="javascript:goSave();"><span>저장</span></a></li>
            <li><a href="javascript:goDelete();"><span>삭제</span></a></li>
        </ul>
    </div>

  </div>
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="perno" value="">
    <input type="hidden" name="begda" value="">
    <input type="hidden" name="seqnr" value="">
</form>
<form name="form2">
    <input type="hidden" name="jobid" value="">
    <input type="hidden" name="begDa" value="">
    <input type="hidden" name="empNo" value="">
</form>

<%@ include file="/web/common/commonEnd.jsp" %>
