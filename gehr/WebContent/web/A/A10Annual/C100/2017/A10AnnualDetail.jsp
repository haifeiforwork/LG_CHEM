<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 나의 연봉 계약서                                            */
/*   Program Name : 나의 연봉 계약서                                            */
/*   Program ID   : A10AnnualDetail.jsp                                         */
/*   Description  : 나의 연봉 조회                                              */
/*   Note         :                                                             */
/*   Creation     : 2017-03-21 김은하 (홍성빈D요청)  [CSR ID:3335973] 17년 사무기술직 연봉계약서 반영 요청의 건.    */
/*   Update       : 2017-03-21 김은하 (홍성빈D요청)[CSR ID:3335973] 17년 사무기술직 연봉계약서 반영 요청의 건. */
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

    ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( empNo ,"1",data.ZYEAR , companyCode );

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
    		 "00201387"
    		,"00200699"
    		,"00200892"
    		,"00200452"
    		,"00205786"
    		,"00209375"
    		,"00217744"
    		,"00080976"
    		,"00080778"
    		,"00214257"
    		,"00206455"
    		,"00005357"
    		,"00200348"
    		,"00205312"
    		,"00080969"
    		,"00205316"
    		,"00080808"
    		,"00080306"
    		,"00215748"
    		,"00203275"
    		,"00030224"
    		,"00200846"
    		,"00080761"
    		,"00215720"
    		,"00072355"
    		,"00210037"
    		,"00039233"
    		,"00223424"
    		,"00071463"
    		,"00005445"
    		,"00039493"
    		,"00080829"
    		,"00046857"
    		,"00072365"
    		,"00203274"
    		,"00072033"
    		,"00206431"
    		,"00068623"
    		,"00200123"
    		,"00205950"
    		,"00080858"
    		,"00203016"
    		,"00082862"
    		,"00071712"
    		,"00205336"
    		,"00000913"
    		,"00203155"
    		,"00202440"
    		,"00210740"
    		,"00080743"
    		,"00018908"
    		,"00202213"
    		,"00201794"
    		,"00080182"
    		,"00017774"
    		,"00080410"
    		,"00200560"
    		,"00200562"
    		,"00043683"
    		,"00205247"
    		,"00071535"
    		,"00205969"
    		,"00018211"
    		,"00203337"
    		,"00205793"
    		,"00080527"
    		,"00200980"
    		,"00018181"
    		,"00037267"
    		,"00201925"
    		,"00045305"
    		,"00201239"
    		,"00031471"
    		,"00201186"
    		,"00018605"
    		,"00080526"
    		,"00080640"
    		,"00081020"
    		,"00080161"
    		,"00218228"
    		,"00207556"
    		,"00080739"
    		,"00206870"
    		,"00205604"
    		,"00206458"
    		,"00207277"
    		,"00207856"
    		,"00201841"
    		,"00217678"
    		,"00200718"
    		,"00219171"
    		,"00220024"
    		,"00070227"
    		,"00048372"
    		,"00071232"
    		,"00046643"
    		,"00026753"
    		,"00048679"
    		,"00221211"
    		,"00111144"
    		,"00017856"
    		,"00001104"
    		,"00022143"
    		,"00009633"
    		,"00006808"
    		,"00054027"
    		,"00011646"
    		,"00046578"
    		,"00037642"
    		,"00009445"
    		,"00056759"
    		,"00068782"
    		,"00001093"
    		,"00208045"
    		,"00118719"
    		,"00031832"
    		,"00216796"
    		,"00045298"
    		,"00031640"
    		,"00055854"
    		,"00215734"
    		,"00040106"
    		,"00009721"
    		,"00047979"
    		,"00047574"
    		,"00037961"
    		,"00040655"
    		,"00028213"
    		,"00005052"
    		,"00206366"
    		,"00043465"
    		,"00068536"
    		,"00043614"
    		,"00037947"
    		,"00003273"
    		,"00036627"
    		,"00069671"
    		,"00001410"
    		,"00027717"
    		,"00038283"
    		,"00030959"
    		,"00047924"
    		,"00213555"
    		,"00037758"
    		,"00048826"
    		,"00005194"
    		,"00027277"
    		,"00010188"
    		,"00110659"
    		,"00073475"
    		,"00069655"
    		,"00214750"
    		,"00218570"
    		,"00218589"
    		,"00005036"
    		,"00118511"
    		,"00017248"
    		,"00009504"
    		,"00068725"
    		,"00016592"
    		,"00006983"
    		,"00044615"
    		,"00006837"
    		,"00215732"
    		,"00071216"
    		,"00111617"
    		,"00111156"
    		,"00038734"
    		,"00200942"
    		,"00040994"
    		,"00025955"
    		,"00061051"
    		,"00081012"
    		,"00044688"
    		,"00218261"
    		,"00202452"
    		,"00072324"
    		,"00212097"
    		,"00218258"
    		,"00218107"
    		,"00201791"
    		,"00054968"
    		,"00211576"
    		,"00080078"
    		,"00200890"
    		,"00211823"
    		,"00202469"
    		,"00081024"
    		,"00215637"
    		,"00025665"
    		,"00039001"
    		,"00029565"
    		,"00205484"
    		,"00044775"
    		,"00036424"
    		,"00017335"
    		,"00046539"
    		,"00015964"
    		,"00044344"
    		,"00021687"
    		,"00203570"
    		,"00110438"
    		,"00072108"
    		,"00200155"
    		,"00051506"
    		,"00200109"
    		,"00057051"
    		,"00071653"
    		,"00219313"
    		,"00071897"
    		,"00030388"
    		,"00032985"
    		,"00061492"
    		,"00061404"
    		,"00057342"
    		,"00087578"
    		,"00058930"
    		,"00057356"
    		,"00063761"
    		,"00061941"
    		,"00050501"
    		,"00072715"
    		,"00055869"
    		,"00041078"
    		,"00060486"
    		,"00036104"
    		,"00085905"
    		,"00061566"
    		,"00071143"
    		,"00085107"
    		,"00073269"
    		,"00085973"
    		,"00054113"
    		,"00058739"
    		,"00063586"
    		,"00061954"
    		,"00076398"
    		,"00072962"
    		,"00220260"
    		,"00220178"
    		,"00220306"
    		,"00061854"
    		,"00042206"
    		,"00202282"
    		,"00056236"
    		,"00074780"
    		,"00052262"
    		,"00059974"
    		,"00052322"
    		,"00063978"
    		,"00056583"
    		,"00053542"
    		,"00058901"
    		,"00074624"
    		,"00056293"
    		,"00060028"
    		,"00099224"
    		,"00052482"
    		,"00058838"
    		,"00060350"
    		,"00058912"
    		,"00064072"
    		,"00072964"
    		,"00077301"
    		,"00053312"
    		,"00004466"
    		,"00050094"
    		,"00050136"
    		,"00058244"
    		,"00080045"
    		,"00002775"
    		,"00200335"
    		,"00088018"
    		,"00071694"
    		,"00083339"
    		,"00057979"
    		,"00061403"
    		,"00001772"
    		,"00064718"
    		,"00078134"
    		,"00077359"
    		,"00060045"
    		,"00082238"
    		,"00202552"
    		,"00064215"
    		,"00072134"
    		,"00056312"
    		,"00072192"
    		,"00078186"
    		,"00082658"
    		,"00071695"
    		,"00201320"
    		,"00058433"
    		,"00058159"
    		,"00072094"
    		,"00097374"
    		,"00202266"
    		,"00201154"
    		,"00061856"
    		,"00062615"
    		,"00061052"
    		,"00084218"
    		,"00056818"
    		,"00090650"
    		,"00057977"
    		,"00072121"
    		,"00060072"
    		,"00036698"
    		,"00201177"
    		,"00219548"
    		,"00060979"
    		,"00078476"
    		,"00072105"
    		,"00075669"
    		,"00206088"
    		,"00201906"
    		,"00067456"
    		,"00048317"
    		,"00080682"
    		,"00080667"
    		,"00005647"
    		,"00203150"
    		,"00200919"
    		,"00200653"
    		,"00080780"
    		,"00081008"
    		,"00080696"
    		,"00220269"
    		,"00202103"
    		,"00071479"
    		,"00203276"
    		,"00080584"
    		,"00205309"
    		,"00201875"
    		,"00018152"
    		,"00202442"
    		,"00200053"
    		,"00080058"
    		,"00070375"
    		,"00071795"
    		,"00017729"
    		,"00200700"
    		,"00080493"
    		,"00214903"
    		,"00036004"
    		,"00080648"
    		,"00040003"
    		,"00213366"
    		,"00017598"
    		,"00082574"
    		,"00205338"
    		,"00031096"
    		,"00004484"
    		,"00038693"
    		,"00011177"
    		,"00080429"
    		,"00214925"
    		,"00203009"
    		,"00201933"
    		,"00200137"
    		,"00203165"
    		,"00080996"
    		,"00206416"
    		,"00080805"
    		,"00080661"
    		,"00201928"
    		,"00072397"
    		,"00080510"
    		,"00205353"
    		,"00018676"
    		,"00080262"
    		,"00039245"
    		,"00203152"
    		,"00068564"
    		,"00220023"
    		,"00223354"
    		,"00071884"
    		,"00205482"
    		,"00030646"
    		,"00038575"
    		,"00217815"
    		,"00030575"
    		,"00215002"
    		,"00205960"
    		,"00019288"
    		,"00035115"
    		,"00030980"
    		,"00031259"
    		,"00028112"
    		,"00030312"
    		,"00054678"
    		,"00202454"
    		,"00030430"
    		,"00205878"
    		,"00205640"
    		,"00024628"
    		,"00030309"
    		,"00216589"
    		,"00202499"
    		,"00080366"
    		,"00202905"
    		,"00072425"
    		,"00028518"
    		,"00222510"
    		,"00027164"
    		,"00030215"
    		,"00047764"
    		,"00040759"
    		,"00046931"
    		,"00044674"
    		,"00030638"
    		,"00219707"
    		,"00030073"
    		,"00205018"
    		,"00219695"
    		,"00030675"
    		,"00221360"
    		,"00204138"
    		,"00042306"
    		,"00222511"
    		,"00200658"
    		,"00045967"
    		,"00036395"
    		,"00214296"
    		,"00219680"
    		,"00031408"
    		,"00031465"
    		,"00026075"
    		,"00001412"
    		,"00001209"
    		,"00220757"
    		,"00221667"
    		,"00001252"
    		,"00052887"
    		,"00110740"
    		,"00080876"
    		,"00030665"
    		,"00031899"
    		,"00060333"
    		,"00030143"
    		,"00200373"
    		,"00200614"
    		,"00038995"
    		,"00019725"
    		,"00037512"
    		,"00200374"
    		,"00008123"
    		,"00200615"
    		,"00201505"
    		,"00069498"
    		,"00200381"
    		,"00031759"
    		,"00032023"
    		,"00068783"
    		,"00051709"
    		,"00203311"
    		,"00200852"
    		,"00031288"
    		,"00200616"
    		,"00201443"
    		,"00030172"
    		,"00205498"
    		,"00024789"
    		,"00031337"
    		,"00080159"
    		,"00066297"
    		,"00031304"
    		,"00012157"
    		,"00068785"
    		,"00054128"
    		,"00220175"
    		,"00201494"
    		,"00200856"
    		,"00030993"
    		,"00009864"
    		,"00030285"
    		,"00205827"
    		,"00080160"
    		,"00068767"
    		,"00200382"
    		,"00220253"
    		,"00080361"
    		,"00030189"
    		,"00220184"
    		,"00220229"
    		,"00220318"
    		,"00223300"
    		,"00220310"
    		,"00212044"
    		,"00220312"
    		,"00018325"
    		,"00205831"
    		,"00030072"
    		,"00061013"
    		,"00066311"
    		,"00030150"
    		,"00200603"
    		,"00216921"
    		,"00201714"
    		,"00044995"
    		,"00206444"
    		,"00206636"
    		,"00072496"
    		,"00208157"
    		,"00031885"
    		,"00201817"
    		,"00201886"
    		,"00001353"
    		,"00032022"
    		,"00204316"
    		,"00200583"
    		,"00200652"
    		,"00203313"
    		,"00018054"
    		,"00200687"
    		,"00031319"
    		,"00200089"
    		,"00201754"
    		,"00031850"
    		,"00053064"
    		,"00205606"
    		,"00201075"
    		,"00203151"
    		,"00080022"
    		,"00201763"
    		,"00217706"
    		,"00200552"
    		,"00205250"
    		,"00015587"
    		,"00070186"
    		,"00030249"
    		,"00203479"
    		,"00221262"
    		,"00221213"
    		,"00011154"
    		,"00030009"
    		,"00066963"
    		,"00046656"
    		,"00218786"
    		,"00068714"
    		,"00009692"
    		,"00045156"
    		,"00216795"
    		,"00217351"
    		,"00220852"
    		,"00038588"
    		,"00209461"
    		,"00043325"
    		,"00203346"
    		,"00031378"
    		,"00121225"
    		,"00203575"
    		,"00118314"
    		,"00118210"
    		,"00202661"
    		,"00219312"
    		,"00204020"
    		,"00203776"
    		,"00114987"
    		,"00203930"
    		,"00117669"
    		,"00203775"
    		,"00113968"
    		,"00116560"
    		,"00117749"
    		,"00117762"
    		,"00113956"
    		,"00113993"
    		,"00117356"
    		,"00118302"
    		,"00068857"
    		,"00115005"
    		,"00200022"
    		,"00203574"
    		,"00004802"
    		,"00069775"
    		,"00048666"
    		,"00001426"
    		,"00201301"
    		,"00027148"
    		,"00080023"
    		,"00066325"
    		,"00047047"
    		,"00117682"
    		,"00203604"
    		,"00004843"
    		,"00038254"
    		,"00116952"
    		,"00203975"
    		,"00001188"
    		,"00080842"
    		,"00080197"
    		,"00003361"
    		,"00001179"
    		,"00045029"
    		,"00001367"
    		,"00031230"
    		,"00031453"
    		,"00080921"
    		,"00206373"
    		,"00203314"
    		,"00060606"
    		,"00054535"
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
    		,"00030328"
    		,"00048854"
    		,"00009561"
    		,"00001383"
    		,"00037773"
    		,"00001296"
    		,"00044776"
    		,"00030270"
    		,"00047588"
    		,"00048705"
    		,"00060923"
    		,"00027236"
    		,"00040019"
    		,"00001177"
    		,"00200708"
    		,"00045142"
    		,"00047474"
    		,"00001411"
    		,"00080253"
    		,"00009545"
    		,"00200598"
    		,"00209491"
    		,"00209496"
    		,"00060863"
    		,"00068766"
    		,"00021878"
    		,"00030937"
    		,"00069599"
    		,"00030799"
    		,"00083675"
    		,"00080165"
    		,"00029667"
    		,"00045227"
    		,"00031110"
    		,"00054838"
    		,"00047093"
    		,"00212190"
    		,"00052814"
    		,"00068261"
    		,"00008574"
    		,"00003564"
    		,"00048448"
    		,"00031868"
    		,"00047575"
    		,"00206949"
    		,"00009722"
    		,"00012694"
    		,"00001165"
    		,"00009748"
    		,"00012854"
    		,"00015965"
    		,"00031550"
    		,"00041564"
    		,"00038024"
    		,"00030763"
    		,"00009546"
    		,"00017424"
    		,"00041476"
    		,"00205970"
    		,"00011978"
    		,"00015907"
    		,"00205953"
    		,"00027092"
    		,"00004439"
    		,"00080010"
    		,"00202597"
    		,"00080650"
    		,"00203771"
    		,"00030913"
    		,"00001396"
    		,"00025128"
    		,"00079194"
    		,"00068899"
    		,"00203589"
    		,"00204100"
    		,"00204101"
    		,"00204008"
    		,"00046233"
    		,"00056847"
    		,"00056599"
    		,"00003926"
    		,"00009764"
    		,"00045012"
    		,"00110752"
    		,"00027325"
    		,"00204023"
    		,"00203573"
    		,"00203955"
    		,"00203590"
    		,"00009705"
    		,"00117805"
    		,"00045067"
    		,"00080935"
    		,"00203263"
    		,"00120054"
    		,"00205027"
    		,"00030693"
    		,"00202350"
    		,"00202616"
    		,"00050105"
    		,"00203471"
    		,"00211835"
    		,"00031483"
    		,"00202339"
    		,"00216263"
    		,"00206429"
    		,"00217350"
    		,"00203039"
    		,"00219714"
    		,"00047995"
    		,"00053077"
    		,"00201935"
    		,"00060026"
    		,"00044905"
    		,"00213183"
    		,"00200912"
    		,"00080902"
    		,"00204210"
    		,"00203084"
    		,"00054577"
    		,"00052858"
    		,"00201915"
    		,"00030747"
    		,"00069467"
    		,"00031002"
    		,"00203503"
    		,"00200306"
    		,"00030358"
    		,"00200391"
    		,"00030069"
    		,"00218271"
    		,"00206472"
    		,"00202951"
    		,"00205605"
    		,"00080176"
    		,"00080781"
    		,"00080551"
    		,"00217690"
    		,"00207420"
    		,"00080740"
    		,"00205751"
    		,"00202467"
    		,"00206591"
    		,"00030157"
    		,"00201516"
    		,"00212193"
    		,"00212009"
    		,"00218270"
    		,"00209651"
    		,"00218331"
    		,"00068756"
    		,"00206583"
    		,"00207654"
    		,"00223191"
    		,"00080232"
    		,"00080178"
    		,"00072395"
    		,"00080834"
    		,"00201777"
    		,"00080906"
    		,"00205929"
    		,"00081054"
    		,"00217840"
    		,"00218550"
    		,"00200568"
    		,"00217782"
    		,"00208167"
    		,"00203469"
    		,"00205443"
    		,"00206628"
    		,"00213012"
    		,"00206880"
    		,"00209175"
    		,"00210717"
    		,"00212906"
    		,"00214259"
    		,"00012809"
    		,"00030762"
    		,"00207367"
    		,"00209154"
    		,"00220772"
    		,"00216938"
    		,"00219669"
    		,"00203261"
    		,"00207275"
    		,"00207529"
    		,"00217811"
    		,"00203505"
    		,"00218444"
    		,"00211577"
    		,"00218325"
    		,"00038966"
    		,"00217725"
    		,"00018153"
    		,"00037107"
    		,"00200254"
    		,"00210034"
    		,"00038037"
    		,"00212874"
    		,"00023105"
    		,"00218197"
    		,"00201848"
    		,"00030766"
    		,"00070085"
    		,"00061029"
    		,"00200310"
    		,"00202069"
    		,"00205832"
    		,"00201496"
    		,"00203027"
    		,"00218445"
    		,"00200989"
    		,"00060103"
    		,"00202034"
    		,"00200611"
    		,"00061049"
    		,"00060320"
    		,"00218412"
    		,"00072384"
    		,"00001221"
    		,"00218408"
    		,"00218410"
    		,"00216884"
    		,"00218201"
    		,"00202824"
    		,"00205682"
    		,"00201658"
    		,"00201501"
    		,"00203544"
    		,"00030574"
    		,"00216934"
    		,"00203087"
    		,"00210710"
    		,"00218202"
    		,"00213145"
    		,"00070157"
    		,"00207798"
    		,"00205798"
    		,"00030730"
    		,"00208951"
    		,"00113201"
    		,"00208165"
    		,"00056586"
    		,"00009675"
    		,"00069586"
    		,"00117983"
    		,"00030607"
    		,"00206073"
    		,"00030084"
    		,"00010377"
    		,"00046207"
    		,"00001324"
    		,"00018485"
    		,"00019275"
    		,"00046392"
    		,"00060321"
    		,"00209459"
    		,"00206218"
    		,"00031672"
    		,"00030653"
    		,"00051983"
    		,"00025708"
    		,"00043628"
    		,"00202076"
    		,"00011327"
    		,"00114999"
    		,"00204097"
    		,"00030182"
    		,"00113888"
    		,"00022044"
    		,"00203778"
    		,"00203569"
    		,"00203680"
    		,"00203565"
    		,"00203572"
    		,"00031248"
    		,"00012564"
    		,"00048015"
    		,"00030780"
    		,"00204173"
    		,"00080569"
    		,"00045794"
    		,"00204160"
    		,"00200535"
    		,"00202099"
    		,"00203272"
    		,"00205231"
    		,"00031874"
    		,"00220267"
    		,"00030447"
    		,"00205035"
    		,"00080072"
    		,"00030280"
    		,"00011415"
    		,"00201097"
    		,"00030103"
    		,"00030181"
    		,"00027223"
    		,"00004905"
    		,"00080889"
    		,"00200990"
    		,"00008516"
    		,"00202334"
    		,"00201721"
    		,"00031340"
    		,"00068842"
    		,"00200271"
    		,"00205036"
    		,"00206879"
    		,"00031690"
    		,"00201950"
    		,"00030257"
    		,"00205987"
    		,"00075011"
    		,"00202418"
    		,"00030273"
    		,"00048013"
    		,"00031280"
    		,"00030373"
    		,"00048838"
    		,"00047445"
    		,"00038532"
    		,"00040026"
    		,"00030894"
    		,"00200409"
    		,"00202205"
    		,"00203777"
    		,"00031825"
    		,"00030332"
    		,"00118615"
    		,"00081003"
    		,"00018166"
    		,"00030908"
    		,"00040010"
    		,"00204186"
    		,"00045102"
    		,"00080017"
    		,"00030321"
    		,"00030327"
    		,"00048246"
    		,"00200749"
    		,"00031671"
    		,"00080336"
    		,"00030125"
    		,"00079239"
    		,"00031553"
    		,"00203149"
    		,"00202795"
    		,"00205131"
    		,"00206210"
    		,"00200009"
    		,"00214381"
    		,"00201710"
    		,"00200072"
    		,"00030371"
    		,"00030669"
    		,"00121211"
    		,"00119493"
    		,"00202054"
    		,"00211889"
    		,"00200049"
    		,"00202431"
    		,"00080295"
    		,"00054095"
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
                <td class="style01" width="100">月賞與金</td>
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
                <td class="style01">③항의 약정된 지급일에 「月基本給」과「月賞與金」<br>및「名節賞與」로  지급된다.</td>
              </tr>
              <tr>
                <td class="style01" valign=top>②</td>
                <td class="style01">基本年俸은 사무직 근로형태의 특성을 감안, 월평균 시간외 근로를 <br>포함하여 포괄 산정한 금액이다.</td>
              </tr>
              <tr>
                <td class="style01">③</td>
                <td class="style01">基本年俸 지급 방법은 「 月基本給 」과「月賞與金」을 매월 25일에 </td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">각각 지급하며「名節賞與」 는 설, 추석에  각각 지급한다.</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">단, 중도입사자의 매월 25일에 지급되는 「 月基本給 」 과「月賞與金」</td>
              </tr>
              <tr>
                <td class="style01">&nbsp;</td>
                <td class="style01">및 설, 추석에 지급되는「名節賞與」에 대해서는 별도 기준에 따른다.</td>
              </tr>

              <!-- CSR ID : 2506534 => 역할급 구분 없이 職務 항목 모두 제외 -->
              <tr id="normal" style="display:none" >
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 資格, 기타수당 등은 별도 기준에 따라 <br>지급한다.</td>
              </tr>
              <tr id="role" style="display:none" >
                <td class="style01" valign=top>④</td>
                <td class="style01">기본연봉에 포함되지 않는 役割給 및 그 외 資格, 기타수당 등은 별도 기준에 따라<br> 지급한다.</td>
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