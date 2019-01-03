<%
/***************************************************************************************/
/*   System Name  : g-HR                                                               */
/*   1Depth Name  : Application                                                        */
/*   2Depth Name  : Time Management                                                    */
/*   Program Name : Overtime                                                           */
/*   Program ID   : D01OTBuild.jsp                                                     */
/*   Description  : 초과근무(OT/특근) 신청을 하는 화면                                 */
/*   Note         :                                                                    */
/*   Creation     : 2002-01-15 박영락
/*   Update       : 2005-03-03 윤정현
/*   Update       : 2007-09-12 huang peng xiao
/*                : 2008-01-02 jungin @v1.0 공휴일 OT 무조건 신청
/*                : 2008-01-23 jungin @v1.1 대만(G220)추가
/*                : 2008-03-19 jungin @v1.2 [C20080312_32365] DAGU법인 OT신청 36시간 초과 신청 체크
/*                : 2008-03-21 jungin @v1.3 [C20080321_37622] Prev. Day 체크시 시간체크
/*                : 2008-05-08 jungin @v1.4 [C20080505_6099] DAGU법인 OT신청 36시간 초과 신청 체크 수정
/*                : 2008-05-14 jungin @v1.5 [C20080513_64781] 중복시 결재상태 체크
/*                : 2008-05-27 jungin @v1.6 [C20080514_66017] DAGU법인 OT신청 36시간 초과 신청 체크 수정
/*                : 2008-06-16 이선아 @v1.7 [C20080613_81843] E_PERSG:B가 아닌걸루 체크하던 현장직 로직을 사원서브그룹E_PERSK=31인 걸루 체크하게 변경함
/*                : 2008-06-16 이선아 @v1.8 clear 오류 수정
/*                : 2008-11-26 jungin @v1.9 [C20081125_62978] DAGU법인 누적 E_ANZHL 체크
/*                : 2009-06-17 jungin @v2.0 [C20090609_70122] LGCC TJ 회사코드 변경(G250->G360)
/*                : 2011-02-24 liukuo @v2.1 [C20110221_28931] LGCC NJ 关于加班申请的时间及加班控制的邀请
/*                : 2011-07-07 liukuo @v2.2 [C20110705_18813] 大沽E-HR加班申请限制申请
/*                : 2011-07-12 liukuo @v2.3 [C20110707_21503] LGCE TP加班设置更改
/*                : 2011-09-22 lixinxin@v2.4 [C20110921_66254] LGCC TJ 关于加班申请的时间及加班控制的邀请
/*                : 2012-03-30 lixinxin@v2.5 [C20120330_79649] 大沽E-HR加班申请限制申请
/*                : 2012-06-28 lixinxin@v2.6 [C20120702_38194] LGCC NJ 关于加班申请的时间及加班控制的取消的邀请
/*                : 2012-09-21 lilonghai@2.7 [C20120919_86405]加班申请功能改善,台湾法人加班限制增加：平日加班必须7点以后申请，节假日、休日加班申请区间必须是早九点晚六点之间
/*                : 2012-12-19 dongxiaomian@v2.8 [C20121218_37585] 大沽关于加班申请增加判断提示午餐扣除时间(12:00-13:00)功能
/*                : 2013-01-08 dongxiaomian@v2.9 [C20130105_46518] 香港法人司机加班取消17小时限制
/*                : 2013-04-26 dongxiaomian@v3.0 [C20130426_20279] 大沽法人最早加班时间8:30判断
/*                : 2013-05-22 dongxiaomian@v3.1 [C20130515_32327] LG TP法人 加班申请时段解锁申请
/*                : 2013-07-30 dongxiaomian@v3.2 [C20130716_70016] LGCC TJ申请加班时扣除午餐(12:00~13:00)晚餐(17:30~18:30)时间的功能
/*                : 2014-04-10 dongxiaomian@v3.3 [C20140408_19687] DAGU事务职人员不能申请加班设置
/*                : 2014-06-23 dongxiaomian@v3.4 [C20140623_62027] 台湾法人加班限制设置
/*                : 2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更
/*                : 2015-03-20 pangxiaolin@v3.6 增加职级导致职级code修改20150320
/*                : 2015-07-03 pangxiaolin@v3.7  [C20150615_01577] [HR]加班申请添加限制
/*                : 2015-07-17 li ying zhe @v3.8  [SI -> SM]Global e-HR Add JV(G450)
/*                : 2015-10-03 masai       @v3.9  [SI -> SM]Global e-HR Add JV(G280 and G110)
/*                : 2016-08-17 pangxiaolin@v4.0  [C20160713_17209]G180加班申请系统设定邀请
/*                : 2016-09-20 pangmin@v4.01  []G180节假日加班申请
/*                : 2016-09-27 pangmin@v4.02  []G170加班申请画面 加班内容通过下拉列表选择
/*                : 2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请
/*                : 2017-03-20 eunha [CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가
/*                : 2017-04-03 eunha [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한
/*                : 2017-05-15 eunha [CSR ID:3379190] Over Time issue
/*                : 2017-05-15 eunha [CSR ID:3357463] 調整台灣法人假日及國定假日加班的時數 START
/*                : 2017-09-21 eunha [CSR ID:3492341] 系统设置
/*                : 2017-12-06 이지은 [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(補休假) function increasing
/*                                  G220법인만 초과근무 신청 시 대체휴가 신청 옵션 기능 추가.
/*                : 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out
/*                : 2018-04-24 이지은 [CSR ID:3670750] LG화학 NJ법인 과장급이상 주말잔업 로직 관련 확인요청드립니다
/*                : 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
/***************************************************************************************/
%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/web/common/commonProcess.jsp"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="tags-family" tagdir="/WEB-INF/tags/A/A04Family"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tags-approval" tagdir="/WEB-INF/tags/approval"%>

<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ page import="hris.common.rfc.*"%>
<%@ page import="hris.D.*"%>
<%@ page import="hris.D.D01OT.*"%>

<%--@elvariable id="g" type="com.common.Global"--%>
<%--@elvariable id="phonenumdata" type="hris.common.PersonData"--%>
<%--@elvariable id="PersonData" type="hris.common.PersonData"--%>
<%--@elvariable id="phonenum" type="hris.common.PersonData"--%>

<%
    WebUserData user = (WebUserData) session.getAttribute("user");

    PersonData phonenum = (PersonData) request.getAttribute("PersonData");
    //out.println("### E_PERSG  :   " + phonenum.E_PERSG);
    //out.println("### E_PERSK  :   " + phonenum.e_PERSK);

    String jobid = (String) request.getAttribute("jobid");
    String message = (String) request.getAttribute("message");

    Vector OTHDDupCheckData_vt = (Vector) request.getAttribute("OTHDDupCheckData_vt");

    String PERNR = (String) request.getAttribute("PERNR");
    String E_BUKRS = (String) request.getAttribute("E_BUKRS");
    String E_JIKKB = (String) request.getAttribute("E_JIKKB");
    //E_BUKRS = "G180";
    //E_BUKRS = "";

    Vector D01OTData_vt = null;
    D01OTData data = null;

    D01OTData_vt = (Vector) request.getAttribute("D01OTData_vt");
    data = (D01OTData) Utils.indexOf(D01OTData_vt, 0);

    if (message == null) {
        message = "";
    }

    // 2003.01.29 - 시간관리에 대한 최초 재계산일을 읽어 신청을 막아준다.
    /*
    GetTimmoRFC rfc = new GetTimmoRFC();

    String E_RRDAT = rfc.GetTimmo( user.companyCode );
    long   D_RRDAT = Long.parseLong(DataUtil.removeStructur(E_RRDAT,"-"));
    */

    //  2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 begin
    Vector reasonCode = (Vector) request.getAttribute("reasonCode");

    Logger.debug.println("E_BUKRS::" + E_BUKRS);
    Boolean isUpdate = (Boolean) request.getAttribute("isUpdate");
    if (isUpdate == null)
        isUpdate = false;
    //[CSR ID:3492341] 系统设置  start
    String OTbuildYn  = "Y";
    if (phonenum.E_BUKRS.equals("G280")){
        if(phonenum.E_JIKKB.equals("3000") ||phonenum.E_JIKKB.equals("3010")){
            OTbuildYn  = "N";
        }
    }
    //[CSR ID:3492341] 系统设置  end
%>


<c:set var="user" value="<%=user%>" />
<c:set var="phonenum" value="<%=phonenum%>" />

<c:set var="message" value="<%=message%>" />
<c:set var="PERNR" value="<%=PERNR%>" />
<c:set var="data" value="<%=data%>" />
<c:set var="E_BUKRS" value="<%=E_BUKRS%>" />
<c:set var="E_JIKKB" value="<%=E_JIKKB%>" />
<c:set var="isUpdate" value="<%=isUpdate%>" />

<c:set var="OTHDDupCheckData_vt" value="<%=OTHDDupCheckData_vt%>" />
<c:set var="OTHDDupCheckData_vt_size"
    value="<%=OTHDDupCheckData_vt.size()%>" />
<c:set var="locale" value="<%=g.getLocale()%>" />
<%--//[CSR ID:3492341] 系统设置  start --%>
<c:set var="OTbuildYn" value="<%=OTbuildYn%>" />
<%--//[CSR ID:3492341] 系统设置  end --%>
<%-- <script language="JavaScript" src="${g.image}js/prototype.js"></script> --%>

<tags:layout css="ui_library_approval.css" script="dialog.js">

    <script language="JavaScript">


<%----------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------- Start beforeSubmit() -------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------%>
//날짜 변경해서 보낸다.
//달력사용
var submitFlag=false;
function beforeSubmit() {
    submitFlag = true
    if( !(check_Data() && other_check()) ) {

         return false;
    }

    // 2004.2.11 - 일정중복을 체크하는 로직 추가. 같은 날짜와 시간일 경우 중복경고.
    // 2016/12/21 - 오류수정 ksc
    var c_WORK_DATE, c_BEGUZ, c_ENDUZ;
    c_WORK_DATE = document.form1.WORK_DATE.value;
    c_WORK_DATE = c_WORK_DATE.replace(".","").replace(".","");
    c_BEGUZ     = c_WORK_DATE+document.form1.BEGUZ.value.replace(":","");
    c_ENDUZ     = c_WORK_DATE+document.form1.ENDUZ.value.replace(":","");
    if (c_BEGUZ   > c_ENDUZ ){
        c_ENDUZ = getAfterDate(c_WORK_DATE,1) + document.form1.ENDUZ.value.replace(":","");
    }
    c_AINF_SEQN = document.form1.AINF_SEQN.value;


      <c:forEach var="c_Data"  items="${OTHDDupCheckData_vt}" varStatus="status">

        <c:set var="s_BEGUZ1" value= "${fn:substring(c_Data.BEGUZ,0,2)}${fn:substring(c_Data.BEGUZ,3,5)}" />
        <c:set var="s_ENDUZ1" value = "${fn:substring(c_Data.ENDUZ,0,2)}${fn:substring(c_Data.ENDUZ,3,5)}" />
        <c:if test='${s_ENDUZ1=="0000"}'>
            <c:set var="s_ENDUZ1" value = "2400"/>
        </c:if>

        <c:set var="s_BEGUZ" value = "${ f:removeStructur (c_Data.WORK_DATE,'-') }${s_BEGUZ1}"/> // Integer.parseInt(
        <c:set var="s_ENDUZ" value = "${ f:removeStructur (c_Data.WORK_DATE,'-') }${s_ENDUZ1}"/> //Integer.parseInt(
        <c:if test='${s_ENDUZ  < s_BEGUZ}'>
            <c:set var="s_ENDUZ" value = "${ f:addDays(f:removeStructur(c_Data.WORK_DATE,'-'),1) }${s_ENDUZ1}"/> //Integer.parseInt(
        </c:if>

        <%-- 두기간이(b~e, B~E)  겹치는 경우는 B <= e AND E > b 의경우이다 (2016/12/21 ksc)
                뒤의 조건 'E > b'의 경우 '>='이 아님에 주의, 통상적으로 09;00 ~ 15:00 까지 근무한다고 할때 엄밀히 14:59분까지 포함되고 15:00은 포함되지 않음.
        --%>

          if( (("${s_BEGUZ }" < c_ENDUZ) && ("${s_ENDUZ }" > c_BEGUZ) )  ||  ("${ c_Data.WORK_DATE }" == c_WORK_DATE)) {
            if( ${isUpdate!=true} || "${c_Data.AINF_SEQN}" != c_AINF_SEQN && ${isUpdate==true} ) {  //check Requested
                  //***********************************************************************************
                  // 중복시 결제상태 체크.     2008-05-14      김정인     [C20080513_64781] @v1.6
                  if( "${ c_Data.APPR_STAT }" != "R" && ${ s_BEGUZ } == c_BEGUZ && ${s_ENDUZ } == c_ENDUZ ) {
                          if("${ c_Data.APPR_STAT }" == "A"){
                                  alert("<spring:message code='MSG.D.D01.0004'/>");//Requested. Please check it in approved document.
                                  document.form1.BEGUZ.select();
                                  return;
                          }else if("${ c_Data.APPR_STAT }" == ""){
                                  alert("<spring:message code='MSG.D.D01.0004'/>");//Requested. Please check it in approved document.
                                  document.form1.BEGUZ.select();
                                  return;
                          }

                      } else if( "${ c_Data.APPR_STAT }" != "R" )  {
                          if("${ c_Data.APPR_STAT }" == "A"){
                                  alert("<spring:message code='MSG.D.D01.0005'/>");//The request time is repeated. Please check it in approved document.
                                  document.form1.BEGUZ.select();
                                  return;
                          }else if("${ c_Data.APPR_STAT }" == ""){
                                  alert("<spring:message code='MSG.D.D01.0005'/>");//The request time is repeated.Please check it in approved document.
                                  document.form1.BEGUZ.select();
                                  return;
                          }
                      }
            }
          }

   </c:forEach>

         <%--
         for( int i = 0 ; i < OTHDDupCheckData_vt.size() ; i++ ) {
             D16OTHDDupCheckData c_Data = (D16OTHDDupCheckData)OTHDDupCheckData_vt.get(i);
             String s_BEGUZ1 = c_Data.BEGUZ.substring(0,2) + c_Data.BEGUZ.substring(3,5);
             String s_ENDUZ1 = c_Data.ENDUZ.substring(0,2) + c_Data.ENDUZ.substring(3,5);

             if(s_ENDUZ1.equals("0000")) {
               s_ENDUZ1 = "2400";
             }
             int s_BEGUZ = Integer.parseInt(s_BEGUZ1);
             int s_ENDUZ = Integer.parseInt(s_ENDUZ1);
         --%>
        <%-- 2016/12/20일 이전소스(중복체크가 잘안됨)
              //ENDUZ가 다음날로 넘어가지 않을 경우.//check repeat
              } else if( "${ c_Data.APPR_STAT }" != "R" && ${ s_BEGUZ } < ${ s_ENDUZ } && (
                              (${ s_BEGUZ } <= c_BEGUZ && ${ s_ENDUZ } > c_BEGUZ) ||
                              (${ s_BEGUZ } < c_ENDUZ   && ${ s_ENDUZ } >= c_ENDUZ) ||
                              (${ s_BEGUZ } >= c_BEGUZ && ${ s_ENDUZ } <= c_ENDUZ)    ))  {

                          if("${ c_Data.APPR_STAT }" == "A"){
                                  alert("<spring:message code='MSG.D.D01.0005'/>");//The request time is repeated. Please check it in approved document.
                                  document.form1.BEGUZ.select();
                                  return;
                          }else if("${ c_Data.APPR_STAT }" == ""){
                                  alert("<spring:message code='MSG.D.D01.0005'/>");//The request time is repeated.Please check it in approved document.
                                  document.form1.BEGUZ.select();
                                  return;
                          }
                  //alert("The request time is repeated.Please check it in approving document.");
                  //document.form1.BEGUZ.select();
                  //return;

              //ENDUZ가 다음날로 넘어가는 경우.//check repeat
            } else if( "${ c_Data.APPR_STAT }" != "R" &&  ${ s_BEGUZ } > ${ s_ENDUZ } &&
                            (        ( (${ s_BEGUZ } <= c_BEGUZ && c_BEGUZ < 2400) || (c_BEGUZ >= 0000 && ${ s_ENDUZ } > c_BEGUZ)    ) ||
                                      ( (c_ENDUZ <= 2400 &&  ${ s_BEGUZ } < c_ENDUZ) || (c_ENDUZ > 0000 && ${ s_ENDUZ } >= c_ENDUZ) ) ||
                                      ( c_BEGUZ > c_ENDUZ && ${ s_BEGUZ } >= c_BEGUZ  && ${ s_ENDUZ } <= c_ENDUZ)
                              )
                             ) {
                              if("${ c_Data.APPR_STAT }" == "A"){
                                  alert("<spring:message code='MSG.D.D01.0000'/>");
                                  document.form1.BEGUZ.select();
                                  return;
                              }else if("${ c_Data.APPR_STAT }" == ""){
                                  alert("<spring:message code='MSG.D.D01.0005'/>");
                                  document.form1.BEGUZ.select();
                                  return;
                              }
                  //alert("The request time is repeated.Please check it in approving document.");
                  //document.form1.BEGUZ.select();
                  //return;
                          }
          //***********************************************************************************
              }
   --%>
   // 2004.2.11
    //2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 begin
   <c:if test='${E_BUKRS != null and (E_BUKRS eq "G170")}'>
         if(document.form1.ZRCODE.value == ""){
             alert("<spring:message code='MSG.D.D01.0055'/>");//Please select Application Reason Type.");
             document.form1.ZRCODE.value= "";
             document.form1.ZRCODE.focus();
             return;
         }
    </c:if>


    //2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 end
    if( $('#ZREASON').val() == "" ){    //신청사유
        alert("Please input Application Reason.");
        document.form1.ZREASON.focus();
        return;
    }

    if (document.form1.STDAZ.value=="" || document.form1.STDAZ.value=="0"){
        alert("<spring:message code='MSG.D.D01.0053'/>");//Application overtime is 0 hour.\nPlease check overtime and break hours  period.");
        return;
    }

    var dayCount = dayDiff(document.form1.BEGDA.value, document.form1.WORK_DATE.value);
    var cDT = new Date();

    <c:choose>
    <c:when test='${OTHDDupCheckData_vt_size > 0}'>
        <c:forEach var="c_Data"  items="${OTHDDupCheckData_vt}" varStatus="status">

          if( "${ c_Data.WORK_DATE }" == c_WORK_DATE ) {
                  if ( "${ c_Data.APPR_STAT }" != "R" && dayCount < 0 ) {

                          //alert("Working overtime (holiday works) must request ahead of time.\nIf there are problems, please contact timekeeper.");
                          //document.form1.WORK_DATE.focus();
                          //return;
                  }else if( dayCount == 0 ) {

                          var curTime = "${f:currentTime()}";
                          var interval_time = getBetweenTime(curTime, document.form1.BEGUZ.value);

                          if( "${ c_Data.APPR_STAT }" != "R" && interval_time < 0 ) {
                              //alert("Working overtime (holiday works) must request ahead of time.\nIf there are problems, please contact timekeeper.");
                              //document.form1.BEGUZ.focus();
                              //return;
                          }
                  }
          }else {
                  if ( "${ c_Data.APPR_STAT }" != "R" && dayCount < 0 ) {

                          //alert("Working overtime (holiday works) must request ahead of time.\nIf there are problems, please contact timekeeper.");
                          //document.form1.WORK_DATE.focus();
                          //return;
                  }else if( dayCount == 0 ) {

                          var curTime ="${f:currentTime()}";
                          var interval_time = getBetweenTime(curTime, document.form1.BEGUZ.value);

                          if( "${ c_Data.APPR_STAT }" != "R" && interval_time < 0 ) {
                              //alert("Working overtime (holiday works) must request ahead of time.\nIf there are problems, please contact timekeeper.");
                              //document.form1.BEGUZ.focus();
                              //return;
                          }
                  }
          }
        </c:forEach>

    </c:when>

    <c:otherwise>

      if ( dayCount < 0 ) {
        //alert("Working overtime (holiday works) must request ahead of time.\nIf there are problems, please contact timekeeper.");
        //document.form1.WORK_DATE.focus();
        //return;
      }

    </c:otherwise>
    </c:choose>


    var E_BUKRS = '${ E_BUKRS }';
    //2012-03-30 lixinxin@v2.5 [C20120330_79649] 添加字段E_JIKKB
    var E_JIKKB = '${ E_JIKKB }';
    var WORK_DATE = document.form1.WORK_DATE.value;
    var day =  Number(WORK_DATE.substring(8,10));
    var STDAZ = document.form1.STDAZ.value;
    var tmp = STDAZ % 4;
    var WORK_DAYS = document.form1.WORK_DAYS.value;
    //2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更 begin
    var year = Number(WORK_DATE.substring(0,4));
    //2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更 end
    // 南京法人关于加班申请的时间及加班控制的邀请                2011-02-24      liukuo      [C20110221_28931] @v2.1
    //目标是事物职的员工
    //2013-07-30 dongxiaomian@v3.2 [C20130716_70016] LGCC TJ申请加班时扣除午餐(12:00~13:00)晚餐(17:30~18:30)时间的功能  begin**************

    <c:if test='${phonenum.e_PERSK != null}'>

    if(E_BUKRS == 'G360'){
          var beguz_tw = document.form1.BEGUZ.value.replace(":",""); //加班开始时间
          var enduz_tw = document.form1.ENDUZ.value.replace(":",""); //加班结束时间
          var pbeg1_tw = document.form1.PBEG1.value.replace(":","");     //休息1开始时间
          var pend1_tw = document.form1.PEND1.value.replace(":",""); //休息1结束时间
          var pbeg2_tw = document.form1.PBEG2.value.replace(":",""); //休息2开始时间
          var pend2_tw = document.form1.PEND2.value.replace(":",""); //休息2结束时间

          if(beguz_tw<=1200){//当加班开始时间小于12点时
              if(enduz_tw>1200&&enduz_tw<=1300){
                  if(pbeg1_tw!='1200'||pend1_tw!=enduz_tw){
                      var end_time = document.form1.ENDUZ.value;
                      //请选择正确的午餐休息时间(12:00~
                              //)。\n\nPlease choose the right lunch period(12:00~
                      alert('<spring:message code='MSG.D.D01.0028'/>(12:00~'+end_time+').');
                      return;
                  }
              }
              if(enduz_tw>1300&&enduz_tw<=1730){
                  if(pbeg1_tw!='1200'||pend1_tw!='1300'){
                      alert("<spring:message code='MSG.D.D01.0022'/>");//请选择正确的午餐休息时间(12:00~13:00)。\nPlease choose the right lunch period(12:00~13:00).
                      return;
                  }
              }
              if(enduz_tw>1730&&enduz_tw<=1830){
                  if(pbeg1_tw!='1200'||pend1_tw!='1300'||pbeg2_tw!='1730'||pend2_tw!=enduz_tw){
                      var end_time = document.form1.ENDUZ.value;
                      alert('<spring:message code='MSG.D.D01.0025'/>'+end_time+end_time+').');
                      return;
                  }
              }
              if(enduz_tw>1830){
                  if(pbeg1_tw!='1200'||pend1_tw!='1300'||pbeg2_tw!='1730'||pend2_tw!='1830'){
                      alert('<spring:message code='MSG.D.D01.0027'/>');
                      return;
                  }
              }
          }

          if(beguz_tw>1200&&beguz_tw<=1300){//当加班开始时间在12点到13点之间时
              if(enduz_tw>1200&&enduz_tw<=1300){
                  if(pbeg1_tw!=beguz_tw||pend1_tw!=enduz_tw){
                      var begin_time = document.form1.BEGUZ.value;
                      var end_time = document.form1.ENDUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>('+begin_time+'~'+end_time+').');
                      return;
                  }
              }
              if(enduz_tw>1300&&enduz_tw<=1730){
                  if(pbeg1_tw!=beguz_tw||pend1_tw!='1300'){
                      var begin_time = document.form1.BEGUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>('+begin_time+'~13:00).');
                      return;
                  }
              }
              if(enduz_tw>1730&&enduz_tw<=1830){
                  if(pbeg1_tw!=beguz_tw||pend1_tw!='1300'||pbeg2_tw!='1730'||pend2_tw!=enduz_tw){
                      var begin_time = document.form1.BEGUZ.value;
                      var end_time = document.form1.ENDUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>('+begin_time+
                              '~13:00)<spring:message code="MSG.D.D01.0027"/>(17:30~'+end_time+').');
                      return;
                  }
              }
              if(enduz_tw>1830){
                  if(pbeg1_tw!=beguz_tw||pend1_tw!='1300'||pbeg2_tw!='1730'||pend2_tw!='1830'){
                      var begin_time = document.form1.BEGUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>('+begin_time+
                              '~13:00)<spring:message code="MSG.D.D01.0027"/>(17:30~18:30)');
                      return;
                  }
              }
          }

          if(beguz_tw>1300&&beguz_tw<=1730){//当加班开始时间在13点之后17点半之前时
              if(enduz_tw>1730&&enduz_tw<=1830){
                  if(pbeg1_tw!='1730'||pend1_tw!=enduz_tw){
                      var end_time = document.form1.ENDUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>(17:30~'+end_time+').');
                      return;
                  }
              }
              if(enduz_tw>1830){
                  if(pbeg1_tw!='1730'||pend1_tw!='1830'){
                      alert('<spring:message code="MSG.D.D01.0028"/>(17:30~18:30)');
                      return;
                  }
              }
          }

          if(beguz_tw>1730&&beguz_tw<=1830){//当加班开始时间在17:30到18:30之间时
              if(enduz_tw>1730&&enduz_tw<=1830){
                  if(pbeg1_tw!=beguz_tw||pend1_tw!=enduz_tw){
                      var begin_time = document.form1.BEGUZ.value;
                      var end_time = document.form1.ENDUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>('+begin_time+'~'+end_time+').');
                      return;
                  }
              }
              if(enduz_tw>1830){
                  if(pbeg1_tw!=beguz_tw||pend1_tw!='1830'){
                      var begin_time = document.form1.BEGUZ.value;
                      alert('<spring:message code="MSG.D.D01.0028"/>('+begin_time+'~18:30)');
                      return;
                  }
              }
          }

      }

    </c:if> // end if (E_PERSK !=null)



    //2013-07-30 dongxiaomian@v3.2 [C20130716_70016] LGCC TJ申请加班时扣除午餐(12:00~13:00)晚餐(17:30~18:30)时间的功能  end**************
    // LGCC TJ(G360)法人关于加班申请的时间及加班控制的邀请             2011-09-22      lixinxin        [C20110921_66254 ] @v2.4
    //目标是事物职的员工

    <c:if test='${phonenum.e_PERSK != null  and phonenum.e_PERSK==("21")}'>


      //LGCC TJ法人之前说 要增加申请加班时间的限制，后来说要从10月21日执行。 2011-10-12
      if('${E_BUKRS}' == 'G360'){
          if(WORK_DAYS > 2){
              alert("<spring:message code="MSG.D.D01.0024"/>");//You have already over 2 limited days.
              return;
          }
      }
      // 2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out Start
      // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
      if(${(E_BUKRS == 'G180') or (E_BUKRS == 'G450') or (E_BUKRS == 'G570') or (E_BUKRS == 'G620') }){//Global e-HR Add JV(G450)   2015-07-17      li ying zhe @v1.1 [SI -> SM]
      // 2018-03-12 KDM @PJ.광저우 법인(G570) Roll-Out End
      //[CSR ID:3670750]   } 괄호 오입력 삭제
         // alert("WORK_DAYS"+WORK_DAYS);
          //2011-06-28 lixinxin@v2.6 [C20120702_38194] LGCC NJ 关于加班申请的时间及加班控制的取消的邀请
          //if(WORK_DAYS > 3){
          //  alert("You have already over 3 limited days.");
          //  return;
          //}

          //主管及以下职级
          // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
          // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
         <c:if test='${E_BUKRS != null and (E_BUKRS==("G180") or E_BUKRS==("G450") or E_BUKRS==("G570") or E_BUKRS==("G620")) }'>//Global e-HR Add JV(G450)    2015-07-17      li ying zhe @v1.1 [SI -> SM]
         // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
              //2015-03-20 pangxiaolin@v3.5 增加职级导致职级code修改20150320start
              //if((phonenum.e_JIKCH.equals("2300") || phonenum.e_JIKCH.equals("2410") || phonenum.e_JIKCH.equals("2420") || phonenum.e_JIKCH.equals("2430"))) {
                      //과장이하
                  <c:choose>
                  <c:when test='${phonenum.e_JIKCH==("2300") or phonenum.e_JIKCH==("2310") or phonenum.e_JIKCH==("2320") or
                          phonenum.e_JIKCH==("2410") or phonenum.e_JIKCH==("2411") or
                          phonenum.e_JIKCH==("2412") or  phonenum.e_JIKCH==("2420") or
                          phonenum.e_JIKCH==("2430")}'>
                          //2015-03-20 pangxiaolin@v3.5 增加职级导致职级code修改20150320end 과장미만

                      if($('#ZMODN').val() == 'ODAY' &&  $('#FTKLA').val() == '0'){  //平日加班不能超过36小时(20号以后到月底不判断)
                           <c:if test='${E_BUKRS=="G450"}'>
                          if(day<21 && eval(document.form1.WORK_HOURS.value) > eval(36)){  //work_hours 는 평일 근태만 합한 값
                              alert('<spring:message code="MSG.D.D01.0023"/>');//Please apply below 36 hours.
                              return;
                          }
                          </c:if>
                      }
                      if( $('#ZMODN').val() == 'OFF' && $('#FTKLA').val() == '0'){  //周末加班每天不能超过8小时
                          if(STDAZ > 8){
                              alert('<spring:message code="MSG.D.D01.0029"/>');//Please apply a multiple of four hours, 8h is maximum hours( 4, 8 ).
                              return;
                          }
                      }
                      var work_date = document.form1.WORK_DATE.value.substring(0,4)+document.form1.WORK_DATE.value.substring(5,7)+document.form1.WORK_DATE.value.substring(8,10);
                        if(work_date > '20160720'){
                        // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
                        <c:if test='${(E_BUKRS eq "G180") or  (E_BUKRS eq "G570")}' >
                        // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
                            if($('#ZMODN').val() == 'ODAY' && $('#FTKLA').val() == '0'){
                                    alert("<spring:message code='MSG.D.D01.0101'/>");//'can not request.');
                                    return;
                            }
                        </c:if>
                        }
              </c:when>
              <c:otherwise>

                  //经理及以上职级周末加班不能超过32小时  과장이상 20160715
                      if($('#ZMODN').val() == 'OFF' && $('#FTKLA').val() == '0'){
//                            if(day<21 && eval(document.form1.OFF_HOURS.value) > eval(32)){        // 입력총시간(<>실적계) OT_OFF
                          if(day<21 && eval(document.form1.HOURS.value) > eval(32)){            // 총연장시간(실적총계+신청시간)    ; SAP상에 G180, G450의 경우 휴일근로시간이 빠지게되어있음.(2017/1/12확인)
                              alert('<spring:message code="MSG.D.D01.0030"/>');//Please apply below 32 hours.
                              return;
                          }
                      }

                      var work_date = document.form1.WORK_DATE.value.substring(0,4)+document.form1.WORK_DATE.value.substring(5,7)+document.form1.WORK_DATE.value.substring(8,10);
                      if(($('#ZMODN').val() == 'ODAY') && ($('#FTKLA').val() == '0') && (work_date > '20160720') ){ // 평일신청불가
                            alert("<spring:message code='MSG.D.D01.0101'/>");//'can not request.');
                            return;
                      }
              </c:otherwise>
              </c:choose>
          </c:if>
      }

    </c:if>

      //2015-07-03 pangxiaolin@v3.7  [C20150615_01577] [HR]加班申请添加限制 start
     if(E_BUKRS == 'G220'){  //if G180 check apply hours.

         //[CSR ID:3544114]--------------start----------------------------------
        for(var i = 0 ; i < document.form1.VERSL.length ; i ++){
            if(document.form1.VERSL[i].checked == true){
                document.form1.VERSL.value = document.form1.VERSL[i].value;
            }
        }

        if( document.form1.VERSL.value == "" ||document.form1.VERSL.value == undefined) {
            alert('<spring:message code="LABEL.D.D01.0017"/><spring:message code="LABEL.A.A19.0003"/>');//초과근무 보상는 필수입력사항입니다.
            return;
        }
        //[CSR ID:3544114]----------------end--------------------------------

          if(day < 21 && (eval(document.form1.WORK_HOURS.value)
                                  +eval(document.form1.OFF_HOURS.value)
                                  +eval(document.form1.HOURS.value)
                                  -eval(document.form1.STDAZ.value)
                                  -eval(document.form1.STDAZ.value)) > eval(46)){
                  alert('<spring:message code="MSG.D.D01.0031"/>');//Please apply below 46 hours.
                  return;
           }



    }
    //2015-07-03 pangxiaolin@v3.7  [C20150615_01577] [HR]加班申请添加限制 end


    //alert("E_BUKRS : " + E_BUKRS);
    //Global e-HR Add JV(G450)      2015-07-17      li ying zhe @v1.1 [SI -> SM]
    // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
    // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
    if(E_BUKRS == 'G180' || E_BUKRS == 'G220' || E_BUKRS == 'G450' || E_BUKRS == 'G570' || E_BUKRS == 'G620'){    //if G180 check apply hours.
    // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out END
    // [CSR ID:3379190] Over Time issue  start
    //if($('#ZMODN').val() == 'OFF' || $('#FTKLA').val() == '1'){
    if($('#ZMODN').val() == 'OFF' || $('#FTKLA').val() == '1'||E_BUKRS == 'G220' &&($('#ZMODN').val()=='XXR'||$('#ZMODN').val()=='GDR'||$('#ZMODN').val()=='LJR'||$('#ZMODN').val()=='XJR')){
        // [CSR ID:3379190] Over Time issue  end
          //2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更
          //if(E_BUKRS == 'G180' && tmp != 0){
          // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
          // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
          if((E_BUKRS == 'G180' || E_BUKRS == 'G450' || E_BUKRS == 'G570' || E_BUKRS == 'G620') && tmp != 0 && year < '2015'){//Global e-HR Add JV(G450)    2015-07-17      li ying zhe @v1.1 [SI -> SM]
          // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
          //2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更 end
              alert('<spring:message code="MSG.D.D01.0032"/>');//Please apply a multiple of four hours ( 4, 8, 12 ..).
              return;

          // ********************************************************
          // 대만(G220)추가.      2008-01-23      김정인     @v1.1
          // LGCE TP加班设置更改 2011-07-12 liukuo   @v2.3
          //2014-06-23 dongxiaomian@v3.4 [C20140623_62027] 台湾法人加班限制设置   begin
          // else if(E_BUKRS == 'G220' && STDAZ > 8)
              //alert('Please apply a multiple of four hours, 8h is maximum hours( 4, 8 ).');
              //alert('Please apply below 8 hours.');
         //[CSR ID:3357463] 調整台灣法人假日及國定假日加班的時數 START
          //}else if(E_BUKRS == 'G220' && STDAZ > 10){
              }else if(E_BUKRS == 'G220' && STDAZ > 12){
              //alert('Please apply a multiple of four hours, 8h is maximum hours( 4, 8 ).');
              alert('<spring:message code="MSG.D.D01.0033"/>');//Please apply below 12 hours.
              ////2014-06-23 dongxiaomian@v3.4 [C20140623_62027] 台湾法人加班限制设置   end
         //[CSR ID:3357463] 調整台灣法人假日及國定假日加班的時數 END
              return;
                //20160701 start
                //20160920 pangmin G180节假日加班申请 start
                //节日加班无上限 原代码 }else if(E_BUKRS == 'G180' && STDAZ > 8  ){
                //     2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
                // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
         }else if( (E_BUKRS == 'G180' || E_BUKRS == 'G570' || E_BUKRS == 'G620') && STDAZ > 8 && $('#FTKLA').val() == '0' ){
                // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
                //20160920 pangmin G180节假日加班申请
                //节日加班无上限 end
                alert('<spring:message code="MSG.D.D01.0102"/>');//Please apply below 8 hours.
                return;
            }//if(E_BUKRS == 'G180'  ){
                //alert('can not request.');
                //return;
            //}
            //20160701 end
          //********************************************************
          //2012-09-21 lilonghai@2.7 [C20120919_86405]
          //2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更 begin
          //if(E_BUKRS == 'G220'){  //限制只有台湾法人有以下限制
          // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Strat
          // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
          if(E_BUKRS == 'G220' || E_BUKRS == 'G180' || E_BUKRS == 'G450' || E_BUKRS == 'G570' || E_BUKRS == 'G620'){ //Global e-HR Add JV(G450)     2015-07-17      li ying zhe @v1.1 [SI -> SM]
          // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
          //2015-01-06 pangxiaolin@v3.5 [C20150106_74242] 南京法人加班申请单位变更 end
              var beguz_tw = document.form1.BEGUZ.value.substring(0,2) ;  //加班开始时间
              var enduz_tw = document.form1.ENDUZ.value.substring(0,2);   //加班结束时间
              var stdaz_tw =  document.form1.STDAZ.value;                      //加班小时数
              //alert(beguz_tw+"   "+enduz_tw+"     "+stdaz_tw);
              if(stdaz_tw%1 != 0){  //最小单位为一小时
                  alert("<spring:message code="MSG.D.D01.0034"/>");//the minimum overtime unit should be one hour.
                  return;
              }
              /**2014-06-23 dongxiaomian@v3.4 [C20140623_62027] 台湾法人加班限制设置   begin
              *if(beguz_tw < 9 || enduz_tw >18){ //节假日、休日加班申请区间必须是早九点晚六点之间
              *   alert("overtime for holiday, off-day must apply between 9:00 to 18:00.");
              *   return;
              *}
              *///2014-06-23 dongxiaomian@v3.4 [C20140623_62027] 台湾法人加班限制设置   end
          }
          //**************************end 2012-09-21 lilonghai@2.7 [C20120919_86405]***************************************
      }else{
          //20160701 start
            var beguz_tw = document.form1.BEGUZ.value.substring(0,2) ;  //加班开始时间
                var enduz_tw = document.form1.ENDUZ.value.substring(0,2);   //加班结束时间
                var stdaz_tw =  document.form1.STDAZ.value;                         //加班小时数
                //alert(beguz_tw+"   "+enduz_tw+"     "+stdaz_tw);
                //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Strat
                //2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
                if((stdaz_tw%1 != 0)&&(E_BUKRS == 'G180' || E_BUKRS == 'G570' || E_BUKRS == 'G620' )){  //最小单位为一小时
                //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
                    alert('<spring:message code="MSG.D.D01.0034"/>');//"the minimum overtime unit should be one hour.");
                    return;
                }
        //20160701 end
        //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
        //2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
          if((E_BUKRS == 'G180' || E_BUKRS == 'G450' || E_BUKRS == 'G570' || E_BUKRS == 'G620') && STDAZ > 3){//Global e-HR Add JV(G450)    2015-07-17      li ying zhe @v1.1 [SI -> SM]
        //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
                alert('<spring:message code="MSG.D.D01.0035"/>');//Please apply below 3 hours.
              return;
          }else if(E_BUKRS == 'G220' && STDAZ > 4){
              //alert("You can't apply overtime in workday.");
              //document.form1.WORK_DATE.value = "";
              //fn_openCal('WORK_DATE','after_fn_openCal()');
              alert('<spring:message code="MSG.D.D01.0036"/>');//Please apply below 4 hours.
              return;
          }
          //2012-09-21 lilonghai@2.7 [C20120919_86405]
          if(E_BUKRS == 'G220'){  //限制只有台湾法人有以下限制
          //2013-05-22 dongxiaomian@v3.1 [C20130515_32327] LG TP法人 加班申请时段解锁申请 begin******************
              //var beguz_tw = document.form1.BEGUZ.value.substring(0,2) ;  //加班开始时间
              var beguz_tw = document.form1.BEGUZ.value.replace(":","");  //加班开始时间
              var enduz_tw = document.form1.ENDUZ.value.replace(":","");   //加班结束时间
         //2013-05-22 dongxiaomian@v3.1 [C20130515_32327] LG TP法人 加班申请时段解锁申请 end******************
              var stdaz_tw =  document.form1.STDAZ.value;                      //加班小时数
              if(stdaz_tw%1 != 0){  //最小单位为一小时
                  alert("<spring:message code="MSG.D.D01.0037"/>");//the minimum overtime unit should be one hour.
                  return;
              }
           //2013-05-22 dongxiaomian@v3.1 [C20130515_32327] LG TP法人 加班申请时段解锁申请 begin******************
          // if(beguz_tw < 1900){    // 平日加班必须7点以后申请
             if(!(beguz_tw==0830&&enduz_tw==1230)&&(beguz_tw < 1900)){
          //2013-05-22 dongxiaomian@v3.1 [C20130515_32327] LG TP法人 加班申请时段解锁申请 end******************
                  alert("<spring:message code="MSG.D.D01.0038"/>");//overtime for weekdays must apply after 7pm.
                  return;
              }
          }
          //**************************end 2012-09-21 lilonghai@2.7 [C20120919_86405]***************************************
      }
    }

    if( ${(E_BUKRS != null and E_BUKRS==("G130")) or (E_BUKRS != null and E_BUKRS==("G360")) }) { 　

        if(eval(document.form1.HOURS.value) > eval(36)){//if G130,check apply hours
            alert('<spring:message code="MSG.D.D01.0023"/>');//Please apply below 36 hours.
            return;
        }
    }

     //香港法人以下5个职级限值每月加班不能超过17个小时，司机除外
       //2013-01-08 dongxiaomian@v2.9 [C20130105_46518] 香港法人司机加班取消17小时限制 begin****************************
       //2015-03-20 pangxiaolin@v3.5 增加职级导致职级code修改20150320 start
       // if(E_BUKRS != null && E_BUKRS.equals("G120") && (phonenum.e_JIKCH.equals("2220") || phonenum.e_JIKCH.equals("2300") || phonenum.e_JIKCH.equals("2410") || phonenum.e_JIKCH.equals("2420") || phonenum.e_JIKCH.equals("2430")) && (!data.PERNR.equals("10017215"))) {
    if( ${E_BUKRS != null and E_BUKRS==("G120") and (phonenum.e_JIKCH==("2220") or
           phonenum.e_JIKCH==("2300") or phonenum.e_JIKCH==("2310") or
           phonenum.e_JIKCH==("2320") or  phonenum.e_JIKCH==("2410") or
           phonenum.e_JIKCH==("2411") or phonenum.e_JIKCH==("2412") or
           phonenum.e_JIKCH==("2420") or phonenum.e_JIKCH==("2430")) and
           (!data.PERNR==("10017215"))}) {
    //2015-03-20 pangxiaolin@v3.5 增加职级导致职级code修改20150320 end

     // if(E_BUKRS != null && E_BUKRS.equals("G120") && (phonenum.e_JIKCH.equals("2220") || phonenum.e_JIKCH.equals("2300") || phonenum.e_JIKCH.equals("2410") || phonenum.e_JIKCH.equals("2420") || phonenum.e_JIKCH.equals("2430")) && (!data.PERNR.equals("12000014"))) { }
    //2013-01-08 dongxiaomian@v2.9 [C20130105_46518] 香港法人司机加班取消17小时限制 end****************************
          if(eval(document.form1.HOURS.value) > eval(17)){//if G120,check apply hours
              alert('<spring:message code="MSG.D.D01.0039"/>');//Please apply below 17 hours.
              return;
          }
    }

   //2014-04-10 dongxiaomian@v3.3 [C20140408_19687] DAGU事务职人员不能申请加班设置 begin
   if( ${E_BUKRS != null and E_BUKRS==("G110") and (phonenum.e_PERSG != ("A")) and
          (phonenum.e_PERSK==("21"))}){//A为韩国人
          alert('<spring:message code="MSG.D.D01.0040"/>');//请联系人事部门.
          return;
   }
  //2014-04-10 dongxiaomian@v3.3 [C20140408_19687] DAGU事务职人员不能申请加班设置  end
    //2012-03-30 lixinxin@v2.5 [C20120330_79649] 大沽法人取消科长及以上职级不能申请加班的限制，换成part长、team长不能申请加班的限制
        //大沽法人科长及以上职级不能申请加班     2011-07-07        liukuo      [C20110705_18813] @v2.2
    // if(E_BUKRS != null && E_BUKRS.equals("G110") && (phonenum.e_JIKCH.equals("2220") || phonenum.e_JIKCH.equals("2100") || phonenum.e_JIKCH.equals("2210"))) { 　
    if(${E_BUKRS != null and E_BUKRS==("G110") and (phonenum.e_JIKKB==("3010") or  phonenum.e_JIKKB==("3000")) }){
            //alert(E_JIKKB);
            //alert('You can not apply overtime.');
            return;
    }
    //2012-12-19 dongxiaomian@v2.8 [C20121218_37585] 大沽关于加班申请增加判断提示午餐扣除时间(12:00-13:00)功能 begin***************

    if(${E_BUKRS==("G110") or E_BUKRS==("G280")}){  //判断是否是大沽法人    add by masai SI 20151003  G280 condition
         //2013-04-26 dongxiaomian@v3.0 [C20130426_20279] 大沽法人最早加班时间8:30判断  begin
          var beguz_tw = document.form1.BEGUZ.value.replace(":","");  //加班开始时间
          if(${E_BUKRS==("G110")}){ // add by masai SI 20151003  G110 condition

              if(beguz_tw<0830){
                     alert('<spring:message code="MSG.D.D01.0041"/>');//正常最早加班时间为8:30。\n\nPlease choose the right time(8:30).
                     return;
              }
          }// add by masai SI 20151003  G110 condition
          //2013-04-26 dongxiaomian@v3.0 [C20130426_20279] 大沽法人最早加班时间8:30判断  end
          if($('#ZMODN').val() == 'OFF' || $('#FTKLA').val() == '1'){     //判断是否是周末，节假日
              //var beguz_tw = document.form1.BEGUZ.value.replace(":","");  //加班开始时间
              var enduz_tw = document.form1.ENDUZ.value.replace(":","");   //加班结束时间
              var pbeg1_tw = document.form1.PBEG1.value.replace(":","");//休息开始时间
              var pend1_tw = document.form1.PEND1.value.replace(":","");//休息结束时间

              if(!(beguz_tw>=1300 || enduz_tw<=1200)){        //判断加班时间是否包含午餐时间

                  if(pbeg1_tw==''||pend1_tw==''){                        //判断是否填写午餐时间
                     alert('<spring:message code="MSG.D.D01.0022"/>');//请选择午餐休息时间(12:00~13:00)。\n\nPlease choose lunch period(12:00~13:00).
                     return;
                  }

          //      if(beguz_tw>=1200&&enduz_tw<=1300){
          //            alert('午餐休息时间');
          //            return;
          //      }

                  if(beguz_tw<=1200 && enduz_tw<=1300){
                         if(pbeg1_tw!='1200'||pend1_tw!=enduz_tw){
                            var end_time = document.form1.ENDUZ.value;
                            alert('<spring:message code="MSG.D.D01.0028"/>(12:00~'+end_time+').');//。\n\nPlease choose the right lunch period(12:00~'+end_time+')
                            return;
                         }
                  }

                  if(beguz_tw<=1200&&enduz_tw>=1300){
                         if(pbeg1_tw!='1200'||pend1_tw!='1300'){
                            alert('<spring:message code="MSG.D.D01.0022"/>');//请选择正确的午餐休息时间(12:00~13:00)。\nPlease choose the right lunch period(12:00~13:00).'
                            return;
                         }
                  }

                  if(beguz_tw>=1200&&enduz_tw>=1300){
                         if(pbeg1_tw!=beguz_tw || pend1_tw!='1300'){
                            var bg_time= document.form1.BEGUZ.value;
                            alert('<spring:message code="MSG.D.D01.0028"/>('+bg_time+'~13:00)');
                            return;
                         }
                 }
            }
        }
   }

      //2012-12-19 dongxiaomian@v2.8 [C20121218_37585] 大沽关于加班申请增加判断提示午餐扣除时间(12:00-13:00)功能 end***************
//       if ( !check_empNo() ){
//           if( copy_Entity() ){
    //         buttonDisabled();
    //         document.form1.jobid.value = "create";
    //         document.form1.action = "${g.servlet}hris.D.D01OT.D01OTBuildGlobalSV";
    //         document.form1.method = "post";
    //             recoverData();
    //         document.form1.submit();
            return true;
//           }
//       }

//     }

}
</script>

<script>

function check_empNo(){ return false;}
<%----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------End beforeSubmit() -------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------%>

$(function() {

//         if ((document.form1.BEGDA.value ).length== 10){
//             document.form1.BEGDA.value = removePoint( document.form1.BEGDA.value );
//         }

        if(parent.resizeIframe){
            parent.resizeIframe(document.body.scrollHeight);
        }
});


//msg 를 보여준다.
function msg(){

    <c:if test='${message != ("")}' >
         alert("${ message }");
    </c:if>

}


function recoverData(){
    document.form1.BEGUZ.value = addColon( document.form1.BEGUZ.value );
    document.form1.ENDUZ.value = addColon( document.form1.ENDUZ.value );
    document.form1.PBEG1.value = addColon( document.form1.PBEG1.value );
    document.form1.PEND1.value = addColon( document.form1.PEND1.value );
    document.form1.PBEG2.value = addColon( document.form1.PBEG2.value );
    document.form1.PEND2.value = addColon( document.form1.PEND2.value );
    document.form1.BEGDA.value = addPointAtDate( document.form1.BEGDA.value );
    document.form1.WORK_DATE.value = addPointAtDate( document.form1.WORK_DATE.value );
}

function getBetweenTime(currentTime, intervalTime)
{
    var hh1 = 0, mm1 = 0;
    var hh2 = 0, mm2 = 0;
    var d_hh = 0, d_mm = 0, interval_time = 0;

    hh1 =currentTime.substring(0,2);
    mm1 =currentTime.substring(2,4);

    hh2 =intervalTime.substring(0,2);
    mm2 =intervalTime.substring(3,5);

    d_hh = hh2 - hh1;
    d_mm = mm2 - mm1;

    if( d_mm >= 0 ){
        d_mm = d_mm / 60;
    } else {
        d_hh = d_hh - 1;
        d_mm = (60 + d_mm) /60;
    }
    interval_time = d_hh + d_mm;

    return interval_time;
}

function doCheck() {
    if( check_Data() ) {
        if( other_check() ){
            if( copy_Entity() ){
                document.form1.BEGUZ.value = addColon( document.form1.BEGUZ.value );
                document.form1.ENDUZ.value = addColon( document.form1.ENDUZ.value );
                document.form1.PBEG1.value = addColon( document.form1.PBEG1.value );
                document.form1.PEND1.value = addColon( document.form1.PEND1.value );
                document.form1.PBEG2.value = addColon( document.form1.PBEG2.value );
                document.form1.PEND2.value = addColon( document.form1.PEND2.value );
            }
         }
    }
    document.form1.BEGDA.value = addPointAtDate( document.form1.BEGDA.value );
    document.form1.WORK_DATE.value = addPointAtDate( document.form1.WORK_DATE.value );
}

function copy_Entity(){

    if ((document.form1.BEGDA.value ).length== 10){
        document.form1.BEGDA.value = removePoint( document.form1.BEGDA.value );
    }
    if ((document.form1.WORK_DATE.value ).length== 10){
        document.form1.WORK_DATE.value = removePoint( document.form1.WORK_DATE.value );
    }
    document.form1.BEGUZ.value = addSec( document.form1.BEGUZ.value );
    document.form1.ENDUZ.value = addSec( document.form1.ENDUZ.value );
    document.form1.PBEG1.value = addSec( document.form1.PBEG1.value );
    document.form1.PEND1.value = addSec( document.form1.PEND1.value );
    document.form1.PBEG2.value = addSec( document.form1.PBEG2.value );
    document.form1.PEND2.value = addSec( document.form1.PEND2.value );

    return true;
}

function fn_openCal(Objectname, moreScriptFunction){
  var lastDate;

  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("${g.jsp}common/calendar.jsp?moreScriptFunction="+moreScriptFunction+"&formname=form1&fieldname="+Objectname+"&curDate="+lastDate+"&iflag=0&optionvalue=","essCal","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=285,top=" + document.body.clientHeight/2 + ",left=" + document.body.clientWidth/2);
  small_window.focus();

}

// 시간 선택
function fn_openTime(Objectname){
    var scrleft = screen.width/3;
    var scrtop = screen.height/2-100;
  lastDate = eval("document.form1." + Objectname + ".value");
  small_window=window.open("${g.jsp}common/time.jsp?formname=form1&fieldname="+Objectname+"&curTime=" + lastDate ,"","toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,width=270,height=200,top="+scrtop+",left="+scrleft);
  small_window.focus();

}

//***********************************************************
// Prev. Day 체크시 시간체크.  2008-03-21      김정인     [C20080321_37622] @v1.3
function js_change() {

    BEGUZ = document.form1.BEGUZ.value;
    ENDUZ = document.form1.ENDUZ.value;

    if( BEGUZ == "" ){//시작시간
        alert("Please input overtime start time.");
        document.form1.VTKEN.checked = false;
        document.form1.BEGUZ.focus();
        return false;
    }
    if( ENDUZ == "" ){//종료시간
        alert("Please input overtime end time.");
        document.form1.VTKEN.checked = false;
        document.form1.ENDUZ.focus();
        return false;
    }

    var c_BEGUZ     = document.form1.BEGUZ.value.replace(":","");
    var c_ENDUZ     = document.form1.ENDUZ.value.replace(":","");

    //alert(document.form1.VTKEN.checked);

    if(document.form1.VTKEN.checked == true){
        //ENDUZ가 다음날로 넘어가는 경우
        if(c_BEGUZ < c_ENDUZ  && c_ENDUZ <= 2400) {
            document.form1.VTKEN.checked = true;
            return;
        }else{
            alert("<spring:message code='MSG.D.D01.0042'/>");//Spanning midnight is not permitted with Prev.Day indicators.
            document.form1.VTKEN.checked = false;
            return;
        }
    }else{
        if(c_BEGUZ < c_ENDUZ  && c_ENDUZ <= 2400) {
            document.form1.VTKEN.checked = false;
            return;
        }
    }

 }
//***********************************************************

function addSec( text ){
  if( text != ""){
    time = removeColon(text);
    return time+"00";
  } else {
    return "";
  }
}

function addColon(text){//형식 체크후 문자형태의 시간 0000을 00:00으로 바꾼다 값이 없을시는 0을 리턴

    if( text!="" ){
        if( text.length == 4 ){
            var tmpTime = text.substring(0,2)+":"+text.substring(2,4);
            return tmpTime;
        }else if( text.length == 6 ){
            var tmpTime = text.substring(0,2)+":"+text.substring(2,4);
            return tmpTime;
        }
    } else {
        return "";
    }
}

function cal_time( time1, time2 ){
    //alert('in cal_time \n time1=' + time1 + '\n' + 'time2=' + time2);
    var tmp_HH1  = 0;//이것이 문제다....
    var tmp_MM1  = 0;
    var tmp_HH2  = 0;
    var tmp_MM2  = 0;
    if( time1.length == 4 ){
        tmp_HH1 = time1.substring(0,2);
        tmp_MM1 = time1.substring(2,4);
    } else if( time1.length == 3 ){
        tmp_HH1 = time1.substring(0,1);
        tmp_MM1 = time1.substring(1,3);
    }
    if( time2.length == 4 ){
        tmp_HH2 = time2.substring(0,2);
        tmp_MM2 = time2.substring(2,4);
    } else if( time2.length == 3 ){
        tmp_HH2 = time2.substring(0,1);
        tmp_MM2 = time2.substring(1,3);
    }

    var tmp_hour = tmp_HH2-tmp_HH1;
    var tmp_min  = tmp_MM2-tmp_MM1;
    var interval_time = 0;

    if( tmp_hour < 0 ){
        tmp_hour = 24+tmp_hour;
    }
    if( tmp_min >= 0 ){
        tmp_min = banolim( (tmp_min/60), 2 );
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim( ( 60 + tmp_min )/60, 2 );
    }
    //alert('in cal_time \n interval_time1=' + interval_time);
    interval_time = tmp_hour+tmp_min+"";
    //alert('in cal_time \n interval_time2=' + interval_time);
    return interval_time;
}

//메인시간 계산용(총 초과 근무시간 계산용)
function cal_time2( time1, time2 ){
    //alert('in cal_time2 \n time1=' + time1 + '\n' + 'time2=' + time2);
    var tmp_HH1  = 0;//이것이 문제다....
    var tmp_MM1  = 0;
    var tmp_HH2  = 0;
    var tmp_MM2  = 0;
    if( time1.length == 4 ){
        tmp_HH1 = time1.substring(0,2);
        tmp_MM1 = time1.substring(2,4);
    } else if( time1.length == 3 ){
        tmp_HH1 = time1.substring(0,1);
        tmp_MM1 = time1.substring(1,3);
    }
    if( time2.length == 4 ){
        tmp_HH2 = time2.substring(0,2);
        tmp_MM2 = time2.substring(2,4);
    } else if( time2.length == 3 ){
        tmp_HH2 = time2.substring(0,1);
        tmp_MM2 = time2.substring(1,3);
    }

    var tmp_hour = tmp_HH2-tmp_HH1;
    var tmp_min  = tmp_MM2-tmp_MM1;
    var interval_time = 0;

    if( tmp_hour < 0 ){
        tmp_hour = 24+tmp_hour;
    }
    if( tmp_min >= 0 ){
        tmp_min = banolim( (tmp_min/60), 2 );
    } else {
        tmp_hour = tmp_hour - 1;
        tmp_min  = banolim( ( 60 + tmp_min )/60, 2 );
    }
    interval_time = tmp_hour+tmp_min+"";
    if( interval_time == 0 ){
        interval_time = 24;
    }
    //alert('in cal_time2 \n interval_time=' + interval_time);
    return interval_time;
}

function other_check(){ //초과근무일 달력 선택 완료 후 check
    /*alert('document.form1.BEGUZ.value=|' + document.form1.BEGUZ.value + '|\n'
        +'document.form1.sdate.value=|' +document.form1.sdate.value+'\n'
         + 'document.form1.edate.value=|' + document.form1.edate.value + '|');
    alert(document.form1.BEGUZ.value < document.form1.edate.value);  */
    var E_BUKRS = '${ E_BUKRS }';
    //if(E_BUKRS == 'G180'){

     //**************************************************************************************************************
     //공휴일에는 overtime신청이 무조건 가능.    2008-01-02      김정인     @v1.0
     //if(!($('#ZMODN') == 'ODAY' && $('#FTKLA') == '1') && !(document.form1.sdate.value == '00:00:00' && document.form1.edate.value == '00:00:00')){

     if(!(document.form1.sdate.value == '00:00:00' && document.form1.edate.value == '00:00:00')){
        //check whether overtime overlaps work time

         if(!($('#FTKLA').val() == '1')){
                 //pangmin 20160920 G180节假日加班申请  start
                 // 添加 G180法人周未加班单次申请8小时以下 限制
                 // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Start
                 // 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out
                     //if( '${E_BUKRS}' == 'G180' && $('#ZMODN').val() == 'OFF'){
                 if( ('${E_BUKRS}' == 'G180' || '${E_BUKRS}' == 'G570' || '${E_BUKRS}' == 'G620') && $('#ZMODN').val() == 'OFF'){
                    // 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End
                     if(document.form1.BEGUZ.value > document.form1.ENDUZ.value ){
                               alert('<spring:message code="MSG.D.D01.0043"/>');//Over time overlaps with working time , please enter right time period.');
                               document.form1.BEGUZ.value = '';
                               document.form1.ENDUZ.value = '';
                               document.form1.STDAZ.value = '';
                               return false;
                           }

                            if(  document.form1.STDAZ.value > eval(8) ) {
                               alert('<spring:message code="MSG.D.D01.0102"/>');//Please apply below 8 hours.');
                               document.form1.BEGUZ.value = '';
                               document.form1.ENDUZ.value = '';
                               document.form1.STDAZ.value = '';
                               return false;
                           }

                    }else               {
                    //pangmin 20160920 G180节假日加班申请  end
                    // 添加 G180法人周未加班单次申请8小时以下 限制

                    if(document.form1.sdate.value < document.form1.edate.value){
                        if(document.form1.BEGUZ.value != ''){
                            if(document.form1.BEGUZ.value < document.form1.edate.value && document.form1.BEGUZ.value > document.form1.sdate.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');//Over time overlaps with working time , please enter right time period.
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                            if(document.form1.ENDUZ.value > document.form1.sdate.value && document.form1.ENDUZ.value < document.form1.edate.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');//Over time overlaps with working time , please enter right time period.
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                            if(document.form1.ENDUZ.value >= document.form1.edate.value && document.form1.BEGUZ.value <= document.form1.sdate.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                            if(document.form1.ENDUZ.value <= document.form1.sdate.value && document.form1.BEGUZ.value <= document.form1.sdate.value && document.form1.BEGUZ.value >= document.form1.ENDUZ.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                            if(document.form1.ENDUZ.value >= document.form1.edate.value && document.form1.BEGUZ.value >= document.form1.edate.value && document.form1.BEGUZ.value >= document.form1.ENDUZ.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                        }

                    }
                    if(document.form1.sdate.value > document.form1.edate.value){
                         if(document.form1.BEGUZ.value != ''){
                           if(document.form1.BEGUZ.value >= document.form1.sdate.value || document.form1.BEGUZ.value < document.form1.edate.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                           if(document.form1.ENDUZ.value > document.form1.sdate.value || document.form1.ENDUZ.value <= document.form1.edate.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                           if(document.form1.BEGUZ.value >= document.form1.ENDUZ.value && document.form1.ENDUZ.value > document.form1.edate.value && document.form1.BEGUZ.value < document.form1.sdate.value){
                                alert('<spring:message code="MSG.D.D01.0043"/>');
                                document.form1.BEGUZ.value = '';
                                document.form1.ENDUZ.value = '';
                                document.form1.STDAZ.value = '';
                                return false;
                            }
                        }
                    }
                   }
            }
    //}
    }
     //**************************************************************************************************************
   appCheck();    // 결재선 갱신
    return true;
}

var tmp = '';
function appCheck(){
    //alert('change.');
    var frm = document.form1;
    var comp = '${ E_BUKRS }';
    //if(frm.WORK_DATE.value == '' || frm.STDAZ.value == '' || frm.STDAZ.value == tmp)
        if(frm.WORK_DATE.value == '' || frm.STDAZ.value == '' )
        return;

    getApp(); // 결재선, 잔여시간 갱신
    tmp = frm.STDAZ.value;
}

function getApp(){//get hours
        var url = '${g.servlet}hris.D.D01OT.D01OTBuildGlobalSV';
//         alert($('#BEGDA').val());
        var pars = 'jobid=getApp&WORK_DATE=' + removePoint($('#WORK_DATE').val()) + '&STDAZ=' + $('#STDAZ').val()
        + '&BEGDA=' + $('#BEGDA').val()+ '&PERNR=' + $('#PERNR').val()+ '&isUpdate=' + ${isUpdate};
             $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){setApp(data)}});
}

function setApp(originalRequest){
    var arr = new Array();
//     var resTxt = originalRequest.responseText;
    var resTxt = originalRequest;
    //alert(resTxt);
    if(resTxt != ''){
        arr = resTxt.split('||||');
        document.form1.HOURS.value = Number(arr[2]) - (${isUpdate}? Number("${data.STDAZ}"):0);
        document.form1.WORK_HOURS.value = Number(arr[3]) - (${isUpdate}? Number("${data.STDAZ}"):0);
        document.form1.OFF_HOURS.value = Number(arr[4]) - (${isUpdate}? Number("${data.STDAZ}"):0);
        document.form1.HOL_HOURS.value = Number(arr[5]) - (${isUpdate}? Number("${data.STDAZ}"):0);
        document.form1.WORK_DAYS.value = arr[6];

        //20151105 start
        $('#-approvalLine-layout').html(unescape(arr[0]));

        $("a,.unloading").click(function() {            /* 동적결재란을 위해 재호출 */
            if(!$(this).hasClass("loading")) {
                window.onbeforeunload = null;
                setTimeout(setBeforeUnload, 1000);
            }
        });

        if (parent.resizeIframe){
            parent.resizeIframe(document.body.scrollHeight);}

        //2017-04-03 [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 start
            var dateTk46Flag = arr[7];
            if(dateTk46Flag.charAt(0) == "E" && submitFlag==false){
                alert("<spring:message code='MSG.D.D01.0105'/>"); //Your overtime hours of this payroll period are over 46 hours.

                document.form1.WORK_DATE.value = "" ;
                document.form1.BEGUZ.value = "" ;
                document.form1.ENDUZ.value = "" ;
                document.form1.STDAZ.value = "" ;

                document.form1.WORK_DATE.focus();
                return;
            }
            submitFlag = false;
            //2017-04-03 [CSR ID:3340999] 台湾法人OT46小时限制申请  대만 당월근태기간동안 46시간 제한 end


        //20151105 end
        //alert( "test data  arr[6]   "+arr[6]);
        //******************************************************************************************************
        // DAGU법인 OT신청 36시간 초과 신청 체크.           2008-03-19      김정인     [C20080312_32365] @v1.2
        // DAGU법인 OT신청 36시간 초과 신청 체크 수정 .   2008-05-08      김정인     [C20080505_6099] @v1.4
        // DAGU법인 OT신청 36시간 초과 신청 체크 수정 .   2008-05-27      김정인     [C20080514_66017] @v1.5
        // E_PERSK : 31 으로 변경.                              2008-06-16      이선아     [C20080613_81843] @v1.7
        // clear 오류 수정.                                         2008-06-16      이선아     @v1.8
        // DAGU법인 누적 E_ANZHL 체크.                        2008-11-26      김정인     [C20081125_62978] @v1.9

        if( ${phonenum.e_BUKRS != null and phonenum.e_BUKRS==("G110") and phonenum.e_PERSG==("B") }){
                        //if( phonenum.E_PERSG != null && ! phonenum.E_PERSG.equals("B")) {     //@v1.7 E_PERSK:31(Plant Operator)
             if( ${phonenum.e_PERSK != null  and phonenum.e_PERSK==("31")}) {

                        //alert("E_PERSK : " +  phonenum.e_PERSK  + " [공장직] " + "교대조 구분값 : " + arr[1] + "  /  누적 신청시간 : " + arr[2]);

                        //교대조 구분값. Y 교대조(현장직)/N 사무직
                        if( arr[1] == 'Y' && (eval(document.form1.HOURS.value) > eval(28)) ){
                            alert("<spring:message code="MSG.D.D01.0044"/>");//You have been already applied over 28 hours.\n If you apply overtime again,\n You should be approved by President.
                            //document.form1.BEGUZ.value = "";
                            //document.form1.ENDUZ.value = "";
                            //document.form1.STDAZ.value = "";  //@v1.8
                            //tmp = "";//@v1.8
                            //alert("1) :   " + tmp);
                            //window.location = document.URL;
                            //return;
                        }else if( arr[1] == 'N' && (eval(document.form1.HOURS.value) > eval(36)) ){
                            alert("<spring:message code="MSG.D.D01.0045"/>");//You have been already applied over 36 hours.\n If you apply overtime again,\n You should be approved by President.
                            //document.form1.BEGUZ.value = "";
                            //document.form1.ENDUZ.value = "";
                            //document.form1.STDAZ.value = "";  //@v1.8
                            //tmp = "";//@v1.8
                            //alert("2) :   " + tmp);
                            //window.location = document.URL;
                            //return;
                        }
                        $('app').innerHTML = unescape(arr[0]);

              }else{

                        //alert("E_PERSK : " +  phonenum.e_PERSK %> + " [사무직] " + "교대조 구분값 : " + arr[1] + "  /  누적 신청시간 : " + arr[2]);
                        if(eval(document.form1.HOURS.value) > eval(36)){    //if G130,check apply hours
                            alert("<spring:message code="MSG.D.D01.0046"/>");//Office Worker can't be over 36 hours of overtime.
                            document.form1.BEGUZ.value = "";
                            document.form1.ENDUZ.value = "";
                            document.form1.STDAZ.value = "";    //@v1.8
                            tmp = "";                                   //@v1.8
                            //alert("3) :   " + tmp);
                            //window.location = document.URL;
                            return;
                        }
              }
            }

         if( ${phonenum.e_BUKRS != null and phonenum.e_BUKRS==("G280") }){
                        //if( phonenum.E_PERSG != null && ! phonenum.E_PERSG.equals("B")) {     //@v1.7 E_PERSK:31(Plant Operator)
                        if(${phonenum.e_PERSK != null  and phonenum.e_PERSK==("21")}){

                        //alert("E_PERSK : " +  phonenum.e_PERSK %> + " [사무직] " + "교대조 구분값 : " + arr[1] + "  /  누적 신청시간 : " + arr[2]);
                        if(eval(document.form1.HOURS.value) > eval(36)){    //if G130,check apply hours
                            alert("<spring:message code="MSG.D.D01.0047"/>");//Office Worker can't be over 36 hours of overtime.
                            document.form1.BEGUZ.value = "";
                            document.form1.ENDUZ.value = "";
                            document.form1.STDAZ.value = "";    //@v1.8
                            tmp = "";                                   //@v1.8
                            //alert("3) :   " + tmp);
                            //window.location = document.URL;
                            return;
                        }
              }
            }
        //******************************************************************************************************
    }
}

function check_Data(){
/**
    1. 前日 근태에 포함 체크  ==> flag      | ?勾不?勾

    2. 각 필드의 형식 첵크 날짜 타입이 맞는지 시간 타입이 맞는지 첵크     |  判?每?日期的???不?
    3. 형식 check와 동시에 해당 필드 특성에 맞게 값 변환 ex) 00:00 ==> 24:00   | check后 ??
    4. 시간필드 colon제거 : 계산하기 위해 : 제거와 초 "00"을 같이 제거  | 去掉分后的00
    5. 필수 입력사항 체크  초과근무 일자, 초과근무 시작시간, 종료시간      | ??必??
    6. 前日 근태에 포함 타입에 맞는 시간 인지를 첵크   |  判???是否包含重?
    7. 휴식시간이 초과 근무 시간 내에 있는지를 첵크     |  休息??是否在加班???
    8. 휴식 시작시간 종료시간이 다 있는지를 첵크 단 ( 00:00 ~ 00:00 은 "" ""로 변환 )   | 判?休息???始?束?不?添了
    9. 휴식시간 무결성 체크        |    判?休息??
    10. 휴식시간 계산    |   ?算休息??
    11. 공란 제거( 필드 이동)      |   移?字段
    12. 다시 화면에 보일수 있는 형식으로 변환 addColon(text) 및 화면에 보임    | ??成?面?示的形式
**/

    if(document.form1.PBEG1.length==6){
        document.form1.PBEG1.value = ( document.form1.PBEG1.value ).substring(0,4);
        document.form1.PEND1.value = ( document.form1.PEND1.value ).substring(0,4);
        document.form1.PBEG2.value = ( document.form1.PBEG2.value ).substring(0,4);
        document.form1.PEND2.value = ( document.form1.PEND2.value ).substring(0,4);
    }

    //  필수 필드의 형식 체크

    if( !dateFormat(document.form1.WORK_DATE) ){
        return false;
    }
    if( !timeFormat(document.form1.BEGUZ) ){//24:00일때 00:00으로 변환 필요
        return false;
    } else {
        if( document.form1.BEGUZ.value == "24:00" ){
            document.form1.BEGUZ.value = "00:00";
        }
    }
    if( !timeFormat(document.form1.ENDUZ) ){//00:00일때 24:00으로 변환 필요
        return false;
    } else {
        if( document.form1.ENDUZ.value == "00:00" ){
            document.form1.ENDUZ.value = "24:00";
        }
    }

    // 필수 입력사항 이외의 필드 값에 대한 값첵크 //휴식시간첵크  //휴식시간에서는 24:00을 00:00으로 변환필요
    if( !timeFormat(document.form1.PBEG1) ){
        return false;
    } else {
        if( document.form1.PBEG1.value == "24:00" ){
            document.form1.PBEG1.value = "00:00" ;
        }
    }
    if( !timeFormat(document.form1.PEND1) ){
        return false;
    } else {
        if( document.form1.PEND1.value == "24:00" ){
            document.form1.PEND1.value = "00:00" ;
        }
    }
    if( !timeFormat(document.form1.PBEG2) ){
        return false;
    } else {
        if( document.form1.PBEG2.value == "24:00" ){
            document.form1.PBEG2.value = "00:00" ;
        }
    }
    if( !timeFormat(document.form1.PEND2) ){
        return false;
    } else {
        if( document.form1.PEND2.value == "24:00" ){
            document.form1.PEND2.value = "00:00" ;
        }
    }

    // 무급 및 유급 시간형식 첵크
    if( !f_timeFormat(document.form1.PUNB1) ){
        return false;
    }
    if( !f_timeFormat(document.form1.PBEZ1) ){
        return false;
    }
    if( !f_timeFormat(document.form1.PUNB2) ){
        return false;
    }
    if( !f_timeFormat(document.form1.PBEZ2) ){
        return false;
    }

    var WORK_DATE = document.form1.WORK_DATE.value;

    var BEGUZ  = removeColon( document.form1.BEGUZ.value );
    var ENDUZ  = removeColon( document.form1.ENDUZ.value );
    var STDAZ  = document.form1.STDAZ.value;
    var PBEG1  = removeColon( document.form1.PBEG1.value );
    var PEND1  = removeColon( document.form1.PEND1.value );
    var PUNB1  = document.form1.PUNB1.value;
    var PBEZ1  = document.form1.PBEZ1.value;
    var PBEG2  = removeColon( document.form1.PBEG2.value );
    var PEND2  = removeColon( document.form1.PEND2.value );
    var PUNB2  = document.form1.PUNB2.value;
    var PBEZ2  = document.form1.PBEZ2.value;
/*
    if( WORK_DATE == "" ){      // 초과근무일
        alert("Please input overtime date.");
        document.form1.WORK_DATE.focus();
        return false;
    }

    if( BEGUZ == "" ){      // 시작시간
        alert("Please input overtime start time.");
        document.form1.BEGUZ.focus();
        return false;
    }

    if( ENDUZ == "" ){  // 종료시간
        alert("Please input overtime end time.");
        document.form1.ENDUZ.focus();
        return false;
    }
*/
    //초과 근무에서 휴식시간의 유효범위 체크
    if ( freetime_check( BEGUZ, ENDUZ, PBEG1 ) ){
        alert("<spring:message code='MSG.D.D01.0019'/>");//The Break hours cannot calculate in the overtime.
        document.form1.PBEG1.focus();
        document.form1.PBEG1.select();
        return false;
    }

    if ( freetime_check( BEGUZ, ENDUZ, PEND1 ) ){
        alert("<spring:message code='MSG.D.D01.0019'/>");//The Break hours cannot calculate in the overtime.
        document.form1.PEND1.focus();
        document.form1.PEND1.select();
        return false;
    }
    if ( freetime_check( BEGUZ, ENDUZ, PBEG2 ) ){
        alert("<spring:message code='MSG.D.D01.0019'/>");//The Break hours cannot calculate in the overtime.
        document.form1.PBEG2.focus();
        document.form1.PBEG2.select();
        return false;
    }
    if ( freetime_check( BEGUZ, ENDUZ, PEND2 ) ){
        alert("<spring:message code='MSG.D.D01.0019'/>");//The Break hours cannot calculate in the overtime.
        document.form1.PEND2.focus();
        document.form1.PEND2.select();
        return false;
    }

    // 시작시간과 종료시간이 둘다 있는지를 첵크 and 0000 0000 일때 공백으로 표시
    if( PBEG1 == "" && PEND1 != "" ){
        alert("<spring:message code='MSG.D.D01.0017'/>");//Pleasae input start time.
        document.form1.PBEG1.focus();
        return false;
    } else if( PBEG1 != "" && PEND1 == "" ){
        alert("<spring:message code='MSG.D.D01.0016'/>");//Pleasae input end time.
        document.form1.PEND1.focus();
        return false;
    } else {
        if( PBEG1 == 0 && PEND1 == 0 ){
            PBEG1 = "";
            PEND1 = "";
        }
    }

    if( PBEG2 == "" && PEND2 != "" ){
        alert("<spring:message code='MSG.D.D01.0017'/>");//Pleasae input start time.
        document.form1.PBEG2.focus();
        return false;
    } else if( PBEG2 != "" && PEND2 == "" ){
        alert("<spring:message code='MSG.D.D01.0016'/>");//Pleasae input end time.
        document.form1.PEND2.focus();
        return false;
    } else {
        if( PBEG2 == 0 && PEND2 == 0 ){
            PBEG2 = "";
            PEND2 = "";
        }
    }

//  휴게시간이 정확한지 여부 첵크
//  시간+날짜
    var D_BEGUZ = "";
    var D_ENDUZ = "";
    var D_PBEG1 = "";
    var D_PEND1 = "";
    var D_PBEG2 = "";
    var D_PEND2 = "";

    if( PBEG1 != "" && PEND1 != "" ){
        //시간설정
        if( BEGUZ <= PBEG1 ){
            D_PBEG1 = "1"+PBEG1;
        } else {
            D_PBEG1 = "2"+PBEG1;
        }
        if( BEGUZ <= PEND1 ){
            D_PEND1 = "1"+PEND1;
        } else {
            D_PEND1 = "2"+PEND1;
        }
        //시간여부 첵크
        if( D_PBEG1 > D_PEND1 ){
            alert("<spring:message code='MSG.D.D01.0015'/>");//Break hours is wrong
            document.form1.PEND1.focus();
            return false;
        }
    }
    if( PBEG2 != "" && PEND2 != "" ){
        if( BEGUZ <= PBEG2 ){
            D_PBEG2 = "1"+PBEG2;
        } else {
            D_PBEG2 = "2"+PBEG2;
        }
        if( BEGUZ <= PEND2 ){
            D_PEND2 = "1"+PEND2;
        } else {
            D_PEND2 = "2"+PEND2;
        }
        //
        if( D_PBEG2 > D_PEND2 ){
            alert("<spring:message code='MSG.D.D01.0015'/>");//Break hours is wrong
            document.form1.PEND2.focus();
            return false;
        }
    }

    //휴식값이 모두 있는경우  //좀더 생각
    if( PBEG1 != "" && PEND1 != "" && PBEG2 != "" && PEND2 != "" ){
        if( D_PEND1 <= D_PBEG2 && D_PEND1 <= D_PEND2){
            //정상적인경우
        } else if( D_PEND2 <= D_PBEG1 && D_PBEG2 <= D_PBEG1 ){
            //정상적인경우
        } else {
            alert("<spring:message code='MSG.D.D01.0015'/>");//Break hours is wrong
            document.form1.PBEG1.focus();
            return false;
        }
    }

    //휴식시간 계산  //잘못된 값 억제..
    tmpSTDAZ = cal_time2( BEGUZ, ENDUZ )+"";

    if( PBEG1 != "" && PEND1 != "" ){
        if( PUNB1 == "" && PBEZ1 == "" ){
            PUNB1 = cal_time( PBEG1, PEND1 );
            PBEZ1 = "";
        }else{
            PUNB1 = cal_time( PBEG1, PEND1 );
        }

        if( PUNB1 != "" && PBEZ1 == "" ){
            if( Number(PUNB1) > cal_time( PBEG1, PEND1 ) ){
                alert("<spring:message code='MSG.D.D01.0013'/>"+ cal_time( PBEG1, PEND1 ) +".");//The maximum input value is
                document.form1.PUNB1.focus();
                document.form1.PUNB1.select();
                return false;
            }
        }
        if( PUNB1 != "" && PBEZ1 != "" ){
            if( (Number(PUNB1)+ Number (PBEZ1)) > cal_time( PBEG1, PEND1 ) ){
                alert("<spring:message code='MSG.D.D01.0013'/>"+ cal_time( PBEG1, PEND1 ) +".");
                document.form1.PBEZ1.focus();
                document.form1.PBEZ1.select();
                return false;
            }
        }
        if( PUNB1 == "" && PBEZ1 != "" ){
            if( Number (PBEZ1) >  cal_time( PBEG1, PEND1 ) ){
              alert("<spring:message code='MSG.D.D01.0013'/> "+ cal_time( PBEG1, PEND1 ) +".");
              document.form1.PBEZ1.focus();
              document.form1.PBEZ1.select();
              return false;

            }
        }
        //alert('if A so tmpSTDAZ1=' + tmpSTDAZ);
        //alert('if A so PUNB2=' + PUNB1);
        tmpSTDAZ = tmpSTDAZ - PUNB1;
        //alert('if A so tmpSTDAZ2=' + tmpSTDAZ);
    } else {
        if( PUNB1 != "" ){
            PUNB1 = "";
        }
        if( PBEZ1 != "" ){
            PBEZ1 = "";
        }
    }

    if( PBEG2 != "" && PEND2 != "" ){

        if( PUNB2 == "" && PBEZ2 == "" ){
            PUNB2 = cal_time( PBEG2, PEND2 );
            PBEZ2 = "";
        }else{
            PUNB2 = cal_time( PBEG2, PEND2 );
        }

        if( PUNB2 != "" && PBEZ2 == "" ){
            if( PUNB2 > cal_time( PBEG2, PEND2 ) ){
                alert("<spring:message code='MSG.D.D01.0013'/> "+ cal_time( PBEG2, PEND2 ) +".");
                document.form1.PUNB2.focus();
                document.form1.PUNB2.select();
                return false;
            }
        }
        if( PUNB2 != "" && PBEZ2 != "" ){
            if( (Number(PUNB2)+ Number (PBEZ2)) > cal_time( PBEG2, PEND2 ) ){
                alert("<spring:message code='MSG.D.D01.0013'/> "+ cal_time( PBEG2, PEND2 ) +".");
                document.form1.PUNB2.focus();
                document.form1.PUNB2.select();
                return false;
            }
        }
        if( PUNB2 == "" && PBEZ2 != "" ){
            if( Number (PBEZ2) >  cal_time( PBEG2, PEND2 ) ){
              alert("<spring:message code='MSG.D.D01.0013'/> "+ cal_time( PBEG2, PEND2 ) +".");
              document.form1.PUNB2.focus();
              document.form1.PUNB2.select();
              return false;

            }
        }

        //alert('if B so tmpSTDAZ1=' + tmpSTDAZ);
        //alert('if B so PUNB2=' + PUNB2);
        tmpSTDAZ = tmpSTDAZ - PUNB2;
        //alert('if B so tmpSTDAZ2=' + tmpSTDAZ);
    } else {
        if( PUNB2 != "" ){
            PUNB2 = "";
        }
        if( PBEZ2 != "" ){
            PBEZ2 = "";
        }
    }

    //이동로직
    if( PBEG1 == "" ){
        if( PBEG2 != "" ){
            PBEG1 = PBEG2;
            PEND1 = PEND2;
            PUNB1 = PUNB2;
            PBEZ1 = PBEZ2;
            PBEG2 = "";
            PEND2 = "";
            PUNB2 = "";
            PBEZ2 = "";
        }
    }

    if( tmpSTDAZ == 0 ){
        STDAZ = "";
    } else {
        STDAZ = banolim( tmpSTDAZ,2 );
    }

    document.form1.STDAZ.value = STDAZ;

    document.form1.PBEG1.value = addColon( PBEG1 );
    document.form1.PEND1.value = addColon( PEND1 );
    document.form1.PUNB1.value = ( PUNB1==0 ? "" : PUNB1 );
    document.form1.PBEZ1.value = ( PBEZ1==0 ? "" : PBEZ1 );

    document.form1.PBEG2.value = addColon( PBEG2 );
    document.form1.PEND2.value = addColon( PEND2 );
    document.form1.PUNB2.value = ( PUNB2==0 ? "" : PUNB2 );
    document.form1.PBEZ2.value = ( PBEZ2==0 ? "" : PBEZ2 );

    return true;
}

//휴식시간 첵크 로직
function freetime_check( BEGUZ, ENDUZ, CHECKTIME ){
    if( CHECKTIME != "" ){
        if( BEGUZ > ENDUZ ){
            if( Number( CHECKTIME ) < Number( BEGUZ ) ){//경우 잘못된값  true 리턴
                if( Number( CHECKTIME ) > Number( ENDUZ ) ){
                    return true;
                }
            }
            return false;
        } else if( BEGUZ < ENDUZ ){    //주의  flag에 따라 체크 방법이 틀림

            if( Number( BEGUZ ) <= Number( CHECKTIME ) ){
                if( Number( CHECKTIME ) <= Number( ENDUZ ) ){
                    return false;
                }
            } else if ( CHECKTIME == 0 && ENDUZ == 2400 ){
                return false;
            }
            return true;
        }
    }
    return false;
}

var flag = 0 ;
function EnterCheck2(){

    if (event.keyCode == 13)  {
        flag = 1;
        doCheck();
    }
}
function EnterCheck3(){
    if (event.keyCode == 13)  {
        flag = 1;
        dateFormat(document.form1.WORK_DATE);
    }
}

function f_timeFormat(obj)
{
  valid_chk = true;

    t = obj.value;
  if( t == "" || t == 0){
      return true;
  } else {
      if( !isNaN ( t ) ){
          if( 99.99 > t && t>0){
              t = t+"";
              d_index = t.indexOf(".");
              if( d_index != -1 ){
                  tmpstr = t.substring( d_index+1, t.length );
                  if( tmpstr.length > 2 ){ //소수점 2제자리가 넘는경우
                      alert( "<spring:message code="MSG.D.D01.0008"/>");//The input format is wrong. \nPlease input by this format(##.##).
                      obj.focus();
                      obj.select();
                      return false;
                  }
              }
              return true;
          }
      }
      alert( "<spring:message code="MSG.D.D01.0008"/>");//The input format is wrong. \nPlease input by this format(##.##).
      obj.focus();
      obj.select();
      return false;
  }
}

function check_Time(){
    if( document.form1.WORK_DATE.value != "" ){
        if( document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != "" ){
            if( document.form1.PBEG1.value == "" && document.form1.PEND1.value == "" ){
                if( document.form1.PBEG2.value == "" && document.form1.PEND2.value == "" ){
                    doCheck();
                } else if( document.form1.PBEG2.value != "" && document.form1.PEND2.value != "" ){
                    doCheck();
                }
            } else if( document.form1.PBEG1.value != "" && document.form1.PEND1.value != "" ){
                if( document.form1.PBEG2.value == "" && document.form1.PEND2.value == "" ){
                    doCheck();
                } else if( document.form1.PBEG2.value != "" && document.form1.PEND2.value != "" ){
                    doCheck();
                }
            }
        }
    }else{
        alert("<spring:message code='MSG.D.D01.0048'/>");//Please input the Overtime Date.
        document.form1.BEGUZ.value="";
        document.form1.ENDUZ.value="";
    }

   //********************************************************************************************
   // Prev.Day 체크시 시간체크.        2008-03-21      김정인     [C20080321_37622] @v1.3

    BEGUZ = document.form1.BEGUZ.value;
    ENDUZ = document.form1.ENDUZ.value;

    var c_BEGUZ     = document.form1.BEGUZ.value.replace(":","");
    var c_ENDUZ     = document.form1.ENDUZ.value.replace(":","");
    //alert(document.form1.VTKEN.checked);

    var checkFlag = document.getElementById("VTKEN");

    if(checkFlag != null){
        //ENDUZ가 다음날로 넘어가는 경우.//check repeat
        if(document.form1.VTKEN.checked == true && document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != ""){
            if(c_BEGUZ < c_ENDUZ  && c_ENDUZ <= 2400) {
                //document.form1.VTKEN.checked = true;
                return;
            }else{
                alert("<spring:message code='MSG.D.D01.0049'/>");//Spanning midnight is not permitted with Prev.Day indicators.
                document.form1.VTKEN.checked = false;
                return;
            }
        }
    }
   //********************************************************************************************
   //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  START
   if(document.form1.BEGUZ.value != "" && document.form1.ENDUZ.value != ""){
           workDateCheck(document.form1.WORK_DATE);
   }
 //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  END
}

// 2003.01.17 - 초과근무신청을 막는다. //////////////////////////////
function after_fn_openCal(){
    workDateCheck(document.form1.WORK_DATE);
    dateFormat(document.form1.WORK_DATE);
    if(document.form1.WORK_DATE.value != "" &&  document.form1.STDAZ.value != ""){
        getApp();
    }
}

function workDateCheck(obj) {
    if(flag == 1){
        flag = 0;
        return;
    }
  //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  START
  //  flag = 1;
  //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  end
    date_n = Number(removePoint(obj.value));
    if( obj.value != "" && dateFormat(obj) ) {//get work date and time
        //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  START
        var BEGUZ = $('#BEGUZ').val();
        if  (BEGUZ != "") BEGUZ = removeColonKsc(BEGUZ)+"00";
        else BEGUZ = "235959";
        var url = '${g.servlet}hris.D.D01OT.D01OTBuildGlobalSV';
        //var pars = 'jobid=check&WORK_DATE=' + removePoint($('#WORK_DATE').val()) + '&PERNR=' + $('#PERNR').val() ;
        var pars = 'jobid=check&WORK_DATE=' + removePoint($('#WORK_DATE').val()) + '&PERNR=' + $('#PERNR').val()+'&BEGUZ='+BEGUZ ;
      //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  END
        $.ajax({type:'GET', url: url, data: pars, dataType: 'html', success: function(data){showResponse(data)}});
    }

}
function showResponse(originalRequest){

//         var flag = originalRequest.responseText.split(",")[4];
        var flag = originalRequest.split(",")[4];

        if(flag == "N" ){
           alert("<spring:message code='MSG.D.D01.0050'/>");//You can't apply this data in payroll period
           document.form1.WORK_DATE.value = "" ;
           document.form1.WORK_DATE.focus();
           return;
        }



          //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  START
        var dateCheckFlag = ( originalRequest.split(",")[5]);

        if(dateCheckFlag.charAt(0) == "E"){
            alert("<spring:message code='MSG.D.D01.0106'/>"); //It could be only allowed from yesterday.
            document.form1.WORK_DATE.value = "" ;
            document.form1.BEGUZ.value = "" ;
            document.form1.ENDUZ.value = "" ;
            document.form1.STDAZ.value = "" ;
            document.form1.WORK_DATE.focus();
            return;
        }
        //[CSR ID:3303691] 邀请设置在HR系统中申请 请假加班的有效期限 사후신청방지 로직추가  END


        $('#edate').val( originalRequest.split(",")[0]);
        $('#sdate').val( originalRequest.split(",")[1]);
        $('#ZMODN').val( originalRequest.split(",")[2]);
        $('#FTKLA').val( originalRequest.split(",")[3]);

        other_check();
}

function reload() {
    frm =  document.form1;
    frm.jobid.value = "first";
    frm.action = "${g.servlet}hris.D.D01OT.D01OTBuildGlobalSV";
    frm.target = "";
    frm.submit();
}


function timeBlur(obj){
//     if(flag == 1){
//         flag = 0;
//         return;
//     }
    if(obj.value != "" && timeFormat(obj)){
        check_Time();
    }else{
        check_Time();
    }
    if(document.form1.BEGUZ.value.length == 0 || document.form1.ENDUZ.value.length == 0){
        document.form1.STDAZ.value = '';
    }
    if(document.form1.PBEG1.value.length == 0 || document.form1.PEND1.value.length == 0){
        document.form1.PUNB1.value = '';
    }
    if(document.form1.PBEG2.value.length == 0 || document.form1.PEND2.value.length == 0){
        document.form1.PUNB2.value = '';
    }
}




$(function(){
     msg();
/*
    $('.timeRest').timepicker({
        controlType: 'select',oneLine: true, defaultValue:'00:00',
        buttonImage:"/web/images/icon_time.gif",   showButtonPanel:false,
        timeFormat: 'HH:mm'
    });
 */
    try{
         if((document.form1.BEGUZ.value).length==6){
            document.form1.BEGUZ.value = ( document.form1.BEGUZ.value ).substring(0,4);
            document.form1.ENDUZ.value = ( document.form1.ENDUZ.value ).substring(0,4);
        }

        if((document.form1.PBEG1.value).length==6){
            document.form1.PBEG1.value = ( document.form1.PBEG1.value ).substring(0,4);
            document.form1.PEND1.value = ( document.form1.PEND1.value ).substring(0,4);
            document.form1.PBEG2.value = ( document.form1.PBEG2.value ).substring(0,4);
            document.form1.PEND2.value = ( document.form1.PEND2.value ).substring(0,4);
        }
        submitFlag = true;
        workDateCheck(document.form1.WORK_DATE);
    } catch(e){}
})



</script>



    <jsp:include page="${g.jsp }D/timepicker-include.jsp" />
    <tags-approval:request-layout
        titlePrefix="COMMON.MENU.ESS_PT_STAT_APPL" representative="true" disable="${ OTbuildYn !='Y'}" disableApprovalLine="${ OTbuildYn !='Y'}">
        <!-- 상단 입력 테이블 시작-->

        <tags:script>
        </tags:script>

        <input type="hidden" id="mode" name="mode" value="">
        <input type="hidden" id="edate" name="edate" value="">
        <input type="hidden" id="sdate" name="sdate" value="">
        <input type="hidden" id="ZMODN" name="ZMODN" value="${ZMODN}">
        <input type="hidden" id="FTKLA" name="FTKLA" value="${FTKLA}">
        <input type="hidden" id="HOURS" name="HOURS" value="">
        <input type="hidden" id="WORK_HOURS" name="WORK_HOURS" value="">
        <input type="hidden" id="OFF_HOURS" name="OFF_HOURS" value="">
        <input type="hidden" id="HOL_HOURS" name="HOL_HOURS" value="">
        <input type="hidden" id="WORK_DAYS" name="WORK_DAYS" value="">
        <input type="hidden" id="E_PERSK" name="E_PERSK"
            value="${phonenum.e_PERSK}">
        <input type="hidden" id="beforeSTDAZ" name="beforeSTDAZ"
            value="${data.STDAZ}">
        <!-- 이전신청시간(수정시 감산을위해 보관) -->
        <input type="hidden" id="BEGDA" name="BEGDA"
            value="${isUpdate == true ? data.BEGDA :  f:printDate( f:currentDate())  }">
<%--[CSR ID:3492341] 系统设置  start --%>
<c:choose>
 <c:when test='${ OTbuildYn!="Y"}'>
    <div class="align_center">
        <p><spring:message code="MSG.D.D15.0211"/></p><!-- 대상자가 아닙니다. -->
    </div>
</c:when>
<c:otherwise>
<%--[CSR ID:3492341] 系统设置  end--%>

        <div class="tableArea">
            <div class="table">
                <table class="tableGeneral">
                    <colgroup>
                        <col width=15% />
<%--  [CSR ID:3544114]  --%>
<c:if test='${E_BUKRS==("G220") }'>
                        <col width=35% />
                        <col width=15% />
</c:if>
<%--  [CSR ID:3544114]  --%>
                        <col />
                    </colgroup>

                    <tr>
                        <th><span class="textPink">*</span> <spring:message
                                code="LABEL.D.D01.0001" />
                            <!--Overtime Date--></th>
                        <td><input type="text" name="WORK_DATE" id="WORK_DATE"
                            class="date required" size="10"
                            value="${ f:printDate(data.WORK_DATE) }"
                            placeholder="<spring:message code="LABEL.D.D01.0001"/>"
                            onchange="javascript:workDateCheck(this);"
                            onKeyPress="javascript:EnterCheck3();">
                        <!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out Star t-->
                        <!-- 2018-08-01 변지현 @PJ.우시법인(G620) Roll-out-->
                        <c:if test='${E_BUKRS==("G180") or E_BUKRS==("G150") or E_BUKRS==("G240") or
                        E_BUKRS==("G170") or E_BUKRS==("G360") or E_BUKRS==("G450") or E_BUKRS==("G570") or E_BUKRS==("G620")}'>
                        <!-- 2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End -->
                                <!-- //Global e-HR Add JV(G450)     2015-07-17      li ying zhe @v1.1 [SI -> SM] -->
                                <input type="checkbox" name="VTKEN" id="VTKEN" value="X"
                                    ${ (data.VTKEN)==("X") ? "checked" : "" }
                                    onClick="javascript:js_change()">
                                <spring:message code="MSG.D.D01.0051" />
                                <!-- Prev. Day-->
                            </c:if></td>

<%--  [CSR ID:3544114]  --%>
<c:if test='${E_BUKRS==("G220") }'>
                            <th class="th02"><span class="textPink">*</span> <spring:message code="LABEL.D.D01.0017" /></th><!--초과근무 보상-->
                            <td>
                                <input type="radio" name="VERSL" id="VERSL1" value="0" ${(data.VERSL == "" || data.VERSL == "0") ? "checked" : "" }  >
                                <label for="contactChoice3"><spring:message code="LABEL.D.D01.0019" /></label>&nbsp;&nbsp;&nbsp;<!-- 초과근무수당 -->
                                <input type="radio" name="VERSL" id="VERSL2" value="3"  ${(data.VERSL == "3") ? "checked" : "" }>
                                <label for="contactChoice3"><spring:message code="LABEL.D.D01.0018" /></label><!-- 대체휴가 -->
                            </td>
</c:if>
<%--  [CSR ID:3544114]  --%>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span> <spring:message
                                code="LABEL.D.D12.0043" />
                            <!--Time--></th>

                        <td colspan="${E_BUKRS=='G220' ? '3':'1'}"><%--  [CSR ID:3544114]  --%>

                        <input type="text" name="BEGUZ" id="BEGUZ"
                            class=" required" size="7"
                            placeholder="<spring:message code="LABEL.D.D12.0043"/>"
                            value="${  f:printTime( data.BEGUZ ) }"
                            onChange="javascript:timeBlur(this)"> <!--                             onfocus=' if ($(this).val()=="")$(this).val("0000");' -->
                            <!--                             onKeyPress = "javascript:EnterCheck2();"  -->
                            <a href="javascript:fn_openTime('BEGUZ');"><img
                                src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
                            ~ <input type="text" name="ENDUZ" id="ENDUZ" class=" required"
                            size="7" placeholder="<spring:message code="LABEL.D.D12.0043"/>"
                            value="${ f:printTime( data.ENDUZ ) }"
                            onChange="javascript:timeBlur(this)"> <!--                             onfocus=' if ($(this).val()=="")$(this).val("0000");' -->
                            <!--                         onKeyPress = "javascript:EnterCheck2();"  -->
                            <a href="javascript:fn_openTime('ENDUZ');"><img
                                src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>

                            <input type="text" name="STDAZ" id="STDAZ" size="3"
                            readonly="readonly" value="${  data.STDAZ  }"
                            style="height: 20px; text-align: right;"> <spring:message
                                code="LABEL.D.D01.0008" />
                            <!--  hour(s)--></td>
                    </tr>
                    <tr>
                        <th><span class="textPink">*</span>
                        <spring:message code="LABEL.D.D15.0157" />
                            <!--Application Reason--></th>

                        <td colspan="${E_BUKRS=='G220' ? '3':'1'}"><%--  [CSR ID:3544114]  --%>
                            <!--  2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 begin -->
                            <c:choose>
                                <c:when test='${E_BUKRS != null and (E_BUKRS eq ("G170"))}'>
                                    <select name="ZRCODE" onchange="">
                                        <option value="">Select</option>
                                        ${f:printOTREasonType(reasonCode, data.ZRCODE)}
                                    </select>
                                    <input type="text" id="ZREASON" name="ZREASON" size="75"
                                        class="required"
                                        placeholder="<spring:message code="LABEL.D.D15.0157"/>"
                                        value="${data.ZREASON }" onChange="javascript:check_Time();"
                                        maxlength="50">
                                    <!--                                      onKeyPress = "javascript:EnterCheck2();"  -->
                                </c:when>
                                <c:otherwise>
                                    <input type="text" name="REASON" class="required" size="75"
                                        value="${ data.REASON }"
                                        placeholder="<spring:message code="LABEL.D.D15.0157"/>"
                                        onChange="javascript:check_Time();" maxlength="100">
                                    <!--                                     onKeyPress = "javascript:EnterCheck2();"  -->
                                </c:otherwise>
                            </c:choose> <!-- //2016-10-09 pangmin [CSR ID:3187342] LG YX法人E-HR OT界面改善邀请 end -->

                        </td>
                    </tr>
                </table>
                <!-- //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out start-->
                <!-- //2018-08-01 변지현 @PJ.우시법인(G620) Roll-out  -->
                <c:if
                    test='${E_BUKRS==("G180") or E_BUKRS==("G150") or E_BUKRS==("G240") or
                E_BUKRS==("G170") or E_BUKRS==("G360") or E_BUKRS==("G450") or E_BUKRS==("G570") or E_BUKRS==("G620")}'>
                <!-- //2018-03-19 KDM @PJ.광저우 법인(G570) Roll-Out End-->
                    <span class="commentOne"><spring:message
                            code="MSG.D.D01.0052" /></span>
                </c:if>
            </div>
        </div>

        <div class="listArea">
            <div class="table">
                <table class="listTable">
                    <colGroup>
                        <col width=20% />
                        <col width=20% />
                        <col width=20% />
                        <col width=20% />
                        <col width=20% />
                    </colGroup>
                    <thead>
                        <tr>
                            <th class="divide">&nbsp;</th>
                            <th><spring:message code="LABEL.D.D15.0162" />
                                <!--시작시간--></th>
                            <th><spring:message code="LABEL.D.D15.0163" />
                                <!--종료시간--></th>
                            <th class="lastCol"></th>
                            <th style="display: none"><spring:message
                                    code="LABEL.D.D01.0005" />
                                <!--유급--></th>
                        </tr>
                    </thead>
                    <tr class="oddRow">
                        <td class="divide"><spring:message code="LABEL.D.D01.0006" />
                            <!--Break Hours 1--></td>
                        <td><input type="text" name="PBEG1" id="PBEG1"
                            class="timeRest" size="10" value="${ f:printTime( data.PBEG1 ) }"
                            onChange="javascript:timeBlur(this)">
                            <!--                         onKeyPress = "javascript:EnterCheck2();"   -->
                            <a href="javascript:fn_openTime('PBEG1');"><img
                                src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
                        </td>
                        <td><input type="text" name="PEND1" id="PEND1"
                            class="timeRest" size="10" value="${ f:printTime( data.PEND1 ) }"
                            onChange="javascript:timeBlur(this)"> <!--                         onKeyPress = "javascript:EnterCheck2();"  -->
                            <a href="javascript:fn_openTime('PEND1');"><img
                                src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
                        </td>
                        <td><input type="text" name="PUNB1" size="10"
                            value="${ (data.PUNB1)==(" ") ? "" : (data.PUNB1)==( "0") ? "" :
                            f:printNum(data.PUNB1) }"
                         onChange="javascript:timeBlur(this)"
                            style="text-align: right; display: none" readonly></td>
                        <!--                          onKeyPress = "javascript:EnterCheck2();"  -->
                        <td class="lastCol" style="display: none"><input type="text"
                            name="PBEZ1" size="10" value="${ (data.PBEZ1)==("
                            ") ? "" : (data.PBEZ1)==( "0") ? "" :
                            f:printNum(data.PBEZ1) }"
                        onChange="javascript:check_Time();">
                            <!--                         onKeyPress = "javascript:EnterCheck2();" -->
                        </td>
                    </tr>

                    <tr>
                        <td class="divide"><spring:message code="LABEL.D.D01.0007" />
                            <!--Break Hours 2--></td>
                        <td><input type="text" name="PBEG2" id="PBEG2"
                            class="timeRest" size="10" value="${ f:printTime( data.PBEG2 ) }"
                            onChange="javascript:timeBlur(this)"> <!--                         onKeyPress = "javascript:EnterCheck2();"  -->
                            <a href="javascript:fn_openTime('PBEG2');"><img
                                src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
                        </td>
                        <td><input type="text" name="PEND2" id="PEND2"
                            class="timeRest" size="10" value="${ f:printTime( data.PEND2 ) }"
                            onChange="javascript:timeBlur(this)">
                        <!-- onblur="timeBlur(this)" --> <!--                         onKeyPress = "javascript:EnterCheck2();"  -->
                            <a href="javascript:fn_openTime('PEND2');"><img
                                src="${g.image}icon_time.gif" align="absmiddle" border="0"></a>
                        </td>
                        <td><input type="text" name="PUNB2" size="10"
                            value="${ (data.PUNB2)==(" ") ? "" : (data.PUNB2)==( "0") ? "" :
                            f:printNum(data.PUNB2) }"
                        onChange="javascript:check_Time();"
                            style="text-align: right; display: none" readonly></td>
                        <!--                         onKeyPress = "javascript:EnterCheck2();"  -->
                        <td class="lastCol" style="display: none"><input type="text"
                            name="PBEZ2" id="PBEZ2" size="10" value="${ (data.PBEZ2)==("
                            ") ? "" : (data.PBEZ2)==( "0") ? "" :
                            f:printNum(data.PBEZ2) }"
                        onChange="javascript:check_Time();">
                        </td>
                        <!--                         onKeyPress = "javascript:EnterCheck2();"  -->
                    </tr>

                </table>

                <div class="commentsMoreThan2">
                    <div>
                        <spring:message code="MSG.COMMON.0061" />
                    </div>
                </div>

            </div>
        </div>
</c:otherwise>
</c:choose>
</tags-approval:request-layout>
</tags:layout>