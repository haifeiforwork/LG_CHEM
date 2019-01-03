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

/* [CSR ID:2506534] 2014년 연봉계약서 생성 요청의 건. | [요청번호]C20140318_06534  2014-03-19 이지은D */
/*  [CSR ID:2731160] LG화학 '15년 연봉계약서 관련의 건. 이지은D  */
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
    //CSR ID : 2506534 역할급(팀장) 목록 수
    var roleAEmpno = new Array(
"00030388"
,"00032985"
,"00064040"
,"00061566"
,"00041078"
,"00060486"
,"00036104"
,"00061404"
,"00061492"
,"00057342"
,"00038372"
,"00058930"
,"00083113"
,"00060030"
,"00063761"
,"00057356"
,"00062726"
,"00061941"
,"00050501"
,"00072715"
,"00052262"
,"00059974"
,"00052322"
,"00055869"
,"00063978"
,"00073269"
,"00071143"
,"00085107"
,"00061323"
,"00085973"
,"00061854"
,"00042206"
,"00202282"
,"00079365"
,"00076398"
,"00072962"
,"00058086"
,"00058901"
,"00063586"
,"00061954"
,"00058739"
,"00056583"
,"00053542"
,"00056293"
,"00099224"
,"00052482"
,"00060350"
,"00058912"
,"00058838"
,"00064072"
,"00071026"
,"00062086"
,"00072964"
,"00077301"
,"00042909"
,"00004466"
,"00050094"
,"00058244"
,"00050136"
,"00064718"
,"00200155"
,"00200109"
,"00077359"
,"00072134"
,"00051506"
,"00034498"
,"00057051"
,"00064215"
,"00056312"
,"00072108"
,"00078134"
,"00082238"
,"00080045"
,"00072192"
,"00201177"
,"00073182"
,"00062615"
,"00061052"
,"00061856"
,"00060979"
,"00060072"
,"00036698"
,"00084218"
,"00072121"
,"00052656"
,"00078476"
,"00072105"
,"00088174"
,"00075669"
,"00067456"
,"00002775"
,"00078186"
,"00082613"
,"00071694"
,"00056818"
,"00059715"
,"00071697"
,"00200335"
,"00083339"
,"00061403"
,"00058159"
,"00071695"
,"00088018"
,"00057979"
,"00001772"
,"00072094"
,"00058433"
,"00057977"
,"00065405"
,"00201906"
,"00206088"
,"00206458"
,"00207277"
,"00212097"
,"00216263"
,"00202069"
,"00070085"
,"00212009"
,"00205603"
,"00060320"
,"00031832"
,"00079123"
,"00205231"
,"00200271"
,"00118615"
,"00204186"
,"00119493"
,"00031489"
,"00022044"
,"00061049"
,"00202215"
,"00009562"
,"00072033"
,"00203276"
,"00203274"
,"00081037"
,"00068623"
,"00205950"
,"00206431"
,"00202227"
,"00071712"
,"00202442"
,"00200552"
,"00205336"
,"00200053"
,"00203016"
,"00000913"
,"00037597"
,"00202543"
,"00208082"
,"00203155"
,"00202440"
,"00071535"
,"00039187"
,"00080842"
,"00205793"
,"00201925"
,"00080493"
,"00200700"
,"00203337"
,"00204134"
,"00201186"
,"00004484"
,"00018605"
,"00080640"
,"00080182"
,"00031471"
,"00037267"
,"00205952"
,"00043683"
,"00005357"
,"00080969"
,"00030224"
,"00205316"
,"00080808"
,"00039233"
,"00081008"
,"00045548"
,"00215748"
,"00203275"
,"00080231"
,"00020235"
,"00201387"
,"00200699"
,"00200892"
,"00080667"
,"00205786"
,"00209375"
,"00080976"
,"00080829"
,"00080778"
,"00072355"
,"00206455"
,"00081020"
,"00080161"
,"00201928"
,"00205605"
,"00200912"
,"00080739"
,"00205604"
,"00201841"
,"00207420"
,"00068536"
,"00031640"
,"00118719"
,"00205953"
,"00216795"
,"00038575"
,"00018396"
,"00202687"
,"00027163"
,"00019288"
,"00110438"
,"00030980"
,"00045967"
,"00028112"
,"00111537"
,"00030309"
,"00216589"
,"00072425"
,"00028518"
,"00202905"
,"00010205"
,"00001324"
,"00030675"
,"00047924"
,"00211576"
,"00042306"
,"00011327"
,"00025955"
,"00036395"
,"00031408"
,"00040759"
,"00031465"
,"00001412"
,"00001209"
,"00052887"
,"00110740"
,"00080876"
,"00030665"
,"00200496"
,"00200373"
,"00203529"
,"00069425"
,"00213555"
,"00121211"
,"00038995"
,"00037512"
,"00200374"
,"00031288"
,"00202454"
,"00069498"
,"00200381"
,"00046643"
,"00030172"
,"00201505"
,"00030993"
,"00032023"
,"00068783"
,"00051709"
,"00200072"
,"00079239"
,"00203311"
,"00205498"
,"00200616"
,"00031337"
,"00024789"
,"00012157"
,"00030285"
,"00205827"
,"00071232"
,"00080361"
,"00054128"
,"00042387"
,"00080240"
,"00068785"
,"00202341"
,"00200382"
,"00068767"
,"00031304"
,"00206598"
,"00018325"
,"00206582"
,"00206647"
,"00206444"
,"00206584"
,"00044995"
,"00080858"
,"00048577"
,"00206207"
,"00008123"
,"00009864"
,"00029197"
,"00018315"
,"00061013"
,"00025968"
,"00207104"
,"00068844"
,"00201886"
,"00032022"
,"00208948"
,"00204316"
,"00001353"
,"00018054"
,"00200687"
,"00015587"
,"00031003"
,"00008516"
,"00203313"
,"00031850"
,"00053064"
,"00200491"
,"00205606"
,"00203188"
,"00203151"
,"00205250"
,"00046656"
,"00030249"
,"00030009"
,"00030367"
,"00118511"
,"00040019"
,"00121225"
,"00041476"
,"00040106"
,"00217351"
,"00203571"
,"00009504"
,"00045507"
,"00043325"
,"00214729"
,"00117669"
,"00118314"
,"00203591"
,"00118210"
,"00112648"
,"00204020"
,"00203603"
,"00117830"
,"00203930"
,"00113968"
,"00116560"
,"00113956"
,"00117749"
,"00117762"
,"00113993"
,"00017856"
,"00115005"
,"00118302"
,"00005487"
,"00001426"
,"00040152"
,"00030319"
,"00040135"
,"00201376"
,"00036627"
,"00080023"
,"00038254"
,"00117682"
,"00203585"
,"00004843"
,"00001104"
,"00037603"
,"00001188"
,"00003361"
,"00044979"
,"00206373"
,"00047445"
,"00203314"
,"00031453"
,"00080197"
,"00001367"
,"00045029"
,"00031133"
,"00009445"
,"00012375"
,"00052016"
,"00022055"
,"00031188"
,"00053005"
,"00001225"
,"00012216"
,"00031104"
,"00027034"
,"00045014"
,"00055088"
,"00048854"
,"00001383"
,"00029549"
,"00038851"
,"00037773"
,"00027236"
,"00038532"
,"00068725"
,"00047588"
,"00048705"
,"00030328"
,"00006808"
,"00001177"
,"00045142"
,"00047474"
,"00001411"
,"00011646"
,"00209491"
,"00209502"
,"00028213"
,"00021878"
,"00215732"
,"00006983"
,"00031110"
,"00051983"
,"00080935"
,"00016679"
,"00027426"
,"00004802"
,"00047093"
,"00080010"
,"00045227"
,"00009561"
,"00070083"
,"00205970"
,"00017729"
,"00030129"
,"00045305"
,"00029667"
,"00001191"
,"00028240"
,"00003564"
,"00048015"
,"00009722"
,"00008574"
,"00001076"
,"00205980"
,"00027092"
,"00001165"
,"00052814"
,"00053022"
,"00009748"
,"00012854"
,"00015965"
,"00031550"
,"00041564"
,"00027018"
,"00025489"
,"00009546"
,"00017424"
,"00012952"
,"00009473"
,"00205969"
,"00080289"
,"00215734"
,"00037336"
,"00030913"
,"00080650"
,"00045028"
,"00025128"
,"00068899"
,"00204021"
,"00203589"
,"00203982"
,"00005500"
,"00028615"
,"00045067"
,"00009764"
,"00045012"
,"00110752"
,"00111168"
,"00009705"
,"00027325"
,"00026797"
,"00003926"
,"00111156"
,"00203573"
,"00203592"
,"00203590"
,"00203263"
,"00200942"
,"00030799"
,"00054968"
,"00202350"
,"00040994"
,"00050105"
,"00203471"
,"00211835"
,"00200583"
,"00027164"
,"00202499"
,"00030215"
,"00039420"
,"00044674"
,"00203346"
,"00030638"
,"00206429"
,"00061051"
,"00212874"
,"00080178"
,"00012809"
,"00001252"
,"00047995"
,"00201935"
,"00211824"
,"00060026"
,"00030677"
,"00023105"
,"00068782"
,"00026826"
,"00030069"
,"00200306"
,"00070141"
,"00031002"
,"00200391"
,"00030358"
,"00030747"
,"00030766"
,"00001093"
,"00200851"
,"00202574"
,"00069467"
,"00056746"
,"00201504"
,"00202336"
,"00201915"
,"00201129"
,"00080176"
,"00080833"
,"00203031"
,"00203039"
,"00080551"
,"00201933"
,"00200990"
,"00030157"
,"00206591"
,"00053077"
,"00052858"
,"00213183"
,"00211889"
,"00080232"
,"00208045"
,"00072384"
,"00060103"
,"00211890"
,"00068756"
,"00211825"
,"00009721"
,"00217350"
,"00005328"
,"00080834"
,"00081054"
,"00209175"
,"00205929"
,"00205443"
,"00208167"
,"00206416"
,"00203469"
,"00203348"
,"00203165"
,"00206880"
,"00213012"
,"00203505"
,"00214142"
,"00207275"
,"00080661"
,"00207555"
,"00207367"
,"00207529"
,"00038966"
,"00018153"
,"00211577"
,"00213053"
,"00037107"
,"00206870"
,"00216884"
,"00202824"
,"00205682"
,"00201658"
,"00031658"
,"00216934"
,"00215637"
,"00200254"
,"00214325"
,"00205798"
,"00210710"
,"00030574"
,"00213145"
,"00070227"
,"00080781"
,"00216935"
,"00210199"
,"00200989"
,"00201848"
,"00031946"
,"00081023"
,"00030125"
,"00061029"
,"00004798"
,"00208951"
,"00025665"
,"00010377"
,"00056586"
,"00039001"
,"00009675"
,"00069586"
,"00035115"
,"00030607"
,"00011154"
,"00030084"
,"00208165"
,"00046207"
,"00204138"
,"00018485"
,"00019275"
,"00046392"
,"00209459"
,"00044775"
,"00031672"
,"00206073"
,"00025708"
,"00047963"
,"00043628"
,"00004684"
,"00114999"
,"00204097"
,"00030182"
,"00113888"
,"00006837"
,"00203778"
,"00203569"
,"00203680"
,"00203565"
,"00203572"
,"00200658"
,"00012564"
,"00031868"
,"00204173"
,"00080569"
,"00071653"
,"00204160"
,"00203272"
,"00200535"
,"00069584"
,"00030103"
,"00030447"
,"00031434"
,"00080072"
,"00032018"
,"00011415"
,"00027223"
,"00080889"
,"00004905"
,"00030072"
,"00081011"
,"00001410"
,"00200089"
,"00200852"
,"00030181"
,"00068842"
,"00031491"
,"00055854"
,"00201875"
,"00061016"
,"00031378"
,"00203776"
,"00069395"
,"00030111"
,"00001397"
,"00202942"
,"00203269"
,"00072324"
,"00009633"
,"00042348"
,"00040919"
,"00030273"
,"00021383"
,"00048013"
,"00204175"
,"00043410"
,"00068714"
,"00030894"
,"00031435"
,"00202205"
,"00031825"
,"00203777"
,"00202320"
,"00080165"
,"00083675"
,"00030912"
,"00040010"
,"00201791"
,"00203149"
,"00031553"
,"00205832"
,"00200297"
,"00031552"
,"00031870"
,"00080336"
,"00200310"
,"00202951"
,"00030669"
,"00200614"
,"00030119"
,"00048826"
,"00060321"
,"00202199"
,"00203170"
,"00200772"
,"00202992"
,"00210742"
,"00070157"
,"00203027"
,"00030379"
,"00031201"
,"00017396"
,"00206366"
,"00080262"
,"00048372"
,"00048806"
,"00038517"
,"00048679"
,"00204291"
,"00111144"
,"00116534"
,"00003748"
,"00027989"
,"00022143"
,"00203580"
,"00037961"
,"00054027"
,"00026824"
,"00046578"
,"00037642"
,"00037668"
,"00111617"
,"00027108"
,"00056759"
,"00038037"
,"00027277"
,"00215899"
,"00047979"
,"00206949"
,"00040906"
,"00047574"
,"00040655"
,"00022981"
,"00203771"
,"00017309"
,"00022778"
,"00205469"
,"00037947"
,"00038588"
,"00066325"
,"00003913"
,"00069655"
,"00038283"
,"00080798"
,"00015964"
,"00037916"
,"00037758"
,"00026753"
,"00005194"
,"00005038"
,"00043614"
,"00045764"
,"00110659"
,"00073475"
,"00069671"
,"00214750"
,"00212710"
,"00005036"
,"00115620"
,"00012863"
,"00001295"
,"00003476"
,"00037888"
,"00013755"
,"00037466"
,"00017248"
,"00201241"
,"00071216"
,"00038734"
,"00027717"
,"00200482"
,"00215019"
,"00003273"
,"00044905"
,"00072222"
,"00081012"
,"00044688"
,"00202452"
,"00200137"
,"00045298"
,"00205577"
,"00043465"
,"00080078"
,"00200890"
,"00201762"
,"00211629"
,"00211823"
,"00202469"
,"00205482"
,"00081024"
,"00216559"
,"00040929"
,"00070098"
,"00029565"
,"00017335"
,"00003724"
,"00036424"
,"00205484"
,"00046539"
,"00044344"
,"00021687"
,"00203570"
,"00015878"
,"00206204"
,"00071897"
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
<body  bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center">
                           <font color="red">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                    </table>
<% } else {  //@v1.1
%>

<body onLoad="javascript:firstHideshow(); if ('<%=msg%>' != '' &&  '<%=msg%>' != 'null' ) alert('<%=msg%>');" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->

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

              <!-- CSR ID : 2506534 => 역할급 구분 없이 職務 항목 모두 제외 -->
              <tr id="normal" style="display:none" >
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 資格, 기타 수당은 별도 기준에 따라 <br>지급한다.</td>
              </tr>
              <tr id="role" style="display:none" >
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 役割給 및 그 외 資格, 기타 수당은<br>별도 기준에 따라 지급한다.</td>
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

                <!-- CSR ID : 2506534 => 이미지 변경 -->
                <td width="361" valign=bottom><img src="<%= imgURL %>img_sign_bjs.gif"></td>
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