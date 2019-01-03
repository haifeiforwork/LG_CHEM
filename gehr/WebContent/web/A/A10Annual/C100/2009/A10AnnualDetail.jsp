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
    String ename = user.ename;
    String imgURL      = (String)request.getAttribute("imgURL");
    String ZYEAR       = (String)request.getAttribute("ZYEAR");

  	//[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start
    WebUserData user_m = WebUtil.getSessionMSSUser(request);
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
"00022213",
"00003748",
"00007814",
"00014176",
"00015474",
"00015878",
"00016984",
"00022143",
"00027383",
"00027396",
"00027455",
"00027579",
"00030696",
"00030755",
"00035037",
"00040906",
"00045044",
"00203560",
"00203566",
"00203587",
"00026927",
"00043410",
"00052796",
"00069845",
"00006882",
"00009864",
"00010844",
"00012863",
"00015859",
"00027484",
"00027817",
"00029565",
"00030973",
"00031110",
"00045298",
"00051969",
"00003836",
"00008603",
"00009472",
"00013755",
"00014774",
"00015644",
"00015875",
"00016073",
"00017309",
"00018383",
"00020868",
"00021656",
"00023293",
"00029823",
"00030287",
"00035008",
"00035301",
"00037815",
"00041808",
"00048372",
"00049610",
"00057473",
"00110082",
"00115620",
"00201910",
"00203564",
"00205663",
"00003447",
"00003689",
"00003867",
"00018089",
"00023248",
"00024657",
"00030086",
"00038228",
"00043787",
"00066367",
"00003305",
"00037962",
"00040674",
"00071216",
"00000973",
"00001093",
"00001206",
"00001221",
"00001295",
"00001353",
"00001396",
"00001410",
"00003157",
"00003258",
"00003347",
"00003361",
"00003404",
"00003476",
"00003724",
"00003913",
"00003926",
"00004843",
"00004873",
"00005038",
"00005194",
"00005343",
"00005500",
"00005539",
"00005643",
"00005656",
"00005718",
"00006708",
"00006808",
"00006994",
"00007057",
"00007073",
"00007146",
"00007173",
"00007233",
"00007262",
"00007552",
"00007582",
"00007594",
"00007957",
"00007972",
"00008122",
"00008123",
"00008311",
"00009445",
"00009473",
"00009504",
"00009561",
"00009633",
"00009721",
"00009748",
"00009823",
"00009836",
"00009993",
"00010002",
"00010086",
"00010132",
"00010188",
"00010205",
"00010234",
"00010247",
"00010743",
"00011280",
"00012564",
"00012775",
"00012809",
"00012864",
"00012892",
"00014625",
"00014716",
"00015663",
"00015907",
"00015965",
"00016071",
"00016157",
"00016679",
"00017019",
"00017146",
"00017335",
"00017424",
"00017494",
"00017856",
"00018064",
"00018485",
"00018676",
"00019141",
"00020697",
"00021197",
"00021267",
"00021383",
"00021546",
"00021572",
"00021687",
"00021964",
"00022752",
"00022807",
"00022981",
"00023105",
"00024628",
"00025014",
"00025216",
"00025388",
"00025397",
"00025708",
"00025809",
"00025955",
"00026753",
"00026797",
"00026812",
"00026883",
"00026885",
"00026956",
"00026998",
"00027018",
"00027077",
"00027108",
"00027164",
"00027193",
"00027277",
"00027325",
"00027438",
"00027717",
"00027989",
"00028196",
"00028240",
"00028615",
"00029197",
"00029507",
"00029549",
"00029985",
"00030029",
"00030041",
"00030064",
"00030178",
"00030309",
"00030319",
"00030524",
"00030595",
"00030622",
"00030699",
"00030787",
"00030931",
"00030960",
"00031064",
"00031068",
"00031080",
"00031133",
"00031146",
"00031201",
"00031284",
"00031465",
"00031641",
"00033816",
"00034151",
"00034154",
"00034920",
"00034949",
"00034994",
"00035024",
"00035115",
"00035346",
"00036424",
"00037336",
"00037424",
"00037427",
"00037466",
"00037525",
"00037557",
"00037567",
"00037596",
"00037603",
"00037613",
"00037629",
"00037668",
"00037704",
"00037714",
"00037743",
"00037746",
"00037758",
"00037857",
"00037886",
"00037916",
"00037958",
"00037961",
"00038039",
"00038049",
"00038081",
"00038094",
"00038126",
"00038244",
"00038254",
"00038283",
"00038417",
"00038444",
"00038575",
"00038733",
"00038734",
"00038822",
"00038995",
"00039245",
"00040064",
"00040106",
"00040135",
"00040152",
"00040642",
"00040671",
"00040759",
"00040876",
"00040919",
"00040929",
"00040994",
"00041519",
"00041788",
"00041895",
"00042306",
"00042319",
"00042335",
"00042348",
"00042387",
"00042417",
"00042446",
"00043250",
"00043292",
"00043325",
"00043465",
"00043511",
"00043628",
"00043657",
"00043713",
"00044344",
"00044504",
"00044527",
"00044569",
"00044588",
"00044688",
"00044905",
"00044966",
"00044976",
"00044979",
"00045012",
"00045096",
"00045103",
"00045142",
"00045144",
"00045156",
"00045227",
"00045287",
"00045507",
"00045764",
"00045793",
"00045852",
"00045884",
"00045894",
"00046207",
"00046392",
"00046422",
"00046523",
"00046526",
"00046552",
"00046578",
"00046608",
"00046624",
"00046656",
"00047574",
"00048203",
"00048242",
"00048314",
"00048679",
"00048705",
"00048789",
"00048806",
"00048838",
"00048854",
"00054968",
"00055854",
"00056759",
"00056775",
"00057374",
"00061051",
"00068594",
"00069671",
"00070359",
"00071783",
"00072209",
"00072222",
"00080101",
"00080262",
"00081012",
"00081023",
"00081024",
"00082835",
"00110280",
"00110358",
"00110659",
"00110740",
"00110752",
"00110924",
"00110936",
"00111090",
"00111168",
"00111482",
"00111550",
"00111617",
"00112648",
"00113888",
"00116534",
"00116560",
"00117332",
"00200137",
"00200942",
"00201915",
"00202336",
"00202451",
"00202452",
"00202469",
"00203009",
"00203214",
"00203561",
"00203563",
"00203565",
"00203567",
"00203568",
"00203570",
"00203571",
"00203580",
"00203582",
"00203585",
"00203586",
"00203588",
"00203589",
"00203591",
"00203592",
"00203593",
"00203594",
"00203598",
"00203612",
"00203647",
"00203685",
"00203771",
"00203777",
"00203982",
"00204134",
"00204291",
"00205344",
"00205484",
"00205498",
"00205499",
"00205526",
"00205577",
"00205631",
"00205938",
"00205952",
"00205969",
"00205980",
"00206373",
"00206374",
"00111537",
"00028112",
"00003273",
"00018384",
"00070098",
"00001383",
"00003912",
"00006837",
"00006983",
"00009270",
"00009851",
"00011646",
"00017248",
"00020755",
"00025476",
"00026971",
"00027223",
"00027426",
"00037947",
"00040655",
"00044775",
"00045102",
"00118178",
"00009878",
"00010364",
"00026683",
"00037932",
"00040889",
"00042390",
"00045839",
"00046288",
"00000913",
"00004484",
"00005441",
"00006154",
"00011177",
"00016624",
"00017035",
"00018315",
"00020235",
"00022167",
"00030224",
"00031096",
"00031471",
"00036004",
"00037267",
"00037597",
"00038693",
"00040003",
"00041096",
"00043683",
"00043797",
"00045139",
"00048317",
"00048907",
"00070375",
"00071479",
"00071712",
"00071897",
"00080019",
"00080058",
"00080231",
"00080429",
"00080510",
"00080584",
"00080644",
"00080667",
"00080682",
"00080696",
"00080780",
"00080799",
"00080801",
"00080805",
"00080821",
"00080842",
"00080969",
"00080996",
"00082574",
"00200149",
"00200653",
"00201234",
"00202470",
"00202590",
"00202596",
"00203152",
"00203244",
"00203502",
"00203928",
"00205439",
"00206182",
"00017396",
"00045305",
"00201241");

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
       //[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件
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

<body onLoad="javascript:firstHideshow(); if ('<%=msg%>' != '' &&  '<%=msg%>' != 'null' ) alert('<%=msg%>');" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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