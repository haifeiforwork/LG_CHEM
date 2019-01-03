<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%/******************************************************************************/
/*                                                                              */
/*   System Name  :                                                          */
/*   1Depth Name  : EAP                                                  */
/*   2Depth Name  : 건강상담 지표안내                                           */
/*   Program Name : 건강상담 지표안내                                                 */
/*   Program ID   : healthlCounsel.jsp                                          */
/*   Description  : 건강지표 안내화면                  */
/*   Note         :                                                             */
/*   Creation     :                                           */
/*   Update       : 2015-12-16  이지은 [CSR ID:2940409] EAP건강지표 수정의 건                         */
/*                                                                              */
/********************************************************************************/%>


<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="java.util.*" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%

            HashMap<String, String> hMINFO = new HashMap<String, String>();
            HashMap<String, String> sMINFO = new HashMap<String, String>();

            Vector nurVT = new Vector();
            Vector strVT = new Vector();

            HashMap mhm= (HashMap)request.getAttribute("healMailData");
            HashMap strhm= (HashMap)request.getAttribute("strData");
            int mhSize = 0 ;
            if(mhm != null){
                nurVT = (Vector)mhm.get("T_MINFO");
                mhSize = nurVT.size();

            }

            String recode = "";
            if(strhm != null){
                strVT = (Vector)strhm.get("MINFO");
                recode = (String)strhm.get("returnCode");
                sMINFO = (HashMap)strVT.get(0);
                Logger.debug.println("---- recode"+recode);

            }
%>

		<jsp:include page="/include/header.jsp" />
    <script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
    <!--[if lt IE 9]>
    <script src="http://getbootstrap.com/2.3.2/assets/js/html5shiv.js"></script>
    <script src="http://ie7-js.googlecode.com/svn/version/2.1/IE9.js">IE7_PNG_SUFFIX=".png";</script>

    <![endif]-->
    <title>LG화학 e-HR 시스템</title>
    <meta name="description" content="LG화학 e-HR 시스템" />
    <link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>/css/ehr_style.css" />
    <link rel="stylesheet" type="text/css" href="<%=WebUtil.ImageURL %>/css/ehr_wsg.css" />

    <script type="text/javascript">

        function popup_old(theURL,winName, width, height) {
          var screenwidth = (screen.width-width)/2;
          var screenheight = (screen.height-height)/2;
          winitem = 'height='+height+',width='+width+',top='+screenheight+',left='+screenwidth+',scrollbars=no';

          window.open(theURL,winName,winitem);
        }

        function popup(theURL,winName, width, height) {
       		$('#ifpopup').attr("src",theURL);
//        		$('#ifpopup').css("height",height);
//        		$('#ifpopup').css("width",width);
       		showPop();
        }
        
        function showPop(){
        	$('#popupframe').show();
        }

        function hidePop(){
        	$('#popupframe').hide();
        } 

	    function fnMove(divname){
	        var offset = $("#" + divname).offset();
	        $('html, body').animate({scrollTop : offset.top}, 400);
	    }

    </script>
</head>

<body id="subBody" class="eapSubBody" oncontextmenu="return true" ondragstart="return false" onselectstart="return false">
<form name="healForm" method="post">

<div class="subWrapper eapSub">
    <div class="healthTop"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_top.jpg" alt="EAP 서비스" /></div>
    <div class="healthTopMent"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_ment.jpg" alt="EAP 서비스 - 건강상담" /></div>
    <div class="healthLink">
        <a href="#" onclick="fnMove('locSec01');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_link_01.gif" alt="제공프로그램" /></a><a
             href="#" onclick="fnMove('locSec02');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_link_02.gif" alt="확인사항" /></a><a
             href="#" onclick="fnMove('locSec03');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_link_03.gif" alt="전사보건관리자 운영현황" /></a><a
             href="#" onclick="fnMove('locSec04');"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_link_04.gif" alt="건강상담 신청하기" />       	 </a>
    </div>
    <div class="contentBody">
<div id="locSec01"></div>
        <h3><a name="sec01"><img src="<%= WebUtil.ImageURL %>/ehr_common/health_title_01.gif" alt="제공 프로그램" /></a></h3>

        <ul class="healthSec01">
            <li class="item01"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec01_img_01.jpg" alt="건강검진" /></li>
            <li class="item02"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec01_img_02.jpg" alt="검진상담" /></li>
            <li class="item03"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec01_img_03.jpg" alt="건강증진P/G" /></li>
        </ul>
        <div class="clear"></div>
        <div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>

<div id="locSec02"></div>
        <h3><a name="sec02"><img src="<%= WebUtil.ImageURL %>/ehr_common/health_title_02.gif" alt="제공 프로그램" /></a></h3>
        <p class="ment1">
        정기 건강검진을 통해 개인의 건강상태를 정확히 파악하고 그에 따른 적합한 예방활동을 실행해야 건강한 생활 유지가 가능합니다.
        </p>
        <div style="margin:20px 0 30px 0;text-align:center;"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec02.jpg" alt="정기건강검진" /></div>
        <div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>

        <p class="ment1"> 건강지표의 의미를 정확히 이해하고 정상수준이 유지될 수 있도록 지속적으로 관리하는 것이 중요합니다.</p>

        <!-- 테이블 시작 -->
        <div class="table">
            <table class="listTable">
                <col width="17%" /><col width="17%" /><col width="17%" /><col width="17%" /><col width="17%" /><col />
                <thead>
                    <tr>
                        <th colspan="2" rowspan="2">구분</th>
                        <th rowspan="2">정상</th>
                        <th colspan="2">유소견자</th>
                        <th class="lastCol" rowspan="2">비고</th>
                    </tr>
                    <tr>
                        <th>C (주의)</th>
                        <th>D (질환)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="oddRow">
                        <td rowspan="3" style="cursor:pointer; background:#fff; border-bottom:1px solid #eee;"><a onclick="popup('/web/N/EAP/mental/eap_health_01_p.html','','600','400')" class="strCol01">간장질환</a></td>
                        <td>GOT</td>
                        <td>40 이하</td>
                        <td class="colorStr">51 이상</td>
                        <td><span class="strTxt b">100 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr>
                        <td>GPT</td>
                        <td>35 이하</td>
                        <td class="colorStr">46 이상</td>
                        <td><span class="strTxt b">100 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr class="oddRow borderRow">
                        <td>γ-GTP</td><!-- [CSR ID:2940409] -->
                        <td>63 이하</td>
                        <td class="colorStr">78 이상</td>
                        <td><span class="strTxt b">200 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr>
                        <td rowspan="4" style="cursor:pointer; background:#fff; border-bottom:1px solid #eee;"><a onclick="popup('/web/N/EAP/mental/eap_health_02_p.html','','600','400')" class="strCol01">고지혈증</a></td>
                        <td>총콜레스테롤</td>
                        <td>200 이하</td>
                        <td class="colorStr">240 이상</td>
                        <td><span class="strTxt b">300 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr class="oddRow">
                        <td>중성지방</td>
                        <td>150 이하</td>
                        <td class="colorStr">200 이상</td>
                        <td><span class="strTxt b">500 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr>
                        <td>저밀도</td>
                        <td>130 이하</td>
                        <td class="colorStr">160 이상</td>
                        <td><span class="strTxt b">190 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr class="oddRow borderRow">
                        <td>고밀도</td>
                        <td>60 이상</td>
                        <td class="colorStr">40 미만</td>
                        <td><span class="strTxt b">30 미만</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr class="borderRow">
                        <td style="cursor:pointer;"><a onclick="popup('/web/N/EAP/mental/eap_health_03_p.html','','600','350')" class="strCol01">당뇨</a></td>
                        <td>혈당</td>
                        <td>110 이하</td>
                        <td class="colorStr">120 이상</td>
                        <td><span class="strTxt b">200 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                    <tr class="oddRow">
                        <td colspan="2" style="cursor:pointer;"><a onclick="popup('/web/N/EAP/mental/eap_health_04_p.html','','600','350')" class="strCol01">고혈압</a></td>
                        <td>120/80 이하</td>
                        <td class="colorStr">140/90 이상</td>
                        <td><span class="strTxt b">160/110 이상</span></td>
                        <td class="lastCol"></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- 테이블 끝 -->

        <div class="tMent">
        <strong class="strCol01">C (주의) </strong> 질환 발전 가능성이 높아 <span class="underLine">정확한 진단 및 치료가  필요한  경우</span><br />
        <strong class="strCol01">D (질환) </strong> 질환 판정/소견이 있어 <span class="underLine">치료 등의 지속적 사후 관리가  반드시 필요한  경우</span>

        </div>
        <br  />
        <p class="ment1"> 자가 진단을 통해 수시로 자신의 건강상태 점검하는 습관이 매우 중요합니다.</p>

        <div class="sec03Content">
            <img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec03_img_01.jpg" />
            <img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec03_img_02.jpg" />
            <img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec03_img_03.jpg" />
            <img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec03_img_04.jpg" />
            <img src="<%= WebUtil.ImageURL %>/ehr_common/eap_health_sec03_img_05.jpg" />
        </div>
        <div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>


<div id="locSec03"></div>
        <h3><a name="sec03"><img src="<%= WebUtil.ImageURL %>/ehr_common/health_title_03.gif" alt="제공 프로그램" /></a></h3>
        <p class="ment1">개인의 건강증진을 지원하기 위해 각 사업장에 건강상담실을 설치하고 전문 간호사가 상주하여 다양한 건강증진 Solution을 제공하고 있습니다.</p>



        <!-- 테이블 시작 -->
        <div class="table">
	        <table class="listTable" >
	            <caption></caption>
	            <col width="200" /><col width="150" /><col width="200" /><col />
	            <thead>
	                <tr>
	                    <th>사업장</th>
	                    <th>보건관리자 </th>
	                    <th>연락처</th>
	                    <th class="lastCol">이메일</th>
	                </tr>
	            </thead>

	            <tbody>
<%if(mhm != null){
                for(int i = 0 ; i < mhSize ; i ++){
                    hMINFO = (HashMap)nurVT.get(i);

                    String tr_class = "";

                    if(i%2 == 0){
                        tr_class="oddRow";
                    }else{
                        tr_class="";
                    }
                %>
	                <tr class="<%=tr_class%>">
	                    <td ><%= hMINFO.get("GRUP_NAME")%></td>
	                    <td><%= hMINFO.get("ENAME")%></td>
	                    <td><%= hMINFO.get("TELNO")%></td>
	                    <td class="align_left lastCol"><a href="mailto:<%= hMINFO.get("EMAIL").toLowerCase()%>"><%= hMINFO.get("EMAIL").toLowerCase()%></a></td>
	                </tr>
                <%
                }
            }else{ %>
	                <tr class="oddRow">
	                    <td class="lastCol" colspan="4">데이터가 없습니다.</td>
	                </tr>
            <%} %>
            	</tbody>
        	</table>
        </div>
        <!-- 테이블 끝 -->

        <p class="ment1">
        각 사업장의 건강 관리실을 방문하시면 보건관리자를 통한 건강상담 및 간단한 건강상태 점검이
가능하오니 적극적인 활용 바랍니다.

        </p>

    <%

        if(recode.equals("S")){
    %>
    
<div id="locSec04"></div>
        <div class="btnCenter">

            <a href="<%=WebUtil.JspPath %>N/EAP/health/health_apply.jsp?RECEIVER=<%= sMINFO.get("EMAIL").toLowerCase()%>" name="sec04"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_health_apply.gif" alt="건강상담 신청하기" /></a>
        </div>
         <%} %>

        <div class="eapTop"><a href="#"><img src="<%= WebUtil.ImageURL %>/ehr_common/eap_btn_top.gif" alt="위로" /></a></div>
    </div>
    <div style="height:300px;"></div>

</div><!-- /subWrapper -->
</form>

<style>
#popupframe{width:670px; height:404px; margin:auto; position:fixed; top:0;bottom:0; left:0;right:0; max-width:100%; max-height:100%; overflow:auto;
	display:none; border:1px solid ;
}
</style>

<div id="popupframe" >
	<iframe id="ifpopup" name="ifpopup" width="100%" height="100%" 
		src="about:blank" scrolling="no"  />
</div>


</body>
</html>
<%@ include file="/web/N/common/responseMsg.jsp" %>