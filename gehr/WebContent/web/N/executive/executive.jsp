<%/******************************************************************************/
/*   System Name  :                                                          															*/
/*   1Depth Name  : 집행임원인사관리규정                                                 													 */
/*   Program ID   : executive.jsp                                          															 */
/*   Description  : 집행임원인사관리규정               																					 */
/*   Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha                         */
/********************************************************************************/%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Vector"%>
<%@ page import="hris.common.*"%>
<%@ include file="/web/common/commonProcess.jsp"%>

<jsp:include page="/include/header.jsp" />
<style type="text/css">
.winPop {
	overflow-y: hidden;
	overflow-x: hidden;
	width: 800px;
	height: 700px;
}
</style>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0"
	marginwidth="0" marginheight="0">

	<form name="form1" method="post">
		<div class="winPop">
			<div class="header">
				<span>퇴임 임원 협력사 취업 관련 신설 내규</span> <a
					href="javascript:window.close();"><img
					src="<%=WebUtil.ImageURL%>sshr/btn_popup_close.png" />
				</a>
			</div>
			<div class="body">
				<div>
					<p>
						<span style="padding: 5px">&nbsp;※퇴임 임원의 협력사 취업 관련 집행임원	인사관리 규정 신설 내규를</span> <br>
						<span style="padding: 15px">다음과 같이 안내 드리오니, 참조하여 주시기 바랍니다.</span>
					</p>
					<p>&nbsp</p>
					<p>
						<span style="padding: 5px">&nbsp;■퇴임 임원 협력사 취업 관련 신설 내규 내용</span>
					</p>
					<p>
						<span style="padding: 15px">&nbsp;① 퇴임 임원의 협력사¹ 취업은 원칙적으로
							금지함.</span> <br>
						<span style="padding: 15px">&nbsp;② 다만, 전략적으로 필요하다고 판단하는
							경우² 에 한해 인사, 정도경영, 구매</span> <br>
						<span style="padding: 30px">&nbsp;책임자 등으로 구성된 별도의 회의체를 통해
							심의 후 취업을 허용할 수 있음.</span>
					</p>
					<p>&nbsp</p>
					<p>
						<span style="padding: 25px">&nbsp;1) 협력사라 함은 해당 회사 제품의 25%
							이상을 자사에 납품하는 회사를 기준으로 하며, 자회사 및 관계사(희성, GS, LS)는 제외함.</span>
					</p>
					<p>
						<span style="padding: 25px">&nbsp;2) 예) 협력사 생산/기술 역량 향상,
							전략적으로 지분 투자한 협력사의 역량 향상 등</span>
					</p>
				</div>
				<p>&nbsp</p>
				<div class="buttonArea">
					<ul class="btn_crud">
						<li><a
							href="<%=WebUtil.ServletURL%>hris.N.executive.ExecutiveSV?jobid=download"><span>Download</span>
						</a>
						</li>
						<li><a href="javascript:window.close();"><span>닫기</span>
						</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</form>
	<jsp:include page="/include/body-footer.jsp" />
	<jsp:include page="/include/footer.jsp" />