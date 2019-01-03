
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page errorPage="/err/error.jsp"%>

<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.G.G001Approval.*"%>
<%@ page import="hris.common.rfc.*"%>

<%
    WebUserData      user    = (WebUserData)session.getAttribute("user");

    Vector vcApprovalDocList = (Vector) request.getAttribute("vcApprovalDocList");
    ApprovalListKey alk = (ApprovalListKey) request.getAttribute("ApprovalListKey");

    Vector vcUpmucode = ( new UpmuCodeRFC() ).getUpmuCode(user.companyCode);

    String paging             = (String)request.getAttribute("page");

    //PageUtil 관련 - Page 사용시 반드시 써줄것.
    PageUtil pu = null;
    try {
        pu = new PageUtil(vcApprovalDocList.size(), paging , 10, 10);
      Logger.debug.println(this, "page : "+paging);
    } catch (Exception ex) {
        Logger.debug.println(DataUtil.getStackTrace(ex));
    }
%>
<html>
<head>
<title>ESS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr2.css" type="text/css">
<!-- <script language="javascript" src="<%= WebUtil.ImageURL %>css/ess.js"></script> -->
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr_wsg.css" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	function opinion() {
		var frm = document.form1;

	    small_window=window.open("","Contact","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,scrollbars=no,width=600,height=410,left=100,top=100");
	    small_window.focus();
	    frm.target = "Contact";
	    frm.action = "/web/"+"common/opinion.jsp";
	    frm.submit();

	}

	function popupOpen(){
		var popUrl = "/web/"+"common/opinion.jsp";	//팝업창에 출력될 페이지 URL
		var popOption = "width=600, height=400, resizable=no, scrollbars=no, status=no; toolbar=no";    //팝업창 옵션(optoin)
			window.open(popUrl,"",popOption);
		}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form name="form1" method="post" action="">
<input type="hidden" name="RequestPageName" >
<input TYPE="hidden" name="jobid" value="">
<input TYPE="hidden" name="GUBUN" value="<%=alk.GUBUN%>">
  <table width="796" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="780" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td width="780" class="title02">전자결재 표준화면</td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
          	<td height="30">
          		<h2 class="subtitle withButtons">제목표시</h2>
          		<ul class="btn_crud">
          			<li><a class="darken" href="javascript:opinion();"><span>승인</span></a></li>
          			<li><a href="popupOpen();"><span>반려</span></a></li>
          			<li><a href=""><span>인쇄</span></a></li>
          			<li><a href=""><span>전달</span></a></li>
          			<li><a href=""><span>목록</span></a></li>
          		</ul>
          	</td>
          </tr>
          <tr>
            <td>
              <!--  입출력 테이블 시작 -->
              <table width="780" border="0" cellpadding="0" cellspacing="0" class="table03">
              	<colgroup>
              		<col witdh="100">
              		<col>
              		<col witdh="100">
              		<col>
              	</colgroup>
              	<tr>
                  <td class="td03">업무항목</td>
                  <td class="td09" colspan="3">업무항목</td>
              	</tr>
                <tr>
                  <td class="td03 td_first">작성일</td>
                  <td class="td09">YYYY-MM-DD HH:MM</td>
                  <td class="td03">보존년한</td>
                  <td class="td09">영구</td>
                </tr>
                <tr>
                  <td class="td03 td_first">문서종류</td>
                  <td class="td09">일반문서</td>
                  <td class="td03">문서구분</td>
                  <td class="td09">품의</td>
                </tr>
              	<tr>
                  <td class="td03 td_first">협의종류</td>
                  <td class="td09" colspan="3">순차</td>
              	</tr>
              	<tr>
                  <td class="td03 td_first">제목</td>
                  <td class="td09" colspan="3">제목이 들어갑니다.</td>
              	</tr>
              	<tr>
              		<td class="td09 td_first" colspan="4">
              			<textarea rows="20" cols="40"></textarea>
              		</td>
              	</tr>
              	<tr>
                  <td class="td03 td_first">파일첨부</td>
                  <td class="td09" colspan="3">
              			<div class="attachFuncLeft">
              				<textarea rows="4" cols="40"></textarea>
              			</div>
              			<div class="attachFuncRight">
              				<ul class="fileAddDel btn_mdl">
              					<li>
              						<a href=""><span>파일추가</span></a>
              					</li>
              					<li>
              						<a href=""><span>파일삭제</span></a>
              					</li>
              				</ul>
              			</div>
                  </td>
              	</tr>
              </table>
              <!--  검색테이블 끝-->
            </td>
          </tr>
          <tr>
          	<td height="30"></td>
          </tr>
          <!-- 테이블 타이틀 시작-->
          <tr>
          	<td>
          		<h2 class="subtitle ie8fix">승인자정보</h2>
          	</td>
          </tr>
          <!-- 테이블 타이틀 끝-->
          <tr>
            <td>
              <!-- 리스트테이블 시작 -->
              <table width="780" border="0" cellpadding="0" cellspacing="0" class="table03">
                <tr class="head">
                  <td class="td03 td_first">구분</td>
                  <td class="td03">성명</td>
                  <td class="td03">직급</td>
                  <td class="td03">부서</td>
                  <td class="td03">결재시간</td>
                  <td class="td03">결재결과</td>
                  <td class="td03">결재의견</td>
                </tr>
                <tr class="oddrow">
                  <td class="td04 td_first">심의</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                </tr>
                <tr>
                  <td class="td04 td_first">확정</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                </tr>
              </table>
              <!-- 리스트테이블 끝-->
            </td>
          </tr>
          <tr>
          	<td height="30"></td>
          </tr>
          <!-- 테이블 타이틀 시작-->
          <tr>
          	<td>
          		<h2 class="subtitle ie8fix">통보자정보</h2>
          	</td>
          </tr>
          <!-- 테이블 타이틀 끝-->
          <tr>
            <td>
              <!-- 리스트테이블 시작 -->
              <table width="780" border="0" cellpadding="0" cellspacing="0" class="table03">
                <tr class="head">
                  <td class="td03 td_first">No.</td>
                  <td class="td03">성명</td>
                  <td class="td03">직급</td>
                  <td class="td03">부서</td>
                </tr>
                <tr class="oddrow">
                  <td class="td04 td_first">1</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                </tr>
                <tr>
                  <td class="td04 td_first">2</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                  <td class="td04">&nbsp;</td>
                </tr>
              </table>
              <!-- 리스트테이블 끝-->
            </td>
          </tr>
          <tr>
            <td>
			<!-- 이동아이콘 테이블 시작 -->
			<table width="780" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="td04" style="padding-top:10px"><input type="hidden" name="page" value="">
					<%= pu == null ? "" : pu.pageControl() %>
                  </td>
                </tr>
              </table>
			  <!-- 이동아이콘 테이블 끝 -->
			</td>
          </tr>
          <tr>
            <td height="10">&nbsp;</td>
          </tr>
          <tr>
          	<td height="30">
          		<ul class="btn_crud">
          			<li><a class="darken" href=""><span>승인</span></a></li>
          			<li><a href=""><span>반려</span></a></li>
          			<li><a href=""><span>인쇄</span></a></li>
          			<li><a href=""><span>전달</span></a></li>
          			<li><a href=""><span>목록</span></a></li>
          		</ul>
			</td>
          </tr>
          <tr height="10"><td></td></tr>
        </table></td>
    </tr>
  </table>
  </form>
  <form name="form2" method="post">
    <input type="hidden" name="AINF_SEQN" >
    <input type="hidden" name="isEditAble" value="false">
    <input type="hidden" name="RequestPageName" >
    <input type="hidden" name="jobid">
  </form>
</body>
</html>
<%!

    private String isCanBlock(ApprovalDocList apl)
    {
        String retValue = "disabled";

        //17:초과근무,18:휴가, 23:식권영업사원
        if (apl.UPMU_TYPE.equals("17") || apl.UPMU_TYPE.equals("18") || apl.UPMU_TYPE.equals("23")) {
            retValue = "";
        } else if (   apl.APPU_TYPE.equals("02") && apl.APPR_SEQN.equals("02")) {
        //} else if ( !apl.UPMU_TYPE.equals("03")  && apl.APPU_TYPE.equals("02") && apl.APPR_SEQN.equals("02")) { //03:의료비는 팀장결재시한도금액체크하므로 일괄결재 막음
            retValue = "";
        } // end if
        return retValue;
    }
%>
