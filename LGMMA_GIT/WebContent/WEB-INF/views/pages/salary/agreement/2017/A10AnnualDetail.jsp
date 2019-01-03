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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>LG MMA</title>
<!-- basic -->
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_library.css" />
<link rel="stylesheet" type="text/css" href="/web-resource/css/ui_jquery.css" />
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-1.9.0.js"></script>
<script type="text/javascript" src="/web-resource/js/jQuery/jquery-ui-1.10.0.js"></script>
</head>
<body>
<div class="printArea">
  <table width="660" align="center">
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
      	<table width="660" cellpadding="0" cellspacing="0">
          <tr>
            <td><img src="/web-resource/images/sub/img_logo_mma.gif" alt="LG MMA"></td>
          </tr>
        </table>
    </tr>
  <tr> 
    <td align="center">
      <table width="660" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center" height="80"><font size="6"><b><u>年 俸 契 約 書</u></b></font></td>
          </tr>
          <tr>
            <td><table width="560">
                <tr>
                  <td align="center">LG MMA(주)와 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= data.BEGDA.substring(0,4) %>년 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>월 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>일부터&nbsp;  
                  <%= data.ENDDA.substring(0,4) %>년 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>월 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>일까지 적용되는<br>
                  <%= data.TITEL %> <%= ename %>의 年俸을 다음과 같이 契約한다.</td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center"><font size="3">- 다 음 -</font></td>
          </tr>
          <tr>
            <td><table width="560" border="1" cellpadding="10" cellspacing="0" bordercolor="#999">
                <tr align="center">
                  <td width="25%" style="padding:3px"><%= data.ZYEAR %>年 基本年俸</td>
                  <td width="25%">月基本給</td>
                  <td width="25%">月賞與金</td>
                  <td width="25%">名節賞與</td>
                </tr>
                <tr align="center">
                  <td><%= WebUtil.printNumFormat(data.BETRG) %></td>
                  <td><%= WebUtil.printNumFormat(tmpInt+"") %></td>
                  <td><%= WebUtil.printNumFormat(tmpSang+"") %></td>
                  <td><%= WebUtil.printNumFormat(tmpMyoung+"") %></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><table width="560"  cellspacing="0" cellpadding="2" class="alignLeft">
              <tr> 
                <td width="22" valign="top">①</td>
                <td >상기 基本年俸은 <%= data.BEGDA.substring(0,4) %>年 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>月 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>日부터 <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지&nbsp;&nbsp;
                    ③항의 약정된 지급일에 <br>「月基本給」과「月賞與金」
                    및「名節賞與」 로 지급된다. </td>
              </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">②</td>
                  <td>基本年俸은 사무직 근로형태의 특성을 감안, 월평균 시간외 근로를 
                    포함하여 포괄 산정한 <br>금액이다. </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">③</td>
                  <td>基本年俸 지급 방법은 「月基本給」과「月賞與金」을 매월 25일에 
                    각각 지급하며<br>「名節賞與」 는 설, 추석에 각각 지급한다. <br>
                    단, 중도입사자의 매월 25일에 지급되는「月基本給」과「月賞與金」
                    및 설, 추석에 지급되는「名節賞與」에 대해서는 별도 기준에 따른다. </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">④</td>
                  <td>기본연봉에 포함되지 않는 資格, 기타 수당 등은 별도 기준에 따라 
                    지급한다.</td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">⑤</td>
                  <td>여사원이 月1일 보건(생리)휴가 청구 시, 「月基本給」의 
                    「日割分(月基本給/근태일수)」을 <br>공제한다. </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">⑥</td>
                  <td>경영목표달성에 따라 비정기적으로 지급되는 成果給은 별도로 정하며, 
                    平均賃金에는 산입하지 <br>않는다. </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">⑦</td>
                  <td>年俸契約과 관련하여 제공받거나 알게 된 내용을 제3자에게 제공하거나 
                    공개하여서는 아니된다. </td>
                </tr>
                <tr>
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td valign="top">⑧</td>
                  <td>기타사항은 就業規則과 勤勞基準法에 따른다. </td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td><table width="560" >
                <tr>
                  <td width="60%"><table width="100%" >
                      <tr>
                        <td width="85px" align="left"><b>LG MMA(주)<br>대표이사<br>社長&nbsp;&nbsp;나상업</b></td>
                        <td align="left" valign="bottom"><img src="<%= imgURL %>sign.jpg" border="0"></td>
                      </tr>
                    </table></td>
                  <td width="20%" align="left">LG MMA(주)<br><%= data.ORGTX %><br><%= ename %> (印)</td>
<%       if ( AGRE_FLAG.equals("Y") ) {  %>  
                  <td width="20%" align="center"><img src="/web-resource/images/sub/btn_agreeYes.gif" alt="합의완료"></td>
<%       }  %>                        
                </tr>
              </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
<%
    if ( Integer.parseInt(data.ZYEAR) >= 2008 && !AGRE_FLAG.equals("Y") ) {  
      if ( !printFlag.equals("Y") ) {   
    //if ( !AGRE_FLAG.equals("Y") ) {  
%>  
          <tr>
            <td>
            	<div class="buttonArea alignCenter">
					<ul class="btn_crud">
						<li><a href="javascript:f_agree();" id="agreeSalaryfBtn"><span>합의</span></a></li>								
					</ul>
				</div>
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
</div>
<script language="javascript">
function f_agree() {
	if(confirm("합의 하시겠습니까?")) {
		$("#agreeSalaryfBtn").prop("disabled", true);
		var param = $("#form1").serializeArray();
		jQuery.ajax({
    		type : 'POST',
    		url : '/salary/agreeSalary',
    		cache : false,
    		dataType : 'json',
    		data : param,
    		async : false,
    		success : function(response) {
    			if(response.success) {
    				alert(response.message);
    				location.reload();
    			} else {
    				alert("오류가 발생하였습니다. " + response.message);
    			}
				$("#agreeSalaryfBtn").prop("disabled", false);
    		}
    	});
	}
<%-- 
	frm =  document.form1;
    frm.jobid.value ="agree";
    frm.target = "beprintedpage";
    frm.I_CONT_TYPE.value = "2"; //저장
    frm.action = "<%= WebUtil.ServletURL %>hris.A.A10Annual.A10AnnualListSV";
    frm.submit();
 --%>
}
                
</script>

<form name="form1" method="post" id="form1">
<input type=hidden name="jobid"     value="">
<input type=hidden name="I_PERNR"     value="<%= user.empNo %>">
<input type=hidden name="I_CONT_TYPE" value="">
<input type=hidden name="I_YEAR"      value="<%= data.ZYEAR %>">
</form>
</body>
</html>
