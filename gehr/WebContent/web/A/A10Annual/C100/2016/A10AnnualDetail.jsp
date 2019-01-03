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
/*   [CSR ID:3015031] '16년 사무기술직 연봉계약서 관련 요청의 건.   */
/*					  : 2018-03-09 cykim  [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件   */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="com.sns.jdf.util.DataUtil" %>
<%@ page import="com.sns.jdf.util.WebUtil" %>
<%@ page import="hris.A.A10Annual.A10AnnualData" %>
<%@ page import="hris.A.A10Annual.rfc.A10AnnualAgreementRFC" %>
<%@ page import="hris.D.D05Mpay.rfc.D05ScreenControlRFC" %>
<%@ page import="hris.common.WebUserData" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="java.util.Vector" %>
<%@ page import="org.apache.commons.lang.math.NumberUtils" %>

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

    if ( NumberUtils.toInt(data.ZYEAR) < 2000) {
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
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery-1.12.4.min.js"></script>
<script language="JavaScript" src="<%= WebUtil.ImageURL %>js/jquery.blockUI.js?v1"></script>


    <SCRIPT LANGUAGE="JavaScript">

        $(function () {
            $.unblockUI();
        });

    //CSR ID : 2506534 역할급(팀장) 목록 수
    var roleAEmpno = new Array(
    		"00040994"
    		,"00219171"
    		,"00218570"
    		,"00219313"
    		,"00017309"
    		,"00012157"
    		,"00026753"
    		,"00038517"
    		,"00048679"
    		,"00111144"
    		,"00017856"
    		,"00001104"
    		,"00022143"
    		,"00009633"
    		,"00037642"
    		,"00037668"
    		,"00111617"
    		,"00056759"
    		,"00068536"
    		,"00031640"
    		,"00055854"
    		,"00040106"
    		,"00206366"
    		,"00211629"
    		,"00218107"
    		,"00215637"
    		,"00205469"
    		,"00037947"
    		,"00069655"
    		,"00001410"
    		,"00015964"
    		,"00037758"
    		,"00048826"
    		,"00205498"
    		,"00005194"
    		,"00043614"
    		,"00045764"
    		,"00010188"
    		,"00110659"
    		,"00073475"
    		,"00069671"
    		,"00214750"
    		,"00218589"
    		,"00006983"
    		,"00044615"
    		,"00017248"
    		,"00027717"
    		,"00205577"
    		,"00003273"
    		,"00061051"
    		,"00044688"
    		,"00081012"
    		,"00218261"
    		,"00068782"
    		,"00045298"
    		,"00054968"
    		,"00211576"
    		,"00080078"
    		,"00200890"
    		,"00070227"
    		,"00202574"
    		,"00079239"
    		,"00030119"
    		,"00201762"
    		,"00072384"
    		,"00208045"
    		,"00200137"
    		,"00072324"
    		,"00218258"
    		,"00053077"
    		,"00211823"
    		,"00202469"
    		,"00081024"
    		,"00216559"
    		,"00038037"
    		,"00040929"
    		,"00070098"
    		,"00029565"
    		,"00205484"
    		,"00003724"
    		,"00036424"
    		,"00017335"
    		,"00046539"
    		,"00044344"
    		,"00021687"
    		,"00203570"
    		,"00015878"
    		,"00206204"
    		,"00071897"
    		,"00201241"
    		,"00200482"
    		,"00048372"
    		,"00037961"
    		,"00054027"
    		,"00026824"
    		,"00046578"
    		,"00001093"
    		,"00027277"
    		,"00215899"
    		,"00009721"
    		,"00047979"
    		,"00047574"
    		,"00040655"
    		,"00022981"
    		,"00043465"
    		,"00066325"
    		,"00038283"
    		,"00005036"
    		,"00055088"
    		,"00115620"
    		,"00001295"
    		,"00037888"
    		,"00071216"
    		,"00038734"
    		,"00044905"
    		,"00072222"
    		,"00031874"
    		,"00205035"
    		,"00030908"
    		,"00072033"
    		,"00203274"
    		,"00206431"
    		,"00068623"
    		,"00200123"
    		,"00202227"
    		,"00082862"
    		,"00205950"
    		,"00071712"
    		,"00200552"
    		,"00205336"
    		,"00200053"
    		,"00037597"
    		,"00000913"
    		,"00208082"
    		,"00203155"
    		,"00202440"
    		,"00210740"
    		,"00018908"
    		,"00080493"
    		,"00203337"
    		,"00201794"
    		,"00080182"
    		,"00080410"
    		,"00200560"
    		,"00200562"
    		,"00043683"
    		,"00071535"
    		,"00205952"
    		,"00205793"
    		,"00080527"
    		,"00018181"
    		,"00037267"
    		,"00201925"
    		,"00045305"
    		,"00031471"
    		,"00201186"
    		,"00018605"
    		,"00080640"
    		,"00005357"
    		,"00080969"
    		,"00030224"
    		,"00205316"
    		,"00080808"
    		,"00080761"
    		,"00080306"
    		,"00215748"
    		,"00203275"
    		,"00080231"
    		,"00071463"
    		,"00020235"
    		,"00201387"
    		,"00200699"
    		,"00200892"
    		,"00080667"
    		,"00205786"
    		,"00209375"
    		,"00217744"
    		,"00080976"
    		,"00080829"
    		,"00080778"
    		,"00072355"
    		,"00206455"
    		,"00081020"
    		,"00080161"
    		,"00201928"
    		,"00218228"
    		,"00200912"
    		,"00207420"
    		,"00207556"
    		,"00080739"
    		,"00206870"
    		,"00205604"
    		,"00206458"
    		,"00207277"
    		,"00215639"
    		,"00201841"
    		,"00217678"
    		,"00212097"
    		,"00207856"
    		,"00200718"
    		,"00118719"
    		,"00031832"
    		,"00216796"
    		,"00005052"
    		,"00071653"
    		,"00216795"
    		,"00038575"
    		,"00217815"
    		,"00200658"
    		,"00030073"
    		,"00031408"
    		,"00206207"
    		,"00008123"
    		,"00009864"
    		,"00029197"
    		,"00206582"
    		,"00206647"
    		,"00045507"
    		,"00203776"
    		,"00203930"
    		,"00212852"
    		,"00012809"
    		,"00030762"
    		,"00214142"
    		,"00210199"
    		,"00207275"
    		,"00080661"
    		,"00207555"
    		,"00207367"
    		,"00215747"
    		,"00203261"
    		,"00207529"
    		,"00038966"
    		,"00018153"
    		,"00217725"
    		,"00213053"
    		,"00217767"
    		,"00203505"
    		,"00211577"
    		,"00218325"
    		,"00026738"
    		,"00207798"
    		,"00011327"
    		,"00022044"
    		,"00018396"
    		,"00202687"
    		,"00027163"
    		,"00019288"
    		,"00110438"
    		,"00030980"
    		,"00031259"
    		,"00045967"
    		,"00028112"
    		,"00111537"
    		,"00030309"
    		,"00216589"
    		,"00202905"
    		,"00072425"
    		,"00080366"
    		,"00061016"
    		,"00205878"
    		,"00214729"
    		,"00001324"
    		,"00205018"
    		,"00030675"
    		,"00047924"
    		,"00044775"
    		,"00042306"
    		,"00025955"
    		,"00036395"
    		,"00031465"
    		,"00026075"
    		,"00001412"
    		,"00001209"
    		,"00052887"
    		,"00110740"
    		,"00030959"
    		,"00030665"
    		,"00080876"
    		,"00072496"
    		,"00203529"
    		,"00200373"
    		,"00069425"
    		,"00213555"
    		,"00121211"
    		,"00038995"
    		,"00037512"
    		,"00200374"
    		,"00069498"
    		,"00200381"
    		,"00201494"
    		,"00046643"
    		,"00201505"
    		,"00030993"
    		,"00032023"
    		,"00068783"
    		,"00051709"
    		,"00203311"
    		,"00200852"
    		,"00030072"
    		,"00031288"
    		,"00200616"
    		,"00030172"
    		,"00080160"
    		,"00024789"
    		,"00031337"
    		,"00012186"
    		,"00200387"
    		,"00071232"
    		,"00200856"
    		,"00068785"
    		,"00054128"
    		,"00042387"
    		,"00030285"
    		,"00205827"
    		,"00200382"
    		,"00030082"
    		,"00031304"
    		,"00018325"
    		,"00080361"
    		,"00030189"
    		,"00068767"
    		,"00061013"
    		,"00218115"
    		,"00066311"
    		,"00200603"
    		,"00216921"
    		,"00208157"
    		,"00206444"
    		,"00206584"
    		,"00044995"
    		,"00048577"
    		,"00201817"
    		,"00201886"
    		,"00032022"
    		,"00208948"
    		,"00204316"
    		,"00200583"
    		,"00001353"
    		,"00018054"
    		,"00200687"
    		,"00015587"
    		,"00031003"
    		,"00200089"
    		,"00203313"
    		,"00031850"
    		,"00053064"
    		,"00030056"
    		,"00205606"
    		,"00201075"
    		,"00203151"
    		,"00205250"
    		,"00030009"
    		,"00070186"
    		,"00030249"
    		,"00046656"
    		,"00203479"
    		,"00218786"
    		,"00068714"
    		,"00121225"
    		,"00041476"
    		,"00009504"
    		,"00217351"
    		,"00038588"
    		,"00209461"
    		,"00043325"
    		,"00203346"
    		,"00118511"
    		,"00117669"
    		,"00118314"
    		,"00203591"
    		,"00118210"
    		,"00112648"
    		,"00204020"
    		,"00117830"
    		,"00113968"
    		,"00203775"
    		,"00116560"
    		,"00113956"
    		,"00117749"
    		,"00117762"
    		,"00113993"
    		,"00117356"
    		,"00118302"
    		,"00068857"
    		,"00115005"
    		,"00200022"
    		,"00203574"
    		,"00004802"
    		,"00001426"
    		,"00069775"
    		,"00045794"
    		,"00201301"
    		,"00027148"
    		,"00036627"
    		,"00080023"
    		,"00038254"
    		,"00117682"
    		,"00203604"
    		,"00004843"
    		,"00204103"
    		,"00037603"
    		,"00001188"
    		,"00080842"
    		,"00045269"
    		,"00003361"
    		,"00044979"
    		,"00045029"
    		,"00001367"
    		,"00203314"
    		,"00031453"
    		,"00080197"
    		,"00206373"
    		,"00036324"
    		,"00060606"
    		,"00009445"
    		,"00012375"
    		,"00052016"
    		,"00022055"
    		,"00031188"
    		,"00053005"
    		,"00001225"
    		,"00012216"
    		,"00031104"
    		,"00046523"
    		,"00045014"
    		,"00016592"
    		,"00048854"
    		,"00009561"
    		,"00001383"
    		,"00029549"
    		,"00027236"
    		,"00037773"
    		,"00001296"
    		,"00044776"
    		,"00068725"
    		,"00047588"
    		,"00048705"
    		,"00040019"
    		,"00006808"
    		,"00001177"
    		,"00045142"
    		,"00047474"
    		,"00001411"
    		,"00083675"
    		,"00028213"
    		,"00209491"
    		,"00209496"
    		,"00045227"
    		,"00060863"
    		,"00021878"
    		,"00215732"
    		,"00213557"
    		,"00011646"
    		,"00031110"
    		,"00030799"
    		,"00009562"
    		,"00080165"
    		,"00029667"
    		,"00017396"
    		,"00054838"
    		,"00047093"
    		,"00030129"
    		,"00052814"
    		,"00027092"
    		,"00028240"
    		,"00205970"
    		,"00003564"
    		,"00009722"
    		,"00008574"
    		,"00047575"
    		,"00206949"
    		,"00001191"
    		,"00009748"
    		,"00012854"
    		,"00015965"
    		,"00031550"
    		,"00041564"
    		,"00038024"
    		,"00025489"
    		,"00009546"
    		,"00017424"
    		,"00012952"
    		,"00205953"
    		,"00011978"
    		,"00080289"
    		,"00080010"
    		,"00215734"
    		,"00203771"
    		,"00030913"
    		,"00080650"
    		,"00001396"
    		,"00025128"
    		,"00079194"
    		,"00068899"
    		,"00203589"
    		,"00204100"
    		,"00004439"
    		,"00204008"
    		,"00046233"
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
    		,"00203955"
    		,"00203590"
    		,"00080935"
    		,"00203263"
    		,"00200942"
    		,"00205027"
    		,"00030693"
    		,"00202350"
    		,"00050105"
    		,"00203471"
    		,"00211835"
    		,"00216263"
    		,"00024628"
    		,"00027164"
    		,"00202499"
    		,"00030215"
    		,"00040759"
    		,"00044674"
    		,"00030638"
    		,"00206429"
    		,"00212874"
    		,"00080178"
    		,"00203308"
    		,"00047995"
    		,"00218116"
    		,"00201935"
    		,"00211824"
    		,"00060026"
    		,"00030677"
    		,"00023105"
    		,"00213183"
    		,"00001252"
    		,"00218216"
    		,"00080902"
    		,"00204210"
    		,"00030900"
    		,"00030766"
    		,"00031002"
    		,"00200306"
    		,"00200391"
    		,"00030358"
    		,"00030747"
    		,"00202336"
    		,"00201915"
    		,"00030069"
    		,"00070141"
    		,"00069467"
    		,"00056746"
    		,"00200786"
    		,"00202069"
    		,"00203027"
    		,"00200310"
    		,"00070085"
    		,"00200851"
    		,"00203143"
    		,"00080176"
    		,"00080833"
    		,"00202977"
    		,"00203031"
    		,"00203039"
    		,"00205605"
    		,"00201129"
    		,"00080781"
    		,"00080551"
    		,"00217690"
    		,"00205751"
    		,"00030157"
    		,"00206591"
    		,"00202467"
    		,"00201516"
    		,"00218270"
    		,"00212009"
    		,"00212193"
    		,"00060103"
    		,"00200611"
    		,"00061049"
    		,"00080295"
    		,"00211890"
    		,"00218207"
    		,"00218408"
    		,"00218410"
    		,"00207654"
    		,"00068756"
    		,"00218331"
    		,"00209651"
    		,"00080232"
    		,"00217350"
    		,"00205603"
    		,"00005328"
    		,"00080834"
    		,"00081054"
    		,"00202452"
    		,"00209175"
    		,"00212906"
    		,"00201777"
    		,"00205929"
    		,"00205443"
    		,"00208167"
    		,"00206628"
    		,"00203469"
    		,"00203348"
    		,"00203165"
    		,"00206880"
    		,"00213012"
    		,"00206583"
    		,"00052858"
    		,"00037107"
    		,"00216884"
    		,"00218201"
    		,"00218202"
    		,"00031658"
    		,"00202824"
    		,"00205682"
    		,"00201658"
    		,"00203544"
    		,"00030574"
    		,"00216934"
    		,"00202215"
    		,"00200254"
    		,"00205798"
    		,"00201852"
    		,"00203087"
    		,"00210710"
    		,"00217782"
    		,"00213145"
    		,"00201848"
    		,"00200989"
    		,"00031946"
    		,"00218197"
    		,"00206472"
    		,"00216935"
    		,"00202398"
    		,"00214120"
    		,"00219177"
    		,"00210034"
    		,"00218222"
    		,"00218264"
    		,"00219174"
    		,"00081023"
    		,"00054577"
    		,"00061029"
    		,"00218412"
    		,"00060320"
    		,"00218445"
    		,"00207982"
    		,"00004798"
    		,"00208951"
    		,"00025665"
    		,"00208165"
    		,"00056586"
    		,"00039001"
    		,"00009675"
    		,"00069586"
    		,"00035115"
    		,"00030607"
    		,"00206073"
    		,"00030084"
    		,"00010377"
    		,"00046207"
    		,"00204138"
    		,"00018485"
    		,"00019275"
    		,"00046392"
    		,"00060321"
    		,"00209459"
    		,"00206218"
    		,"00031672"
    		,"00051983"
    		,"00011154"
    		,"00025708"
    		,"00043628"
    		,"00004684"
    		,"00114999"
    		,"00204097"
    		,"00030182"
    		,"00113888"
    		,"00203778"
    		,"00203569"
    		,"00203680"
    		,"00203565"
    		,"00203572"
    		,"00031483"
    		,"00202339"
    		,"00047764"
    		,"00012564"
    		,"00031248"
    		,"00031868"
    		,"00204173"
    		,"00080569"
    		,"00079123"
    		,"00204160"
    		,"00069584"
    		,"00200535"
    		,"00203272"
    		,"00205231"
    		,"00030447"
    		,"00080072"
    		,"00030280"
    		,"00032018"
    		,"00011415"
    		,"00030103"
    		,"00030181"
    		,"00027223"
    		,"00004905"
    		,"00080889"
    		,"00200990"
    		,"00008516"
    		,"00202334"
    		,"00201721"
    		,"00031489"
    		,"00068842"
    		,"00200271"
    		,"00031491"
    		,"00030111"
    		,"00001397"
    		,"00069395"
    		,"00205987"
    		,"00203269"
    		,"00030273"
    		,"00048013"
    		,"00031280"
    		,"00204175"
    		,"00048838"
    		,"00040919"
    		,"00043410"
    		,"00040026"
    		,"00030894"
    		,"00200409"
    		,"00202205"
    		,"00203777"
    		,"00031825"
    		,"00031434"
    		,"00118615"
    		,"00202320"
    		,"00081003"
    		,"00018166"
    		,"00040010"
    		,"00204186"
    		,"00045102"
    		,"00030321"
    		,"00030327"
    		,"00201791"
    		,"00030125"
    		,"00203149"
    		,"00031553"
    		,"00218108"
    		,"00031552"
    		,"00214381"
    		,"00030669"
    		,"00200614"
    		,"00201710"
    		,"00200072"
    		,"00030371"
    		,"00200009"
    		,"00203170"
    		,"00070157"
    		,"00200772"
    		,"00210742"
    		,"00205832"
    		,"00212081"
    		,"00200049"
    		,"00211889"
    		,"00119493"
    		,"00202054"
    		,"00030379"
    		,"00006837"
    		,"00080017"
    		,"00030388"
    		,"00032985"
    		,"00064040"
    		,"00061566"
    		,"00041078"
    		,"00060486"
    		,"00036104"
    		,"00056293"
    		,"00061492"
    		,"00061404"
    		,"00057342"
    		,"00038372"
    		,"00058930"
    		,"00083113"
    		,"00060030"
    		,"00063761"
    		,"00057356"
    		,"00087578"
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
    		,"00085973"
    		,"00054113"
    		,"00061854"
    		,"00042206"
    		,"00202282"
    		,"00056236"
    		,"00074780"
    		,"00058739"
    		,"00063586"
    		,"00061954"
    		,"00076398"
    		,"00072962"
    		,"00058086"
    		,"00058901"
    		,"00056583"
    		,"00053542"
    		,"00074624"
    		,"00099224"
    		,"00052482"
    		,"00060350"
    		,"00058912"
    		,"00058838"
    		,"00072964"
    		,"00064072"
    		,"00077301"
    		,"00053312"
    		,"00004466"
    		,"00050094"
    		,"00050136"
    		,"00058244"
    		,"00064718"
    		,"00200155"
    		,"00200109"
    		,"00051506"
    		,"00034498"
    		,"00057051"
    		,"00064215"
    		,"00056312"
    		,"00077359"
    		,"00072134"
    		,"00078134"
    		,"00072108"
    		,"00082238"
    		,"00080045"
    		,"00072192"
    		,"00090650"
    		,"00036698"
    		,"00060072"
    		,"00201177"
    		,"00201154"
    		,"00084218"
    		,"00061856"
    		,"00062615"
    		,"00061052"
    		,"00056818"
    		,"00097374"
    		,"00072121"
    		,"00060979"
    		,"00078476"
    		,"00072105"
    		,"00088174"
    		,"00075669"
    		,"00078186"
    		,"00002775"
    		,"00071694"
    		,"00200335"
    		,"00088018"
    		,"00071697"
    		,"00083339"
    		,"00057979"
    		,"00061403"
    		,"00001772"
    		,"00065405"
    		,"00071695"
    		,"00057977"
    		,"00058159"
    		,"00072094"
    		,"00059715"
    		,"00082613"
    		,"00206088"
    		,"00201906"
    		,"00067456"
    		,"00219548"
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
            $("#role, #role_1, #role_h").show();
        } else {
            $("#normal, #normal_1, #normal_h").show();
        }
       <% } %>
    }

    $(function() {
        $("body").height(document.body.scrollHeight + 100);
    });


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
                  <%= StringUtils.substring(data.BEGDA, 0, 4) %>年 <%= NumberUtils.toInt(StringUtils.substring(data.BEGDA, 5, 7)) %>月 <%= NumberUtils.toInt(StringUtils.substring(data.BEGDA, 8, 10)) %>日부터
                  <%= StringUtils.substring(data.ENDDA, 0, 4) %>年 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지 적용되는<br>
                  <%= data.TITEL %> <%= ename %>의 年俸을 다음과 같이 契約한다.</td>
              </tr>
              <tr id="role_h" style="display:none" >
                <td class="style01">(주)LG화학과 <%= ename %>은(는) 信義와 誠實을 바탕으로<br>
                  <%= StringUtils.substring(data.BEGDA, 0, 4) %>年 3月 1日부터
                  <%= StringUtils.substring(data.ENDDA, 0, 4) %>年 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지 적용되는<br>
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
                <td class="style01">상기 基本年俸은 <%= StringUtils.substring(data.BEGDA, 0, 4) %>年 <%= NumberUtils.toInt(StringUtils.substring(data.BEGDA, 5, 7)) %>月 <%= NumberUtils.toInt(StringUtils.substring(data.BEGDA, 8, 10)) %>日부터 <%= StringUtils.substring(data.ENDDA, 0, 4) %>年 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지</td>
              </tr>
              <tr id="role_1" style="display:none" >
                <td width="10" class="style01">①</td>
                <td class="style01">상기 基本年俸은 <%= StringUtils.substring(data.BEGDA, 0, 4) %>年 3月 1日부터 <%= StringUtils.substring(data.ENDDA, 0, 4) %>年 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 5, 7)) %>月 <%= NumberUtils.toInt(StringUtils.substring(data.ENDDA, 8, 10)) %>日까지</td>
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
          <td align="center">
            <table width="600" border="0" cellspacing="0" cellpadding="0">
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
    //if ( NumberUtils.toInt(data.ZYEAR) >= 2008 && !AGRE_FLAG.equals("Y") ) {
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