<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사이트 맵                                                   */
/*   Program ID   : SiteMap.jsp                                                 */
/*   Description  : 사이트 맵을 위한 jsp 파일                                   */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-01 유용원                                           */
/*   Update       : 2005-12-23 @v1.1 ep 포탈로 인한 변경                        */
/*                                                                              */
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page errorPage="/web/err/error.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import = "com.sns.jdf.util.*"%>
<%@ page import="hris.common.*" %>
<%@ page import="com.sns.jdf.*"%>

<tags:layout title="COMMON.MENU.SITEMAP">
	<tags:script>
		<script>
			function moveMenu(menu1, menu2, menu3) {
				parent.location.href = "${g.jsp}main.jsp?menu1=" + menu1 + "&menu2=" + menu2 + "&menu3=" + menu3;
			}
		</script>

	</tags:script>

	<c:set var="menu1List" value="${menuMap['ROOT']}" />

	<c:forEach var="menu1" items="${menu1List}">
		<%--<h2 class="categoryTitle"><spring:message code="COMMON.MENU.${menu1.FCODE}" /></h2>--%>
		<h2 class="categoryTitle"><spring:message code="COMMON.MENU.${menu1.FCODE}" /></h2>

		<div class="category">

		<c:set var="menu2List" value="${menuMap[menu1.FCODE]}" />
		<c:set var="modValue" value="${(fn:length(menu2List) - fn:length(menu2List) % 2) /2}"/>

		<c:forEach var="menu2" items="${menu2List}" varStatus="status2">
			<c:if test="${status2.index % modValue == 0}">
			<div class="column">
			</c:if>
				<ul>
					<h3><spring:message code="COMMON.MENU.${menu2.FCODE}" /></h3>
					<c:set var="menu3List" value="${menuMap[menu2.FCODE]}" />
					<c:forEach var="menu3" items="${menu3List}" varStatus="status3">
						<li><a href="" onclick="moveMenu('${menu1.FCODE}', '${menu2.FCODE}', '${menu3.FCODE}')" ><spring:message code="COMMON.MENU.${menu3.FCODE}" /></a></li>
					</c:forEach>
				</ul>
			<c:if test="${status2.index % modValue == (modValue - 1) or status2.last}">
			</div>
			</c:if>
		</c:forEach>
			<div class="clear"></div>
		</div>
	</c:forEach>

</tags:layout>

<%--

<%!
    // 레벨
    int depth = 0;
    // 문서 갯수
    int docCount = 0;
    // 메뉴 갯수
    int menuCount = 0;

    public String writeMenu(Vector vc ,String topCode ,String parentID,String webUserID)
    {
        String ep_FALG ="YES";   //@v1.1

        depth ++;
        StringBuffer sb = new StringBuffer();
        int order = 0;
        int leve1 = 0;
        int leve2 = 0;
        int brcount =0;

        //메뉴가 단일건일 경우 예외 처리한다. 2,3 단계 메뉴가 없을경우 => sb.append("<br>" ); 처리 2015-06-01
        String excpMenu[] = {"1255","A015"};

        for (int i = 0; i < vc.size(); i++) {
            hris.sys.MenuCodeData mncd   =   (hris.sys.MenuCodeData) vc.get(i);
            if (mncd.HLFCD.equals(topCode)) {
                // 구분
                String strGubun = "";
                if(!mncd.FCODE.equals("1252")){//사이트맵 자신은 제외.
	                if (mncd.FTYPE.equals("01") && mncd.isDisplay) {
	                    String selfID = parentID;

	                    if(depth==1){

		                    sb.append("<tr><td class=sMenu_1st  colspan=\"2\">");
		                    sb.append("&nbsp;&nbsp;<strong>" + mncd.prnMenu + "</strong></td></tr>\n");

	                    }else if(depth==2){
	                        leve2++;
	                        if(leve2>1 ){
	                            sb.append("</table></td></tr> \n");
	                        }
	                        sb.append("<tr><td valign=top ><table width=780 border=0 cellspacing=0 cellpadding=0>");
	                        sb.append("<tr><td height=30  class=\"sMenu_2nd\" colspan=\"2\">");
	                        sb.append("&nbsp;&nbsp;<strong>" + mncd.prnMenu + "</strong></td></tr>\n");
	                    }else{
	                    	brcount++;
		                    sb.append("<td colspan=\"2\" style=\"vertical-align:top;padding:10px 0 10px 10px\" nowrap>");
		                    sb.append("<table border=0 width=140 style=\"border:solid 1px #ddd;padding-bottom:10px;\" cellspacing=0 cellpadding=0 ><tr ><td  class=\"sMap_3rd\" >");
		                    sb.append("&nbsp;" + mncd.prnMenu + "</td>");
		                    sb.append("</tr><tr><td>" );
		                    sb.append(writeMenu(vc ,mncd.FCODE ,selfID,webUserID));
		                    sb.append("</td></tr></table>" );
		                	if(brcount % 5 == 0)
		                		 sb.append("<tr>" );

	                    }

	                    if(depth ==1 || depth ==2){
		                    sb.append("<td > \n");
		                    sb.append("<table width=780 border=0 cellspacing=\"0\" cellpadding=\"0\"> \n");
		                    sb.append("<tr>" );
		                    sb.append(writeMenu(vc ,mncd.FCODE ,selfID,webUserID));
		                    sb.append("</tr>" );
		                    sb.append("</table> \n" );
		                    sb.append("</td></tr> \n");
	                    }else{

	                    }
	                } else if (mncd.menuClsf.equals("02") && mncd.isDisplay) {
	                    order ++;
	                    String mcode = mncd.HLFCDFCODE;
                      //@v1.1  admin 화면에서는 ehr메뉴사용
                      if ( ep_FALG.equals("NO") || (webUserID.equals("EADMIN") || webUserID.equals("EMANAG") )){
                    	  if(mncd.pgDetail.realPath.equals("/servlet/")){  // 하위 메뉴가 없을경우 처리해 준다.
                    		  sb.append("<table border=0 width=155><tr ><td  style=\"border:solid 1px #ddd;padding-bottom:10px;\" class=\"sMap_3rd\" >");
                    		  sb.append("&nbsp;"+strGubun+"<a href=\"javascript:parent.left.openDoc('" + mncd.FCODE  + "');parent.left.hideIMG('" + mncd.FCODE  + "')\" >" + mncd.prnMenu + "</a><br>" );
                    		  sb.append("</td></tr><tr><td height=10></td></tr></table>" );
                    	  }else{

                          	sb.append(""+strGubun+"<div class=\"sMap_4th\"><a href=\"javascript:parent.left.openDoc('" +mcode  + "');parent.left.hideIMG('" +mcode  + "')\" >" + mncd.prnMenu + "</a></div>" );
                          	if(mcode != ""){
                          		for(int m = 0 ; m < excpMenu.length ; m ++){
                          			if(mcode.equals(excpMenu[m])){
                          				sb.append("<br>" );
                          			}
                          		}
                          	}
                    	  }
                      }else{

                          sb.append( ""+strGubun+"<div class=\"sMap_4th\"><a href=\"javascript:parent.left.openDoc('" +mcode  + "');parent.left.hideIMG('" +mcode  + "')\" >" + mncd.prnMenu +"</a></div>" );
                          if(mcode != ""){
                        		for(int m = 0 ; m < excpMenu.length ; m ++){
                        			if(mcode.equals(excpMenu[m])){
                        				sb.append("<br>" );
                        			}
                        		}
                        	}
                      }
	                    if(order==14 ){
	                        sb.append("</tr>" );
	                    }
	                    docCount ++;
	                } // end if
                } // end if
            } // end if
        } // end for
        depth --;
        return sb.toString();
    }
%>
<%  //@v1.1
    WebUserData user = WebUtil.getSessionUser(request);
    String webUserID = "";
    if (user.webUserId == null ||user.webUserId.equals("") )
        webUserID = "";
    else
        webUserID = user.webUserId.substring(0,6).toUpperCase();

    Vector vcOMenuCodeData = (Vector)request.getAttribute("vcMeneCodeData");


    Config conf = new Configuration();

    StringBuffer portalServer = new StringBuffer(conf.get("portal.serverUrl"));

%>

<html>
<head>

<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/snsscript.js"></script>

<link rel="stylesheet" href="http://nabiro.eduhansol.co.kr/css/left.css" type="text/css">
<link rel="stylesheet" href="http://nabiro.eduhansol.co.kr/css/default.css" type="text/css">
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr1.css" type="text/css">
<title>MSS</title>

<script language="javascript">
    //@v1.1 start
    var epUrl = new Array("","","","","");
    ////인사정보
    //epUrl[0]= "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRInfo_2_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRInfoMenu%2Fbegin&_windowLabel=portlet_EHRInfo_2&_pageLabel=Menu03_Book01_Page01&portlet_EHRInfo_2url=";
    ////신청
    //epUrl[1]= "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_eHRApplyMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApplyMenu%2Fbegin&_windowLabel=portlet_eHRApplyMenu_1&_pageLabel=Menu03_Book02_Page01&portlet_eHRApplyMenu_1url=";
    ////사원인사정보
    //epUrl[2]= "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHREmpInfoMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHREmpInfoMenu%2Fbegin&_windowLabel=portlet_EHREmpInfoMenu_1&_pageLabel=Menu03_Book03_Page01&portlet_EHREmpInfoMenu_1url=";
    ////조직통계
    //epUrl[3]= "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHROrgStatMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHROrgStatMenu%2Fbegin&_windowLabel=portlet_EHROrgStatMenu_1&_pageLabel=Menu03_Book04_Page01&portlet_EHROrgStatMenu_1url=";
    ////결재함
    //epUrl[4]= "http://portal.lgchem.com/epWeb/appmanager/portal/desktop_lgch?_nfpb=true&portlet_EHRApprovalMenu_1_actionOverride=%2Fpageflow%2Fcom%2Flgchem%2Fep%2Fpbs%2Finform%2Fehrs%2FEHRApprovalMenu%2Fbegin&_windowLabel=portlet_EHRApprovalMenu_1&_pageLabel=Menu03_Book05_Page01&portlet_EHRApprovalMenu_1url=";

    //운영
    //인사정보
    epUrl[0]= "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrInfo&url=";
    //신청
    epUrl[1]= "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApply&url=";
    //사원인사정보
    epUrl[2]= "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrEmpInfo&url=";
    //조직통계
    epUrl[3]= "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrOrgStat&url=";
    //결재함
    epUrl[4]= "http://<%=portalServer%>/portal/lgchemMenu/lgchemHrMenu.do?menu=hrApproval&url=";



    var docUpid = new Array("0_1006","0_1254","0_1088","0_1089","0_1090","0_1091","0_1092","0_1285","1_1007","1_1066","1_1134","1_1163","1_1168","1_1222","1_1281","2_1033","2_1053","2_1056","2_1060","2_1063","3_1094","3_1137","3_1138","3_1139","3_1140","3_1141","3_1299","3_1300","4_1003");
    //중간그룹추가시 추가 해야함

    function openDoc(docID, upID, realPath)
    {
        var epReturnUrl = "";
        for (r=0;r<docUpid.length;r++) {
           if (upID == docUpid[r].substring(2,6)) {
              epReturnUrl = epUrl[docUpid[r].substring(0,1)]+realPath;
           }
        }
        //alert("rela:"+epReturnUrl);

        if (docID == "1281")
            clickDoc2(docID,epReturnUrl); //퇴직정리신청
        else
            clickDoc(docID,epReturnUrl);

    }
    function clickDoc(docID,epReturnUrl)
    {
       frm = document.tssform;
      // var lDoc = eval("doc" + docID);
       frm.action = epReturnUrl;
       //alert("a:"+this.name+"top.frames0:"+top.frames[0].name);
       //frm.target = "main_ess";
      //top.frames[0].location.href =epReturnUrl;
       frm.target = "_parent";
       //top.frames['Main'].location.href
       frm.submit();

    } // end function

    function clickDoc2(docID)
    {
       frm = document.tssform;
       var lDoc ='<%=user.e_mail.substring(0,user.e_mail.lastIndexOf("@"))%>';
     <% //if (user.SServer != "") { %>
       var SServer = '<%=user.SServer%>';
     <%// } else { %>
       var SServer = 'mail2.lgchem.com';
     <% //} %>
       frm.action ="http://" + SServer + "/portal.nsf/splitFrame?readform&expand=n&type=T&node=14&menu=업무지원&content=http://eloffice.lgchem.com:8002/intra/owa/neloinit.quick?p_user=" + lDoc + "&p_port=8002&p_svr_name=" + SServer + "&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";
       frm.target = "New";
       frm.submit();

    } // end function
    //@v1.1 end
</script>

</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
  <table width="846" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="830" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>

              <table width="780" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td height="5" colspan="2"></td>
                </tr>
                <tr>
                  <td class="title02"><img src="<%= WebUtil.ImageURL %>ehr/title01.gif">사이트맵</td>
                  <td class="titleRight"><a href="javascript:open_help('contents.html');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','<%= WebUtil.ImageURL %>btn_help_on.gif',1)"></a>
                  </td>
                </tr>
              </table>

            </td>
          </tr>
          <tr>
          	<td style="height:15px;"></td>
          </tr>

	      <tr>
	        <td valign="top" class="tr01">
		      <table width="760" border="0" cellspacing="0" cellpadding="0">
			    <%=writeMenu(vcOMenuCodeData ,"1000" ,"",webUserID)%>
		      </table>
		    </td>
	      </tr>

	      <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
<form name="tssform" method="post">
<input type="hidden" name="menuCount" value="<%=menuCount%>">
<input type="hidden" name="docCount" value="<%=docCount%>">
<%
    docCount = 0;
    menuCount = 0;
%>
</form>
<form name="aa" method="post">
<input type="hidden" name="aa" value="97">
</form>
</body>
</html>
--%>
