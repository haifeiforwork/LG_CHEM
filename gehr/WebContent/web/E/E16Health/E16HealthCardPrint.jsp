<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 건강검진                                                    */
/*   Program Name : 건강검진                                                    */
/*   Program ID   : E16HealthCard.jsp                                           */
/*   Description  : 건강검진 카드 조회                                          */
/*   Note         :                                                             */
/*   Creation     : 2010-05-24  lsa                                             */
/*   Update       :2017/08/28 eunha [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E16Health.*" %>
<%
    WebUserData        user           = (WebUserData)session.getAttribute("user");

    Vector e16Health9416Data_vt = (Vector)request.getAttribute("e16Health9416Data_vt");
    Vector e16Health9419Data_vt = (Vector)request.getAttribute("e16Health9419Data_vt");
    Vector e16Health9420Data_vt = (Vector)request.getAttribute("e16Health9420Data_vt");
    Vector e16Health9421Data_vt = (Vector)request.getAttribute("e16Health9421Data_vt");

    String E_ENAME = (String)request.getAttribute("E_ENAME");
    String E_TITEL = (String)request.getAttribute("E_TITEL");
    String E_REGNO = (String)request.getAttribute("E_REGNO");
    String E_STEXT = (String)request.getAttribute("E_STEXT");
    String E_DARDT = (String)request.getAttribute("E_DARDT");
    String E_CENAME = (String)request.getAttribute("E_CENAME"); //조직장
    String E_HENAME = (String)request.getAttribute("E_HENAME"); //보건담당자 이름
    String E_TITL2 = (String)request.getAttribute("E_TITL2"); //직책 [CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건

    String PERNR = (String)request.getAttribute("PERNR");
    String YEAR = (String)request.getAttribute("YEAR");

    int startYear = 2006;
    int endYear   = Integer.parseInt( DataUtil.getCurrentYear() );

    Vector CodeEntity_vt = new Vector();
    for( int i = startYear ; i <= endYear ; i++ ){
        CodeEntity entity = new CodeEntity();
        entity.code  = Integer.toString(i);
        entity.value = Integer.toString(i);
        CodeEntity_vt.addElement(entity);
    }

    Vector e16Health9419Data_Svt = SortUtil.sort( e16Health9419Data_vt,"REAL_DATE","desc");
 %>
<jsp:include page="/include/header.jsp" />


<script language="javascript">
function prevDetail() {
	switch (location.hash)  {
		case "#page2":
			location.hash ="#page1";
		break;
	} // end switch
}

function nextDetail() {
	switch (location.hash)  {
		case "":
		case "#page1":
			location.hash ="#page2";
		break;
	} // end switch
}
function __ws__(id)
{
   document.write(id.innerHTML);
   id.id =  "";

}
function reload() {
    frm =  document.form1;
    frm.jobid_m.value ="";
    frm.action = "<%= WebUtil.ServletURL %>hris.E.E16Health.E16HealthCardSV";
    frm.target = "";
    frm.submit();
}
function go_print(){
    window.open('', 'essPrintWindow', "toolbar=no,location=no, directories=no,status=no,menubar=yes,resizable=no,width=1010,height=662,left=0,top=2");

    document.form1.jobid_m.value = "print";
    document.form1.target = "essPrintWindow";
    document.form1.action = "<%= WebUtil.JspURL %>common/printFrame_e15Health.jsp";
    document.form1.method = "post";
    document.form1.submit();


}
</script>

 <jsp:include page="/include/body-header.jsp"/>
<form name="form1" method="post">
  <table width="660" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <!--<td width="16">&nbsp;</td>-->
      <td>
<div class="winPop">
<div class="header">
		    <span><%=g.getMessage("LABEL.E.E16.0002")%><!-- 임직원 건강관리 카드 --></span>
    <a href="" onclick="top.close();"><img src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" /></a>
</div>

   <div class="body">
<br>
  <input type="hidden" name="PERNR" value="<%=PERNR%>">
  <input type="hidden" name="jobid_m"       value="">
  <input type="hidden" name="ThisJspName" value="E16HealthCard.jsp">

    <div class="tableArea">
    <div class="table">
      <table class="tableGeneral">
      	<colgroup>
      		<col width="15%" />
      		<col />
      	</colgroup>
        <tr>
          <th><!--조회년도 --><%=g.getMessage("LABEL.E.E16.0005")%></th>
          <td  width="700">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= YEAR %> <!--년 --><%=g.getMessage("LABEL.E.E20.0017")%>
          </td>
        </tr>
      </table>
    </div>
  </div>

   <h2 class="subtitle"><!--인적사항 --><%=g.getMessage("LABEL.E.E16.0006")%></h2>

    <div class="tableArea">
      <div class="table">
        <table class="tableGeneral">
	      	<colgroup>
	      		<col width="13%" />
	      		<col width="12%" />
	      		<col width="15%" />
	      		<col width="10%" />
	      		<col width="13%" />
	      		<col width="12%" />
	      		<col width="13%" />
	      		<col width="12%" />
	      	</colgroup>
			<tr>
			  <th><!--사번 --><%=g.getMessage("LABEL.E.E16.0007")%></th>
			  <td><%= PERNR %></td>
			  <th class="th02"><!--이름 --><%=g.getMessage("LABEL.E.E16.0008")%></th>
			  <td><%= E_ENAME %></td>
			  <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 start--%>
  			  <%--<th class="th02"><!--직위 --><%=g.getMessage("LABEL.E.E16.0009")%></th> --%>
			  <th class="th02"><!--직책/직급호칭 --><%=g.getMessage("MSG.APPROVAL.0025")%></th>
			  <td><%=E_TITEL.equals("책임") &&  !E_TITL2.equals("") ? E_TITL2 : E_TITEL %></td>
			  <%--[CSR ID:3456352] 직급체계개편 후 직위/직책 표시 기준 변경에 따른 시스템 변경 요청 건 end--%>
			  <th class="th02"><!--주민번호 --><%=g.getMessage("LABEL.E.E16.0010")%></th>
			  <td>
<%
        if( user.empNo.equals(PERNR) ) {
%>
          <%= DataUtil.addSeparate(E_REGNO) %>
<%
        } else {
             String regno = E_REGNO.substring( 0, 6 ) + "-*******";
%>
                                        <%= regno %>
<%
        }
%>

            </td>
          </tr>
          <tr>
            <th><!--소속부서 --><%=g.getMessage("LABEL.E.E16.0011")%></th>
            <td colspan=3><%= E_STEXT %></td>
            <th class="th02" ><!--자사입사일 --><%=g.getMessage("LABEL.E.E16.0012")%></th>
            <td><%= E_DARDT.equals("0000-00-00")? "" : WebUtil.printDate(E_DARDT) %></td>
            <th class="th02" ><!--조직책임자 --><%=g.getMessage("LABEL.E.E16.0013")%></th>
            <td><%= E_CENAME %></td>
          </tr>
          <tr>
            <th><!--보건담당자 --><%=g.getMessage("LABEL.E.E16.0014")%></th>
            <td><%= E_HENAME %>&nbsp;</td>
            <th class="th02"><!--P/G가입여부 --><%=g.getMessage("LABEL.E.E16.0015")%></th>
            <td></td>
            <th class="th02" ><!--흡연여부 --><%=g.getMessage("LABEL.E.E16.0016")%></th>
            <td></td>
            <th class="th02"><!--운동여부 --><%=g.getMessage("LABEL.E.E16.0017")%></th>
            <td></td>
          </tr>
<%
    if (e16Health9421Data_vt.size()>0){
         E16Health9421Data e16Health9421Data = (E16Health9421Data)e16Health9421Data_vt.get(0);
%>
          <tr>
            <th><!--가족력 --><%=g.getMessage("LABEL.E.E16.0018")%></th>
            <td colspan=7><%= e16Health9421Data.MEDI_HIST1 %><%= e16Health9421Data.MEDI_HIST2.equals("") ? "" : "<br>"+e16Health9421Data.MEDI_HIST2 %></td>
          </tr>
<%  } else{ %>
          <tr>
            <th><!--가족력 --><%=g.getMessage("LABEL.E.E16.0018")%></th>
            <td colspan=7>&nbsp;</td>
          </tr>
<%  } %>
      </table>
    </div>
  </div>
  <!--개인인적사항 테이블 끝-->

   <h2 class="subtitle"><!--검진이력 --><%=g.getMessage("LABEL.E.E16.0019")%></h2>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
	      	<colgroup>
	      		<col width="10%" />
	      		<col width="15%" />
	      		<col width="35%" />
	      		<col width="40%" />
	      	</colgroup>
      <thead>
        <tr>
          <th><!--검진년도 --><%=g.getMessage("LABEL.E.E16.0020")%></th>
          <th><!--유소견 코드 --><%=g.getMessage("LABEL.E.E16.0021")%></th>
          <th><!--질환명 --><%=g.getMessage("LABEL.E.E16.0022")%></th>
          <th class="lastCol"><!--상세결과 --><%=g.getMessage("LABEL.E.E16.0023")%></th>
        </tr>
      </thead>
<%
            String MEDI_DISE =  "";

            for( int i = 0 ; i < e16Health9416Data_vt.size() ; i++ ){
                E16Health9416Data e16Health9416Data = (E16Health9416Data)e16Health9416Data_vt.get(i);
                if ( ( e16Health9416Data.MEDI_DISE1.equals("0") && e16Health9416Data.MEDI_DISE2.equals("0")&& e16Health9416Data.MEDI_DISE3.equals("0")
                     && e16Health9416Data.MEDI_DISE4.equals("0")&& e16Health9416Data.MEDI_DISE5.equals("0")&&e16Health9416Data.MEDI_DISE6.equals("0") )
                     || ( e16Health9416Data.MEDI_DISE1.equals("0") && e16Health9416Data.MEDI_DISE2.equals("")&& e16Health9416Data.MEDI_DISE3.equals("")
                     && e16Health9416Data.MEDI_DISE4.equals("")&& e16Health9416Data.MEDI_DISE5.equals("")&&e16Health9416Data.MEDI_DISE6.equals("") )
                      )  {
                    MEDI_DISE ="정상" ;
                }else{
                    if (e16Health9416Data.MEDI_DISE1.equals("0") )
                       MEDI_DISE = "";
                    else
                       MEDI_DISE = e16Health9416Data.DDTEXT1;

                    if (e16Health9416Data.MEDI_DISE2.equals("0") )
                       MEDI_DISE = "";
                    else
                       MEDI_DISE = MEDI_DISE+"&nbsp"+e16Health9416Data.DDTEXT2;

                    if (e16Health9416Data.MEDI_DISE3.equals("0") )
                       MEDI_DISE = "";
                    else
                       MEDI_DISE = MEDI_DISE+"&nbsp"+e16Health9416Data.DDTEXT3;

                    if (e16Health9416Data.MEDI_DISE4.equals("0") )
                       MEDI_DISE = "";
                    else
                       MEDI_DISE = MEDI_DISE+"&nbsp"+e16Health9416Data.DDTEXT4;

                    if (e16Health9416Data.MEDI_DISE5.equals("0") )
                       MEDI_DISE = "";
                    else
                       MEDI_DISE = MEDI_DISE+"&nbsp"+e16Health9416Data.DDTEXT5;

                    if (e16Health9416Data.MEDI_DISE6.equals("0") )
                       MEDI_DISE = "";
                    else
                       MEDI_DISE = MEDI_DISE+"&nbsp"+e16Health9416Data.DDTEXT6;
                }
%>
        <tr class="<%=WebUtil.printOddRow(i)%>">
          <td><%= e16Health9416Data.Z_YEAR  %>&nbsp;</td>
          <td><%= e16Health9416Data.MEDI_RSLT   %>&nbsp;</td>
          <td style="text-align:left">&nbsp;<%= MEDI_DISE %></td>
          <td class="lastCol" style="text-align:left">&nbsp;<%= e16Health9416Data.MEDI_DESC1  %>&nbsp;<%= e16Health9416Data.MEDI_DESC2  %>&nbsp;<%= e16Health9416Data.MEDI_DESC3  %></td>
        </tr>
<%
            }
%>
          </table>
      </div>
  </div>

<h2 class="subtitle"><!--건강관리 --><%=g.getMessage("LABEL.E.E16.0024")%></h2>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
      	<colgroup>
      		<col width="4%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col width="9%" />
      		<col />
      	</colgroup>
      	<thead>
        <tr>
          <th rowspan="2" colspan="2"><!--구분 --><%=g.getMessage("LABEL.E.E16.0025")%></th>
          <th colspan="2"><!--고혈압 --><%=g.getMessage("LABEL.E.E16.0026")%></th>
          <th colspan="4"><!--고지혈증 --><%=g.getMessage("LABEL.E.E16.0027")%></th>
          <th colspan="3"><!--간장질환 --><%=g.getMessage("LABEL.E.E16.0028")%></th>
          <th class="lastCol"><!--당뇨 --><%=g.getMessage("LABEL.E.E16.0029")%></th>
        </tr>
        <tr>
          <th><!--혈압(고) --><%=g.getMessage("LABEL.E.E16.0030")%></th>
          <th><!--혈압(저) --><%=g.getMessage("LABEL.E.E16.0031")%></th>
          <th><!--총 --><%=g.getMessage("LABEL.E.E16.0032")%><br><!--콜레스테롤 --><%=g.getMessage("LABEL.E.E16.0033")%></th>
          <th><!--중성지방 --><%=g.getMessage("LABEL.E.E16.0034")%></th>
          <th><!--고밀도(HDL) --><%=g.getMessage("LABEL.E.E16.0035")%><br><!--콜레스테롤 --><%=g.getMessage("LABEL.E.E16.0033")%></th>
          <th><!--저밀도(LDL) --><%=g.getMessage("LABEL.E.E16.0036")%><br><!--콜레스테롤 --><%=g.getMessage("LABEL.E.E16.0033")%></th>
          <th>GOT</th>
          <th>GPT</th>
          <th>r-GTP<BR>(GGT)</th>
          <th class="lastCol"><!--식전혈당 --><%=g.getMessage("LABEL.E.E16.0037")%></th>
        </tr>
        </thead>
<%          int qtar=0;
            int TMP_MEDI_QTAR=1;
            String graph_label= "0,1/4,2/4,3/4,4/4";
            String MEDI_BPH  = "0";
            String MEDI_BPL  = "0";
            String MEDI_TTC  = "0";
            String MEDI_TRG  = "0";
            String MEDI_HDL  = "0";
            String MEDI_LDL  = "0";
            String MEDI_GOT  = "0";
            String MEDI_GPT  = "0";
            String MEDI_GGT  = "0";
            String MEDI_GLU  = "0";
            String MEDI_BPH_STD  = ""; //정상기준
            String MEDI_BPL_STD  = "";
            String MEDI_TTC_STD  = "";
            String MEDI_TRG_STD  = "";
            String MEDI_HDL_STD  = "";    //고밀도(HDL)<br>콜레스테롤
            String MEDI_LDL_STD  = "";    //저밀도(LDL)<br>콜레스테롤
            String MEDI_GOT_STD  = "";
            String MEDI_GPT_STD  = "";
            String MEDI_GGT_STD  = "";
            String MEDI_GLU_STD  = "";
            String MEDI_BPHR_LAST = "";
            String MEDI_BPLR_LAST = "";
            String MEDI_TTCR_LAST = "";
            String MEDI_TRGR_LAST = "";
            String MEDI_HDLR_LAST = "";
            String MEDI_LDLR_LAST = "";
            String MEDI_GOTR_LAST = "";
            String MEDI_GPTR_LAST = "";
            String MEDI_GGTR_LAST = "";
            String MEDI_GLUR_LAST = "";
            String REAL_DATE = "00000000";
            int qtar_cnt=0;

            for( int i = 0 ; i < e16Health9419Data_Svt.size() ; i++ ){
                E16Health9419Data e16Health9419Data1 = (E16Health9419Data)e16Health9419Data_Svt.get(i);

                if ( !( e16Health9419Data1.MEDI_QTAR.equals("0000")||e16Health9419Data1.MEDI_QTAR.equals("")) ) qtar_cnt++;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_BPHR_LAST.equals("") )) && !e16Health9419Data1.MEDI_BPHR.equals("")) MEDI_BPHR_LAST = e16Health9419Data1.MEDI_BPHR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_BPLR_LAST.equals("") )) && !e16Health9419Data1.MEDI_BPLR.equals("")) MEDI_BPLR_LAST = e16Health9419Data1.MEDI_BPLR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_TTCR_LAST.equals("") )) && !e16Health9419Data1.MEDI_TTCR.equals("")) MEDI_TTCR_LAST = e16Health9419Data1.MEDI_TTCR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_TRGR_LAST.equals("") )) && !e16Health9419Data1.MEDI_TRGR.equals("")) MEDI_TRGR_LAST = e16Health9419Data1.MEDI_TRGR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_HDLR_LAST.equals("") )) && !e16Health9419Data1.MEDI_HDLR.equals("")) MEDI_HDLR_LAST = e16Health9419Data1.MEDI_HDLR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_LDLR_LAST.equals("") )) && !e16Health9419Data1.MEDI_LDLR.equals("")) MEDI_LDLR_LAST = e16Health9419Data1.MEDI_LDLR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_GOTR_LAST.equals("") )) && !e16Health9419Data1.MEDI_GOTR.equals("")) MEDI_GOTR_LAST = e16Health9419Data1.MEDI_GOTR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_GPTR_LAST.equals("") )) && !e16Health9419Data1.MEDI_GPTR.equals("")) MEDI_GPTR_LAST = e16Health9419Data1.MEDI_GPTR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_GGTR_LAST.equals("") )) && !e16Health9419Data1.MEDI_GGTR.equals("")) MEDI_GGTR_LAST = e16Health9419Data1.MEDI_GGTR;
                if ( ( (Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE)) > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE)) )|| (MEDI_GLUR_LAST.equals("") )) && !e16Health9419Data1.MEDI_GLUR.equals("")) MEDI_GLUR_LAST = e16Health9419Data1.MEDI_GLUR;
                if ( Float.parseFloat(DataUtil.delDateGubn(e16Health9419Data1.REAL_DATE))  > Float.parseFloat(DataUtil.delDateGubn(REAL_DATE) )  ) REAL_DATE = e16Health9419Data1.REAL_DATE;

            }

            for( int i = 0 ; i < e16Health9419Data_vt.size() ; i++ ){
                E16Health9419Data e16Health9419Data = (E16Health9419Data)e16Health9419Data_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }
%>
        <tr class="<%=tr_class%>">
<%
          if ( qtar <1 && !e16Health9419Data.MEDI_QTAR.equals("0000")&&!e16Health9419Data.MEDI_QTAR.equals("")) {
%>
          <td rowspan="<%=qtar_cnt%>"><!--상담 --><%=g.getMessage("LABEL.E.E16.0038")%></td>
<%
  }
%>
          <!--<td <%= e16Health9419Data.MEDI_QTAR.equals("")||e16Health9419Data.MEDI_QTAR.equals("0000") ? "colspan='2' witdh='130'": "witdh='80'" %>><%= e16Health9419Data.STEXT  %></td>-->
          <td <%= e16Health9419Data.MEDI_QTAR.equals("")||e16Health9419Data.MEDI_QTAR.equals("0000") ? "colspan='2' witdh='130'": "witdh='80'" %>><%= e16Health9419Data.REAL_DATE.equals("0000-00-00")||e16Health9419Data.REAL_DATE.equals("0000.00.00")?  e16Health9419Data.STEXT : WebUtil.printDate(e16Health9419Data.REAL_DATE)  %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_BPH) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_BPL) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_TTC) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_TRG) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_HDL) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_LDL) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_GOT) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_GPT) %></td>
          <td><%= Integer.parseInt(e16Health9419Data.MEDI_GGT) %></td>
          <td class="lastCol"><%= Integer.parseInt(e16Health9419Data.MEDI_GLU) %></td>
        </tr>
<%
        if (e16Health9419Data.MEDI_QTAR.equals("")){
%>

<%                      MEDI_BPH_STD = e16Health9419Data.MEDI_BPH;
                        MEDI_BPL_STD = e16Health9419Data.MEDI_BPL;
                        MEDI_TTC_STD = e16Health9419Data.MEDI_TTC;
                        MEDI_TRG_STD = e16Health9419Data.MEDI_TRG;
                        MEDI_HDL_STD = e16Health9419Data.MEDI_HDL;
                        MEDI_LDL_STD = e16Health9419Data.MEDI_LDL;
                        MEDI_GOT_STD = e16Health9419Data.MEDI_GOT;
                        MEDI_GPT_STD = e16Health9419Data.MEDI_GPT;
                        MEDI_GGT_STD = e16Health9419Data.MEDI_GGT;
                        MEDI_GLU_STD = e16Health9419Data.MEDI_GLU;
                    }else{
                        for( int j = TMP_MEDI_QTAR ; j < Integer.parseInt(e16Health9419Data.MEDI_QTAR); j++ ){

                             MEDI_BPH = MEDI_BPH+",0";
                             MEDI_BPL = MEDI_BPL+",0";
                             MEDI_TTC = MEDI_TTC+",0";
                             MEDI_TRG = MEDI_TRG+",0";
                             MEDI_HDL = MEDI_HDL+",0";
                             MEDI_LDL = MEDI_LDL+",0";
                             MEDI_GOT = MEDI_GOT+",0";
                             MEDI_GPT = MEDI_GPT+",0";
                             MEDI_GGT = MEDI_GGT+",0";
                             MEDI_GLU = MEDI_GLU+",0";
                             TMP_MEDI_QTAR++;
                             qtar++;
                        }
                        if (Integer.parseInt(e16Health9419Data.MEDI_QTAR) > 0) {
                             MEDI_BPH = MEDI_BPH+","+e16Health9419Data.MEDI_BPH;
                             MEDI_BPL = MEDI_BPL+","+e16Health9419Data.MEDI_BPL;
                             MEDI_TTC = MEDI_TTC+","+e16Health9419Data.MEDI_TTC;
                             MEDI_TRG = MEDI_TRG+","+e16Health9419Data.MEDI_TRG;
                             MEDI_HDL = MEDI_HDL+","+e16Health9419Data.MEDI_HDL;
                             MEDI_LDL = MEDI_LDL+","+e16Health9419Data.MEDI_LDL;
                             MEDI_GOT = MEDI_GOT+","+e16Health9419Data.MEDI_GOT;
                             MEDI_GPT = MEDI_GPT+","+e16Health9419Data.MEDI_GPT;
                             MEDI_GGT = MEDI_GGT+","+e16Health9419Data.MEDI_GGT;
                             MEDI_GLU = MEDI_GLU+","+e16Health9419Data.MEDI_GLU;
                             TMP_MEDI_QTAR++;
                             qtar++;
                        }
                        //out.println("<br>2-----TMP_MEDI_QTAR:"+TMP_MEDI_QTAR+"MEDI_BPH:"+MEDI_BPH+"MEDI_BPL:"+MEDI_BPL);
                    }
                   //out.println("<br>2DataUtil.delDateGubn(e16Health9419Data.REAL_DATE):"+DataUtil.delDateGubn(e16Health9419Data.REAL_DATE)+ "MEDI_GGTR:"+e16Health9419Data.MEDI_GGTR);


                    if ( i ==(e16Health9419Data_vt.size()-1) ) {%>
        <tr class="sumRow">
          <td colspan="2"><!--최종결과 --><%=g.getMessage("LABEL.E.E16.0039")%></td>
          <td><%= MEDI_BPHR_LAST %></td>
          <td><%= MEDI_BPLR_LAST %></td>
          <td><%= MEDI_TTCR_LAST %></td>
          <td><%= MEDI_TRGR_LAST %></td>
          <td><%= MEDI_HDLR_LAST %></td>
          <td><%= MEDI_LDLR_LAST %></td>
          <td><%= MEDI_GOTR_LAST %></td>
          <td><%= MEDI_GPTR_LAST %></td>
          <td><%= MEDI_GGTR_LAST %></td>
          <td class="lastCol"><%= MEDI_GLUR_LAST %></td>
        </tr>
<%                  }
            }

            for( int j = TMP_MEDI_QTAR ; j < 5; j++ ){
                  TMP_MEDI_QTAR++;qtar++;
                  MEDI_BPH = MEDI_BPH+",0";
                  MEDI_BPL = MEDI_BPL+",0";
                  MEDI_TTC = MEDI_TTC+",0";
                  MEDI_TRG = MEDI_TRG+",0";
                  MEDI_HDL = MEDI_HDL+",0";
                  MEDI_LDL = MEDI_LDL+",0";
                  MEDI_GOT = MEDI_GOT+",0";
                  MEDI_GPT = MEDI_GPT+",0";
                  MEDI_GGT = MEDI_GGT+",0";
                  MEDI_GLU = MEDI_GLU+",0";

            }
%>
          </table>
      </div>
  </div>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
      	      	<colgroup>
	      		<col width="15%" />
	      		<col width="70%" />
	      		<col width="15%" />
	      	</colgroup>
	  <thead>
        <tr>
          <th><!--일자 --><%=g.getMessage("LABEL.E.E16.0044")%></th>
          <th><!--상담 및 건강 Check --><%=g.getMessage("LABEL.E.E16.0045")%></th>
          <th class="lastCol"><!--비고 --><%=g.getMessage("LABEL.E.E16.0046")%></th>
        </tr>
       </thead>
<%
            for( int i = 0 ; i < e16Health9420Data_vt.size() ; i++ ){
                E16Health9420Data e16Health9420Data = (E16Health9420Data)e16Health9420Data_vt.get(i);

            String tr_class = "";

            if(i%2 == 0){
                tr_class="oddRow";
            }else{
                tr_class="";
            }
%>
        <tr class="<%=tr_class%>">
          <td><%= WebUtil.printDate(e16Health9420Data.BEGDA) %>&nbsp;</td>
          <td class="align_left"><%= e16Health9420Data.MEDI_ADVC1  %>&nbsp;<%= e16Health9420Data.MEDI_ADVC2  %>&nbsp;<%= e16Health9420Data.MEDI_ADVC3  %>&nbsp;<%= e16Health9420Data.MEDI_ADVC4  %>&nbsp;<%= e16Health9420Data.MEDI_ADVC5  %>&nbsp;<%= e16Health9420Data.MEDI_ADVC6  %></td>
          <td class="lastCol"><%= e16Health9420Data.MEDI_NOTE  %></td>
        </tr>
<%
            }
%>
      </table>
    </div>
  </div>
</td></tr></table>
<%    if (e16Health9419Data_vt.size()  > 1000 ){ qtar++;%>


      <!--2page-->
        <p style="page-break-after:avoid;">
    <table width="640" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <!--<td width="16">&nbsp;</td>-->
      <td>
   <h2 class="subtitle"> <!--건강관리 추이 Graph --><%=g.getMessage("LABEL.E.E16.0040")%></h2>

  <!-- 상단 입력 테이블 시작-->
  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th><!--고혈압 --><%=g.getMessage("LABEL.E.E16.0026")%><font color=blue><!--혈압(고) --><%=g.getMessage("LABEL.E.E16.0030")%></font></th>
          <th><font color=blue><!--혈압(저) --><%=g.getMessage("LABEL.E.E16.0031")%></font></th>
        </tr>
        <tr class="oddRow">
          <td valign=top>
            <comment id="__NSID__1">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_BPH%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="고">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_BPH_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_BPH_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_BPH_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__1);</script>
          </td>
          <td>
            <comment id="__NSID__2">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_BPL%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="저">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_BPL_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_BPL_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_BPL_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__2);</script>
          </td>
        </tr>
      </table>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th><!--고지혈증 --><%=g.getMessage("LABEL.E.E16.0027")%><font color=blue><!--총콜레스트롤 --><%=g.getMessage("LABEL.E.E16.0032")%><%=g.getMessage("LABEL.E.E16.0033")%></font></th>
          <th><font color=blue><!--중성지방 --><%=g.getMessage("LABEL.E.E16.0041")%></font></th>
        </tr>
        <tr class="oddRow">
          <td>
            <comment id="__NSID__3">
            <!--APPLET CODE="ExLineChart.class" archive ="http://165.244.243.190:5041/web/s_link/s_link.jar" WIDTH=750 HEIGHT=350-->
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_TTC%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="T.C">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_TTC_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_TTC_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_TTC_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__3);</script>
          </td>
          <td>
            <comment id="__NSID__4">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_TRG%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="TG">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_TRG_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_TRG_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_TRG_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__4);</script>
          </td>
        </tr>
      </table>
    </div>
  </div>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th><!--고지혈증 --><%=g.getMessage("LABEL.E.E16.0027")%><font color=blue><!--고밀도(HDL) --><%=g.getMessage("LABEL.E.E16.0035")%><!--콜레스테롤 --><%=g.getMessage("LABEL.E.E16.0033")%></th>
          <th><font color=blue><!--저밀도(LDL) --><%=g.getMessage("LABEL.E.E16.0036")%><!--콜레스테롤 --><%=g.getMessage("LABEL.E.E16.0033")%></font></th>
        </tr>
        <tr>
          <td>
            <comment id="__NSID__31">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_HDL%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="HDL">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_HDL_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_HDL_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_HDL_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__31);</script>
          </td>
          <td>
            <comment id="__NSID__41">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_LDL%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="LDL">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_LDL_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_LDL_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_LDL_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__41);</script>
          </td>
        </tr>
      </table>
    </div>
  </div>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th><!--간장질환 --><%=g.getMessage("LABEL.E.E16.0028")%><font color=blue>GOT</font></th>
          <th><font color=blue>GPT</font></th>
        </tr>
        <tr>
          <td>
            <comment id="__NSID__5">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_GOT%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="GOT">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_GOT_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_GOT_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_GOT_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__5);</script>
          </td>
          <td>
            <comment id="__NSID__6">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_GPT%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="GPT">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_GPT_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_GPT_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_GPT_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__6);</script>
          </td>
        </tr>
      </table>
    </div>
  </div>

  <div class="listArea">
    <div class="table">
      <table class="listTable">
        <tr>
          <th><!--간장질환 --><%=g.getMessage("LABEL.E.E16.0028")%><font color=blue>r-GTP</font></th>
          <th><!--당뇨 --><%=g.getMessage("LABEL.E.E16.0029")%><font color=blue><!--식전혈당 --><%=g.getMessage("LABEL.E.E16.0037")%></font></th>
        </tr>
        <tr>
          <td>
            <comment id="__NSID__7">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_GGT%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="GGT">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_GGT_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_GGT_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_GGT_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__7);</script>
          </td>
          <td>
            <comment id="__NSID__8">
            <APPLET CODE="ExLineChart.class" archive ="/web/s_link/s_link.jar" border=0 WIDTH=380 HEIGHT=250>
            <PARAM NAME=LINEDATA VALUE="<%=MEDI_GLU%>">
            <PARAM NAME=NUMOFGROUP VALUE=1>
            <PARAM NAME=NUMOFDATA VALUE="<%=qtar%>">
            <PARAM NAME=LABEL VALUE="<%=graph_label%>">
            <PARAM NAME=LEGEND VALUE="혈당">
            <PARAM NAME=NUMOFBEELINE VALUE=1>
            <PARAM NAME=BEELINEDATA VALUE="<%=MEDI_GLU_STD%>">
            <PARAM NAME=BEELINELABEL VALUE="정상">
            <PARAM NAME=BEELINEPOS VALUE=1>
            <PARAM NAME=MIN VALUE=<%= Integer.parseInt(MEDI_GLU_STD)-50%>>
            <PARAM NAME=MAX VALUE=<%= Integer.parseInt(MEDI_GLU_STD)+50%>>
            </APPLET>
            </comment>
            <script>__ws__(__NSID__8);</script>
          </td>
        </tr>
      </table>
    </div>
  </div>
  </td></tr></table>
    <% } %>


<input type=hidden name="aa" value="<%=user.e_grup_numb%>">
</div>
</div>
</form>

<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->
