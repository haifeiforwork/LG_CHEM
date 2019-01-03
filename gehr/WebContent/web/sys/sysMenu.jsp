<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--@elvariable id="menuInputData" type="hris.sys.MenuInputData"--%>
<%--@elvariable id="menuMap" type="Map<String, Vector<MenuCodeData>>"--%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="com.common.constant.Area" %>
<%@ page import="java.net.InetAddress" %>
<%@ page errorPage="/web/err/error.jsp"%>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type"     content="text/html; charset=UTF-8">
    <meta http-equiv="Pragma"           content="no-cache"/>
    <meta http-equiv="Cache-Control"    content="no-cache"/>
    <meta http-equiv="Expires"          content="-1"/>
    <meta http-equiv="p3p"              content="CP='CAO DSP AND SO'" policyref="/w3c/p3p.xml" />
    <meta http-equiv="X-XSS-Protection" content="0; mode=block;" />
    <meta name="robots"                 content="none,noindex,nofollow"/>
    <meta http-equiv="X-UA-Compatible" content="IE=8">

    <link rel="stylesheet" href="<%=WebUtil.ImageURL %>css/menu.css" type="text/css">

    <script language="JavaScript" src="${g.image}js/jquery-1.12.4.min.js"></script>
    <script language="JavaScript" src="${g.image}js/promise-7.0.4.min.js"></script>
    <script language="JavaScript" src="${g.image}js/underscore.js"></script>
    <script language="JavaScript" src="${g.image}js/common.js"></script>

    <script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

    <%
        WebUserData user = WebUtil.getSessionUser(request);
    %>

    <%--@elvariable id="initPop_hm" type="java.util.Map<java.lang.String,java.util.List>"--%>
    <script>

        function showHideMenu(code) {
            return new Promise(function() {
                var _$current = $(".current");
                var _$select = $("#-menu-" + code);

                _$current.removeClass("current");

                _$select.addClass("current")
                        .parents("li").addClass("current").andSelf()
                        .children("ul").show('fast');

                //현재 선택된 level의 li의 current가 존재 할경우 삭제 하위 ul값 숨김
                _$select.siblings("li").removeClass("current").find("ul").hide();
            });
        }

        function selectMenu(menuCode, isMove) {
            if(isMove)
                $("#-menu-" + menuCode + " a").click();
            else showHideMenu(menuCode);
        }

        var _showLoading = function(p, count) {
            if(count == 0) return;
            p = p || window.parent;
            count = count || 5;

            if(p && p["showLoading"]) window.onbeforeunload = p["showLoading"];
            else if(p && p.parent && p !== p.parent) _showLoading(p.parent, --count);
            else return ;
        };


        $(function() {
            $(".unloading").click(function() {
                window.onbeforeunload = null;
                setTimeout(_showLoading, 1000);
            });

            $(".-menu").click(function(e) {
                e.preventDefault();
                var $this = $(this);

                showHideMenu($this.data("code"));

                var sMenuCode = $this.data("code");
                $("#sMenuCode").val(sMenuCode);
                $("#sMenuText").val($this.data("text"));

                var _url = $this.data("url");
                if(!_.isEmpty(_url)) {
                    if(_url.indexOf("javascript:") == 0) {
                        eval(_url.replace("javascript:", ""));
                    } else {
                        try {
                            parent.showLoading();
                        } catch(e) {}
                        $("#menuForm").attr("action", $this.data("url")).submit();
                    }
                    $(".-param").val("");   <%-- 1회성 값 초기화 --%>
                }

                //메뉴 클릭 후 로그 남기기
                ajaxPost("<%= WebUtil.ServletURL %>hris.LogSV", {sMenuCode : sMenuCode}, null, null, true);
            });

            var $current = $(".current:last");

            if(_.isEmpty($current.children("a").data("url"))) {
                $current.find("a[data-url!='']:first").click();
            } else $current.children("a").click();


            var iLeft  = 100;
            var itop = 100;

            //[CSR ID:2953938] 개인 인사정보 확인기능 구축 및 반영의 件
            <%--<c:if test="${InsaInfoYN == 'Y'}">
                //alert("ggg");
                var pop_window=window.open("${g.servlet}hris.N.essperson.A01SelfDetailNeoSV?jobid=popup","","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=850,height=900,left=10,top=10");
                pop_window.focus();
            </c:if>--%>

            <c:forEach var="pop" items="${initPop_hm['T_EXPORTA']}">
            if ( getCookie( "${pop['OBJID']}" ) != "done" ){

                var pop_window${pop['OBJID']}=window.open("${g.servlet}hris.N.notice.EHRNoticeSV?OBJID=${pop['OBJID']}","${pop['OBJID']}","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=no,scrollbars=yes,width=720,height=600,left="+iLeft+",top="+itop);
                pop_window${pop['OBJID']}.focus();
                iLeft += iLeft;
                itop += itop;
            }

            </c:forEach>

        });

        function foldLeftmenu() {
            var FrameSet = parent.document.getElementById("framesets");
            // 접기
            if (FrameSet.cols == "225,*,0") {
                FrameSet.cols = "24,*,0";
                document.btn_fold.src = "${g.image}leftMenu/new/ico_left_open.png";
                $('html').css('overflow', "hidden");
                $(".-menu-body").hide();

                // 펼치기
            } else if (FrameSet.cols == "24,*,0") {
                FrameSet.cols = "225,*,0";
                document.btn_fold.src = "${g.image}leftMenu/new/bg_lnb_top.gif";
                $('html').css('overflow', "auto");
                $(".-menu-body").show();
            }
        }

        function moveRetireURL() {
            var lDoc = "";

            <%if(!user.e_mail.equals("")){%>
            lDoc ='<%=user.e_mail.substring(0,user.e_mail.lastIndexOf("@"))%>';
            <%}%>
            <% if (user.SServer != "") { %>
            var SServer = '<%=user.SServer%>';
            <% } else { %>
            var SServer = 'mail2.lgchem.com';
            <% } %>

            var url = "";
            var url ="<%= WebUtil.ServletURL %>hris.RetireSV?lDoc="+lDoc+"&SServer="+SServer;

            <%--<%
            if(request.getServerName().indexOf("dev") > -1) {
           %>
            var url ="http://sundevelope.lgchem.com:8002/intra/owa/neloinit.quick?p_user="+lDoc+"&p_port=8002&p_svr_name="+SServer+"&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";
            <%
            } else {
            %>
            var url ="http://eloffice.lgchem.com:8002/intra/owa/neloinit.quick?p_user="+lDoc+"&p_port=8002&p_svr_name="+SServer+"&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";

            <%} %>--%>


            parent.menuContentIframe.location.href =url;

        } // end function

        function open_charge() {
            // small_window=window.open("<%= WebUtil.JspURL %>common/HRChargePop.jsp?I_BUKRS=<%= user.companyCode %>&I_GRUP_NUMB=<%= user.e_grup_numb %>","Charge","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,scrollbars=yes,width=812,height=480,left=300,top=100");
            small_window=window.open("<%= WebUtil.ServletURL %>hris.common.HrChargePopSV?I_BUKRS=<%= user.companyCode %>&I_GRUP_NUMB=<%= user.e_grup_numb %>","Charge","toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,scrollbars=yes,width=980,height=620,left=300,top=100");

            small_window.focus();
        }

        function popupP(theURL,width, height) {
            //var width=900;
            // var height = 750;
            var screenwidth = (screen.width-width)/2;
            var screenheight = (screen.height-height)/2;

            pop_window = window.open(theURL,"_newfin","width="+width+",height="+height+",toolbar=no,location=no,resizable=yes,scrollbars=yes,top="+screenheight+",left="+screenwidth);
            pop_window.focus();
        }

        function open_help(){
            small_window=window.open('/web/help_online/helpGlobal.jsp?param=contents.html', 'essHelp', "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=yes,width=880,height=650,left=100,top=100");
            small_window.focus();
        }

    </script>
</head>
<body style="overflow-x:hidden;" <% if(!WebUtil.isLocal(request)) { %> oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear();" <% } %>>

<div class="wrapper">
    <form id="menuForm" name="menuForm" method="post" target="menuContentIframe">
        <%-- 기존 로직 필요할 경우
        <c:if test="${param.menuCode == '9999'}">
        <input type="hidden" id="AINF_SEQN" name="AINF_SEQN" value="${param.AINF_SEQN}" />
        </c:if>
        <c:if test="${param.menuCode == '1320' or param.menuCode == '1184'}">
        <input type="hidden" id="year" name="year" value="${param.year}" />
        <input type="hidden" id="month" name="month" value="${param.month}" />
        </c:if>
        --%>
        <input type="hidden" id="sMenuCode" name="sMenuCode"/>
        <input type="hidden" id="sMenuText" name="sMenuText"/>

        <%-- 외부에서 넘어오는 parameter 값들 1회성 --%>
        <input type="hidden" class="-param" id="tabid" name="tabid" value="${param.tabid}"/>
        <input type="hidden" class="-param" id="year" name="year" value="${param.year}"/>
        <input type="hidden" class="-param" id="month" name="month" value="${param.month}"/>
        <input type="hidden" class="-param" id="AINF_SEQN" name="AINF_SEQN" value="${param.AINF_SEQN}"/>

    </form>
    <div class="lnb_bg">
        <div class="lnb_top">
            <a class="leftTop close unloading" href="javascript:foldLeftmenu();" ><img src="${g.image}leftMenu/new/bg_lnb_top.gif" name="btn_fold" alt="접기"></a>
        </div>
        <c:set var="menuList" value="${menuMap[menuInputData.menu1]}" />

        <div class="lnb_title -menu-body"><h2><c:if test="${not empty menuList[0].HLFCD}"><spring:message code="COMMON.MENU.${menuList[0].HLFCD}" /></c:if></h2></div>
        <div class="lnb -menu-body">
            <%-- lnb.html : 원본 --%>
            <ul>
                <c:forEach var="subMenu" items="${menuList}" >
                    <%--FCODE		CHAR	20	기능코드
                    FTEXT		CHAR	40	기능코드 Text
                    ORDSQ		NUMC	2	정렬 순서
                    HLFCD		CHAR	20	상위레벨 기능코드
                    EMGUB		CHAR	1	ESS/MSS 구분자
                    LEVEL		NUMC	2	노드레벨
                    FTYPE		CHAR	4	기능유형
                    RPATH		CHAR	255	Web 주소(URL)
                    target="menuContentIframe"

                    if ( mncd.menuCode.equals("1281")) {
                    sb.append("<tr><td  colspan=\"2\" name=\"do"+docCount+"\" id=\"doc" + mncd.menuCode  + "\" parent=\"" + parentID  + "\" href=\"" + mncd.pgDetail.realPath + "\" "  + backGround + " >");
                    sb.append("<a href=\"javascript:clickDoc2('" + EHRCommonUtil.nullToEmpty(mncd.menuCode)  + "')\" onClick=\"hideIMG('"+EHRCommonUtil.nullToEmpty(mncd.menuCode)+"');this.blur()\"><span class=\"lMenu_3rd\">" + mncd.prnMenu + "</span></a>" );
                    sb.append("</td></tr> \n");
        --%>

                    <li id="-menu-${subMenu.FCODE}" class="lnb_1depth ${subMenu.FCODE == menuInputData.menu2 ? 'current' : ''}" >
                        <a class="-menu" href="javascript:;" data-code="${subMenu.FCODE}" data-text="${subMenu.FTEXT}" data-url="${subMenu.RPATH}"><spring:message code="COMMON.MENU.${subMenu.FCODE}" /><%--${subMenu.FTEXT}--%></a>
                        <c:if test="${!empty menuMap[subMenu.FCODE]}">
                            <%-- 하위메뉴가 추가 되어지는 경우 아래 부분 li 안으로 변수명만 주의 - 메뉴레벨이 정해져 있어 재귀호출 사용안함 --%>
                            <ul id="-sub-${subMenu.FCODE}" style="display:${subMenu.FCODE == menuInputData.menu2 ? "" : "none"};" >
                                <c:forEach var="subMenu2" items="${menuMap[subMenu.FCODE]}">
                                    <li id="-menu-${subMenu2.FCODE}" class=" lnb_2depth ${subMenu2.FCODE == menuInputData.menu3 ? 'current' : ''}" >
                                        <a class="-menu" href="javascript:;" data-code="${subMenu2.FCODE}" data-text="${subMenu2.FTEXT}" data-url="${subMenu2.RPATH}"><spring:message code="COMMON.MENU.${subMenu2.FCODE}" /><%--${subMenu2.FTEXT}--%></a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </li>
                </c:forEach>

                <% if(WebUtil.isLocal(request))  { %>
                <li id="-menu-DEV" class="lnb_1depth">
                    <a class="-menu" data-code="DEV" href="javascript:;">개발진행중 - 임시</a>
                    <ul id="-sub-DEV">
                       <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.ResetApporvalExcelSV" target="menuContentIframe">전자결재 리셋 Excel</a>
                        </li>

                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.ResetApporvalSV" target="menuContentIframe">전자결재 리셋</a>
                        </li>

                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.SyncApprovalListSV" target="menuContentIframe">전자결재 싱크</a>
                        </li>

                        <li class="lnb_2depth">
                            <a href="/web/N/orgstats/languageprsn/LanguagePrsnFrame.jsp?checkYn=Y" target="menuContentIframe">어학우수인재</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/web/N/bsnrmd/BusinRecommend.jsp" target="menuContentIframe">사업가 후보 추천</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m" target="menuContentIframe">임원 Profile </a>
                        </li>

                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.D.D05Mpay.D05MpayDetailSV_m" target="menuContentIframe">MSS월급여 </a>
                        </li>

                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.D.D06Ypay.D06YpayKoreaSV_m" target="menuContentIframe">MSS연급여 </a>
                        </li>

                    <%--    <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E18Hospital.E18HospitalFrameSV" target="menuContentIframe">의료비(KR)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E19Congra.E19CongraFrameSV" target="menuContentIframe">경조금(ESS)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E30HealthInsurance.E30HealthFrameSV"  target="menuContentIframe">건강보험(ESS)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E29PensionDetail.E29PensionListSV" target="menuContentIframe">국민연금(ESS)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E28General.E28GeneralFrameSV" target="menuContentIframe">종합검진(ESS)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E28Genera.E28GeneralCancerFrameSV" target="menuContentIframe">추가암검진(ESS)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E16Health.E16HealthCardSV" target="menuContentIframe">건강검진 내역조회(ESS)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.D.D00ReportFrameSV" target="menuContentIframe">근태 집계표</a>
                        </li>

                        <li class="lnb_2depth">
                            <a href="${g.jsp}F/F00DeptPersonFrame.jsp" target="menuContentIframe">인원현황</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E26InfoState.E26InfoFrameSV" target="menuContentIframe">동호회가입현황</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.E.E31InfoStatus.E31InfoStatusListSV" target="menuContentIframe">동호회가입현황(간사용)</a>
                        </li>
                        <li class="lnb_2depth">
                            <a href="/servlet/servlet.hris.D.D13ScheduleChange.D13ScheduleChangeSV" target="menuContentIframe">부서근태/일근태[CN]</a>
                        <li class="lnb_2depth">
                            <a href="/web/D/D13ScheduleChange/D13ScheduleChangeFrame.jsp" target="menuContentIframe">부서근태/일근태[CN]</a>
                        </li>--%>

                    </ul>
                </li>
                <%  } %>
            </ul>
        </div>
        <div class="lnb_bottom"></div>
    </div>
    <div class="-menu-body">
        <%--<a class="btn_link" href="${g.servlet}hris.A.A22ExecutiveProfile.A22ExecutiveProfileSV_m" target="menuContentIframe"><img src="${g.image}new/icon_profile.gif" />임원 Profile</a>
        <a class="btn_link" href="${g.jsp}D/D00ConductFrame.jsp" target="menuContentIframe"><img src="${g.image}leftMenu/new/icon_profile.gif" />근태실적조회및신청(ESS)</a>--%>


        <a class="text_link iconSite" href="${g.servlet}hris.common.SiteMapSV" target="menuContentIframe">Site Map</a>
        <%  if(user.area == Area.KR) { %>
        <a class="text_link iconPrivacy" href="http://epapp.lgchem.com:8701/jsp/ep/privacy/html/privacy.html" target="_privacyBlank">Privacy Policy</a>

        <% if(Arrays.asList("00215019","00037466","00218588","00030041","00037567"
                ,"00217852","00006882","00117332","00022778","00201234"
                ,"00212710","00043713","00204291","00111090","00219561"
                ,"00038096","00219341","00080798","00003913","00037916"
                ,"00027108","00005487","00116534","00203593").contains(user.empNo)){
            //String elurl = "http://eloffice.lgchem.com:8001/intra/owa/insarule?p_user="+user.empNo; --%>
        <%--[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha start --%>
        <%-- <a class="text_link iconBook" href="<%= elurl %>" target="hidden">

        <a class="text_link iconBook" href="${g.servlet}hris.N.executive.ExecutiveSV" target="_ExecutiveBlank"><spring:message code="COMMON.MENU.QUICK.1"/><!--집행임원인사관리규정--></a>  --%>
        <a class="text_link iconBook"  href="javascript:popupP('<c:out value='${g.servlet}'/>hris.N.executive.ExecutiveSV', '800','350')"><spring:message code="COMMON.MENU.QUICK.1"/><%--집행임원인사관리규정--%></a>
		<%--[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha end --%>
        <% } %>

        <%  } %>

    </div>
    <div style="color: white;">
        <%= InetAddress.getLocalHost() %>
    </div>
    <iframe name="hidden" id="hidden" frameborder="0" width="0" height="0" style="top: -9999px; display:none;"></iframe>
</div>
</body>
<script type="javascript">
    _showLoading();
</script>
</html>