<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 집행임원 서약서  (임원용)                                          */
/*   Program Name : 집행임원 서약서   (임원용)                                         */
/*   Program ID   : A21ExecutivesPledge.jsp                                         */
/*   Description  : 집행임원 서약서                                              */
/*   Note         :                                                             */
/*   Creation     : 2017-04-06    eunha [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건          */
/*   Update       : 2018-03-27 rdcamel [CSR ID:3633546] 임원 연봉계약/집행임원서약서 온라인 날인을 위한 시스템 지원 요청                     */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.A.A10Annual.A10AnnualData" %>
<%@ page import="hris.A.A10Annual.rfc.A10AnnualOathAgreementRFC" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%

    WebUserData user = WebUtil.getSessionUser(request);
	WebUserData user_m = WebUtil.getSessionMSSUser(request);

    String imgURL      = (String)request.getAttribute("imgURL");
    String ZYEAR       = (String)request.getAttribute("ZYEAR");
	String type = (String)request.getParameter("type");

    String ename = user.ename;
    String regno = user.e_regno;
    String companyCode = user.companyCode;
    String empNo = user.empNo;
    String adminUser =user.empNo;

    if(type!=null  && type.equals("M")){
    	ename = user_m.ename;
    	regno = user_m.e_regno;
    	companyCode = user_m.companyCode;
    	empNo = user_m.empNo;
    }

    if(regno.equals("6807235200026")){//[CSR ID:3633546] 미국국적 대상자 소스 수정 필요
    	regno = "6807231200026";
    }
    String birthday = DataUtil.getBirthday(regno);

    Vector A10AnnualData_vt  = (Vector)request.getAttribute("A10AnnualData_vt");
    boolean aFlag = true;
    String curYear = DataUtil.getCurrentYear();
    A10AnnualData data = (A10AnnualData)request.getAttribute("a10AnnualData");
    if( A10AnnualData_vt != null || A10AnnualData_vt.size() > 0 ) {
        for( int i = 0 ; i < A10AnnualData_vt.size(); i++ ) {
            A10AnnualData adata = (A10AnnualData)A10AnnualData_vt.get(i);
            if ( adata.ZYEAR.equals( curYear ) ) {
                break;
            } else if ( adata.ZYEAR.equals(ZYEAR) ) {
                data = adata;
                break;
            }
        }
    }

    if (NumberUtils.toInt(data.ZYEAR) < 2000) {
        aFlag = false;
    }

    //@v1.3 합의여부조회
    Vector              ret            = new Vector();

    ret = ( new A10AnnualOathAgreementRFC() ).getAnnualAgreeYn( empNo ,"1",data.ZYEAR ,companyCode );

    String AGRE_FLAG = (String)ret.get(0);
    String E_BETRG = (String)ret.get(1);

    String msg     = (String)request.getAttribute("msg"); //@v1.3 합의여부
    List<String> exceptEmpnoList = Arrays.asList(
    		"00224147"
    		,"00224148"
    		,"00080805"
    		,"00224152"
    		,"00009633"
    		,"00009721"
    		,"00025955"
    		,"00043614"
    		,"00054027"
    		,"00071216"
    		,"00218589"
    		,"00220269"
    		,"00224149"
    		,"00224153"
    		,"00224154"
    		,"00224160"
    		,"00224438"
    		,"00048317"
    		,"00221414"
    		,"00044527"
    );

%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=5">
<title>ESS</title>
<link rel="stylesheet" href="/web/A/A20AnnualBoard/C100/2017/ess.css" type="text/css">

    <script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
    <script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery.blockUI.js"></script>
    <script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>
<SCRIPT LANGUAGE="JavaScript">

    $.unblockUI();

    function f_print(){
        self.print();
    }

    function firstHideshow() {
        if("<%=data.TITL3%>" == "CEO"){
            $("#ceoForm").show();
        }else{
            $("#exeForm").show();
        }
     }

</SCRIPT>
</head>
<%
 if (exceptEmpnoList.contains(empNo)) {//하드코딩 해당 인원 오픈 제외   %>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center">
                           <font color="red">※ 임원 연봉계약을 오프라인상으로 체결하셨으므로 대상이 아니십니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                    </table>

<%}else{ //@v1.1  %>

<body  onLoad="javascript:firstHideshow(); if ('<%=msg%>' != '' &&  '<%=msg%>' != 'null' ) alert('<%=msg%>');" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->


<table width="624" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td>
      <table width="624" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td   height="80">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center">
      <table width="450" border="0" cellspacing="2" cellpadding="0">
        <tr>
          <td align="center"><font face="바탕, 바탕체" size="6"><b>집행임원 서약서</b></font></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="style01">주식회사 LG화학 대표이사 귀중
           </td>
        <tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="style01">본인은 ㈜LG화학의 집행임원으로서 LG Way의 실현을 위해 헌신할 것을 다짐하며, 다음과 같이 서약합니다.</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="td04">--- 다     음 ---</td>
        </tr>

        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="550" border="0" cellspacing="0" cellpadding="2" align="center">
                <colgroup>
                    <col width="20">
                    <col width="">
                </colgroup>
              <tr  >
                <td colspan="2" class="style01"><u>제 1 조 기본의무 </u></td>
              </tr>
              <tr>
                <td class="style01" valign=top>①</td>
                <td class="style01">	본인은 ㈜LG화학의 집행임원으로서의 긍지와 품위를 유지하고, 신의에 따라 성실하게 직무를 수행하며, 법률, 정관 및 제반 사규를 준수한다.</td>
              </tr>
              <tr>
                <td class="style01" valign=top>②</td>
                <td class="style01">본인은 성과주의에 입각하여 공정하고 합리적인 기준에 따라 직무를 수행하고 담당 조직을 관리하며, 장기적인 관점에 따라 인재를 육성한다.<br>&nbsp;</td>
              </tr>

              <tr >
                <td colspan="2" class="style01"><u>제 2 조 신분 </u></td>
              </tr>
              <tr  id="exeForm" style="display:none">
                <td colspan="2" class="style01">본인은 집행임원으로서 근로기준법상 근로자에 해당하지 아니함을 확인하며, 집행임원으로서의 신분에 관한 제반 사항은 정관, 이사회 및 집행임원 인사관리 규정에서 정한 바에 따른다.<br>&nbsp;
				</td>
			  </tr>
			  <tr id="ceoForm" style="display:none">
                <td colspan="2" class="style01">본인은 집행임원으로서의 신분에 관한 제반 사항은 정관, 이사회 및 집행임원 인사관리 규정에서 정한 바에 따른다.<br>&nbsp;
			  </td>
              </tr>
				<tr>
                <td colspan="2" class="style01"><u>제 3 조 보수 및 제반 처우 </u></td>
              </tr>
              <tr>
                <td class="style01"  valign=top>①</td>
                <td class="style01">본인의 고정연봉은 회사와의 연봉 계약을 통해 결정하고, 기타 보수 및 제반 처우에 관한 사항은 정관, 이사회 및 집행임원 인사관리 규정에서 정한 바에 따른다.
				</td>
              </tr>
              <tr>
                <td class="style01" valign=top>②</td>
                <td class="style01">본인은 연봉 계약 내용, 기타 집행임원으로서의 보수에 관한 일체의 사항에    대하여 사내외 제3자에게 누설하지 아니하며, 이를 위반할 경우 집행임원 인사관리 규정상 징계 절차에 따른 해임의 조치를 감수한다.<br>&nbsp;
                </td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 4 조 정도경영 및 윤리 의무 </u></td>
              </tr>
              <tr>
              	<td colspan="2" class="style01">본인은 ㈜LG화학의 집행임원으로서 직무를 수행함에 있어, 주주와 사회에 대한 책임과 의무를 다하기 위하여 아래의 사항을 준수한다.</td>
              </tr>
              <tr>
                <td class="style01" valign=top>1. </td>
                <td class="style01">고객에게는 정직하고, 협력회사와는 공정거래를 통한 상호 발전을 추구하며, 경쟁사와는 정정당당하게 경쟁한다.
				</td>
              </tr>
              <tr>
                <td class="style01" valign=top>2. </td>
                <td class="style01">㈜LG화학의 윤리규범 및 관련 규정(집행임원 인사관리 규정 등)을 준수하고, 본인은 물론 조직 내에 정도경영 문화를 전파, 정착시키기 위한 집행임원으로서의 책임과 의무를 다한다.
                </td>
              </tr>
              <tr>
                <td class="style01" valign=top>3. </td>
                <td class="style01">㈜LG화학의 윤리규범을 위반한 불공정 거래 및 부정ㆍ비리 행위 여부에 대한 정기 및 수시 조사 진행 시, 회사가 요청하는 관련 자료 제출 등을 포함한 모든 협조 의무를 반드시 준수한다.<br>&nbsp;
                </td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 5 조 정보 보호 의무 </u></td>
              </tr>
              <tr  >
                <td colspan="2" class="style01">본인은 재직 중 업무상 지득한 경제적 가치 있는 모든 정보를 재직 중은 물론 퇴직 후에도 공개, 누설 또는 제3자를 위해 사용하지 아니하며, 퇴직 후 1년간 회사의 동종 또는 경쟁 관계에 있는 사업에 고용되거나 그러한 활동에 종사하지 아니한다.<br>&nbsp;
				</td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 6 조 지적 재산권 기타 </u></td>
              </tr>
              <tr>
                <td class="style01" valign=top>①</td>
                <td class="style01">본인의 재직 중 직무와 관련한 모든 발명 및 저작물에 관한 사항 (특허, 실용신안, 의장 등 지적재산권과 아이디어 및 일체의 Know-How, 컴퓨터 프로그램, 설계, 도표, 도안, 도서 등에 대한 저작권 등 포함)은 회사에 귀속되며, 회사가 이에 대한 권리 보호를 위한 출원, 등록, 기타 절차를 취할 경우 적극 협조한다. <br>
                							(이 경우 집행임원은 특허법 기타 관련 법령에서 정하는 정당한 보상을 받을 권리가 있다.)
				</td>
              </tr>
              <tr>
                <td class="style01" valign=top>②</td>
                <td class="style01">본인은 본 서약서 제출 이전에 이룩한 것으로서 본 서약서의 적용을 배제하고자 하는 발명 및 저작물이 있는 경우에는 그 목록을 본 서약서에 첨부하고, 만약 첨부된 목록이 없는 경우 그러한 발명 및 저작물은 없는 것으로 간주한다.
                </td>
              </tr>
              <tr>
                <td class="style01" valign=top>③</td>
                <td class="style01">본인은 퇴직 시에 본인이 보관하고 있는 서류, 도안, 기록, 메모, 디스켓, 테이프, 기타 영업 비밀을 담고 있거나 재산적 가치가 있는 일체의 자료를 회사에 반납한다.<br>&nbsp;

                </td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 7 조 서약서 준수 및 위반시 책임 </u></td>
              </tr>
              <tr  >
                <td colspan="2" class="style01">본인은 본 서약서 내용을 준수하며, 위반 시 집행임원 인사관리 규정에 의한 징계 및 민/형사상 책임을 감수한다.

				</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="481" border="0" cellspacing="0" cellpadding="0">
              <tr>

                <!-- CSR ID : 2506534 => 이미지 변경 -->

                <td align="center" >
                  <table width="350" border="0" cellspacing="5" cellpadding="5" align="right">
                    <tr>
                      <td align="right" width="350" class="style01" colspan="3"><%=ZYEAR %>년 4월 1일</td>
                    </tr>
                    <tr>
                    <td colspan="3" class="style01">&nbsp;서약자</td>
                    </tr>
                    <tr>
                    <td colspan="3" class="style01">&nbsp;생년월일 : <%=StringUtils.substring(birthday, 0,4) %>년 <%=StringUtils.substring(birthday, 4,6) %>월 <%=StringUtils.substring(birthday, 6,8) %>일</td>
                    </tr>
                    <tr>
                      <td align="left" width="200" class="style01">&nbsp;직위 : <%= data.TITEL %></td>
                      <td align="left" width="70" class="style01">&nbsp;<%= ename %></td>
                      <td align="right" rowspan="2" class="style01" width="80">
                     <%       if ( AGRE_FLAG.equals("Y") ) {  %>
                      <img src="<%= WebUtil.ImageURL %>btn_pledgeYes.gif" border="0">
                      <%  }else{  %>
                         (서명)</td>
                      <%} %>
                    </tr>
                        <!-- @< %= data.ORGTX %><br> -->


                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
          <%
              //if ( Integer.parseInt(data.ZYEAR) >= 2008 && !AGRE_FLAG.equals("Y") ) {
              if ( !AGRE_FLAG.equals("Y") ) {
          %>
          <tr>
              <td align="center">
                  <table width="150" border="0" cellspacing="0" cellpadding="0">
                      <tr><td>&nbsp;</td>
                      </tr>
                      <tr>
                          <td align="center">
                              <div class="buttonArea">
                                  <ul class="btn_crud">
                                      <li><a href="javascript:;" onclick="f_agree();" style="font: 12px/1.5em  'Malgun Gothic', 'Simsun',dotum, arial, sans-serif; color: #222;"><span ><spring:message code="BUTTON.COMMON.CONFIRM" /><%--확인--%></span></a></li>
                                  </ul>
                              </div>
                          </td>
                      </tr>
                  </table>
              </td>
          </tr>
          <%
              }
          %>
      </table>
    </td>
  </tr>
</table>



<script language="javascript">

function f_agree() {
    frm =  document.form1;
    frm.jobid.value ="agree";
    frm.target = "beprintedpage";
    frm.I_CONT_TYPE.value = "2"; //저장
    <%if(type!=null && type.equals("M")){%>
    frm.action = "<%= WebUtil.ServletURL %>hris.A.A21ExecutivePledge.A21EPListSV_m";
    <%}else{%>
    frm.action = "<%= WebUtil.ServletURL %>hris.A.A21ExecutivePledge.A21EPListSV";
    <%}%>
    frm.submit();
}

</script>
<form name="form1" method="post">
<input type=hidden name="jobid"     value="">
<input type=hidden name="I_PERNR"     value="<%= empNo %>">
<input type=hidden name="I_CONT_TYPE" value="">
<input type=hidden name="I_YEAR"      value="<%=data.ZYEAR %>">
</form>

</body>
<%}%>
</html>