<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 종합검진                                                    */
/*   Program Name : 종합검진 신청현황달력                                       */
/*   Program ID   : Hospitalcalendar.jsp                                        */
/*   Description  : 종합검진 신청현황달력                                       */
/*   Note         :                                                             */
/*   Creation     : 2008-01-18  lsa                                             */
/*   Update       : 2016-03-09 rdcamel [CSR ID:3004032] 종합검진 신청 날짜 클릭시 신청일로부터 2주후로 수검 희망일 선택 해 주도록 안내문 띄우기 요청드립니다                                                            */
/*   				  : 2017-03-23  eunha [CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청*/
/*                                                                              */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="hris.E.E15General.rfc.*" %>
<%@ page import="hris.E.E15General.*" %>
<%@ page import="hris.E.E13CyGeneral.rfc.*" %>
<%@ page import="hris.E.E13CyGeneral.*" %>
<%@ page import="java.util.Vector" %>
<%
    WebUserData user = WebUtil.getSessionUser(request);
    String PERNR     = (String)request.getParameter("PERNR");
    String Pernr     = PERNR.substring(0,8);
    String HOSP_CODE = (String)request.getParameter("HOSP_CODE");
    String STMCCHECK = "";
    if (PERNR.length() == 10) {
       STMCCHECK = PERNR.substring(8,10);
    }
    else {
       STMCCHECK = "";
    }
%>

<%!
    ///////////////////////////////////////////////////////
	//calendar를 위한 변수 설정
	///////////////////////////////////////////////////////
	int Year,Month,Day,First_of_Month,LastDay;
	Calendar today,newdate,p_date;

	private void doRun(Calendar p_date){

	   today = p_date;
	   Year    = today.get(Calendar.YEAR);
	   Month   = today.get(Calendar.MONTH)+1;
	   Day     = today.get(Calendar.DATE);

	   //정확한 달과 그달 첫번일의 요일을 얻는 방법1
	   today.set(Calendar.DAY_OF_MONTH, 1);

	   First_of_Month = today.get(Calendar.DAY_OF_WEEK);
	   LastDay        = getMonthLastDay(Year,Month);
	}
    ///////////////////////////////////////////////////////
	// jsp에서 적용된 값을 새로 설정한다.
	///////////////////////////////////////////////////////
	public void setNewDate(Calendar p_date){

       newdate        = p_date;
	   Year           = newdate.get(Calendar.YEAR);
	   Month          = newdate.get(Calendar.MONTH)+1;
	   Day            = newdate.get(Calendar.DATE);
	   First_of_Month = newdate.get(Calendar.DAY_OF_WEEK);

	   LastDay=getMonthLastDay(Year,Month);
	}
    ///////////////////////////////////////////////////////
	//각 달의 날짜수를 구한다.
	///////////////////////////////////////////////////////
	private int getMonthLastDay(int year, int month){
	   switch (month) {
     		case 1:
     		case 3:
     		case 5:
     		case 7:
     		case 8:
			case 10:
			case 12:
   		      return (31);

			case 4:
			case 6:
			case 9:
			case 11:
   		      return (30);

			default:
        	  if(((year%4==0)&&(year%100!=0)) || (year%400==0) )
				return (29);   // 2월 윤년계산을 위해서
	      	  else
	        	return (28);
	   }
	}

	///////////////////////////////////////////////////////
	//set
	///////////////////////////////////////////////////////
	public void setMyYear(int value){
	   this.Year=value;
	}
	public void setMyMonth(int value){
	   this.Month=value;
	}
	public void setMyDay(int value){
	   this.Day=value;
	}
	public void setMyWeek(int value){
	   this.First_of_Month=value;
	}

	public void setWeekNo(String opt){
	   newdate = Calendar.getInstance();
	   if (opt.equals("prev")) {
		  newdate.set(this.Year,(this.Month-1),(this.Day-7));
	   } else if (opt.equals("next")){
		  newdate.set(this.Year,(this.Month-1),(this.Day+7));
	   }

	   this.Year = newdate.get(Calendar.YEAR);
	   this.Month = newdate.get(Calendar.MONTH)+1;
	   this.Day = newdate.get(Calendar.DATE);
	}

    ///////////////////////////////////////////////////////
	//get
	///////////////////////////////////////////////////////
	public int getMyYear(){
	   return this.Year;
	}
	public int getMyMonth(){
	   return this.Month;
	}
	public int getMyDay(){
	   return this.Day;
	}
	public int getMyWeek(){
	   return this.First_of_Month;
	}
	public int getMyLastDay(){
	   return this.LastDay;
	}

	public int getWeekOfMonth (int yyyy,int mm,int dd) {
		Calendar t_date;
		t_date = Calendar.getInstance();
		t_date.set(Calendar.YEAR, yyyy);
		t_date.set(Calendar.MONTH, mm - 1);
		t_date.set(Calendar.DATE, dd);

		return t_date.get(Calendar.WEEK_OF_MONTH);
	}

	//Date Check
	public boolean DateCheck(String dt){//input date = "yyyy-mm-dd"

	   boolean value = true;
	   try {
		  DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT);
		  df.setLenient(false);
		  Date dt2 = df.parse(dt);
	   } catch (ParseException e) {          //input이 yyyy-mm-dd format이 아닐경우당...
		  value = false;
	   } catch (IllegalArgumentException e) { // yyyy,mm,dd가 유효하지 않은 날짜 일경우...
		  value = false;
	   }
	   return value;
	}//end of constructor

	public String DateFormat(String d_fmt, Date d){
	   SimpleDateFormat sdf = new SimpleDateFormat (d_fmt);
	   return sdf.format(d);
	}
%>
<%
/*******************************************************
///////////////////////////////////////////////////////
// jsp
///////////////////////////////////////////////////////
********************************************************/

	String curDate ="" ;
	int curYear=0;
	int curMonth=0;
	int curDay=0;
	int iflag = 0;
	String value="";
    String afterAction="";
	Calendar current_date,current_date2,temp_date, temp_date1;

	value = request.getParameter("optionvalue");                 //click flag

	curDate = request.getParameter("curDate");                  //현재 날짜
  if( curDate == null || curDate.equals("") ){
      curDate = WebUtil.printDate( DataUtil.getCurrentDate() );
  }
    afterAction = request.getParameter("afterAction");


    if(afterAction == null) afterAction = "";
	if(request.getParameter("iflag") != null)
		iflag = Integer.parseInt(request.getParameter("iflag"));

	//일단 이전에 저장된 날짜을 가져온다.

    int cur_year =0;
    int cur_month=0;
    int cur_day  =0;

//처음일 경우 & 기본 날짜가 없을 경우..
	if((value == null) || (curDate == null) || (curDate.length() == 0)){
	   p_date = Calendar.getInstance();
	   doRun(p_date);

	}  // 기본 날짜가 있는 경우
	else if (iflag != 2)
	{
		if (curDate.length() > 0){
		    StringTokenizer t = new StringTokenizer(curDate ,"."); //입력된 일자
			if(t.countTokens() > 1) {
				curYear = Integer.parseInt(t.nextToken());
				curMonth = Integer.parseInt(t.nextToken());
				curDay = Integer.parseInt(t.nextToken());
			}
			temp_date1 = Calendar.getInstance();
			temp_date1.set(Calendar.YEAR, curYear);
			temp_date1.set(Calendar.MONTH, curMonth -1);
			temp_date1.set(Calendar.DATE, curDay);

			setNewDate(temp_date1);
		}
	}

   	cur_year  = getMyYear();
   	cur_month = getMyMonth();
   	cur_day   = getMyDay();

   temp_date = Calendar.getInstance();
   if(value!=null){

	   if(value.equals("prev_year")){
	      cur_year  = cur_year-1;
	      cur_day   = temp_date.get(Calendar.DATE);

	   }else if(value.equals("next_year")){
	      cur_year  = cur_year+1;
	      cur_day   = temp_date.get(Calendar.DATE);

	   }else if(value.equals("today")){
    	   //temp_date=Calendar.getInstance();
    	   //cur_year=temp_date.get(Calendar.YEAR);
    	   //cur_month=temp_date.get(Calendar.MONTH) + 1;
    	   //
    	   //
	   }else if(value.equals("selectvalue")){
	     cur_month = Integer.parseInt(request.getParameter("selectvalue"));
	     cur_day   = temp_date.get(Calendar.DATE);
	   }
   }//end if

   if(cur_month < 1){
      cur_month=12;
      cur_year=cur_year-1;
   }

   if(cur_month>12){
      cur_month=1;
      cur_year=cur_year+1;
   }

   temp_date = Calendar.getInstance();
   temp_date.set(Calendar.YEAR, cur_year);
   temp_date.set(Calendar.MONTH, cur_month-1);
   temp_date.set(Calendar.DATE, 1);
   setNewDate(temp_date);

   int dayno = 0;
   int lastday = 0;

   dayno =  getMyWeek();
   lastday = getMyLastDay();

   DecimalFormat fmt = new DecimalFormat("00");
   String cur_yyyymm = cur_year + "." + fmt.format(cur_month) + ".";

   String moreScriptFunction = request.getParameter("moreScriptFunction");
   if( moreScriptFunction == null ) moreScriptFunction = "";
   if( moreScriptFunction.equals("null")) moreScriptFunction = "";

   String Yymm = cur_year + fmt.format(cur_month);

   Vector E13CyPossNumData_vt  = (new E13CyPossNumRFC()).getInwonCnt(Pernr,Yymm,HOSP_CODE);

   int [] DATUM     = null;
   String [] EXAM_NUM  = null;
   String [] EXAM_NUM1 = null;
   String [] EXAM_POSS = null;
   DATUM = new int [31];
   EXAM_NUM = new String [31];
   EXAM_NUM1 = new String [31];
   EXAM_POSS = new String [31];

   for( int i = 0 ; i < E13CyPossNumData_vt.size() ; i++ ) {
       E13CyPossNumData data = (E13CyPossNumData)E13CyPossNumData_vt.get(i);
       DATUM[i]     = Integer.parseInt(data.DATUM);
       EXAM_NUM[i]  = data.EXAM_NUM;
       EXAM_NUM1[i] = data.EXAM_NUM1;
       EXAM_POSS[i] = data.EXAM_POSS;
  //  out.println("  i:"+ DATUM[i]+"EXAM_NUM:"+EXAM_NUM[i]+"EXAM_POSS:"+EXAM_POSS[i] );
   }
%>

<html>
<head>
<title>Calendar</title>
<link rel="stylesheet" href="<%= WebUtil.ImageURL %>css/ehr.css" type="text/css">
<style type="text/css">
<!--
.pu_title {  font-family: "굴림", "굴림체"; font-size: 9pt; line-height: 15pt; font-weight: bold;; color: #111d47}
.pu_stitle {  font-family: "굴림", "굴림체"; font-size: 9pt; line-height: 15pt; font-weight: bold}
.font01 {  font-family: "굴림", "굴림체"; font-size: 9pt}
-->
</style>
<script language="JavaScript">
<!--
  /////////////////////////////////////////////////////
  //calendar를 호출한 곳으로 날짜 데이타를 돌려줌.
  /////////////////////////////////////////////////////
  function submit_date(selectDate,reserv,reserv1  ) {
      //if (reserv !="0000" || reserv !="9999" ) {
      if (reserv =="0000") {
         alert("신청 가능 인원이 0명입니다.");
         return ;
      }
      if (reserv1 =="0000" && "<%=STMCCHECK%>" !="" ) {
         alert("대장검진 신청 가능 인원이 0명입니다.");
         return ;
      }
      opener.document.<%=request.getParameter("formname")%>.<%=request.getParameter("fieldname")%>.value = selectDate;
      <%= afterAction.equals("") ? "" : "opener."+afterAction+";" %>
      <%= moreScriptFunction.equals("") ? "" : ("opener."+moreScriptFunction+";") %>
      self.close();
  }

  function Submitit(){
	//[CSR ID:3004032] 여수 site에 한하여 alert 추가
		if("<%=user.e_btrtl%>" =="BAAA" || "<%=user.e_btrtl%>" =="BAAB" || "<%=user.e_btrtl%>" =="BAAC" || "<%=user.e_btrtl%>" =="BAAD" || "<%=user.e_btrtl%>" =="BAAE" ||
		   "<%=user.e_btrtl%>" =="BAEA" || "<%=user.e_btrtl%>" =="BAEB" || "<%=user.e_btrtl%>" =="BAEC" || "<%=user.e_btrtl%>" =="BAGA" || "<%=user.e_btrtl%>" =="CABA" ){
			alert("병원측과 수검자의 상호 원활할 검진 진행을 위해 수검 희망일은 \n신청일로부터 2주 후로 신청 해 주시기 바랍니다.\n※ 병원측 종검 관련 검사 부서에 예약(X-RAY,내시경,CT,MRI등) 및 \n문진표와 검진 준비물 배포시 날짜가 촉박하여 병원에서 많이 \n힘들어 합니다.");
		}

    url = '<%=WebUtil.JspURL%>E/E13CyGeneral/Hospitalcalendar.jsp?PERNR=<%=PERNR%>&moreScriptFunction=<%=moreScriptFunction%>&optionvalue=selectvalue';
	url +='&formname=<%=request.getParameter("formname")%>';
	url +='&fieldname=<%=request.getParameter("fieldname")%>&curDate=<%=curDate %>&iflag=2';
    <%= afterAction.equals("") ? "" : "url +=\'&afterAction=" + afterAction + "\';" %>
    //window.location.replace(url);
    document.calen.action = url
    document.calen.HOSP_CODE.disabled  = false;
    document.calen.submit();
  }
  function PrevNext(val){
    url = '<%=WebUtil.JspURL%>E/E13CyGeneral/Hospitalcalendar.jsp?PERNR=<%=PERNR%>&moreScriptFunction=<%=moreScriptFunction%>';
	url +='&optionvalue='+val;
	url +='&formname=<%=request.getParameter("formname")%>';
	url +='&fieldname=<%=request.getParameter("fieldname")%>&curDate=<%=curDate %>&iflag=2';
	url +='&<%= afterAction.equals("") ? "" : "url +=\'&afterAction=" + afterAction + "\';" %>';

    //window.location.replace(url);
    document.calen.action = url
    document.calen.HOSP_CODE.disabled  = false;
    document.calen.submit();
  }
//-->
</script>
</head>
<!--
화면사이즈 450
-->
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form name="calen"  method="post">
  <input type=hidden name=PERNR vale="<%=PERNR%>">
  <table width="350" border="0" cellspacing="0" cellpadding="0" height="300">
    <tr>
      <td height="1" background="<%=WebUtil.ImageURL%>pu_tbg.jpg" colspan="3">&nbsp; </td>
    </tr>
    <tr>
      <td height="35" class="pu_title" colspan="3" align=center>
        <img src="<%=WebUtil.ImageURL%>hospital_img.gif" align="absmiddle">
      </td>
    </tr>
    <tr aliggn=center>
      <td>
      <!-- [CSR ID:3000327] 테이블 size 및 td class 변경 -->
     <table width="450" border="0">
        <tr>
          <td class="td03" width="20%" colspan="2">검진병원</td>
          <td  class="td09" align=right>
             <%--[CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 start --%>
             <select name="HOSP_CODE" class="input03"  onChange="Submitit();" disabled style="width:200px;">
        			<%--<select name="HOSP_CODE"  onChange="Submitit();" disabled> --%>
        			<%--[CSR ID:3393141] HR종합검진 ERP시스템 에러개선 요청 end--%>
             <option value="">-------------</option>
<%           Vector E15HospCodeData_opt  = (new E13CyHospCodeRFC()).getHospCode(Pernr);
             for( int i = 0 ; i < E15HospCodeData_opt.size() ; i++ ) {
                 E15GeneralData data = (E15GeneralData)E15HospCodeData_opt.get(i);
                 if ( data.HOSP_CODE.equals(HOSP_CODE) ) {
%>
                 <option value="<%=data.HOSP_CODE%>" selected><%=data.HOSP_NAME%></option>
<%               }else{ %>
                 <option value="<%=data.HOSP_CODE%>"><%=data.HOSP_NAME%></option>
<%               } //
             } //for
%>

             </select>
          </td>
        </tr>
      </table>
      </td>
    </tr>
	<tr>
	  <td>
      <table width="350" border="0">
        <tr>
          <td width="28%" align=right>
<!--            <a href="javascript:PrevNext('prev_year')"><img src='<%=WebUtil.ImageURL%>btn_prev.gif' border=0 ></a> -->
          </td>
          <td align="center" width="44%" class="title02">
            <%=cur_year%>년
              <select name="selectvalue" size=1 onChange="Submitit();">
<%
			for(int i=1 ; i < 13 ; i++){
			   out.println("<Option value='" + i + "'");
			   if (cur_month == i){
				  out.println("selected");
			   }
			   out.println(">" + i + "</option>");
			}
%>
              </select> 월
          </td>
          <td width="28%" align=left>
<!--            <a href="javascript:PrevNext('next_year')"><img src='<%=WebUtil.ImageURL%>btn_next.gif' border=0 ></a> -->
          </td>
        </tr>
      </table>
      <table width="80%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" align=center>
        <tr bgcolor="#B9B09C">
          <td width="14%" height="19" align="center"><font size="2" color="white"><b>일</b></font>
          <td width="14%" align="center"><font size="2" color="white"><b>월</font>
          <td width="14%" align="center"><font size="2" color="white"><b>화</font>
          <td width="14%" align="center"><font size="2" color="white"><b>수</font>
          <td width="14%" align="center"><font size="2" color="white"><b>목</font>
          <td width="14%" align="center"><font size="2" color="white"><b>금</font>
          <td width="14%" align="center"><font size="2" color="white"><b>토</font>
        </tr>
<%
  int    inx;
  String wdate,wcontents,url,gb;
  gb = "list";
  inx = ((-1) * dayno) +2 ;
  while (inx <= lastday){
%>
        <tr>
<%
	for (int i = 0 ; i < 7; i++, inx++) {
%>
          <td <%= inx>0 && inx<= E13CyPossNumData_vt.size() && EXAM_POSS[inx-1].equals("X") ? "bgcolor=dc9146" : cur_day==inx ? "bgcolor=FFFECC" : "bgcolor=EFEEE8" %> height="19" align=center>
<%
		if (inx >= 1 && inx <= lastday) {
			wdate =cur_yyyymm+fmt.format(inx);
%>
              <%
                 if (EXAM_POSS[inx-1].equals("X")) {
              %>
                 <font size="2" <%= i == 0 ? "color=red" : i == 6 ? "color=blue" : "color=black"%>><%= inx %>
              </font></a>
              <%
                 }else {
              %>
            <a href="JavaScript:submit_date('<%=wdate%>',<%=EXAM_NUM[inx-1]%>,<%=EXAM_NUM1[inx-1]%> )"><%= cur_day==inx ? "<b>" : "" %>
              <font size="2" <%= i == 0 ? "color=red" : i == 6 ? "color=blue" : "color=black"%>><%= inx %>
              </font></a>
              <br> <font color=#cc0bcc>
              <%

                 if (!EXAM_NUM[inx-1].equals("9999") && !EXAM_NUM[inx-1].equals("0000") ){
              %>
                 <%=Integer.parseInt(EXAM_NUM[inx-1])%>
              <% } %>
              </font><font color=#000000>
              <%
                 if (!STMCCHECK.equals("") &&!EXAM_NUM1[inx-1].equals("9999") && !EXAM_NUM1[inx-1].equals("0000") ){
              %>
                 (<%=Integer.parseInt(EXAM_NUM1[inx-1])%>)
              <% }else{ %>
              <% }%>
              </font>
             <input type=hidden name=able<%=DataUtil.delDateGubn(wdate)%> value="<%=EXAM_NUM[inx-1]%>">
             <input type=hidden name=full<%=DataUtil.delDateGubn(wdate)%> value="<%=EXAM_NUM1[inx-1]%>">
<%		}
              }%>
         </td>
<%	}%>
       </tr>
<%}%>
      </table>
    </td>
    </tr>
    <tr>
      <table>
      <tr>
      <td class="td09" width="20"></td>
          <%
             if (!STMCCHECK.equals("")){
          %>
          <td class="td09" width="270">※<font color=#cc0bcc>검진신청가능자수</font><font color=#000000>(대장검진신청가능자수)
          <% }else { %>
          <td class="td09" width="270">※<font color=#cc0bcc>검진신청가능자수</font>
          <% }%>
          </td>
      </tr>
      <tr>
          <td class="td09" width="20"></td>
          <td class="td09" width="270"><font color=dc9146>■</font>검진불가기간
          </td>
      </tr>

   </tr>
    <tr>
      <td height="15" background="<%=WebUtil.ImageURL%>images/pu_bgdn.gif" colspan="3">&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
