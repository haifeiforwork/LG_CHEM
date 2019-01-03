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
    double monBasic;
    double bonusMon;
    double seasonBous;
    if ( AGRE_FLAG.equals("Y") ) {
         tmpInt = Double.parseDouble( E_BETRG);  //합의된 금액
         BETRG  = Double.parseDouble( E_BETRG);  //합의된 금액
    }
    else {
         tmpInt = Double.parseDouble( data.BETRG ); //급여의 기본년봉
         BETRG  = Double.parseDouble( data.BETRG ); //급여의 기본년봉
    }
    monBasic = tmpInt/20;
    bonusMon = tmpInt/40;
    seasonBous = tmpInt/20;

    String msg     = (String)request.getAttribute("msg"); //@v1.3 합의여부

%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
    //@v1.2
    var roleAEmpno = new Array(
"00029197",
"00209502",
"00011280",
"00005500",
"00022167",
"00005343",
"00015663",
"00016679",
"00023105",
"00027325",
"00027077",
"00027426",
"00026797",
"00029565",
"00030319",
"00030309",
"00031471",
"00030367",
"00031110",
"00030224",
"00206365",
"00028615",
"00028240",
"00034920",
"00035115",
"00038254",
"00037267",
"00037704",
"00038417",
"00038283",
"00037603",
"00037336",
"00037668",
"00037642",
"00038693",
"00038733",
"00039420",
"00040919",
"00040759",
"00040876",
"00203563",
"00041788",
"00042348",
"00042306",
"00203565",
"00042387",
"00043410",
"00043797",
"00043325",
"00043628",
"00043657",
"00043683",
"00044569",
"00044615",
"00045012",
"00044905",
"00044995",
"00045227",
"00045142",
"00046526",
"00110438",
"00046207",
"00046624",
"00046643",
"00045764",
"00046578",
"00046656",
"00045621",
"00046523",
"00045507",
"00046392",
"00046552",
"00045305",
"00110659",
"00047574",
"00110740",
"00110752",
"00048705",
"00048838",
"00048854",
"00111027",
"00003273",
"00206373",
"00003564",
"00003476",
"00003926",
"00203598",
"00003361",
"00111156",
"00111090",
"00111144",
"00005194",
"00005052",
"00004843",
"00004798",
"00004684",
"00111168",
"00111193",
"00111537",
"00006983",
"00006837",
"00006865",
"00006808",
"00008123",
"00112648",
"00010205",
"00009546",
"00009504",
"00009633",
"00010377",
"00206366",
"00009748",
"00009561",
"00009721",
"00009705",
"00009445",
"00009473",
"00009764",
"00209459",
"00009864",
"00113888",
"00113968",
"00113956",
"00113993",
"00116560",
"00115005",
"00040152",
"00015964",
"00015965",
"00016592",
"00018064",
"00017424",
"00017856",
"00020235",
"00022778",
"00022143",
"00021383",
"00021572",
"00018396",
"00021964",
"00027164",
"00026753",
"00027236",
"00027018",
"00026738",
"00027223",
"00027163",
"00026927",
"00027034",
"00027092",
"00026826",
"00027122",
"00028213",
"00028112",
"00028052",
"00027438",
"00027466",
"00031284",
"00040135",
"00034224",
"00037107",
"00037597",
"00211576",
"00040106",
"00039187",
"00039233",
"00038588",
"00037758",
"00038995",
"00037947",
"00038734",
"00038096",
"00038517",
"00038575",
"00037888",
"00038966",
"00038851",
"00039001",
"00038722",
"00038024",
"00038037",
"00044688",
"00045014",
"00044775",
"00045055",
"00045156",
"00045102",
"00117436",
"00025955",
"00025665",
"00028329",
"00025708",
"00025968",
"00024789",
"00025128",
"00022044",
"00025779",
"00025489",
"00036395",
"00036627",
"00029667",
"00040747",
"00041476",
"00040994",
"00000913",
"00117682",
"00001410",
"00005487",
"00001396",
"00001221",
"00005328",
"00001104",
"00001295",
"00001367",
"00004905",
"00001191",
"00008574",
"00005357",
"00001093",
"00001252",
"00001223",
"00001426",
"00001412",
"00117830",
"00117749",
"00012809",
"00011415",
"00011154",
"00012157",
"00011646",
"00011574",
"00012564",
"00012854",
"00019275",
"00017396",
"00118210",
"00055854",
"00018166",
"00017729",
"00047979",
"00052814",
"00054968",
"00053077",
"00048679",
"00054027",
"00047924",
"00055088",
"00052858",
"00053064",
"00051709",
"00018315",
"00053005",
"00054577",
"00048826",
"00118302",
"00051983",
"00048129",
"00047995",
"00054128",
"00047588",
"00018054",
"00018605",
"00056759",
"00056717",
"00056586",
"00069655",
"00069425",
"00069584",
"00069498",
"00212710",
"00061013",
"00061016",
"00060923",
"00060026",
"00071712",
"00066325",
"00071753",
"00066311",
"00004439",
"00004484",
"00043469",
"00068536",
"00068564",
"00072033",
"00071897",
"00068783",
"00068714",
"00068756",
"00068782",
"00068785",
"00068766",
"00068724",
"00068899",
"00069076",
"00072324",
"00072412",
"00072384",
"00083692",
"00072496",
"00072355",
"00083675",
"00072425",
"00070085",
"00072397",
"00083678",
"00070157",
"00070227",
"00082835",
"00071232",
"00202454",
"00079239",
"00080019",
"00080058",
"00080078",
"00030129",
"00030119",
"00030285",
"00030172",
"00030270",
"00030181",
"00080176",
"00080161",
"00080165",
"00030103",
"00030125",
"00030111",
"00030182",
"00030157",
"00080231",
"00040026",
"00080240",
"00030379",
"00030404",
"00030471",
"00080295",
"00030574",
"00060103",
"00030607",
"00060320",
"00030747",
"00030675",
"00030694",
"00030669",
"00030766",
"00080399",
"00080411",
"00030799",
"00080493",
"00031003",
"00031146",
"00031133",
"00031188",
"00080510",
"00031204",
"00031337",
"00080650",
"00080551",
"00031304",
"00080661",
"00080667",
"00031378",
"00080682",
"00121211",
"00031435",
"00080699",
"00121225",
"00031451",
"00031465",
"00061051",
"00031491",
"00031493",
"00031509",
"00080732",
"00080740",
"00031550",
"00031552",
"00080780",
"00080778",
"00080798",
"00080808",
"00080805",
"00031640",
"00080842",
"00080829",
"00031691",
"00080969",
"00080976",
"00081008",
"00081012",
"00080996",
"00081020",
"00081023",
"00008516",
"00032023",
"00200053",
"00200137",
"00200254",
"00200381",
"00200382",
"00200387",
"00200482",
"00200583",
"00200616",
"00200491",
"00200614",
"00200652",
"00200658",
"00200687",
"00200700",
"00206429",
"00200892",
"00200890",
"00066297",
"00200851",
"00200912",
"00200919",
"00200942",
"00200989",
"00200990",
"00201190",
"00201376",
"00201387",
"00201658",
"00201875",
"00201762",
"00028518",
"00201791",
"00201886",
"00201915",
"00201933",
"00201935",
"00202103",
"00202227",
"00202469",
"00202442",
"00202350",
"00202499",
"00202574",
"00202609",
"00203150",
"00203149",
"00203274",
"00203276",
"00203269",
"00203318",
"00203337",
"00203346",
"00203345",
"00203313",
"00203505",
"00203529",
"00205192",
"00203591",
"00203592",
"00203585",
"00203594",
"00203571",
"00203570",
"00204134",
"00203593",
"00203569",
"00203573",
"00204291",
"00203982",
"00203777",
"00203603",
"00203589",
"00203612",
"00203572",
"00204021",
"00203622",
"00204097",
"00203590",
"00204175",
"00205309",
"00205316",
"00205344",
"00205353",
"00205443",
"00205482",
"00205498",
"00205682",
"00205786",
"00205793",
"00205796",
"00205827",
"00205832",
"00205938",
"00205929",
"00205980",
"00205952",
"00205969",
"00205950",
"00205953",
"00205948",
"00206204",
"00206416",
"00206431",
"00206443",
"00206477",
"00206582",
"00206584",
"00206591",
"00206628",
"00206647",
"00206650",
"00207104",
"00207275",
"00207555",
"00207982",
"00208038",
"00208045",
"00208165",
"00208167",
"00208951",
"00209491",
"00210199",
"00210710",
"00211629",
"00211824",
"00211825",
"00211835",
"00211855",
"00211889",
"00211905",
"00212097",
"00212851",
"00213555",
"00213554",
"00070098",
"00003748",
"00022981",
"00010743",
"00013755",
"00016073",
"00015878",
"00027383",
"00027396",
"00029549",
"00026824",
"00027989",
"00025397",
"00036424",
"00037613",
"00037916",
"00037567",
"00038244",
"00037815",
"00037961",
"00040906",
"00040655",
"00040929",
"00110358",
"00043465",
"00043713",
"00044344",
"00205577",
"00044979",
"00046539",
"00045298",
"00203586",
"00048372",
"00048806",
"00003724",
"00003913",
"00005036",
"00111617",
"00006882",
"00010188",
"00116534",
"00014176",
"00115620",
"00017248",
"00017335",
"00016984",
"00020755",
"00021687",
"00027277",
"00039245",
"00043614",
"00206949",
"00027108",
"00027717",
"00005038",
"00017309",
"00052796",
"00202452",
"00069671",
"00072209",
"00072222",
"00071216",
"00030041",
"00080262",
"00031201",
"00081024",
"00117332",
"00201241",
"00203564",
"00203580",
"00203567",
"00203771",
"00205469",
"00205484",
"00205802",
"00206619",
"00211822",
"00211820",
"00211823",
"00022213",
"00015587",
"00202334"
);

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
       if (flag == "role") {
           role.style.display = "block";
           role_1.style.display = "block";
           role_h.style.display = "block";
       }
       else {
           normal.style.display = "block";
           normal_1.style.display = "block";
           normal_h.style.display = "block";
       }
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
                           <font color="red">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
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
            <table width="440" border="1" cellspacing="0" cellpadding="5" align="center" bordercolor="#999999">
              <tr align="center">
                <td class="style01" width="140"><%= data.ZYEAR %>年 基本年俸</td>
                <td class="style01" width="100">月基本給</td>
                <td class="style01" width="100">賞與月割分</td>
                <td class="style01" width="100">名節賞與</td>
              </tr>
              <tr align="center">
             <!--   <td class="style01"><%= WebUtil.printNumFormat(data.BETRG) %></td>-->
                <td class="style01"><%= WebUtil.printNumFormat(BETRG) %></td>
                <td class="style01"><%= WebUtil.printNumFormat(monBasic+"") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(bonusMon+"") %></td>
                <td class="style01"><%= WebUtil.printNumFormat(seasonBous+"") %></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="500" border="0" cellspacing="0" cellpadding="2" align="center">
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
                <td class="style01">③항의 약정된 지급일에 「月基本給」과「賞與月割分」및「名節賞與」로  지급된다.</td>
              </tr>
              <tr>
                <td class="style01" valign=top>②</td>
                <td class="style01">基本年俸은 사무직 근로형태의 특성을 감안, 월평균 시간외 근로를 <br>포함하여 포괄 산정한 금액이다.</td>
              </tr>
              <tr>
                <td class="style01">③</td>
                <td class="style01">基本年俸 지급 방법은 「 月基本給 」과「賞與月割分」을 매월 25일에 </td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">각각 지급하며「名節賞與」 는 설, 추석에  각각 지급한다.</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">단, 중도입사자의 매월 25일에 지급되는 「 月基本給 」 과「賞與月割分」</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">및 설, 추석에 지급되는「名節賞與」에 대해서는 별도 기준에 따른다.</td>
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
                <td class="style01">여사원이 月1일 보건(생리)휴가 청구 시, 「月基本給」의</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">「日割分(月基本給/근태일수)」을 공제한다.</td>
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
                <td class="style01">年俸契約과 관련하여 제공받거나 알게 된 내용을 제3자에게 제공하거나</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">공개하여서는 아니된다.</td>
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
                  <table width="200" border="0" cellspacing="0" cellpadding="0" align="right">
                    <tr>
                      <td align="center" width="200" class="style01">(주)LG화학<br>
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