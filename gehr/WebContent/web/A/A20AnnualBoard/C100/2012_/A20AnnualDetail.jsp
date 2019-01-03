<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 나의 연봉 계약서  (임원용)                                          */
/*   Program Name : 나의 연봉 계약서   (임원용)                                         */
/*   Program ID   : A20AnnualDetail.jsp                                         */
/*   Description  : 나의 연봉 조회                                              */
/*   Note         :                                                             */
/*   Creation     : 2016-03-09      [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청                                                       */
/*   Update       :                      */
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
	WebUserData user_m = WebUtil.getSessionMSSUser(request);
    String ename = user.ename;
    String imgURL      = (String)request.getAttribute("imgURL");
    String ZYEAR       = (String)request.getAttribute("ZYEAR");
    String type = (String)request.getParameter("type");
    
    if(type.equals("M")){
    	
    }else if(type.equals("I")|| type == null){
    	
    }
   
    String birthday = DataUtil.getBirthday(user.e_regno);
    
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

    ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( user.empNo ,"1",data.ZYEAR ,user.companyCode );
    
    String AGRE_FLAG = (String)ret.get(0); 
    String E_BETRG = (String)ret.get(1); 
    String E_BETRG2 = (String)ret.get(2); 
    
    double BETRG;//기본급
    double BET01;//역할급
    double ANSAL;//합계
    
    if ( AGRE_FLAG.equals("Y") ) {  
         //tmpInt = Double.parseDouble( E_BETRG);  //합의된 금액
         BETRG  = Double.parseDouble( E_BETRG);  //합의된 금액(기본급)
         BET01  = Double.parseDouble( E_BETRG2);  //합의된 금액(역할급)
         ANSAL  = BETRG + BET01;
    }
    else { 
        //tmpInt = Double.parseDouble( data.BETRG ); //급여의 기본년봉  
         BETRG  = Double.parseDouble( data.BETRG ); //급여의 기본년봉 
         BET01  = Double.parseDouble( data.BET01 ); //급여의 기본년봉  
         ANSAL  = Double.parseDouble( data.ANSAL ); //급여의 기본년봉  
    }

    String msg     = (String)request.getAttribute("msg"); //@v1.3 합의여부
    
    
%>
<html>
<head>
<title>ESS</title>
<link rel="stylesheet" href="<%= imgURL %>ess.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript">
                                        
    function f_print(){                 
        self.print();                   
    }                                   
   
    function firstHideshow() { 
        if("<%=data.TITL2%>" == "CEO"){
        	ceoForm.style.display = "block";
        	ceoForm1.style.display = "block";
        	ceoForm2.style.display = "block";
        }else{
        	exeForm.style.display = "block";
        	exeForm1.style.display = "block";
        	exeForm2.style.display = "block";
        }                                                                         
     }  
                                        
</SCRIPT>                               
</head>
 
<% //@v1.1 
  String O_CHECK_FLAG = ( new D05ScreenControlRFC() ).getScreenCheckYn( user.empNo );
  
  if (O_CHECK_FLAG.equals("N") ) {
%>            
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
                    <table border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="td09" align="center">
                           <font color="red">※ 급여작업으로 인해 메뉴 사용을 일시 중지합니다.<br><br></font><!--@v1.1-->
                         </td>
                      </tr>
                    </table>
<% } else {  //@v1.1   
%>  
 
<body  onLoad="javascript:firstHideshow(); if ('<%=msg%>' != '' &&  '<%=msg%>' != 'null' ) alert('<%=msg%>');" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return false" ondragstart="return false" onselectstart="return false" onKeyUp="ClipBoardClear()"><!-- 20151110 담당님 지시사항 보안조치 강화 -->
 
<%  

     if ( aFlag == true ) {  %>
<table width="624" border="0" cellspacing="3" cellpadding="0">
  <tr>
    <td>
&nbsp;
    </td>
  </tr>
  <tr>
    <td align="center">
    <%if(user != null){ %>
      <table width="450" border="0" cellspacing="2" cellpadding="0">
        <tr>
          <td align="center"><font face="바탕, 바탕체" size="6"><b>연봉계약서</b></font></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="style01">주식회사 LG화학과 <%= ename %> <%= user.e_titel %>는 신의와 성실을 바탕으로 
                  <%= data.BEGDA.substring(0,4) %>년 <%= Integer.parseInt(data.BEGDA.substring(5,7)) %>월 <%= Integer.parseInt(data.BEGDA.substring(8,10)) %>일부터
                  <%= data.ENDDA.substring(0,4) %>년 <%= Integer.parseInt(data.ENDDA.substring(5,7)) %>월 <%= Integer.parseInt(data.ENDDA.substring(8,10)) %>일까지 적용되는
                  <%= ename %> <%= user.e_titel %>의 고정연봉을 다음과 같이 계약한다.
           </td> 
        <tr>
                  
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td class="td04">--- 다     음 ---</font></td>
        </tr>

        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
            <table width="560" border="0" cellspacing="0" cellpadding="2" align="center">
              <tr >
                <td colspan="2" class="style01"><u>제 1조 고정연봉 금액 </u></td>
              </tr>
              <tr>
                <td class="style01" valign=top>①</td>
                <td class="style01">	고정연봉(기본연봉+역할급)은 <font style="background-color: #CCCCCC"><i><b>\<%=WebUtil.printNumFormat(ANSAL) %>원(\<%=WebUtil.printNumFormat(DataUtil.olim(ANSAL/12, -3)) %>원/月)</b></i></font>으로 한다.</td>
              </tr> 
               <tr id="exeForm" style="display:none">
                <td class="style01" valign=top>②</td>
                <td class="style01">기본연봉은 <font style="background-color: #CCCCCC"><i><b>\<%=WebUtil.printNumFormat(BETRG) %>원(\<%=WebUtil.printNumFormat(DataUtil.olim(BETRG/12, -3)) %>원/月)</b></i></font>으로 한다.<br>
                							단, 계약기간 중 승진 시 혹은 집행임원 인사관리 규정의 기본연봉 기준표 
											변경 시에는 승진/변경 일자를 기준으로 해당 직위 기본연봉을 적용하되, 
											대표이사는 본인에게 변동 내용을 통보한다.
                </td>
              </tr>                                                            
              <tr id="ceoForm" style="display:none">
                <td class="style01" valign=top>②</td>
                <td class="style01">기본연봉은 <font style="background-color: #CCCCCC"><i><b>\<%=WebUtil.printNumFormat(BETRG) %>원(\<%=WebUtil.printNumFormat(DataUtil.olim(BETRG/12, -3)) %>원/月)</b></i></font>으로 한다.<br>
                							단, 계약기간 중 승진 시 혹은 집행임원 인사관리 규정의 기본연봉 기준표 
											변경 시에는 승진/변경 일자를 기준으로 해당 직위 기본연봉을 적용하되, 
											이사회는 본인에게 변동 내용을 통보한다.
                </td>
              </tr>
              <tr id="exeForm1" style="display:none">
                <td class="style01"  valign=top>③</td>
                <td class="style01">역할급은 <font style="background-color: #CCCCCC"><i><b>\<%=WebUtil.printNumFormat(BET01) %>원(\<%=WebUtil.printNumFormat(DataUtil.olim(BET01/12, -3)) %>원/月)</b></i></font>으로 한다. <br>
                							단, 역할급은 현 직무와 역할을 기준으로 한 것이며, 수행 직무 및 역할의 
											변동이 있을 경우, 계약 기간 중이라도 대표이사의 결정에 따라 변동 가능
											하다. 이 경우, 대표이사는 본인에게 변동 내용을 통보한다.<br>&nbsp;</td>
              </tr>
               <tr id="ceoForm1" style="display:none">
                <td class="style01"  valign=top>③</td>
                <td class="style01">역할급은 <font style="background-color: #CCCCCC"><i><b>\<%=WebUtil.printNumFormat(BET01) %>원(\<%=WebUtil.printNumFormat(DataUtil.olim(BET01/12, -3)) %>원/月)</b></i></font>으로 한다. <br>
                							단, 역할급은 현 직무와 역할을 기준으로 한 것이며, 수행 직무 및 역할의 
											변동이 있을 경우, 계약 기간 중이라도 이사회의 결정에 따라 변동 가능
											하다. 이 경우, 이사회는 본인에게 변동 내용을 통보한다.<br>&nbsp;</td>
              </tr>
              </tr>
              <!-- CSR ID : 2506534 => 역할급 구분 없이 職務 항목 모두 제외 -->
              <tr  >
                <td colspan="2" class="style01"><u>제 2조 지급방식 </u></td>
              </tr>  
              <tr    >
                <td colspan="2" class="style01">고정연봉은 기본연봉과 역할급을 각각 12개월로 균등 분할하여 월기본급
(기본연봉÷12) 과 월역할급(역할급÷12) 명목으로 매월 지급한다.<br>&nbsp;
</td>
              </tr>  
<tr   >
                <td colspan="2" class="style01"><u>제 3조 특별상여금 </u></td>
              </tr>
              <tr  >
                <td colspan="2" class="style01">회사는 회사의 재무성과와 개인의 경영목표 달성도에 따른 특별 상여금을 
비정기적으로 지급할 수 있다.<br>&nbsp;
</td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 4조 퇴직금 산정기준 </u></td>
              </tr>
              <tr  >
                <td colspan="2" class="style01">집행임원인사관리규정 제34조①항 에 의한 퇴직금 산정은 해당 직위 재임 
매 1년에 대하여 [퇴직시 월기본급×해당직위 지급율]로 계산한다.<br>&nbsp;
</td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 5조 비밀유지 </u></td>
              </tr>
              <tr  >
                <td colspan="2" class="style01">상기 고정연봉 계약 내용 및 기타 집행임원으로서의 보수에 관한 일체의 사항에 대하여 사내외 제3자에게 누설하지 아니하며, 이를 위반할 경우 집행임원 
인사관리 규정상 징계절차 따른 해임의 조치를 감수한다.<br>&nbsp;
</td>
              </tr>
              <tr  >
                <td colspan="2" class="style01"><u>제 6조 기타 </u></td>
              </tr>
              <tr  >
                <td colspan="2" class="style01">기타 집행임원으로서의 보수 및 처우에 관한 사항은 정관, 이사회 및 집행임원 인사관리 규정에서 정한 바에 따른다.</td>
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
<% if(data.TITL2.equals("CEO")){%>                
                <td width="361" valign=bottom><img src="<%= imgURL %>img_sign_isa.gif"></td>
<%}else{ %>     
				<td width="361" valign=bottom><img src="<%= imgURL %>img_sign_bjs.gif"></td>
<%} %>             
                <td align="left" > 
                  <table width="300" border="0" cellspacing="5" cellpadding="5" align="right">
                    <tr>
                      <td align="right" width="300" class="style01" colspan="3"><%=ZYEAR %>년 4월 1일</td>
                    </tr>
                    <tr>
                    <td colspan="3" class="style01">&nbsp;생년월일 : <%=birthday.substring(0,4) %>년 <%=birthday.substring(4,6) %>월 <%=birthday.substring(6,8) %>일</td>
                    </tr>
                    <tr>
                    <td colspan="2" class="style01">&nbsp;직책 : <%= data.TITL3 %></td>
                     <%       if ( AGRE_FLAG.equals("Y") ) {  %>  
                      <td align="center" rowspan="2"><img src="<%= WebUtil.ImageURL %>btn_agreeYes.gif" border="0">
                      </td>  
<%       }  %>     
                    </tr>
                    <tr>
                      <td align="left" width="100" class="style01">&nbsp;직위 : <%= data.TITEL %></td>
                      <td align="left" width="100" class="style01">&nbsp;<%= ename %>&nbsp;&nbsp;&nbsp;(印)</td>
                     
                    </tr>
                        <!-- @< %= data.ORGTX %><br> -->
                        

                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
<%
    //if ( Integer.parseInt(data.ZYEAR) >= 2008 && !AGRE_FLAG.equals("Y") )   
    if ( !AGRE_FLAG.equals("Y") ) {  
%>  
        <tr>
          <td align="center">
            <table width="150" border="0" cellspacing="0" cellpadding="0">
            <tr><td>&nbsp;</td>
            </tr>
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
      <%}//화면 숨김 %>
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
<input type=hidden name="I_YEAR"      value="<%=data.ZYEAR %>">
</form>

</body>
</html>