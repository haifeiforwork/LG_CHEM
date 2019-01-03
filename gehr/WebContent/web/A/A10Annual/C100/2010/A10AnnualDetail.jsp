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
/*   Update       : 2006-03-17  @v1.1 lsa 급여작업으로 막음                     */
/*                              @v1.2 lsa 문구변경                              */
/*                  2006-05-17  @v1.1 lsa 5월급여작업으로 막음  전문기술직만    */
/*                  2006-06-16  @v1.1 kdy 임금인상관련 급여화면 제어            */
/*                  2007-06-20  @v1.3 합의프로세스추가(년도별로 합의한 문서내용 보관:년도별디렉토리를 생성하여 처리)      */
/*                              2008년 이후부터 년도별로 디렉토리 생성후 이전년도 소스를 복사하여 만들어서 수정하여야 함  */
/*                              대상 위치: /ehr/hris/dev_hris/web/A/A10Annual/C100/2008 ~ /A10AnnualDetail.jsp 및 이미지  */
/*                              기준     : 년도 */
/*					  : 2018-03-09 cykim  [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件   */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.Vector" %>
<%@ page import="com.sns.jdf.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.A.A10Annual.*" %>
<%@ page import="hris.A.A10Annual.rfc.*" %>
<%@ page import="hris.D.D05Mpay.rfc.*" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
    String ename = user.ename;
    String imgURL      = (String)request.getAttribute("imgURL");
    String ZYEAR       = (String)request.getAttribute("ZYEAR");

  	//[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start
    String type = (String)request.getParameter("type");

    String companyCode = user.companyCode;
    String empNo = user.empNo;

    if(type!=null && type.equals("M")){
        ename = user_m.ename;
        companyCode = user_m.companyCode;
        empNo = user_m.empNo;
    }
	//[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 end

    Vector A10AnnualData_vt  = (Vector)request.getAttribute("A10AnnualData_vt");
    boolean aFlag = true;
    String curYear = DataUtil.getCurrentYear();
    A10AnnualData data = (A10AnnualData)request.getAttribute("a10AnnualData");
    if( A10AnnualData_vt.size() > 0 ) {
        for( int i = 0 ; i < A10AnnualData_vt.size(); i++ ) {
            A10AnnualData adata = (A10AnnualData)A10AnnualData_vt.get(i);
            if ( adata.ZYEAR.equals( curYear ) ) {
                break;
            } else if ( adata.ZYEAR.equals(ZYEAR) ) {
                data = adata;
                break;
            }

            //if ( adata.ZYEAR.equals( curYear ) ) {
            //    break;
            //} else if ( Integer.parseInt(adata.ZYEAR) == (Integer.parseInt( curYear )-1) ) {
            //    data = adata;
            //    break;
            //} else if ( Integer.parseInt(adata.ZYEAR) < (Integer.parseInt( curYear )-1) ) {
            //    data = adata;  //임시추가
            //    //aFlag = false;
            //    break;
            //} else {
            //    aFlag = false;
            //    break;
            //}
        }
    }

    if ( Integer.parseInt(data.ZYEAR) < 2000) {
        aFlag = false;
    }

    //@v1.3 합의여부조회
    Vector              ret            = new Vector();

  	//[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start
    ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( empNo ,"1",data.ZYEAR , companyCode );
    //ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( user.empNo ,"1",data.ZYEAR ,user.companyCode );

    String AGRE_FLAG = (String)ret.get(0);
    String E_BETRG = (String)ret.get(1);

    double tmpInt;
    double BETRG;
    if ( AGRE_FLAG.equals("Y") ) {
         tmpInt = Double.parseDouble( E_BETRG);  //합의된 금액
         BETRG  = Double.parseDouble( E_BETRG);  //합의된 금액
    }
    else {
         tmpInt = Double.parseDouble( data.BETRG ); //급여의 기본년봉
         BETRG  = Double.parseDouble( data.BETRG ); //급여의 기본년봉
    }
    tmpInt = tmpInt/20;

    String msg     = (String)request.getAttribute("msg"); //@v1.3 합의여부

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery.blockUI.js?v1"></script>

<SCRIPT LANGUAGE="JavaScript">
    //@v1.2
    var roleAEmpno = new Array(
"00069845",
"00022213",
"00013755",
"00071216",
"00025955",
"00027717",
"00045227",
"00202575",
"00044527",
"00024628",
"00037743",
"00037336",
"00027223",
"00003273",
"00001410",
"00045044",
"00006837",
"00027426",
"00022143",
"00031188",
"00070098",
"00037947",
"00037961",
"00040655",
"00006983",
"00043713",
"00205577",
"00026885",
"00081012",
"00027108",
"00071753",
"00069655",
"00045102",
"00202336",
"00038722",
"00118178",
"00001383",
"00011646",
"00011574",
"00045305",
"00201241",
"00017396",
"00012863",
"00027277",
"00068899",
"00047588",
"00009864",
"00010188",
"00040106",
"00068246",
"00028112",
"00038417",
"00111537",
"00040642",
"00007173",
"00070359",
"00045507",
"00009504",
"00044905",
"00037916",
"00038283",
"00031378",
"00205464",
"00031465",
"00040759",
"00018485",
"00030622",
"00031204",
"00043614",
"00031550",
"00205526",
"00202469",
"00205668",
"00038966",
"00030309",
"00072222",
"00003724",
"00055854",
"00037424",
"00021964",
"00042306",
"00044569",
"00044504",
"00057374",
"00031284",
"00080101",
"00025216",
"00046656",
"00028052",
"00037613",
"00042387",
"00046624",
"00069671",
"00045764",
"00010086",
"00031640",
"00038096",
"00037758",
"00206204",
"00046422",
"00026753",
"00005038",
"00068594",
"00027438",
"00003913",
"00044893",
"00205776",
"00052796",
"00048806",
"00202451",
"00205802",
"00206582",
"00029197",
"00043410",
"00203586",
"00111482",
"00038575",
"00201376",
"00040135",
"00030319",
"00040674",
"00040152",
"00204291",
"00203594",
"00203570",
"00116560",
"00111090",
"00110924",
"00111027",
"00110280",
"00017856",
"00018064",
"00112648",
"00203591",
"00038254",
"00116534",
"00203585",
"00037603",
"00203647",
"00203582",
"00042319",
"00001396",
"00203771",
"00110358",
"00037668",
"00021197",
"00204021",
"00111144",
"00203589",
"00203982",
"00206373",
"00047979",
"00040919",
"00034920",
"00048314",
"00040876",
"00205344",
"00009633",
"00048838",
"00031133",
"00027034",
"00031146",
"00020755",
"00021383",
"00046523",
"00009445",
"00045014",
"00029549",
"00003157",
"00031201",
"00048854",
"00046526",
"00003476",
"00037704",
"00030524",
"00037466",
"00009721",
"00035346",
"00048705",
"00026824",
"00015907",
"00005500",
"00016592",
"00045142",
"00046552",
"00041788",
"00030931",
"00027092",
"00028240",
"00037642",
"00021572",
"00003361",
"00015965",
"00009748",
"00009546",
"00043657",
"00046578",
"00000973",
"00027018",
"00205952",
"00027077",
"00015859",
"00005343",
"00040064",
"00205980",
"00044588",
"00113888",
"00028615",
"00015663",
"00009473",
"00016679",
"00027989",
"00204134",
"00038733",
"00005194",
"00009561",
"00031080",
"00022981",
"00205969",
"00117332",
"00004843",
"00021687",
"00047574",
"00038734",
"00054968",
"00005036",
"00205484",
"00027164",
"00205469",
"00011280",
"00039245",
"00203561",
"00045894",
"00012809",
"00038049",
"00071783",
"00044688",
"00205938",
"00201915",
"00021546",
"00030041",
"00026738",
"00010743",
"00056759",
"00081024",
"00001221",
"00018676",
"00080262",
"00021267",
"00081023",
"00072209",
"00026927",
"00200137",
"00037525",
"00202452",
"00034949",
"00026826",
"00082835",
"00031064",
"00111617",
"00003926",
"00045012",
"00005656",
"00033816",
"00111168",
"00027325",
"00110752",
"00026797",
"00042348",
"00110740",
"00043325",
"00110659",
"00040929",
"00017424",
"00110438",
"00035115",
"00006994",
"00043465",
"00005643",
"00010205",
"00023105",
"00038995",
"00017335",
"00046207",
"00046392",
"00036424",
"00043628",
"00025708",
"00203777",
"00111193",
"00203580",
"00203593",
"00203573",
"00203592",
"00044344",
"00203563",
"00203571",
"00203612",
"00203565",
"00203569",
"00001295",
"00200611",
"00072384",
"00048679",
"00025968",
"00001353",
"00069498",
"00030119",
"00205498",
"00202454",
"00202103",
"00006808",
"00025489",
"00205958",
"00012564",
"00040994",
"00200942",
"00030025",
"00080078",
"00203318",
"00027122",
"00001093",
"00038037",
"00201933",
"00203009",
"00200890",
"00061051",
"00206619",
"00206647",
"00017019",
"00011177",
"00048317",
"00080667",
"00080231",
"00080780",
"00017035",
"00080682",
"00080799",
"00020235",
"00080696",
"00000913",
"00080969",
"00080801",
"00041096",
"00082574",
"00080644",
"00031096",
"00004484",
"00203928",
"00036004",
"00039187",
"00080842",
"00031471",
"00038693",
"00037267",
"00022167",
"00043797",
"00043683",
"00081008",
"00080510",
"00048907",
"00080019",
"00071897",
"00080805",
"00206182",
"00080118",
"00203152",
"00202227",
"00080584",
"00070375",
"00200653",
"00080058",
"00071479",
"00037597",
"00071712",
"00203276",
"00080996",
"00201386",
"00018152",
"00018315",
"00110082",
"00203587",
"00003748",
"00030755",
"00203566",
"00040906",
"00016984",
"00015878",
"00007814",
"00037567",
"00027383",
"00027396",
"00006882",
"00007146",
"00029565",
"00031110",
"00027817",
"00044979",
"00030287",
"00016073",
"00045298",
"00048372",
"00115620",
"00025397",
"00041808",
"00037886",
"00017309",
"00205631",
"00017248",
"00038244",
"00030178",
"00014774",
"00015875",
"00018383",
"00203564",
"00037815",
"00203567",
"00056775",
"00037629",
"00014176",
"00206477",
"00080798",
"00027466",
"00068564",
"00047924" );

    function f_print(){
        self.print();
    }
    //@v1.2
    function firstHideshow() {
       var flag;
       for (r=0;r< roleAEmpno.length;r++) {
    	  //[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件  empNo
          <%-- if ("<%=user.empNo%>" == roleAEmpno[r]) { --%>
          if ("<%=empNo%>" == roleAEmpno[r]) {
              flag = "role";
          }
       }
       <% if ( aFlag == true ) {  %>
       //[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start
       if (flag == "role") {
           $("#role, #role_1, #role_h").show();
       } else {
           $("#normal, #normal_1, #normal_h").show();
       }

       /* if (flag == "role") {
           role.style.display = "block";
           role_1.style.display = "block";
           role_h.style.display = "block";
       }
       else {
           normal.style.display = "block";
           normal_1.style.display = "block";
           normal_h.style.display = "block";
       } */
       //[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 end
       <% } %>
    }


</SCRIPT>
</head>

<% //@v1.1
  String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user.empNo );

  if (O_CHECK_FLAG.equals("N") ) {
%>
<body  bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center">
                           <font color="red"face="굴림, 굴림체" size="-1">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                    </table>
<% } else {  //@v1.1
%>

<body onLoad="javascript:firstHideshow(); if ('<%=msg%>' != '' &&  '<%=msg%>' != 'null' ) alert('<%=msg%>');" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()">

<%
     if ( aFlag == true ) {  %>
<table width="624" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td>
      <table width="624" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="<%= imgURL %>img_logo_hwahak.gif"></td>
          <td align="right"><img src="<%= imgURL %>img_addr_hwahak.gif"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td align="center">
      <table width="450" border="0" cellspacing="2" cellpadding="0">
        <tr>
          <td align="center"><font face="굴림, 굴림체" size="5"><b><u>年 俸 契 約 書</u></b></font></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="style01">
            <table width="360" border="0" cellspacing="0" cellpadding="0" align="center">
              <tr id="normal_h" style="display:none" >
                <td class="style01">(주)LG화학과 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= data.BEGDA.substring(0,4) %>年 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>月 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>日부터
                  <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지 적용되는<br>
                  <%= data.TITEL %> <%= ename %>의 年俸을 다음과 같이 契約한다.</td>
              </tr>
              <tr id="role_h" style="display:none" >
                <td class="style01">(주)LG화학과 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= data.BEGDA.substring(0,4) %>年 3月 1日부터
                  <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지 적용되는<br>
                  <%= data.TITEL %> <%= ename %>의 年俸을 다음과 같이 契約한다.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td align="center"><font face="굴림, 굴림체" size="2">- 다 음 -</font></td>
        </tr>
        <tr>
          <td>
            <table width="300" border="1" cellspacing="0" cellpadding="5" align="center" bordercolor="#999999">
              <tr align="center">
                <td class="style01" width="138"><%= data.ZYEAR %>年 基本年俸</td>
                <td class="style01" width="137">基本年俸 月割分</td>
              </tr>
              <tr align="center">
             <!--   <td class="style01"><%= WebUtil.printNumFormat(data.BETRG) %></td>-->
                <td class="style01"><%= WebUtil.printNumFormat(BETRG) %></td>
                <td class="style01"><%= WebUtil.printNumFormat(tmpInt+"") %></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="397" border="0" cellspacing="0" cellpadding="2" align="center">
              <tr id="normal_1" style="display:none" >
                <td width="10" class="style01">①</td>
                <td class="style01">상기 基本年俸은 <%= data.BEGDA.substring(0,4) %>年 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>月 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>日부터 <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지</td>
              </tr>
              <tr id="role_1" style="display:none" >
                <td width="10" class="style01">①</td>
                <td class="style01">상기 基本年俸은 <%= data.BEGDA.substring(0,4) %>年 3月 1日부터 <%= data.ENDDA.substring(0,4) %>年 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>月 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>日까지</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">③항의 약정된 지급일에 「基本年俸 月割分」으로 지급된다.</td>
              </tr>
              <tr>
                <td class="style01" valign=top>②</td>
                <td class="style01">基本年俸은 사무직 근로형태의 특성을 감안, 월평균 시간외 근로를 <br>포함하여 포괄 산정한 금액이다.</td>
              </tr>
              <tr>
                <td class="style01">③</td>
                <td class="style01">基本年俸 지급방법은 『基本年俸÷20』을 「基本年俸 月割分」으로</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">산정한 후, 매월 25일과 짝수월 25일, 설날, 추석에 「基本年俸 </td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">月割分」을 각각 지급한다.</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">※ 중도입사자의 짝수월 25일, 설날, 추석에 지급되는 「基本年俸</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">&nbsp;&nbsp;&nbsp;&nbsp;月割分」에 대해서는 별도 기준에 따름.</td>
              </tr>
              <tr id="normal" style="display:none" >
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 職務, 資格, 기타 수당은 별도 기준에 따라 <br>지급한다.</td>
              </tr>
              <tr id="role" style="display:none" >
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 役割給 및 그 외 職務, 資格, 기타 수당은<br>별도 기준에 따라 지급한다.</td>
              </tr>
              <tr>
                <td class="style01">⑤</td>
                <td class="style01">여사원이 月 1일 보건(생리)휴가 청구 시, 「基本年俸 月割分」의</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">「日割分(基本年俸 月割分/근태일수)」을 공제한다.</td>
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
                <td class="style01">⑦</td>
                <td class="style01">基本年俸을 제3자에게 이야기해서는 안된다.</td>
              </tr>
              <tr>
                <td class="style01">⑧</td>
                <td class="style01">기타사항은 就業規則과 勤勞基準法에 따른다.</td>
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
                <td width="361" valign=bottom><img src="<%= imgURL %>img_sign_kbs.gif"></td>
                <td align="left" >
                  <table width="120" border="0" cellspacing="0" cellpadding="0" align="right">
                    <tr>
                      <td align="center" width="120" class="style01">(주)LG화학<br>
                        <%= data.ORGTX %><br>
                        <%= ename %>&nbsp;&nbsp;&nbsp;(印)</td>
<%       if ( AGRE_FLAG.equals("Y") ) {  %>
                      <td align="center"><img src="<%= WebUtil.ImageURL %>btn_agreeYes.gif" border="0">
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
    //if ( Integer.parseInt(data.ZYEAR) >= 2008 && !AGRE_FLAG.equals("Y") ) {
    if ( !AGRE_FLAG.equals("Y") ) {
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
%>

      </table>
    </td>
  </tr>
</table>

<%  } else {  %>

<table width="624" border="0" cellspacing="2" cellpadding="0">
    <tr>
      <td width="16">&nbsp;</td>
      <td>
        <table width="600"  border="0" cellspacing="1" cellpadding="0">
          <tr align="center">
                  <td class="td04"> <br><br>해당하는 데이타가 없습니다.</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<%  }%>

<% } //@v1.1 end %>
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