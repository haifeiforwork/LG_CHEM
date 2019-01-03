<%/******************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalCard_m.jsp                                       */
/*   Description  : 인사기록부 조회                                             */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-17  윤정현                                          */
/*   Update       :                                                             */
/*   Update       : C20130611_47348 징계기간추가                                */
/*                  2013-08-21 [CSR ID:2389767] [정보보안] e-HR MSS시스템 수정    */
/*                  2014-02-07 C20140204_80557  어학 이라는 표현을  외국어 로 변경*/
/*                  2017-07-10 [CSR ID:3428773] 인사기록부 수정 요청            */
/*                  2017/07/13 eunha    [CSR ID:3475164] 인사기록부 수정 요청                           */
/********************************************************************************/%>

<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="self" tagdir="/WEB-INF/tags/A/A01SelfDetail" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" uri="http://www.lgchemhr.com/taglibs/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="language" tagdir="/WEB-INF/tags/C/C05" %>
<%@ taglib prefix="valudte" tagdir="/WEB-INF/tags/B/B01ValuateDetail" %>
<%--@elvariable id="pageConfig" type="hris.A.PersonalCardInterfaceMainData"--%>
<tags:layout >
	<style>
		/* !*   @media print {
                body { font-size: xx-small }
            }*!
            body {font: 12px/1.5em "Malgun Gothic", "Simsun", dotum, arial, sans-serif; color: #222; width:100%; margin-bottom:20px; font-size: x-small}
            .subWrapper{
                min-width: 100%;
            }

            .tableGeneral th {
                height: 20px;
                text-align: right;
                padding-right: 10px;
                border-right: 1px solid #dddddd;
                border-bottom: 1px solid #dddddd;
                background: #f5f5f5;
                vertical-align: middle;
                font-weight: bold;
            }
            table{
                table-layout: fixed;
            }
            .listTable .oddRow {
                height: 20px;
                background-color: #f5f5f5;
            }
            .listTable .oddRow {
                height: 20px;
            }
            .listTable th {
                height: 20px;
            }
            .listTable td {
                height: 20px;
                white-space:nowrap;
                text-overflow:ellipsis;		!* IE, Safari *!
                -o-text-overflow:ellipsis;		!* Opera under 10.7 *!
                overflow:hidden;			!* "overflow" value must be different from "visible" *!
                -moz-binding: url('ellipsis.xml#ellipsis');
            }
            .tableArea {
                padding: 0 0 10px 0;
            }
            .listArea {
                margin: 0 0 10px 0;
            }*/
		.insaPadding {margin:0 25px 20px 15px;}
		div.pageBreak {
			page-break-before: always;
		}

		div.printPageTitle {
			display:none;
		}
		div.printPageHeader {
			display:none;
		}

	</style>
	<tags:script>
		<script>

            $(function() {
            	 // 2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청    start
 				<c:if test='${user.area == "KR" and fn:substringBefore(resultData.VGLST,"/") =="L3"}'>
 				parent.prt.document.getElementById("yearView").style.display = "";
 				</c:if>
            	 // 2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청    end
            });

            function insaPrint() {
                window.frames["insa_hiddenFrame"].$("#insaLayout").html($("#insaLayout").html());
                window.frames["insa_hiddenFrame"].focus();
                window.frames["insa_hiddenFrame"].print();
            }

           // 2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청    start
            function insaPrint(viewYn) {
                window.frames["insa_hiddenFrame"].$("#insaLayout").html($("#insaLayout").html());

              <c:if test="${user.area == 'KR'}">
                if (viewYn =="N") {
	                <c:if test='${fn:substringBefore(resultData.VGLST,"/") =="L3"}'>
	                	window.frames["insa_hiddenFrame"].$("#VGLST").html('${fn:substringBefore(resultData.VGLST,"/")}');
					</c:if>
                	<c:forEach var="row" items="${appointList}" varStatus="status">
                		<c:if test='${fn:substringBefore(row.VGLST,"/") =="L3"}'>
                			window.frames["insa_hiddenFrame"].$("#aVGLST${status.index}").html('${fn:substringBefore(row.VGLST,"/")}');
						</c:if>
                	</c:forEach>
                }
               </c:if>
                window.frames["insa_hiddenFrame"].focus();
                window.frames["insa_hiddenFrame"].print();
            }
         // 2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청    end

            function click() {

                //if (event.button==2||event.button==0) {
                if (event.button==2||event.keyCode==17||event.keyCode==45) {
                    alert('<spring:message code="MSG.A.A01.0081" />');  //버튼을 사용할수 없습니다.
                    return false;
                }
                return false;
            }

            function keypressed() {
//alert("event.keyCode:"+event.keyCode)
                if (event.button==2||event.keyCode==17||event.keyCode==45) {

                    bod.style.display = "none";
                    alert('<spring:message code="MSG.A.A01.0082" />');  //키를 사용할 수 없습니다.
                    return false;
                }
            }

            document.onkeypress=click;
            document.oncontextmenu=keypressed;
            document.onmousedown=click;
            document.onkeydown=click;
            function ClipBoardClear(){     if(window.clipboardData) clipboardData.clearData();    }    //[CSR ID:2389767] [정보보안] e-HR MSS시스템 수정

		</script>
	</tags:script>

	<div id="insaLayout" class="insaPadding">
			<%--
                ○ 학력 : 5개
                ○ 어학 : 3개
                ○ 자격면허 : 3개
                ○ 경력사항 : 3개
                ○ 평가사항 : 6개
                ○ 발령사항 : 29개
                ○ 해외경험 : 4개
                ○ 핵심인재 : 5개
                ○ 교육이력 : 15개
                ○ 포상 : 4개
                ○ 징계 : 3개
                [KR특화]
                ○ 주소 및 신상 : 6개
                ○ 가족사항 : 10개
                ○ 병역사항 : 3개
                --%>
		<c:set var="schoolLimit" value="5"/>
		<c:set var="langLimit" value="3"/>
		<c:set var="licenseLimit" value="3"/>
		<c:set var="careerLimit" value="3"/>
		<c:set var="valudteLimit" value="6"/>
		<c:set var="appointLimit" value="29"/>
		<c:set var="tripLimit" value="4"/>
		<c:set var="talentLimit" value="5"/>

		<c:set var="trainingLimit" value="19"/>
		<c:set var="prizeLimit" value="4"/>
		<c:set var="punishLimit" value="3"/>

		<c:if test="${user.area == 'KR'}">
			<c:set var="addressLimit" value="6"/>
			<c:set var="familyLimit" value="10"/>
			<c:set var="armyLimit" value="3"/>
		</c:if>
		<c:if test="${user.area == 'CN' || user.area == 'HK' || user.area == 'TW'}">
			<c:set var="familyLimit" value="10"/>
		</c:if>

		<c:if test="${pageConfig.PCH1 == 'X'}">
			<div class="printPageTitle"><spring:message code="MSG.A.MSS.CARD.001"/><%--인사기록부 (Ⅰ)--%></div>
			<%--<div class="listArea">
                <div class="table"></div>
            </div>--%>

			<self:self-card-page-header resultData="${resultData}" hideHeader="true"/>
			<%-- 인사 기록부 헤더부분 --%>
			<self:self-header personData="${resultData}" />

			<%-- 학력 --%>
			<self:self-school schoolList="${schoolList}" limit="${schoolLimit}" limitBlank="true"/>

			<%-- 어학 --%>
			<c:choose>
				<c:when test="${user.area == 'KR'}">
					<h2 class="subtitle"><spring:message code="MSG.C.C05.0001" /><%--어학능력--%></h2>
					<div class="listArea">
						<div class="table">
							<table class="listTable">
								<colgroup>
									<col width="120" />
									<col width="80" />
									<col width="60" />
									<col width="60" />
									<col  />
								</colgroup>
								<thead>
								<tr>
									<th><spring:message code="MSG.A.A01.055" /><%--어학유형--%></th>
									<th><spring:message code="MSG.C.C05.0006" /><%--검정일--%></th>
									<th><spring:message code="MSG.C.C05.0027" /><%--점수--%></th>
									<th><spring:message code="MSG.A.A01.0072" /><%--등급--%></th>
									<th class="lastCol"><spring:message code="MSG.A.A01.056" /><%--항목별 점수--%></th>
								</tr>
								</thead>
								<c:forEach begin="0" varStatus="status" end="${langLimit - 1}">
									<c:set var="row" value="${langList[status.index]}" />
									<tr class="${f:printOddRow(status.index)}">
										<td>${row.STEXT}</td>
										<td>${f:printDate(row.BEGDA)}</td>
										<td>${row.ZTOTL_SCOR}</td>
										<td>${row.LANG_LEVL}</td>
										<td class="lastCol">${row.FLDSCR}</td>
									</tr>
								</c:forEach>
									<%--<tags:table-row-nodata list="${langList}" col="5" />--%>
							</table>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<language:language-layout-GLOBAL limit="${langLimit}" limitBlank="true"/>
				</c:otherwise>
			</c:choose>

			<%-- 자격 면허 --%>
			<self:self-license licenseList="${licenseList}" limit="${licenseLimit}" limitBlank="true" />

			<%--경력사항--%>
			<self:self-career careerList="${resultList}" limit="${careerLimit}" limitBlank="true"/>

			<%-- 평가 --%>
			<c:if test="${check_A01 == 'Y'}">
				<c:if test="${evalSuffix == 'KR'}">
					<%-- 재작성 --%>
					<h2 class="subtitle"><spring:message code="MSG.B.B01.0036" /><%--평가사항--%></h2>
					<div class="listArea">
						<div class="table">
							<table class="listTable">
								<colgroup>
									<col width="60">
									<col>
									<col width="60">
									<col width="50">
									<col width="50">

									<col width="70">
									<col width="60">
									<col width="60">
								</colgroup>
								<thead>
								<tr>
									<th><spring:message code="MSG.B.B01.0037" /><%--년도--%></th>
									<th><spring:message code="MSG.B.B01.0038" /><%--소속--%></th>
									<th><spring:message code="MSG.B.B01.0062" /><%--업적평가--%></th>
									<th><spring:message code="MSG.B.B01.0045" /><%--능력--%></th>
									<th><spring:message code="MSG.B.B01.0046" /><%--태도--%></th>

									<th><spring:message code="MSG.B.B01.0044" /><%--HR Index--%></th>
									<th><spring:message code="MSG.B.B01.0063" /><%--절대평가--%></th>

									<th class="lastCol"><spring:message code="MSG.B.B01.0048" /><%--상대화--%></th>
								</tr>
								<thead>
									<%--@elvariable id="evalList" type="java.util.Vector<hris.B.B01ValuateDetailData>"--%>
								<c:forEach begin="0" varStatus="status" end="${valudteLimit - 1}">
									<c:set var="row" value="${evalList[status.index]}" />
								<tr class="${f:printOddRow(status.index)}">
									<td>${row.YEAR1}</td>
									<td>${row.ORGTX}</td>
									<td>${f:defaultIfZero(row.RATING4,  "")}</td>
									<td>${f:defaultIfZero(row.RATING1,  "")}</td>
									<td>${f:defaultIfZero(row.RATING2,  "")}</td>
									<td>${f:defaultIfZero(row.RATING12, "")}</td>
									<td>${row.TOTL }</td>
									<td class="lastCol">${row.RTEXT1 }</td>
								</tr>
								</c:forEach>
									<%--<tags:table-row-nodata list="${langList}" col="5" />--%>
							</table>
						</div>
					</div>
				</c:if>

				<c:if test="${evalSuffix == 'EU'}">
					<valudte:valuate-list-EU limit="${valudteLimit}" limitBlank="true"/>
				</c:if>

				<c:if test="${evalSuffix == 'GLOBAL'}">
					<valudte:valuate-list-GLOBAL limit="${valudteLimit}" limitBlank="true" />
				</c:if>
			</c:if>

			<div class="pageBreak"></div>
		</c:if>
		<c:if test="${pageConfig.PCH2 == 'X'}">
			<div class="printPageTitle"><spring:message code="MSG.A.MSS.CARD.002"/><%--인사기록부 (Ⅰ)--%></div>
			<self:self-card-page-header resultData="${resultData}" />


			<%-- 발령 --%>
			<h2 class="subtitle"><spring:message code="MSG.A.A05.0001" /><%--발령사항--%></h2>

			<!-- 발령사항 리스트 테이블 시작-->
			<div class="listArea">
				<div class="table">
					<c:choose>
						<c:when test="${user.area == 'KR'}">
							<table class="listTable">
								<colgroup>
									<col width="100">
									<col width="70">
									<col >
									<col width="70">
									<col width="70">
									<col width="70">
									<col width="70">
									<col width="70">
									<col width="70">
								</colgroup>
								<thead>
								<tr>
									<th><spring:message code="MSG.A.A05.0002" /><%--발령유형--%></th>
									<th><spring:message code="MSG.A.A05.0003" /><%--발령일자--%></th>
									<th><spring:message code="MSG.A.A05.0005" /><%--소속--%></th>

									<th><spring:message code="MSG.B.B01.0039" /><%--직급--%></th>
									<!-- [CSR ID:3428773]
									<th><spring:message code="MSG.A.A05.0007" /><%--직위--%></th>  -->
									<th><spring:message code="MSG.A.A01.0084" /><%--직위/직급호칭--%></th>
									<th><spring:message code="MSG.A.A05.0009" /><%--직책--%></th>
									<th><spring:message code="MSG.A.A05.0010" /><%--직무--%></th>
									<th><spring:message code="MSG.A.A05.0013" /><%--승급일자--%></th>
									<th class="lastCol"><spring:message code="MSG.A.A01.0019" /><%--급호--%></th>
								</tr>
								</thead>
								<tbody>
									<%--@elvariable id="appointList" type="java.util.Vector<hris.A.A05AppointDetail1Data>"--%>
								<c:forEach begin="0" varStatus="status" end="${appointLimit - 1}">
									<c:set var="row" value="${appointList[status.index]}" />
									<tr class="${status.index % 2 == 0 ? 'oddRow' : ''}">
										<td>${row.MNTXT}</td>
										<td>${f:printDate(row.BEGDA)}</td>
										<td>${row.ORGTX}</td>

										<td>${row.TRFGR}</td>
										<td>${row.JIKWT}</td>
										<td>${row.JIKKT}</td>
										<td>${row.STLTX}</td>

										<td>${f:printDate(row.SBEGDA)}</td>
										<%--  2017/07/13 eunha   [CSR ID:3475164] 인사기록부 수정 요청(id값추가) --%>
										<td class="lastCol" id="aVGLST${status.index}">${row.VGLST}</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</c:when>
						<c:otherwise>
							<table class="listTable">
								<colgroup>
									<col width="120">
									<col width="80">
									<col >
									<col width="100">
									<col width="100">
									<col width="120">
									<col >
								</colgroup>
								<thead>
								<tr>
									<th ><spring:message code="MSG.A.A05.0002" /><%--발령유형--%></th>
									<th ><spring:message code="MSG.A.A05.0003" /><%--발령일자--%></th>
									<th ><spring:message code="MSG.A.A05.0005" /><%--소속--%></th>
									<th><spring:message code="MSG.A.A05.0007" /><%--직위--%></th>
									<th ><spring:message code="MSG.A.A05.0008" /><%--직급/연차--%></th>
									<th><spring:message code="MSG.A.A05.0009" /><%--직책--%></th>
									<th class="lastCol"><spring:message code="MSG.A.A05.0010" /><!-- 직무 --></th>
								</tr>
								</thead>
								<tbody>
									<%--@elvariable id="appointList" type="java.util.Vector<hris.A.A05AppointDetail1Data>"--%>
								<c:forEach begin="0" varStatus="status" end="${appointLimit - 1}">
									<c:set var="row" value="${appointList[status.index]}" />
									<tr class="${status.index % 2 == 0 ? 'oddRow' : ''}">
										<td>${row.MNTXT}</td>
										<td>${f:printDate(row.BEGDA)}</td>
										<td>${row.ORGTX}</td>
										<td>
												${row.JIKWT}
											<c:if test="${not empty row.KEEP_TITL2}"><br>(${row.KEEP_TITL2})</c:if>
										</td>
										<td  id = "aVGLST${status.index}"  >${row.VGLST}</td>
										<td>${row.JIKKT}</td>
										<td class="lastCol">${row.STLTX}</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<!-- 발령사항 리스트 테이블 끝-->

			<%--승급--%>
			<%--<c:if test="${user.area == 'KR'}">
                <self:self-promotion />
            </c:if>--%>

			<%-- 해외경험 --%>
			<self:self-trip limit="${tripLimit}" limitBlank="true"/>

			<div class="pageBreak"></div>
		</c:if>
		<c:if test="${pageConfig.PCH3 == 'X'}">
			<div class="printPageTitle"><spring:message code="MSG.A.MSS.CARD.003"/><%--인사기록부 (Ⅰ)--%></div>
			<self:self-card-page-header resultData="${resultData}" />
			<%-- 핵심인재 --%>
			<self:self-talent limit="${talentLimit}" limitBlank="true"/>

			<%-- 교육 이력 --%>
			<h2 class="subtitle"><spring:message code="TITLE.C.C03.MSS" /><%--교육이력--%></h2>

			<div class="listArea">
				<div class="table">
					<table id="-training-table" class="listTable tablesorter" >
						<colgroup>
							<col width="120"/>
							<col />
							<col width="160"/>
							<col width=""/>
							<%--<col width="60"/>
							<col width="80"/>--%>
						</colgroup>
						<thead>
						<tr>
							<th><spring:message code="LABEL.C.C03.0015"/><%--분야--%></th>
							<th><spring:message code="LABEL.C.C03.0003"/><%--과정명--%></th>
							<th><spring:message code="LABEL.C.C03.0004"/><%--교육기간--%></th>
							<th class="lastCol"><spring:message code="LABEL.C.C03.0005"/><%--주관부서--%></th>
							<%--<th><spring:message code="LABEL.C.C03.0007"/></th>	--%><%--평가--%>
							<%--<th class="lastCol"><spring:message code="LABEL.C.C03.0008"/></th>--%><%--필수과정--%>
						</tr>
						</thead>
						<tbody id="-training-tbody">
							<%--@elvariable id="training" type="java.util.Vector<hris.C.C03LearnDetailData>"--%>
						<c:forEach begin="0" varStatus="status" end="${trainingLimit - 1}">
							<c:set var="row" value="${training[status.index]}" />
							<tr class="${f:printOddRow(status.index)}">
								<td>${row.LVSTX}</td>
								<td>${row.DVSTX}</td>
								<td>${row.PERIOD}</td>
								<td class="lastCol">${row.TESTX}</td>
								<%--<td>${f:parseFloat(row.TASTX) == 0 ? "" : row.TASTX}</td>
								<td class="lastCol">${row.ATTXT}</td>--%>
							</tr>
						</c:forEach>
							<%--<tags:table-row-nodata list="${training}" col="7" />--%>
						</tbody>
					</table>
						<%--<script>
                            $(function() {
                                rowspan("-training-tbody", 1, ${fn:length(training)});
                            });

                        </script>--%>
				</div>
			</div>

			<%-- 포상 / 징계 --%>
			<c:choose>
				<c:when test="${user.area == 'KR'}">

					<h2 class="subtitle"><spring:message code="MSG.A.A06.0001"/><%--포상--%></h2>

					<!-- 포상내역 리스트 테이블 시작-->
					<div class="listArea">
						<div class="table">
							<table class="listTable">
								<colgroup>
									<col>
									<col width="80">
									<col width="80">
									<col >
										<%--<col width="110">--%>
									<col >
								</colgroup>
								<thead>
								<tr>
									<th><spring:message code="MSG.A.A06.0002"/><%--포상항목 - 등급--%></th>
									<th><spring:message code="MSG.A.A06.0003"/><%--수상일자--%></th>
									<th><spring:message code="MSG.A.A06.0004"/><%--포상점수--%></th>
									<th><spring:message code="MSG.A.A06.0005"/><%--시상주체--%></th>
										<%--<th><spring:message code="MSG.A.A06.0006"/>&lt;%&ndash;포상금액&ndash;%&gt;</th>--%>
									<th class="lastCol"><spring:message code="MSG.A.A06.0007"/><%--수상내역--%></th>
								</tr>
								</thead>
								<c:forEach begin="0" varStatus="status" end="${prizeLimit - 1}">
									<c:set var="row" value="${prizeList[status.index]}" />
									<c:set var="amt" value="${f:changeLocalAmount(data.PRIZ_AMNT, user.area)}"/>
									<tr class="${f:printOddRow(status.index)}">
										<td>${row.PRIZ_DESC}${row.GRAD_TEXT}</td>
										<td>${f:printDate(row.BEGDA)}</td>
										<td>${row.GRAD_QNTY }</td>
										<td>${row.BODY_NAME }</td>
											<%--<td style="text-align:right">${amt} ${empty amt ? "" : "원"}</td>--%>
										<td class="lastCol " >${row.PRIZ_RESN }</td>
									</tr>
								</c:forEach>
									<%--<tags:table-row-nodata list="${prizeList}" col="6" />--%>
							</table>
						</div>
					</div>
					<%-- 징계 --%>
					<self:self-punish punishList="${punishList}" limit="${punishLimit}" limitBlank="true"/>

				</c:when>
				<c:otherwise>
					<self:self-prize-GLOBAL limit="${prizeLimit}" limitBlank="true"/>
					<self:self-punish-GLOBAL limit="${punishLimit}" limitBlank="true"/>
				</c:otherwise>
			</c:choose>
		</c:if>
		<c:if test="${pageConfig.PCH4 == 'X'}">
			<c:if test="${user.area == 'KR' || user.area == 'CN' || user.area == 'HK' || user.area == 'TW'}">
				<div class="pageBreak"></div>
				<div class="printPageTitle"><spring:message code="MSG.A.MSS.CARD.004"/><%--인사기록부 (Ⅰ)--%></div>
				<self:self-card-page-header resultData="${resultData}" />
			</c:if>

			<c:choose>
				<c:when test="${user.area == 'KR'}">

					<%-- 주소 및 신상 --%>
					<self:self-personal-address personalData="${personalData}" />

					<%-- 가족사항 --%>
					<self:self-family-mss-kr familyList="${familyList}" limit="${familyLimit}" limitBlank="true"/>

					<%-- 병역 --%>
					<self:self-army extraData="${armyData}" />
				</c:when>
				<c:otherwise>

					<%-- 추가 개인데이타 --%>
					<%--<self:self-extra-data extraData="${extraData}" />--%>

				</c:otherwise>
			</c:choose>
			<%-- 긴급 연락처 --%>
			<c:if test="${user.area == 'US'}">
				<self:self-emergency />
			</c:if>
			<%-- 가족사항 --%>
			<c:if test="${user.area == 'CN' || user.area == 'HK' || user.area == 'TW'}">
				<self:self-family-mss-cn familyList="${familyList}" limit="${familyLimit}" limitBlank="true"/>
			</c:if>
		</c:if>
	</div>

	<iframe id="insa_hiddenFrame" name="insa_hiddenFrame" src="/web/A/A01PersonalCardPrintIframe_m.jsp" width="0" height="0" style="top: -99999px" frameborder="0"> ></iframe>
</tags:layout>

