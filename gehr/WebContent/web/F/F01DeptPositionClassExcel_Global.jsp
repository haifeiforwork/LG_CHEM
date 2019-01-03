<%/***************************************************************************************
*		System Name	: g-HR
*   	1Depth Name 	: Organization & Staffing
*   	2Depth Name 	: Org.Unit/Level
*   	Program Name	: 소속별/직급별 인원현황
*   	Program ID   	: F01DeptPositionClassExcel.jsp
*   	Description  	: 소속별/직급별 인원현황 Excel 저장을 위한 jsp 파일
*   	Note         		: 없음
*   	Creation     	:
*		Update			: 2018-04-03 cykim   [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청
***************************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../common/commonProcess.jsp" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ page import="java.lang.reflect.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="hris.common.*" %>
<%@ page import="hris.common.rfc.*" %>
<%@ page import="hris.common.util.*" %>
<%@ page import="hris.F.*" %>
<%@ page import="hris.F.rfc.*" %>
<%
    request.setCharacterEncoding("utf-8");

    WebUserData user = (WebUserData)session.getAttribute("user");                           	// 세션

    String deptId = WebUtil.nvl(request.getParameter("hdn_deptId"));			// 부서코드
    String deptNm = (WebUtil.nvl(request.getParameter("hdn_deptNm")));                      	// 부서명

    Vector F01DeptPositionClassTitle_vt = (Vector)request.getAttribute("F01DeptPositionClassTitle_vt");		// 제목

    /*----- Excel 파일 저장하기 --------------------------------------------------- */
    response.setHeader("Content-Disposition","attachment;filename=Org_Unit_Level.xls");
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    /*----------------------------------------------------------------------------- */
	HashMap meta = (HashMap)request.getAttribute("meta");
    if(meta == null)
    	meta = new HashMap();

    F01DeptPositionClassTitleGlobalData total = new F01DeptPositionClassTitleGlobalData();
    AppUtil.initEntity(total,"0");

    if (F01DeptPositionClassTitle_vt != null && F01DeptPositionClassTitle_vt.size() > 0)
    	total = (F01DeptPositionClassTitleGlobalData)F01DeptPositionClassTitle_vt.get(F01DeptPositionClassTitle_vt.size() - 1 );
    AppUtil.nvlEntity(total);

    int office = 0;
    int plant = 0;
    int intern = 0;

    //office colspan
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start
    /* if(Integer.parseInt(total.JIKCN03) > 0) {
    	office ++;
    } */
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end
    if(Integer.parseInt(total.JIKCN04) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN05) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN06) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN07) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN08) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN09) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.SUBTOL1) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN10) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN11) > 0) {
    	office ++;
    }
    if(Integer.parseInt(total.JIKCN12) > 0) {
    	office ++;
    }
	if(Integer.parseInt(total.JIKCN13) > 0) {
     	office ++;
    }
    if(Integer.parseInt(total.JIKCN14) > 0) {
    	office ++;
    }
    //[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 start
    if(Integer.parseInt(total.JIKCN21) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN22) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN23) > 0) {
        office ++;
    }
    if(Integer.parseInt(total.JIKCN24) > 0) {
        office ++;
    }
  	//[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청 end

    //plant colspan
    if(Integer.parseInt(total.JIKCN15) > 0) {
    	plant ++;
    }
    if(Integer.parseInt(total.JIKCN16) > 0) {
    	plant ++;
    }
    if(Integer.parseInt(total.JIKCN17) > 0) {
    	plant ++;
    }
    if(Integer.parseInt(total.JIKCN18) > 0) {
    	plant ++;
    }
    if(Integer.parseInt(total.JIKCN19) > 0) {
    	plant ++;
    }
    if(Integer.parseInt(total.JIKCN20) > 0) {
    	plant ++;
    }
    if(Integer.parseInt(total.SUBTOL2) > 0) {
    	plant ++;
    }

    //Intern colspan
    if(Integer.parseInt(total.INTERN1) > 0) {
    	intern ++;
    }
    if(Integer.parseInt(total.INTERN2) > 0) {
    	intern ++;
    }
    if(Integer.parseInt(total.SUBTOL3) > 0) {
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
    if (F01DeptPositionClassTitle_vt != null && F01DeptPositionClassTitle_vt.size() > 0 ) {

        // 전체 테이블 크기 조절.
        int tableSize = 0;
%>
<table width="" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
    	<td width="16">&nbsp;</td>
    	<td>
      		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        		<tr>
		          	<td class="title02">* Org.Unit/Level Staff Present State</td>
		        </tr>
		        <tr>
		        	<td height="10"></td>
		        </tr>
		        <tr>
		          	<td width="50%" class="td09">&nbsp;<spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --> : <%= WebUtil.nvl(deptNm, user.e_obtxt) %></td>
		          	<td></td>
		        </tr>
        		<tr>
        			<td height="10"></td>
        		</tr>
      		</table>
    	</td>
    	<td width="16">&nbsp;</td>
	</tr>
	<tr>
    	<td width="16">&nbsp;</td>
    	<td colspan="2" valign="top">
      		<table border="1" cellpadding="0" cellspacing="1" class="table02" align="left">
        		<tr>
          			<td rowspan="2" style="text-align:center"><spring:message code='LABEL.F.FCOMMON.0001'/><!-- 부서 --></td>
					<%
						if (Integer.parseInt(total.JIKEXP_KR) > 0 && Integer.parseInt(total.JIKEXP_PR) > 0) {
					%>
					<td width="" style="text-align:center" colspan="2"><spring:message code='LABEL.F.F01.0001'/><!-- EXP. --></td>
					<%
						} else if (Integer.parseInt(total.JIKEXP_KR) > 0 || Integer.parseInt(total.JIKEXP_PR) > 0) {
					%>
					<td width="" style="text-align:center" ><spring:message code='LABEL.F.F01.0001'/><!-- EXP. --></td>
					<%
						}
						if (office > 0) {
					%>
					<td style="text-align:center" colspan="<%= office %>"><spring:message code='LABEL.F.F01.0002'/><!-- Office Worker --></td>
					<%
						}
						if (plant >0) {
					%>
					<td style="text-align:center" colspan="<%=plant %>"><spring:message code='LABEL.F.F01.0003'/><!-- Plant Operator --></td>
					<%
						}
						if (intern > 0) {
					%>
					<td style="text-align:center" colspan="<%=intern %>"><spring:message code='LABEL.F.F01.0004'/><!-- Intern --></td>
					<%
						}
						if (Integer.parseInt(total.OTHRS) > 0) {
					%>
					<td style="text-align:center" rowspan="2" width="50" nowrap><spring:message code='LABEL.F.F01.0005'/><!-- Others --></td>
					<%
						}
						if (Integer.parseInt(total.EMPSUM) > 0) {
					%>
					<td style="text-align:center" rowspan="2" width="50" >&nbsp;&nbsp;<spring:message code='LABEL.F.F01.0043'/><!-- EMP. -->&nbsp;<br>&nbsp;<spring:message code='LABEL.F.F04.0002'/><!-- SUM -->&nbsp;&nbsp;</td>
					<%
						}
					%>
					  <td style="text-align:center" rowspan="2" width="50" ><spring:message code='LABEL.F.F01.0006'/><!-- TOTAL --></td>
					</tr>
					<tr>
					  	<%
					 		if (Integer.parseInt(total.JIKEXP_KR) > 0) {
					 	%>
						<td width="70" style="text-align:center" nowrap>KR</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKEXP_PR) > 0) {
					 	%>
					 	<td width="70" style="text-align:center" nowrap>Partner</td>
					 	<%
					       }
							if (Integer.parseInt(total.JIKEXEC) > 0) {
					   	%>
					 	<td width="70" style="text-align:center">EXEC.</td>
					 	<%
							}
					 		if (Integer.parseInt(total.JIKCN04) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">I</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN05) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">II-1</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN06) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">II-2</td>
						<%
							}
							if (Integer.parseInt(total.JIKCN07) > 0) {
						%>
					 	<td width="70" style="text-align:center">III</td>
					 	<%
							}
							if (Integer.parseInt(total.JIKCN08) > 0) {
						%>
					 	<td width="70" style="text-align:center">III-1</td>
					 	<%
							}
							if (Integer.parseInt(total.JIKCN09) > 0) {
						%>
					 	<td width="70" style="text-align:center">III-2</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN10) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">IV-1</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN11) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">IV-1.A</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN12) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">IV-1.B</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN13) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">IV-2</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN14) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">IV-3</td>
					 	<!--[CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  START -->
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN23) > 0) {
	                    %>
	                    <td width="70" style="text-align:center">L1</td>
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN22) > 0) {
	                    %>
	                    <td width="70" style="text-align:center">L2</td>
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN21) > 0) {
	                    %>
	                    <td width="70" style="text-align:center">L3</td>
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN24) > 0) {
	                    %>
	                    <td width="70" style="text-align:center">OTHERS</td>
	                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  END -->
					 	<%
					 		}
					 		if (Integer.parseInt(total.SUBTOL1) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">SUM</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN15) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">J1</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN18) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">J2</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN16) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">J1-1</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN17) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">J1-2</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN19) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">J2-1</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.JIKCN20) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">J2-2</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.SUBTOL2) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">SUM</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.INTERN1) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">O/W</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.INTERN2) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">P/O</td>
					 	<%
					 		}
					 		if (Integer.parseInt(total.SUBTOL3) > 0) {
					 	%>
					 	<td width="70" style="text-align:center">SUM</td>
					 	<%
					 		}
					 	%>
					</tr>

			        <%
			        	String tmp = "";
			        	String tmpCode = "";
			        	for (int i = 0 ; i < F01DeptPositionClassTitle_vt.size() ; i ++) {
			        		F01DeptPositionClassTitleGlobalData entity = (F01DeptPositionClassTitleGlobalData)F01DeptPositionClassTitle_vt.get(i);
			      	%>
        			<tr>
			        	<%
			        		if (!tmpCode.equals(entity.ORGEH) || !tmp.equals(entity.ORGTX) || entity.ORGTX.equals("")) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>" rowspan="<%= meta.get(entity.ORGTX + entity.ORGEH) == null ? "0" : meta.get(entity.ORGTX) %>" nowrap style='text-align:<%= entity.ORGTX.equals("TOTAL")?"center":"left" %>'>
			        	<%
			        		if (!entity.ZLEVEL.equals(""))
			        			for (int j = 0 ; j < Integer.parseInt(entity.ZLEVEL) ; j ++) {
									out.println("&nbsp;");
								}
			        	%>
			        	<%= entity.ORGTX %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKEXP_KR) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKEXP_KR) %>
			        	</td>
			 			<%
			 				}
			        		if (Integer.parseInt(total.JIKEXP_PR) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>" >
			        	<%= WebUtil.printNumFormat(entity.JIKEXP_PR) %>
			 			<%
			 				}
			          		if (Integer.parseInt(total.JIKEXEC) > 0) {
			          	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKEXEC) %>
			        	</td>
			          	<%
			          		}
			          		if (Integer.parseInt(total.JIKCN04) > 0) {
			          	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN04) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN05) > 0 ) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN05) %>
			        	</td>
						<%
							}
							if (Integer.parseInt(total.JIKCN06) > 0 ) {
						%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN06) %>
			        	</td>
						<%
							}
							if (Integer.parseInt(total.JIKCN07) > 0) {
						%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN07) %>
			        	</td>
			        	<%
							}
							if (Integer.parseInt(total.JIKCN08) > 0) {
						%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN08) %>
			        	</td>
			        	<%
							}
							if (Integer.parseInt(total.JIKCN09) > 0) {
						%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN09) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN10) > 0) {
			        	%>
			        	<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN10) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN11) > 0) {
			        	%>
			        	<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN11) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN12) > 0) {
			        	%>
			        	<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN12) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN13) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05"%>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN13) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN14) > 0 ) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN14) %>
			        	</td>
			        	<!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  START -->
						<%
	                        }
	                        if (Integer.parseInt(total.JIKCN23) > 0 ) {
	                    %>
	                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
	                    <%= WebUtil.printNumFormat(entity.JIKCN23) %>
	                    </td>
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN22) > 0 ) {
	                    %>
	                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
	                    <%= WebUtil.printNumFormat(entity.JIKCN22) %>
	                    </td>
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN21) > 0 ) {
	                    %>
	                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
	                    <%= WebUtil.printNumFormat(entity.JIKCN21) %>
	                    </td>
	                    <%
	                        }
	                        if (Integer.parseInt(total.JIKCN24) > 0 ) {
	                    %>
	                    <td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
	                    <%= WebUtil.printNumFormat(entity.JIKCN24) %>
	                    </td>
	                    <!-- [CSR ID:3637301] 해외 ERP 사무직 직급(L!/L2/L3) 추가 요청  END -->
			        	<%
			        		}
			        		if (Integer.parseInt(total.SUBTOL1) > 0 ) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.SUBTOL1) %>
			        	</td>
						<%
							}
							if (Integer.parseInt(total.JIKCN15) > 0) {
						%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN15) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN18) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN18) %><!-- 20170810 오류 수정 -->
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.JIKCN16) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN16) %>
			        	</td>
						<%
							}
							if (Integer.parseInt(total.JIKCN17) > 0) {
						%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN17) %>
			        	</td>
			        	<%
				        	}
				        	if (Integer.parseInt(total.JIKCN19) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN19) %>
			        	</td>
			        	<%
				        	}
				        	if (Integer.parseInt(total.JIKCN20) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKCN20) %>
			        	</td>
			        	<%
				        	}
				        	if (Integer.parseInt(total.SUBTOL2) > 0) {
			        	%>
			        	<td class="<%=entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%=WebUtil.printNumFormat(entity.SUBTOL2) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.INTERN1) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.INTERN1) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.INTERN2) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.INTERN2) %>
			        	</td>
			        	<%
			        		}
							if (Integer.parseInt(total.SUBTOL3) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.SUBTOL3) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.OTHRS) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.OTHRS) %>
			        	</td>
			        	<%
			        		}
			        		if (Integer.parseInt(total.EMPSUM) > 0) {
			        	%>
			        	<td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.EMPSUM) %>
			        	</td>
			        	<%
			        		}
			        	%><td class="<%= entity.ORGTX.equals("TOTAL")?"td11":"td05" %>">
			        	<%= WebUtil.printNumFormat(entity.JIKTOL) %>
			        	</td>
					</tr>
			        <%
				      	tmp = entity.ORGTX;
				      	tmpCode = entity.ORGEH;
						}
			        %>
        	</table>
    	</td>
    	<td width="16">&nbsp;</td>
  	</tr>
	<tr>
		<td height="16"></td>
	</tr>
</table>

<%
    } else {
%>
<table width="780" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td  class="td04" align="center" height="25" ><spring:message code='MSG.F.FCOMMON.0002'/><!-- There is no data that match. --></td>
  </tr>
</table>
<%
    } //end if.
%>
</form>
</body>
</html>
