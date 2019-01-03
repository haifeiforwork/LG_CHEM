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
/*                             */
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


<c:set var="user" value="<%=WebUtil.getSessionUser(request) %>"/>

<tags:layout >
	<style>
		/*   @media print {
               body { font-size: xx-small }
           }*/
		body {font: 12px/1.5em "Malgun Gothic", "Simsun", dotum, arial, sans-serif; color: black; width:100%; margin-bottom:20px; ${user.locale != 'ko' ? 'font-size: x-small' : ''}}
		.subWrapper{
			min-width: 100%;
		}
		/*.insaPadding {margin:0 25px 20px 15px;}*/
		.tableGeneral th {
			height: 20px;
			text-align: right;
			padding-right: 5px;
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
			height: 20px; padding-left: 0px; padding-right: 0px;
		}
		.listTable td {
			height: 20px;
			white-space:nowrap;
			text-overflow:ellipsis;		/* IE, Safari */
			-o-text-overflow:ellipsis;		/* Opera under 10.7 */
			overflow:hidden;			/* "overflow" value must be different from "visible" */
			-moz-binding: url('ellipsis.xml#ellipsis');
			padding-left: 0;
			padding-right: 0;
		}
		.tableArea {
			padding: 0 0 10px 0;
		}
		.listArea {
			margin: 0 0 10px 0;
		}
		div.pageBreak {
			page-break-before: always;
		}
		div.printPageTitle {
			text-align: center; font-weight: bold;font-size: large; margin-bottom: 5px;
		}

		.-small-font {font-size: x-small;}

		td.align_left {text-align: left; padding-left: 5px;}

		h2.subtitle {
			margin: 0 10px 0px 2px;
		}
	</style>
	<style type = "text/css">
		P.breakhere {page-break-before: always}
	</style>
	<div id="insaLayout" class="insaPadding">

	</div>

</tags:layout>

