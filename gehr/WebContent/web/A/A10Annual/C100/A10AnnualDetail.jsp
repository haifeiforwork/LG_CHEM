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
/*                  2006-06-16 @v1.1 kdy 임금인상관련 급여화면 제어              */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.A.A10Annual.A10AnnualData" %>
<%@ page import="hris.D.D05Mpay.rfc.D05ScreenControlRFC" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.Vector" %>

<%
    WebUserData user = WebUtil.getSessionUser(request);
    String ename = user.ename;
    String imgURL      = (String)request.getAttribute("imgURL");

    Vector A10AnnualData_vt  = (Vector)request.getAttribute("A10AnnualData_vt");
    boolean aFlag = true;
    String curYear = DataUtil.getCurrentYear();
    A10AnnualData data = (A10AnnualData)request.getAttribute("a10AnnualData");
    if( A10AnnualData_vt.size() > 0 ) {
        for( int i = 0 ; i < A10AnnualData_vt.size(); i++ ) {
            A10AnnualData adata = (A10AnnualData)A10AnnualData_vt.get(i);

            if ( adata.ZYEAR.equals( curYear ) ) {
                break;
            } else if ( Integer.parseInt(adata.ZYEAR) == (Integer.parseInt( curYear )-1) ) {
                data = adata;
                break;
            } else if ( Integer.parseInt(adata.ZYEAR) < (Integer.parseInt( curYear )-1) ) {
                aFlag = false;
                break;
            } else {
                aFlag = false;
                break;
            }
        }
    }
    double tmpInt         = Double.parseDouble( data.BETRG );
    tmpInt = tmpInt/20;
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery.blockUI.js?v1"></script>

  <SCRIPT LANGUAGE="JavaScript">
    $(function () {
      $.unblockUI();
    });

    //@v1.2
    var roleAEmpno = new Array("00000913",
                               "00004468",
                               "00004484",
                               "00005195",
                               "00005441",
                               "00006154",
                               "00011177",
                               "00010927",
                               "00010754",
                               "00016624",
                               "00017266",
                               "00018849",
                               "00018315",
                               "00020235",
                               "00019116",
                               "00022167",
                               "00027453",
                               "00029319",
                               "00030224",
                               "00030367",
                               "00031096",
                               "00031471",
                               "00036004",
                               "00037267",
                               "00037554",
                               "00037597",
                               "00038693",
                               "00040003",
                               "00038983",
                               "00040153",
                               "00041096",
                               "00043797",
                               "00045139",
                               "00068564",
                               "00071525",
                               "00071479",
                               "00070375",
                               "00071884",
                               "00071712",
                               "00080231",
                               "00080118",
                               "00080019",
                               "00080471",
                               "00080429",
                               "00080425",
                               "00080696",
                               "00080667",
                               "00080644",
                               "00080584",
                               "00080510",
                               "00081008",
                               "00080966",
                               "00080842",
                               "00200653",
                               "00200394",
                               "00200149",
                               "00082574",
                               "00201888",
                               "00200698",
                               "00200671",
                               "00203214",
                               "00202469",
                               "00010205",
                               "00044688",
                               "00034920",
                               "00045507",
                               "00020755",
                               "00031146",
                               "00043465",
                               "00202097",
                               "00021964",
                               "00037916",
                               "00002025",
                               "00009270",
                               "00031110",
                               "00044182",
                               "00027223",
                               "00045028",
                               "00010552",
                               "00014595",
                               "00030178",
                               "00009892",
                               "00045305",
                               "00201241",
                               "00017396",
                               "00024657",
                               "00030086",
                               "00043787",
                               "00043755",
                               "00003447",
                               "00003867",
                               "00009822",
                               "00010276",
                               "00023248",
                               "00018089",
                               "00029507",
                               "00045298",
                               "00009663",
                               "00035346",
                               "00037962",
                               "00040674",
                               "00044588",
                               "00011280",
                               "00017019",
                               "00026912",
                               "00039245",
                               "00046608",
                               "00203598",
                               "00001410",
                               "00000973",
                               "00003360",
                               "00003347",
                               "00003273",
                               "00003258",
                               "00003724",
                               "00003361",
                               "00003913",
                               "00003811",
                               "00005036",
                               "00004974",
                               "00004871",
                               "00004843",
                               "00005337",
                               "00005052",
                               "00005038",
                               "00005571",
                               "00005539",
                               "00005500",
                               "00005343",
                               "00005962",
                               "00005718",
                               "00005675",
                               "00005656",
                               "00005643",
                               "00006994",
                               "00006882",
                               "00006808",
                               "00006708",
                               "00007552",
                               "00007173",
                               "00007146",
                               "00007073",
                               "00007057",
                               "00007972",
                               "00007957",
                               "00007814",
                               "00009456",
                               "00008122",
                               "00009851",
                               "00009662",
                               "00009504",
                               "00010002",
                               "00009993",
                               "00009894",
                               "00009864",
                               "00010188",
                               "00010132",
                               "00010117",
                               "00010086",
                               "00010743",
                               "00010364",
                               "00012892",
                               "00012864",
                               "00012775",
                               "00014703",
                               "00014644",
                               "00014625",
                               "00014615",
                               "00015575",
                               "00015474",
                               "00014989",
                               "00014716",
                               "00015663",
                               "00016071",
                               "00015918",
                               "00015907",
                               "00017146",
                               "00016996",
                               "00016679",
                               "00017335",
                               "00017309",
                               "00018064",
                               "00017856",
                               "00017494",
                               "00017424",
                               "00018878",
                               "00018676",
                               "00019593",
                               "00019577",
                               "00019141",
                               "00021197",
                               "00020697",
                               "00021687",
                               "00021572",
                               "00021546",
                               "00021267",
                               "00022143",
                               "00022055",
                               "00022011",
                               "00023105",
                               "00022981",
                               "00025397",
                               "00023293",
                               "00026812",
                               "00026228",
                               "00025708",
                               "00026927",
                               "00026909",
                               "00026885",
                               "00027193",
                               "00027177",
                               "00027164",
                               "00027077",
                               "00027006",
                               "00027325",
                               "00027277",
                               "00027439",
                               "00027426",
                               "00027396",
                               "00027989",
                               "00027717",
                               "00027579",
                               "00027569",
                               "00029197",
                               "00028615",
                               "00028240",
                               "00028196",
                               "00028112",
                               "00029565",
                               "00029549",
                               "00029494",
                               "00030029",
                               "00029985",
                               "00029953",
                               "00030287",
                               "00030276",
                               "00030266",
                               "00030595",
                               "00030524",
                               "00030319",
                               "00030787",
                               "00030716",
                               "00030699",
                               "00030999",
                               "00030960",
                               "00030931",
                               "00030856",
                               "00031133",
                               "00031080",
                               "00031064",
                               "00031284",
                               "00031201",
                               "00031188",
                               "00032765",
                               "00031641",
                               "00031640",
                               "00034949",
                               "00034154",
                               "00034151",
                               "00033816",
                               "00035037",
                               "00035024",
                               "00035011",
                               "00035008",
                               "00034994",
                               "00036424",
                               "00035301",
                               "00035115",
                               "00037394",
                               "00037336",
                               "00037293",
                               "00037124",
                               "00037525",
                               "00037466",
                               "00037427",
                               "00037424",
                               "00037613",
                               "00037567",
                               "00037557",
                               "00037743",
                               "00037727",
                               "00037714",
                               "00037668",
                               "00037629",
                               "00037886",
                               "00037857",
                               "00037815",
                               "00037758",
                               "00037746",
                               "00037961",
                               "00037958",
                               "00037947",
                               "00038096",
                               "00038094",
                               "00038081",
                               "00038049",
                               "00038039",
                               "00038300",
                               "00038283",
                               "00038254",
                               "00038244",
                               "00038228",
                               "00038734",
                               "00038733",
                               "00038575",
                               "00038417",
                               "00040106",
                               "00040064",
                               "00040642",
                               "00040597",
                               "00040152",
                               "00040135",
                               "00040759",
                               "00040929",
                               "00040919",
                               "00040906",
                               "00040899",
                               "00042319",
                               "00042306",
                               "00041895",
                               "00041808",
                               "00041788",
                               "00043250",
                               "00042390",
                               "00042387",
                               "00042348",
                               "00042335",
                               "00043410",
                               "00043325",
                               "00043292",
                               "00043739",
                               "00043713",
                               "00043628",
                               "00044527",
                               "00044344",
                               "00044995",
                               "00044979",
                               "00044966",
                               "00044905",
                               "00045103",
                               "00045096",
                               "00045044",
                               "00045025",
                               "00045287",
                               "00045142",
                               "00045796",
                               "00045793",
                               "00045764",
                               "00045487",
                               "00045883",
                               "00045852",
                               "00045839",
                               "00045813",
                               "00045807",
                               "00046288",
                               "00046278",
                               "00046207",
                               "00045894",
                               "00045884",
                               "00046578",
                               "00046526",
                               "00046523",
                               "00046422",
                               "00046392",
                               "00047574",
                               "00046656",
                               "00046624",
                               "00048838",
                               "00048705",
                               "00048314",
                               "00048242",
                               "00057374",
                               "00056775",
                               "00056759",
                               "00049610",
                               "00070098",
                               "00069845",
                               "00069671",
                               "00068899",
                               "00068594",
                               "00071216",
                               "00070359",
                               "00072209",
                               "00071795",
                               "00071783",
                               "00080101",
                               "00072254",
                               "00080407",
                               "00080262",
                               "00081024",
                               "00081023",
                               "00200137",
                               "00202452",
                               "00202451",
                               "00202126",
                               "00203536",
                               "00202453",
                               "00203563",
                               "00203562",
                               "00203561",
                               "00203570",
                               "00203568",
                               "00203567",
                               "00203566",
                               "00203565",
                               "00203582",
                               "00203581",
                               "00203580",
                               "00203579",
                               "00203571",
                               "00203592",
                               "00203591",
                               "00203585",
                               "00203610",
                               "00203594",
                               "00203593",
                               "00204134",
                               "00203928",
                               "00203647",
                               "00203612",
                               "00205499",
                               "00205484",
                               "00205344",
                               "00205186",
                               "00205526",
                               "00205504",
                               "00044569",
                               "00069655",
                               "00018384",
                               "00007582",
                               "00020868",
                               "00026683",
                               "00030064",
                               "00037596",
                               "00040889",
                               "00040671",
                               "00043511",
                               "00205001",
                               "00030696",
                               "00012863",
                               "00014348",
                               "00048372",
                               "00007926",
                               "00010844",
                               "00013843",
                               "00015878",
                               "00022213",
                               "00027455",
                               "00031159",
                               "00015859",
                               "00026824",
                               "00030973",
                               "00003445",
                               "00005311",
                               "00008603",
                               "00013755",
                               "00014774",
                               "00018383",
                               "00021065",
                               "00021656",
                               "00023088",
                               "00029823",
                               "00030194",
                               "00201910",
                               "00203560",
                               "00013097",
                               "00027484",
                               "00030306",
                               "00002211",
                               "00003748",
                               "00010684",
                               "00014176",
                               "00016984",
                               "00024802",
                               "00027383",
                               "00030755",
                               "00203554",
                               "00205503",
                               "00011987",
                               "00015644",
                               "00029998",
                               "00040684",
                               "00025658",
                               "00031779",
                               "00003836",
                               "00009472",
                               "00015875",
                               "00016073",
                               "00030543",
                               "00203564",
                               "00203587",
                               "00203586",
                               "00003305",
                               "00203597",
                               "00021816",
                               "00026683",
                               "00072384",
                               "00201073" );

    function f_print(){
        self.print();
    }
    //@v1.2
    function firstHideshow() {
        var flag;
        for (r=0;r< roleAEmpno.length;r++) {
          if ("<%=user.empNo%>" == roleAEmpno[r]) {
            flag = "role";
          }
        }
        if (flag == "role") {
            $("#role, #role_1, #role_h").show();
        } else {
          $("#normal, #normal_1, #normal_h").show();
        }
    }

    
</SCRIPT>
</head>

<% //@v1.1 
   //if ( (user.e_persk.equals("32")||user.e_persk.equals("33") ) && Integer.parseInt(DataUtil.getCurrentDate()) >= 20060616 &&  Integer.parseInt(DataUtil.getCurrentDate())  < 20060623 ) { 
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

<body onLoad="javascript:firstHideshow();" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
                  <%= StringUtils.substring(data.BEGDA, 0,4) %>年 <%= Integer.parseInt(StringUtils.substring(data.BEGDA, 5, 7)) %>月 <%= Integer.parseInt(StringUtils.substring(data.BEGDA, 8, 10)) %>日부터
                  <%= StringUtils.substring(data.ENDDA, 0,4) %>年 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지 적용되는<br>
                  <%= data.TITEL %> <%= ename %>의 年俸을 다음과 같이 契約한다.</td>
              </tr>
              <tr id="role_h" style="display:none" >
                <td class="style01">(주)LG화학과 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= StringUtils.substring(data.BEGDA, 0,4) %>年 3月 1日부터
                  <%= StringUtils.substring(data.ENDDA, 0,4) %>年 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지 적용되는<br>
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
                <td class="style01"><%= WebUtil.printNumFormat(data.BETRG) %></td>
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
                <td class="style01">상기 基本年俸은 <%= StringUtils.substring(data.BEGDA, 0,4) %>年 <%= Integer.parseInt(StringUtils.substring(data.BEGDA, 5, 7)) %>月 <%= Integer.parseInt(StringUtils.substring(data.BEGDA, 8, 10)) %>日부터 <%= StringUtils.substring(data.ENDDA, 0,4) %>年 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지</td>
              </tr>
              <tr id="role_1" style="display:none" >
                <td width="10" class="style01">①</td>
                <td class="style01">상기 基本年俸은 <%= StringUtils.substring(data.BEGDA, 0,4) %>年 3月 1日부터 <%= StringUtils.substring(data.ENDDA, 0,4) %>年 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= Integer.parseInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지</td>
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
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
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

</body>
</html>