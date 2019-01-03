<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 교육이력                                                    */
/*   Program Name : 교육이력                                                    */
/*   Program ID   : C04HrdLearnDetail_m.jsp                                     */
/*   Description  : 교육 이력 조회                                              */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-07  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %> 
<%@ include file="/web/common/commonProcess.jsp" %> 

<%@ page import="java.util.Vector" %> 
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.C.*" %>
       
<%@ page import="hris.A.A12Family.rfc.*" %>
<%@ page import="com.sns.jdf.util.*" %>     
<%    
    String pernr       = (String)request.getParameter("pernr"); 
    String IM_SORTKEY = (String)request.getParameter("IM_SORTKEY"); 
    String IM_SORTDIR = (String)request.getParameter("IM_SORTDIR"); 

    Vector C04HrdLearnDetailData_vt = ( Vector ) request.getAttribute( "C04HrdLearnDetailData_vt" ) ;

 
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=GlobalDetailList.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */        
%>
 
<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">      
  
  <table width="791" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td><table width="740" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td><table width="740" border="0" cellpadding="0" cellspacing="0">
                <tr> 
                  <td height="5" colspan="2"></td>
                </tr>
                <tr> 
                  <td width="624" class="title02">교육이력</td>
                </tr>
              </table></td>
          </tr>
<%
// 사원 검색한 사람이 없을때
if ( pernr != null ) {
%>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td> 
              <!--교육이수현황 리스트 테이블 시작-->
              <table width="740" border="0" cellspacing="0" cellpadding="0">
                <tr> 

                  <td class="td02" align="right"><font color="#006699">※ Y : 이수, M : 미이수&nbsp;</font></td>
                </tr>
              </table></td>
          </tr>   
          <tr> 
            <td> 
              <!--교육이수현황 리스트 테이블 시작-->
              <table width="740" border="0" cellspacing="1" cellpadding="4" class="table02">
                <tr> 
                  <td class="td03" width="140">과정명</td>
                  <td class="td03" width="100">차수명</td>
                  <td class="td03" width="150">교육기간</td>
                  <td class="td03" width="100">주관부서</td>
                  <td class="td03" width="30">이수</td>
                  <td class="td03" width="30">평가</td>
                  <td class="td03" width="70">필수과정</td>
                  <td class="td03" width="70">교육형태</td>
                </tr>
<%
    if( C04HrdLearnDetailData_vt.size() > 0 ) {
        for ( int i = 0 ; i < C04HrdLearnDetailData_vt.size() ; i++ ) {
            C03LearnDetailData learnDetailData = ( C03LearnDetailData ) C04HrdLearnDetailData_vt.get( i ) ;
            if(!learnDetailData.FLAG1.equals("")) {
%>
                <tr> 
                  <td class="td04" style="text-align:left"><%= learnDetailData.STEXT_D %></td>
                  <td class="td04" style="text-align:left"><%= learnDetailData.STEXT_E %></td>
                  <td class="td04"><%= learnDetailData.PERIOD    %></td>
                  <td class="td04" style="text-align:left"><%= learnDetailData.MC_STEXT  %></td>
                  <td class="td04"><%= learnDetailData.FLAG1     %></td>
                  <td class="td04"><%= learnDetailData.PYONGGA   %></td>
                  <!--<td class="td04"><%= learnDetailData.FLAG2.equals("N") ? "" : learnDetailData.FLAG2 %></td>-->
                  <td class="td04"><%= learnDetailData.STEXT_N %></td>
                  <td class="td04"><%= learnDetailData.CODE_NAME %></td>
                </tr>
                <%
            }
        }
    } else {
%>
                <tr align="center"> 
                  <td class="td04" colspan="7">해당하는 데이터가 존재하지 않습니다.</td>
                </tr>
<%
    }
%>
 
              </table>
              <!--교육이수현황 리스트 테이블 끝-->
            </td>
          </tr>
          <tr> 
            <td height="10">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
<%
}
%>  
</form>
</body>
</html>

