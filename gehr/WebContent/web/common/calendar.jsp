<%@ page contentType="text/html; charset=utf-8" %>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.sns.jdf.util.*" %>
<%@ page import="java.text.DecimalFormat" %>

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
   String cur_yyyymm = cur_year +"-" + fmt.format(cur_month) + "-";

   String moreScriptFunction = request.getParameter("moreScriptFunction");
   if( moreScriptFunction == null ) moreScriptFunction = "";
   if( moreScriptFunction.equals("null")) moreScriptFunction = "";
%>

<html>
<head>
<title>Calendar</title>
<style type="text/css">
body {background:#fff; font-family:"Malgun Gothic", dotum, arial, sans-serif; font-size:12px; margin:0; padding:0; }
tr.calHeader td {background:#f8f8f8; border-bottom:1px solid #B7B7B7; padding:10px 0;}
.calTitle {text-align:center;padding:7px 0 3px 0;margin:0;}
.calDateT {margin-bottom:10px;}
.todayDate {}
.todayDate a {color:#054373; padding:10px 13px; text-decoration:none;background:#DCE9EF; border:1px solid #ABC5D4;}
.calDate {width:100%;}
.calTitleRow td {background:#fff; height:28px; text-align:center; font-size:11px; border-bottom:1px solid #E6E6E6;}
.calBody td {width:14.28%; padding:12px 0; font-size:11px; border:1px solid #eee; border-left:none; border-top:none;}
.calBody td:hover {background:#f1f1f1;}
/*.calWrap {border:solid 1px #ddd;width:280px;margin:0 0 0 11px;border-top:solid 2px #eb446b;}*/
/*.calTable td {font-weight:bold;}*/
.calTable td.calDate a {text-decoration:none;color:#222;}
.calTable td.todayDate a {font-weight:bold; text-decoration:none;color:#054373}
.calTitle td img {vertical-align:middle;}
.dateT {font-size:12px;color:#222;font-weight:bold;}
.dateT select {font-size:12px;color:#c8294b;font-weight:bold;}
</style>
<script language="JavaScript">
<!--
  /////////////////////////////////////////////////////
  //calendar를 호출한 곳으로 날짜 데이타를 돌려줌.
  /////////////////////////////////////////////////////
  function submit_date(selectDate) {

      opener.document.<%=request.getParameter("formname")%>.<%=request.getParameter("fieldname")%>.value = selectDate;
      <%= afterAction.equals("") ? "" : "opener."+afterAction+";" %>
      <%= moreScriptFunction.equals("") ? "" : ("opener."+moreScriptFunction+";") %>
      self.close();
  }

  function Submitit(){

    url = '<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction=<%=moreScriptFunction%>&optionvalue=selectvalue';
	url +='&formname=<%=request.getParameter("formname")%>';
	url +='&fieldname=<%=request.getParameter("fieldname")%>&curDate=<%=curDate %>&iflag=2';
    <%= afterAction.equals("") ? "" : "url +=\'&afterAction=" + afterAction + "\';" %>
    //window.location.replace(url);
    document.calen.action = url
    document.calen.submit();
  }

//-->
</script>
</head>
<!--
화면사이즈 450
-->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form name="calen"  method="post">


		<table width="100%" border="0" cellspacing="0" class="calDateT" style="margin:0;">
        <tr class="calHeader">
          <td width="28%" align=left style="padding:0 8px">
            <a href='<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction=<%=moreScriptFunction%>&optionvalue=prev_year&formname=<%=request.getParameter("formname")%>&fieldname=<%=request.getParameter("fieldname")%>&curDate=<%=curDate %>&iflag=2<%= afterAction.equals("") ? "" : "&afterAction=" + afterAction  %>'>
            <img src='<%=WebUtil.ImageURL%>sshr/ico_date_pre.gif' border=0 ></a>
          </td>
          <td align="center" width="44%">
            <span class="dateT"><%=cur_year%>년
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
            </span>
          </td>
          <td width="28%" align=right style="padding:0 8px">
            <a href='<%=WebUtil.JspURL%>common/calendar.jsp?moreScriptFunction=<%=moreScriptFunction%>&optionvalue=next_year&formname=<%=request.getParameter("formname")%>&fieldname=<%=request.getParameter("fieldname")%>&curDate=<%=curDate %>&iflag=2<%= afterAction.equals("") ? "" : "&afterAction=" + afterAction  %>'>
            <img src='<%=WebUtil.ImageURL%>sshr/ico_date_next.gif' border=0 ></a>
          </td>
        </tr>
      </table>
		<div class="calWrap">
      <table class="calTable" width="100%" border="0" cellspacing="0" cellpadding="0" align=center>

      	<tr class="calTitleRow">
      		<td style="color:#838383;">S</td>
      		<td>M</td>
      		<td>T</td>
      		<td>W</td>
      		<td>T</td>
      		<td>F</td>
      		<td style="color:#838383;">S</td>
      	</tr>
      	<!--
        <tr bgcolor="#B9B09C">
          <td width="14%" height="19" align="center"><font size="2" color="white">일</font>
          <td width="14%" align="center"><font size="2" color="white">월</font>
          <td width="14%" align="center"><font size="2" color="white">화</font>
          <td width="14%" align="center"><font size="2" color="white">수</font>
          <td width="14%" align="center"><font size="2" color="white">목</font>
          <td width="14%" align="center"><font size="2" color="white">금</font>
          <td width="14%" align="center"><font size="2" color="white">토</font>
        </tr>
        -->
<%
  int    inx;
  String wdate,wcontents,url,gb;
  gb = "list";
  inx = ((-1) * dayno) +2 ;
  while (inx <= lastday){
%>
        <tr class="calBody">
<%
	for (int i = 0 ; i < 7; i++, inx++) {
%>
          <td <%= cur_day==inx ? "class=todayDate" : "class=calDate" %> align=center>
<%
		if (inx >= 1 && inx <= lastday) {
			wdate =cur_yyyymm+fmt.format(inx);
%>
            <a href="JavaScript:submit_date('<%=wdate%>')"><%= cur_day==inx ? "<b>" : "" %>
              <font <%= i == 0 ? "color=#eb446b" : i == 6 ? " " : " "%>><span><%= inx %></span>
              </font></a>
<%		}%>
         </td>
<%	}%>
       </tr>
<%}%>
      </table>
	</div>

</form>
</body>
</html>
