<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 동호회가입현황(간사용)                                      */
/*   Program Name : 동호회가입현황(간사용)                                      */
/*   Program ID   : E31InfoStatusAll.jsp                                        */
/*   Description  : 동호회가입현황(간사용)                                      */
/*   Note         : 없음                                                        */
/*   Creation     :                                                             */
/*   Update       : 2005-01-31  윤정현                                          */
/*                                                                              */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.Vector" %>
<%@ page import="hris.E.E31InfoStatus.*" %>

<%
    Vector E31InfoMemberData_vt = (Vector)request.getAttribute("E31InfoMemberData_vt");
    String YEAR  = (String)request.getAttribute("YEAR");
    String MONTH = (String)request.getAttribute("MONTH");
    String MGART = (String)request.getAttribute("MGART");
    String INFTY = (String)request.getAttribute("INFTY");
    String STEXT = (String)request.getAttribute("STEXT");

    String cur_year  = DataUtil.getCurrentYear() ;  // 년
    String cur_month = DataUtil.getCurrentMonth();  // 월
    cur_month = DataUtil.fixEndZero(cur_month,2);
%>

<jsp:include page="/include/header.jsp" />
<script language="JavaScript">
<!--
function excelDown() {
    document.form1.jobid.value = "exceldown1";
    document.form1.action = "<%= WebUtil.ServletURL %>hris.E.E31InfoStatus.E31InfoStatusListSV";
    document.form1.target = "hidden";
    document.form1.method = "post";
    document.form1.submit();
}


//-->
</script>
    <jsp:include page="/include/body-header.jsp">
        <jsp:param name="click" value="Y"/>
        <jsp:param name="always" value="true"/>
    </jsp:include>
<form name="form1">


	<div class="listArea">
		<div class="listTop">
			<span class="listCnt"><%= E31InfoMemberData_vt == null ? 0 : E31InfoMemberData_vt.size() %>&nbsp;<!-- 건 --><%=g.getMessage("LABEL.E.E13.0006")%>
<%
    if ( YEAR.equals(cur_year) && MONTH.equals(cur_month) ) {
%>
            	<span class="commentOne"><!--  탈퇴자 제외된 현재원 목록임. --><%=g.getMessage("LABEL.E.E13.0008")%></span>
            </span>
<%
    } else {
%>
			</span>
<%
    }
%>
			<div class="buttonArea">
				<ul class="btn_mdl">
					<li><a class="unloading" href="javascript:excelDown();"><span><spring:message code='LABEL.F.F31.0001'/><!-- Excel Download --></span></a></li>
				</ul>
			</div>
			<div class="clear"></div>
		</div>
<%
    // 전체 선택 후 조회시 ----------------------------------------------------------------
    if ( MGART == null || MGART.equals("") ) {
%>
		<div class="table">
	        <table class="listTable">
	         <thead>
	          <tr>
	            <th><!-- 소속부서 --><%=g.getMessage("LABEL.E.E16.0011")%></th>
	            <th><!-- 동호회 --><%=g.getMessage("LABEL.E.E26.0002")%></th>
	            <th><!-- 성명 --><%=g.getMessage("LABEL.E.E29.0001")%></th>
	            <th><!-- 회비 --><%=g.getMessage("LABEL.E.E13.0007")%></th>
	            <th class="lastCol"><!-- 가입일 --><%=g.getMessage("LABEL.E.E26.0001")%></th>
	          </tr>
	          </thead>
<%
        if( E31InfoMemberData_vt != null && E31InfoMemberData_vt.size() > 0 ) {
            for ( int i = 0 ; i < E31InfoMemberData_vt.size() ; i++ ) {
                E31InfoMemberData data = (E31InfoMemberData)E31InfoMemberData_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }

                double i_betrg = Double.parseDouble(data.BETRG) * 100;
%>
				<tr class="<%=tr_class%>">
					<td><%= data.ORGTX %></td>
					<td><%= data.STEXT %></td>
					<td><%= data.ENAME %></td>
					<td><%= WebUtil.printNumFormat(i_betrg, 0) %></td>
					<td class="lastCol"><%= WebUtil.printDate(data.BEGDA) %></td>
				</tr>
<%
            }
%>
			</table>
		</div>
	</div>
<%
        } else {
%>
				<tr class="oddRow">
					<td class="lastCol" colspan="5"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
				</tr>
			</table>
		</div>
	</div>

<%
        	}
    // 동호회 하나 선택 후 조회시 ----------------------------------------------------------------
    } else {
%>


		<div class="table">
        	<table class="listTable">
        	 <thead>
				<tr>
	            <th><!-- 소속부서 --><%=g.getMessage("LABEL.E.E16.0011")%></th>
	            <th><!-- 성명 --><%=g.getMessage("LABEL.E.E29.0001")%></th>
	            <th><!-- 회비 --><%=g.getMessage("LABEL.E.E13.0007")%></th>
	            <th class="lastCol"><!-- 가입일 --><%=g.getMessage("LABEL.E.E26.0001")%></th>
				</tr>
			  </thead>
<%
        if( E31InfoMemberData_vt != null && E31InfoMemberData_vt.size() > 0 ) {
            for ( int i = 0 ; i < E31InfoMemberData_vt.size() ; i++ ) {
                E31InfoMemberData data = (E31InfoMemberData)E31InfoMemberData_vt.get(i);

                String tr_class = "";

                if(i%2 == 0){
                    tr_class="oddRow";
                }else{
                    tr_class="";
                }

                double i_betrg = Double.parseDouble(data.BETRG) * 100;
%>
           <tr class="<%=tr_class%>">
            <td><%= data.ORGTX %></td>
            <td><%= data.ENAME %></td>
            <td><%= WebUtil.printNumFormat(i_betrg, 0) %></td>
            <td class="lastCol"><%= WebUtil.printDate(data.BEGDA)%></td>
          </tr>

<%
            }
%>
			</table>
		</div>
	</div>
<%
        } else {
%>
          <tr class="oddRow">
            <td class="lastCol" colspan="4"><!-- 해당하는 데이터가 존재하지 않습니다. --><%=g.getMessage("MSG.E.ECOMMON.0002")%></td>
          </tr>
        </table>
      </div>
    </div>
<%
        }
    }
%>
<input type="hidden" name="jobid" value="">
<input type="hidden" name="YEAR"  value="<%=YEAR%>">
<input type="hidden" name="MONTH" value="<%=MONTH%>">
<input type="hidden" name="MGART" value="<%=MGART%>">
<input type="hidden" name="INFTY" value="<%=INFTY%>">
<input type="hidden" name="STEXT" value="<%=STEXT%>">
</form>
<jsp:include page="/include/body-footer.jsp" /> <!-- body footer 부분 -->
<jsp:include page="/include/footer.jsp"/>       <!-- html footer 부분 -->