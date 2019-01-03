<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 나의 연봉 계약서                                            */
/*   Program Name : 나의 연봉 계약서                                            */
/*   Program ID   : A10AnnualDetail.jsp                                         */
/*   Description  : 나의 연봉 조회                                              */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2007-08-28  @v1.0 합의프로세스추가(년도별로 합의한 문서내용 보관:년도별디렉토리를 생성하여 처리)      */
/*                              2008년 이후부터 년도별로 디렉토리 생성후 이전년도 소스를 복사하여 만들어서 수정하여야 함  */
/*                              대상 위치: /ehr/web/A/A10Annual/2008 ~ /A10AnnualDetail.jsp 및 이미지  */
/*                              기준     : 년도 */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.A.A10Annual.rfc.*" %>

<%
	WebUserData user   = (WebUserData)session.getValue("user");
	A10AnnualData data   = (A10AnnualData)request.getAttribute("a10AnnualData");

    String        ename  = user.ename;
    String        imgURL = (String)request.getAttribute("imgURL");
    String        printFlag = "N"; 
    //double        tmpInt = Double.parseDouble( data.BETRG );


    //@v1.3 합의여부조회
    Vector              ret            = new Vector();
    ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( user.empNo ,"1",data.ZYEAR,user.companyCode );
    
    String AGRE_FLAG = (String)ret.get(0); 
    String E_BETRG = (String)ret.get(1); 
    double tmpInt;
    double BETRG;
    
    double tmpSang;
    double tmpMyoung;
    
    if ( AGRE_FLAG.equals("Y") ) {   
         tmpInt = Double.parseDouble( E_BETRG);  //합의된 금액
         BETRG  = Double.parseDouble( E_BETRG);  //합의된 금액 
    }
    else { 
         tmpInt = Double.parseDouble( data.BETRG ); //급여의 기본년봉  
         BETRG  = Double.parseDouble( data.BETRG ); //급여의 기본년봉     
    }
    
    tmpInt = tmpInt/20;
    
    
    
    
    if ( user.e_persk.equals("31") ) {   
         tmpSang = tmpInt;  
         tmpMyoung = tmpInt; 
    }else{
    	   tmpSang = tmpInt/2;
         tmpMyoung = tmpInt;  
    }

    String msg     = (String)request.getAttribute("msg"); //@v1.3 합의여부    
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript"> 

function f_print() {  
  self.print();  
}
</SCRIPT> 
</head>

<body onLoad="javascript:if ('<%=msg%>' != '' &&  '<%=msg%>' != 'null' ) alert('<%=msg%>');" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="660" border="0" cellspacing="2" cellpadding="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="20">&nbsp;</td>
          <td><img src="<%= imgURL %>img_logo_mma.gif"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td align="center">
      <table width="450" border="0" cellspacing="2" cellpadding="0">
        <tr> 
          <td align="center"><font face="돋움, 돋움체" size="6"><b><u>年 俸 契 約 書</u></b></font></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td class="style01">
            <table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr> 
                <td class="style01">LG MMA(주)와 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= data.BEGDA.substring(0,4) %>년 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>월 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>일부터 
                  <%= data.ENDDA.substring(0,4) %>년 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>월 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>일까지  적용되는<br>
                  <%= data.TITEL %> <%= ename %>의 年俸을 다음과 같이 契約한다.</td>
              </tr>
            </table>
          </td>
        </tr>
         <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td align="center"><font face="돋움, 돋움체" size="3">- 다 음 -</font></td>
        </tr>
        <tr> 
          <td> 
            <table width="380" border="1" cellspacing="0" cellpadding="5" align="center" bordercolor="#999999">
              <tr align="center"> 
                <td class="style01" width="110"><%= data.ZYEAR %>年 基本年俸</td>
                <td class="style01" width="80">月基本給</td>  
                <td class="style01" width="80">賞與月割分</td>
                <td class="style01" width="68">名節賞與</td> 
              </tr>
              <tr align="center"> 
                <td class="style01"><%= WebUtil.printNumFormat(data.BETRG) %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpInt+"") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpSang+"") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpMyoung+"") %></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
              <tr> 
                <td width="10" class="style01">①</td>
                <td class="style01">상기 基本年俸은 <%= data.BEGDA.substring(0,4) %>年 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>月 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>日부터 <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">&nbsp;③항의 약정된 지급일에 「月基本給」과「賞與月割分」</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">&nbsp;&nbsp;&nbsp; 및「名節賞與」 로 지급된다.</td>
              </tr>
<%
if ( Integer.parseInt(data.ZYEAR) == 2010 && Integer.parseInt(data.BEGDA.substring(5,7)) == 9 ) {
%>              
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">※ 금번 연봉 조정은 3월 1일자로 소급적용 하지 않으며, 따라서 2010년 
                </td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">&nbsp;&nbsp;&nbsp;  실 지급 연봉은 상기 기본연봉보다 적음
                </td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">&nbsp;&nbsp; 『2010년 실 지급 연봉 = 조정 전 월기본급 * 9 + 조정 후 월기본급 *11』
                </td>
              </tr>
<%          }             %>                                      
              
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">②</td>
                <td class="style01">基本年俸은 사무직 근로형태의 특성을 감안, 월평균 시간외 근로를</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">포함하여 포괄 산정한 금액이다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">③</td>
                <td class="style01">基本年俸 지급 방법은 「月基本給」과「賞與月割分」을 매월 25일에</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">각각 지급하며「名節賞與」 는 설, 추석에  각각 지급한다.</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">단, 중도입사자의 매월 25일에 지급되는「月基本給」과「賞與月割分」</td>
              </tr>
              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">및 설, 추석에 지급되는「名節賞與」에 대해서는 별도 기준에 따른다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 職務, 資格, 기타 수당은 별도 기준에 따라 <br>지급한다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">⑤</td>
                <td class="style01">여사원이 月1일 보건(생리)휴가 청구 시, 「月基本給」의</td>
              </tr>

              <tr> 
                <td class="style01">&nbsp;</td>
                <td class="style01">「日割分(月基本給/근태일수)」을 공제한다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr> 
                <td class="style01">⑥</td>
                <td class="style01">경영목표달성에 따라 비정기적으로 지급되는 成果給은 별도로 정하며,</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">平均賃金에는 산입하지 않는다.</td>
              </tr>
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td class="style01">⑦</td>
                <td class="style01">年俸契約과 관련하여 제공받거나 알게 된 내용을 제3자에게 제공하거나</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">공개하여서는 아니된다.</td>
              </tr> 
              <tr> 
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td class="style01">⑧</td>
                <td class="style01">기타사항은 就業規則과 勤勞基準法에 따른다. </td>
              </tr>            
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td> 
                	 <table width=300" border="0" cellspacing="0" cellpadding="0" align="left">
                    <tr> 
                      <td align="left" width="130" class="style01"><font face="맑은고딕, 맑은고딕체" size="2"><b>LG MMA(주)<br>
                        대표이사<br>
                        社長&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;나상업 </b></font></td>
                      <!--<td align="left"><img src="<%= WebUtil.ImageURL %>sign.jpg" border="0">-->
                      <td align="left"><img src="<%= imgURL %>sign.jpg" border="0">
                      </td>                      
                    </tr>
                  </table>
                  <!--img src="<%= imgURL %>sign.jpg" width="300" height="80"--></td>
                <td> 
                  <table width="150" border="0" cellspacing="0" cellpadding="0" align="right">
                    <tr> 
                      <td align="center" width="197" class="style01">LG MMA(주)<br>
                        <%= data.ORGTX %><br>
                        <%= ename %> (印)</td>
<%       if ( AGRE_FLAG.equals("Y") ) {  %>  
                      <td align="center"><img src="/web-resource/images/sub/btn_agreeYes.gif" alt="합의완료">
                      </td>  
<%       }  %>                        
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
<%
    if ( Integer.parseInt(data.ZYEAR) >= 2008 && !AGRE_FLAG.equals("Y") ) {  
      if ( !printFlag.equals("Y") ) {   
    //if ( !AGRE_FLAG.equals("Y") ) {  
%>  
        <tr>
          <td align="center">
            <table width="150" border="0" cellspacing="0" cellpadding="0"> 
               <tr>
                 <td align="center"><a href="javascript:f_agree();">
                     <img src="<%= WebUtil.ImageURL %>btn_agree.gif" height="20" border="0"></a>
                 </td>
               </tr> 
            </table>        
          </td>
        </tr>     
<%    
    }
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
    frm.action = "<%= WebUtil.ServletURL %>hris.A.A10Annual.A10AnnualListSV";
    frm.submit();
}
                
</script>

<form name="form1" method="post">
<input type=hidden name="jobid"     value="">
<input type=hidden name="I_PERNR"     value="<%= user.empNo %>">
<input type=hidden name="I_CONT_TYPE" value="">
<input type=hidden name="I_YEAR"      value="<%= data.ZYEAR %>">
</form>
</body>
</html>
