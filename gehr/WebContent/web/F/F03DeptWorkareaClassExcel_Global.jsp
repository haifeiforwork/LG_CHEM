<%/******************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manaer's Desk
*   2Depth Name  : 인원현황
*   Program Name : 근무지별/직급별 인원현황
*   Program ID   : F03DeptWorkareaClassExcel.jsp
*   Description  : 근무지별/직급별 인원현황 Excel 저장을 위한 jsp 파일
*   Note         : 없음
*   Creation     :
*   Update       : 2018-04-04 cykim		[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청
********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%@ page import="hris.common.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
    WebUserData user    = (WebUserData)session.getAttribute("user");                            //세션.
    String deptId       = WebUtil.nvl(request.getParameter("hdn_deptId"));                  //부서코드


    String deptNm       = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                  //부서명
    Vector F03DeptWorkareaClassTitle_vt = (Vector)request.getAttribute("F03DeptWorkareaClassTitle_vt");   //제목

    HashMap meta = (HashMap)request.getAttribute("meta");
    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Working_area_Level.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
    F03DeptWorkareaClassTitleGlobalData total = new F03DeptWorkareaClassTitleGlobalData();
    AppUtil.initEntity(total,"0");
    if(F03DeptWorkareaClassTitle_vt.size() > 0)
         total = (F03DeptWorkareaClassTitleGlobalData)F03DeptWorkareaClassTitle_vt.get(F03DeptWorkareaClassTitle_vt.size() - 1 );
    AppUtil.nvlEntity(total);
    int office = 0 ;
    int plant = 0 ;
    int intern = 0 ;

    //office colspan

	if(Integer.parseInt(total.P03) > 0){
     	office ++;
    }
    if(Integer.parseInt(total.P04) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P05) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P06) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P24) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P25) > 0){
    	office ++;
    }

    if(Integer.parseInt(total.P07) > 0){
    	office ++;
    }

    if(Integer.parseInt(total.P26) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P27) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P08) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P09) > 0){
    	office ++;
    }
    if(Integer.parseInt(total.P10) > 0){
    	office ++;
    }
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start
	if (Integer.parseInt(total.P28) > 0) {
        office ++;
    }
    if (Integer.parseInt(total.P29) > 0) {
        office ++;
    }
    if (Integer.parseInt(total.P30) > 0) {
        office ++;
    }
    if (Integer.parseInt(total.P31) > 0) {
        office ++;
    }
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end

    //plant colspan
	if(Integer.parseInt(total.P11) > 0){
     	plant ++;
    }
    if(Integer.parseInt(total.P12) > 0){
    	plant ++;
    }
    if(Integer.parseInt(total.P13) > 0){
    	plant ++;
    }
    if(Integer.parseInt(total.P14) > 0){
    	plant ++;
    }
    if(Integer.parseInt(total.P15) > 0){
    	plant ++;
    }
    if(Integer.parseInt(total.P16) > 0){
    	plant ++;
    }
    if(Integer.parseInt(total.P17) > 0){
    	plant ++;
    }
    //Intern colspan
    if(Integer.parseInt(total.P18) > 0){
    	intern ++;
    }
    if(Integer.parseInt(total.P19) > 0){
    	intern ++;
    }
    if(Integer.parseInt(total.P20) > 0){
    	intern ++;
    }

%>

<html>
<head>
<title>MSS</title>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 9">
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post">

<%
    if ( F03DeptWorkareaClassTitle_vt != null && F03DeptWorkareaClassTitle_vt.size() > 0 ) {

        //전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="<%=tableSize%>" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr>
    <td width="16">&nbsp;</td>
    <td >
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td colspan="2" class="title02">* <spring:message code='LABEL.F.F03.0001'/><!-- Working Area -->/Level</td>
        </tr>
        <tr><td height="10"></td></tr>
        <tr>
          <td colspan="2" class="td09">
            &nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- Team --> : <%=WebUtil.nvl(deptNm, user.e_obtxt)%>
          </td>
          <td ></td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr>
    <td width="16">&nbsp;</td>
    <td valign="top" width="">
     	<%--<div style="width: 73%; height:125px; overflow-x: auto;">--%>
		<table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        <tr>
          <td colspan="2" style="text-align:center" ><spring:message code='LABEL.F.F03.0001'/><!-- Working Area --></td>
 		  <%
          	if(Integer.parseInt(total.P01)>0 && Integer.parseInt(total.P02) > 0){
          %>
          <td width="" style="text-align:center" colspan="2"><spring:message code='LABEL.F.F01.0001'/><!-- EMP. --></td>
          <%
          	}else if(Integer.parseInt(total.P01)>0 || Integer.parseInt(total.P02) > 0){
          %>
          <td width="" style="text-align:center" ><spring:message code='LABEL.F.F01.0001'/><!-- EMP. --></td>
		  <%
          	}
          	if(office > 0){
          %>
          <td style="text-align:center" colspan="<%=office %>" ><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></td>
          <%
          }
          if(plant >0){
          %>
          <td style="text-align:center" colspan="<%=plant %>" ><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></td>
          <%
          }
          if(intern > 0){
          %>
          <td style="text-align:center" colspan="<%=intern %>" ><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></td>
          <%
          }
          if(Integer.parseInt(total.P21) > 0){
          %>
          <td style="text-align:center" rowspan="2" width="50" ><spring:message code='LABEL.F.F01.0005'/><!-- Others --></td>
          <%
          }
          if(Integer.parseInt(total.P22) > 0){
          %>
          <td style="text-align:center" rowspan="2" width="50" >&nbsp;&nbsp;<spring:message code='LABEL.F.F01.0043'/><!-- EMP. -->&nbsp;<br>&nbsp;<spring:message code='LABEL.F.F04.0002'/><!-- SUM -->&nbsp;&nbsp;</td>
          <%
          }
          %>
          <td style="text-align:center" rowspan="2" width="50" ><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></td>
        </tr>
        <tr>
          <td width="70" style="text-align:center"><spring:message code='LABEL.F.F03.0002'/><!-- Pers. Area --></td>
          <td width="70" style="text-align:center"><spring:message code='LABEL.F.F03.0003'/><!-- Pers. Subarea --></td>

          <%
          	if(Integer.parseInt(total.P01) > 0){
          %>
          <td width="50" style="text-align:center" nowrap><spring:message code='LABEL.F.F01.0007'/><!-- KR --></td>
          <%
          }
          	if(Integer.parseInt(total.P02) > 0){
          %>

          <td width="50" style="text-align:center" nowrap><spring:message code='LABEL.F.F01.0008'/><!-- Partner --></td>
          <%
          }
         	if(Integer.parseInt(total.P03) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0010'/><!-- I --></td>
          <%
          	}
          	if(Integer.parseInt(total.P04) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0011'/><!-- II-1 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P05) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0012'/><!-- II-2 --></td>
		  <%
		  	}
		  	if(Integer.parseInt(total.P06) > 0){
		  %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0013'/><!-- III --></td>

          <%
		  	}
		  	if(Integer.parseInt(total.P24) > 0){
		  %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0014'/><!-- III-1 --></td>
          <%
		  	}
		  	if(Integer.parseInt(total.P25) > 0){
		  %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0015'/><!-- III-2 --></td>

          <%
          	}
          	if(Integer.parseInt(total.P07) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0016'/><!-- IV-1 --></td>

          <%
          	}
          	if(Integer.parseInt(total.P26) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0017'/><!-- IV-1.A --></td>
          <%
          	}
          	if(Integer.parseInt(total.P27) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0018'/><!-- IV-1.B --></td>

          <%
          	}
          	if(Integer.parseInt(total.P08) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0019'/><!-- IV-2 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P09) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0020'/><!-- IV-3 --></td>
          <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start -->
		  <%
           }
           if (Integer.parseInt(total.P30) > 0) {
         %>
         <td width="50" style="text-align:center"><spring:message code='LABEL.F.F01.0044'/><!-- L1 --></td>
         <%
           }
           if (Integer.parseInt(total.P29) > 0) {
         %>
         <td width="50" style="text-align:center"><spring:message code='LABEL.F.F01.0045'/><!-- L2 --></td>
         <%
           }
           if (Integer.parseInt(total.P28) > 0) {
         %>
         <td width="50" style="text-align:center"><spring:message code='LABEL.F.F01.0046'/><!-- L3 --></td>
         <%
           }
           if (Integer.parseInt(total.P31) > 0) {
         %>
         <td width="50" style="text-align:center"><spring:message code='LABEL.F.F01.0047'/><!-- OTHERS --></td>
         <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  end -->
        <%
          	}
          	if(Integer.parseInt(total.P10) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F04.0002'/><!-- SUM --></td>
          <%
          	}
          	if(Integer.parseInt(total.P11) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0021'/><!-- J1 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P14) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0022'/><!-- J2 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P12) > 0){
           %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0023'/><!-- J1-1 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P13) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0024'/><!-- J1-2 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P15) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0025'/><!-- J2-1 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P16) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0026'/><!-- J2-2 --></td>
          <%
          	}
          	if(Integer.parseInt(total.P17) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F04.0002'/><!--SUM --></td>
          <%
          	}
          	if(Integer.parseInt(total.P18) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0027'/><!-- O/W --></td>
          <%
          	}
          	if(Integer.parseInt(total.P19) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F01.0028'/><!-- P/O --></td>
          <%
          	}
          	if(Integer.parseInt(total.P20) > 0){
          %>
          <td width="50" style="text-align:center"  ><spring:message code='LABEL.F.F04.0002'/><!--SUM --></td>
          <%
          	}
          %>
        </tr>
        <%
        	String tmp = "";
        	for( int i = 0 ; i < F03DeptWorkareaClassTitle_vt.size() ; i ++){
        		F03DeptWorkareaClassTitleGlobalData entity = (F03DeptWorkareaClassTitleGlobalData)F03DeptWorkareaClassTitle_vt.get(i);
        %>
        <tr>
        	<%
        		if(!tmp.equals(entity.PBTXT)){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":"td05"%>" rowspan="<%=meta.get(entity.PBTXT)%>" <%=entity.PBTXT.equals("TOTAL")?"colspan='2'":""%> style="text-align:<%=entity.PBTXT.equals("TOTAL")?"center":"left"%>" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<%=entity.PBTXT %></td>
        	<%
        		}if(!entity.PBTXT.equals("TOTAL")){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>"><%=entity.BTEXT %></td>
        	<%}
        	if(Integer.parseInt(total.P01) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P01) %>
        	</td>
 			<%
 			}
        	if(Integer.parseInt(total.P02) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P02) %>
        	</td>
 			<%
 			}
 			%>
          <%
          	if(Integer.parseInt(total.P03) > 0){
          %>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>">
        	<%=WebUtil.printNumFormat(entity.P03) %>
        	</td>
          <%
          	}
          	if(Integer.parseInt(total.P04) > 0){
          %>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>">
        	<%=WebUtil.printNumFormat(entity.P04) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P05) > 0 ){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>">
        	<%=WebUtil.printNumFormat(entity.P05)%>
        	</td>
			<%
			}
			if(Integer.parseInt(total.P06) > 0 ){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P06) %>
        	</td>

        	<%
			}
			if(Integer.parseInt(total.P24) > 0 ){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P24) %>
        	</td>
        	<%
			}
			if(Integer.parseInt(total.P25) > 0 ){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P25) %>
        	</td>

			<%
			}
			if(Integer.parseInt(total.P07) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P07) %>
        	</td>

        	<%
			}
			if(Integer.parseInt(total.P26) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P26) %>
        	</td>
        	<%
			}
			if(Integer.parseInt(total.P27) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P27) %>
        	</td>

        	<%
        	}
        	if(Integer.parseInt(total.P08) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P08) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P09) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P09) %>
        	</td>
        	<!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start -->
			<%
             }
             if(Integer.parseInt(total.P30) > 0){
             %>
             <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
             <%=WebUtil.printNumFormat(entity.P30) %>
             </td>
             <%
             }
             if(Integer.parseInt(total.P29) > 0){
             %>
             <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
             <%=WebUtil.printNumFormat(entity.P29) %>
             </td>
             <%
             }
             if(Integer.parseInt(total.P28) > 0){
             %>
             <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
             <%=WebUtil.printNumFormat(entity.P28) %>
             </td>
             <%
             }
             if(Integer.parseInt(total.P31) > 0){
             %>
             <td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
             <%=WebUtil.printNumFormat(entity.P31) %>
             </td>
            <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  end -->
        	<%
        	}
        	if(Integer.parseInt(total.P10) > 0 ){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P10) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P11) > 0 ){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P11) %>
        	</td>
			<%
			}
			if(Integer.parseInt(total.P14) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P14) %>
        	</td>
        	<%
        	}
			if(Integer.parseInt(total.P12) > 0){
			%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P12)%>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P13) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P13) %>
        	</td>
			<%
			}
        	if(Integer.parseInt(total.P15) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P15) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P16) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P16) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P17) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P17) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P18) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P18) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P19) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P19) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P20) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P20) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P21) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P21) %>
        	</td>
        	<%
        	}
        	if(Integer.parseInt(total.P22) > 0){
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P22) %>
        	</td>
        	<%
        	}
        	%>
        	<td class="<%=entity.PBTXT.equals("TOTAL")?"td11":entity.BTEXT.equals("SUBTOTAL")?"td11_2":"td05"%>" >
        	<%=WebUtil.printNumFormat(entity.P23)%>
        	</td>
        </tr>
        <%
	      	tmp = entity.PBTXT;
        	}
        %>
        </table>
    </td>
    <td width="16">&nbsp;</td>
  </tr>
  <tr><td height="16"></td></tr>
</table>

<%
    }else{
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/></td>
  </tr>
</table>
<%
    } //end if...
%>
</form>
</body>
</html>


