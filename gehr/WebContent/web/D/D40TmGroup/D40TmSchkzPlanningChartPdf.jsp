<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정	-근무계획표 조회						*/
/*   Program Name	:   계획근무일정	-근무계획표 조회						*/
/*   Program ID		: D40TmSchkzPlanningChartPdf.jsp						*/
/*   Description		: 계획근무일정-근무계획표 조회							*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@page import="java.awt.Color"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Vector" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.io.*"%>
<%@ page import="java.io.FileOutputStream" %>

<%@ page import="com.itextpdf.text.*" %>
<%@ page import="com.itextpdf.tool.xml.*" %>
<%@ page import="com.itextpdf.tool.xml.css.*" %>
<%@ page import="com.itextpdf.tool.xml.html.*" %>
<%@ page import="com.itextpdf.tool.xml.parser.*" %>
<%@ page import="com.itextpdf.tool.xml.pipeline.css.*" %>
<%@ page import="com.itextpdf.tool.xml.pipeline.html.*" %>
<%@ page import="com.itextpdf.tool.xml.pipeline.end.*" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>
<%@ page import="com.lowagie.text.pdf.*" %>
<%@ page import="com.itextpdf.text.Font" %>
<%@ page import="com.itextpdf.text.Image" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="com.itextpdf.text.pdf.BaseFont" %>
<%@ page import="com.itextpdf.text.BaseColor" %>
<%@ page import="com.itextpdf.text.pdf.PdfPCell" %>
<%@ page import="com.itextpdf.text.pdf.PdfPTable" %>

<%@ page import="hris.common.*" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%

	WebUserData user = WebUtil.getSessionUser(request);

	String currentDate  = WebUtil.printDate(DataUtil.getCurrentDate(),".") ;  // 발행일자

	String E_INFO    = (String)request.getAttribute("E_INFO");
	Vector T_TPROG    = (Vector)request.getAttribute("T_TPROG");	//일일근무상세설명
	Vector T_EXPORTA    = (Vector)request.getAttribute("T_EXPORTA");	//근무계획표-TITLE
	Vector T_EXPORTB    = (Vector)request.getAttribute("T_EXPORTB");	//근무계획표-DATA

	if(T_EXPORTA.isEmpty()){
%>
		<script language="JavaScript">alert('<%=g.getMessage("MSG.COMMON.0004")%>');</script>
<%
	}else{

		ServletOutputStream sos = null;
		PdfWriter	writer = null;
		Document document = null;

		try{
			out.clear();
			out = pageContext.pushBody();
			response.reset(); // 이 문장이 없으면 excel 등의 파일에서 한글이 깨지는 문제 발생.

			// 기본 Document를 생성한다.
			document = new Document(PageSize.A4.rotate(), 5, 5, 5, 5); // 용지 및 여백 설정

			// PDF가 저장될 위치를 지정한다. C에 저장이 되도록 되어있어요
			sos = response.getOutputStream();
			writer = PdfWriter.getInstance(document, sos);

			String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0029"), "UTF-8"); // 파일명이 한글일 땐 인코딩 필요
			fileName = fileName.replaceAll("\\+", "%20");

			response.setContentType("application/pdf");
			response.setHeader("Set-Cookie", "fileDownload=true; path=/");
			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			response.setHeader("Content-Disposition", "inline; filename=" + fileName + ".pdf");
			response.setHeader("Content-Transfer-Encoding", "binary");

			document.open();

			//베이스 폰트로는 한글입력이 되지 않기 때문에 TTF 를 직접 지정합니다.
			String sfont = request.getSession().getServletContext().getRealPath("/web/images/css/font/MALGUN.TTF");
			BaseFont objBaseFont = BaseFont.createFont(sfont, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

			//타이들 객체를 생성한다
			Paragraph title = new Paragraph(E_INFO, new Font(objBaseFont, 12, Font.BOLD));
			title.setAlignment(Paragraph.ALIGN_LEFT); //정렬

			//구분라인을 표시하기 위하여 이미지를 이용합니다.
			Image image2 = Image.getInstance(request.getSession().getServletContext().getRealPath("/web/mail_img/blank.gif"));
			image2.setAlignment(Image.ALIGN_CENTER); // 가운데 정렬

			//Font 설정
			Font blackFont = new Font(objBaseFont, 7, Font.NORMAL);
			Font redFont = new Font(objBaseFont, 7, Font.NORMAL, BaseColor.RED);

			int titlSize = T_EXPORTA.size();

	        String tempDept = "";
	    	for( int j = 0; j < T_EXPORTB.size(); j++ ){
	    		D40TmSchkzPlanningChartNoteData deptData = (D40TmSchkzPlanningChartNoteData)T_EXPORTB.get(j);

	       		//하위부서를 선택했을 경우 부서 비교.
		        if( !deptData.ORGEH.equals(tempDept) ){

		        	Paragraph preface = new Paragraph();

		        	PdfPTable table = new PdfPTable(titlSize+2);
		        	table.setHorizontalAlignment(Element.ALIGN_LEFT);
			        table.setWidthPercentage(100);
					//table widths 설정
					if(titlSize == 1 ){table.setWidths(new int[]{120,120,80});}
					else if( titlSize == 2 ){table.setWidths(new int[]{120,120,80,80});}
					else if( titlSize == 3 ){table.setWidths(new int[]{120,120,80,80,80});}
					else if( titlSize == 4 ){table.setWidths(new int[]{120,120,80,80,80,80});}
					else if( titlSize == 5 ){table.setWidths(new int[]{120,120,80,80,80,80,80});}
					else if( titlSize == 6 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80});}
					else if( titlSize == 7 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80});}
					else if( titlSize == 8 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80});}
					else if( titlSize == 9 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 10 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 11 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 12 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 13 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 14 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 15 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 16 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 17 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 18 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 19 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 20 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 21 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 22 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 23 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 24 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 25 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 26 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 27 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
					else if( titlSize == 28 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
			        else if( titlSize == 29 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
		        	else if( titlSize == 30 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}
		        	else if( titlSize == 31 ){table.setWidths(new int[]{120,120,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80});}

					//부서명
					String subTitle = g.getMessage("LABEL.F.F41.0002")+ " : " +deptData.STEXT+ " [ "+deptData.ORGEH+" ]";
					Paragraph title2 = new Paragraph(subTitle , new Font(objBaseFont, 12));
					title2.setAlignment(Paragraph.ALIGN_LEFT); //정렬

					Paragraph title4 = new Paragraph(g.getMessage("LABEL.D.D40.0120") + " : "+currentDate , new Font(objBaseFont, 10));
					title4.setAlignment(Paragraph.ALIGN_RIGHT); //정렬

					// 테이블을 생성한다.
					PdfPCell c1 = new PdfPCell(new Paragraph( g.getMessage("LABEL.D.D05.0006"), new Font(objBaseFont, 9)));
					c1.setRowspan(2);
					c1.setHorizontalAlignment(Element.ALIGN_CENTER);
					c1.setFixedHeight(18f);
					table.addCell(c1);

					c1 = new PdfPCell(new Paragraph(g.getMessage("LABEL.D.D05.0005"), new Font(objBaseFont, 9)));
					c1.setRowspan(2);
					c1.setFixedHeight(18f);
					c1.setHorizontalAlignment(Element.ALIGN_CENTER);
					table.addCell(c1);

					List<String> arr = new ArrayList<String>();
					//날짜
					for( int h = 0; h < titlSize; h++ ){
						D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(h);

		                c1 = new PdfPCell(new Phrase(titleData.DD, new Font(objBaseFont, 9)));		//날짜
						//토 일 글자색 빨강
		                if (titleData.HOLIDAY.equals("Y")) {
	                    	c1.setBackgroundColor(new BaseColor(255,182,193));
	                    }
						//휴일 글자색 빨강
						if (titleData.HOLIDAY.equals("X")) {
							arr.add("T"+(h+1));	//휴일일때 배열에 담아둔다. 아래에 일일근무일정이 휴일인경우 글자색 바꾸기 위해서
	                    	c1.setBackgroundColor(new BaseColor(255,182,193));
	                    }
		                c1.setFixedHeight(18f);	//높이
		                c1.setHorizontalAlignment(Element.ALIGN_CENTER);	//가운데 정렬
						table.addCell(c1);

					}
					//요일
					for( int k = 0; k < titlSize; k++ ){
	                	D40TmSchkzPlanningChartData titleData = (D40TmSchkzPlanningChartData)T_EXPORTA.get(k);

	                	c1 = new PdfPCell(new Phrase(titleData.KURZT, new Font(objBaseFont, 9)));	//요일
	                	//토 일 글자색 빨강
	                	if (titleData.HOLIDAY.equals("Y")) {
	                    	c1.setBackgroundColor(new BaseColor(255,182,193));
	                    }
	                	//휴일 글자색 빨강
	                    if (titleData.HOLIDAY.equals("X")) {
	                    	c1.setBackgroundColor(new BaseColor(255,182,193));
	                    }
                    	c1.setFixedHeight(18f);
						c1.setHorizontalAlignment(Element.ALIGN_CENTER);
						table.addCell(c1);
					}
					//일일근무일정
					for( int i = j; i < T_EXPORTB.size(); i++ ){
	                	D40TmSchkzPlanningChartNoteData data = (D40TmSchkzPlanningChartNoteData)T_EXPORTB.get(i);

						if( data.ORGEH.equals(deptData.ORGEH) ){

							c1 = new PdfPCell(new Paragraph(data.ENAME, new Font(objBaseFont, 7)));
							c1.setHorizontalAlignment(Element.ALIGN_CENTER);
							table.addCell(c1);

							c1 = new PdfPCell(new Paragraph(data.PERNR, new Font(objBaseFont, 7)));
							c1.setHorizontalAlignment(Element.ALIGN_CENTER);
							table.addCell(c1);

							if( titlSize >= 1 ){
								//일일근무일정이 OFF 이거나 OFFH인 경우 빨강색으로
								c1 = new PdfPCell(new Paragraph(data.T1, ("OFF".equals(data.T1) || "OFFH".equals(data.T1))? redFont : blackFont));
								//배열에 담아둔 값과 비교해서 있으면 글자색 빵강으로
								if(arr.contains("T1")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);	//가운데 정렬
								table.addCell(c1);
							}
							if( titlSize >= 2 ){
								c1 = new PdfPCell(new Paragraph(data.T2, ("OFF".equals(data.T2) || "OFFH".equals(data.T2))? redFont : blackFont));
								if(arr.contains("T2")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 3 ){
								c1 = new PdfPCell(new Paragraph(data.T3, ("OFF".equals(data.T3) || "OFFH".equals(data.T3))? redFont : blackFont));
								if(arr.contains("T3")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 4 ){
								c1 = new PdfPCell(new Paragraph(data.T4, ("OFF".equals(data.T4) || "OFFH".equals(data.T4))? redFont : blackFont));
								if(arr.contains("T4")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 5 ){
								c1 = new PdfPCell(new Paragraph(data.T5, ("OFF".equals(data.T5) || "OFFH".equals(data.T5))? redFont : blackFont));
								if(arr.contains("T5")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 6 ){
								c1 = new PdfPCell(new Paragraph(data.T6, ("OFF".equals(data.T6) || "OFFH".equals(data.T6))? redFont : blackFont));
								if(arr.contains("T6")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 7 ){
								c1 = new PdfPCell(new Paragraph(data.T7, ("OFF".equals(data.T7) || "OFFH".equals(data.T7))? redFont : blackFont));
								if(arr.contains("T7")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 8 ){
								c1 = new PdfPCell(new Paragraph(data.T8, ("OFF".equals(data.T8) || "OFFH".equals(data.T8))? redFont : blackFont));
								if(arr.contains("T8")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 9 ){
								c1 = new PdfPCell(new Paragraph(data.T9, ("OFF".equals(data.T9) || "OFFH".equals(data.T9))? redFont : blackFont));
								if(arr.contains("T9")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 10 ){
								c1 = new PdfPCell(new Paragraph(data.T10, ("OFF".equals(data.T10) || "OFFH".equals(data.T10))? redFont : blackFont));
								if(arr.contains("T10")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 11 ){
								c1 = new PdfPCell(new Paragraph(data.T11, ("OFF".equals(data.T11) || "OFFH".equals(data.T11))? redFont : blackFont));
								if(arr.contains("T11")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 12 ){
								c1 = new PdfPCell(new Paragraph(data.T12, ("OFF".equals(data.T12) || "OFFH".equals(data.T12))? redFont : blackFont));
								if(arr.contains("T12")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 13 ){
								c1 = new PdfPCell(new Paragraph(data.T13, ("OFF".equals(data.T13) || "OFFH".equals(data.T13))? redFont : blackFont));
								if(arr.contains("T13")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 14 ){
								c1 = new PdfPCell(new Paragraph(data.T14, ("OFF".equals(data.T14) || "OFFH".equals(data.T14))? redFont : blackFont));
								if(arr.contains("T14")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 15 ){
								c1 = new PdfPCell(new Paragraph(data.T15, ("OFF".equals(data.T15) || "OFFH".equals(data.T15))? redFont : blackFont));
								if(arr.contains("T15")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 16 ){
								c1 = new PdfPCell(new Paragraph(data.T16, ("OFF".equals(data.T16) || "OFFH".equals(data.T16))? redFont : blackFont));
								if(arr.contains("T16")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 17 ){
								c1 = new PdfPCell(new Paragraph(data.T17, ("OFF".equals(data.T17) || "OFFH".equals(data.T17))? redFont : blackFont));
								if(arr.contains("T17")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 18 ){
								c1 = new PdfPCell(new Paragraph(data.T18, ("OFF".equals(data.T18) || "OFFH".equals(data.T18))? redFont : blackFont));
								if(arr.contains("T18")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 19 ){
								c1 = new PdfPCell(new Paragraph(data.T19, ("OFF".equals(data.T19) || "OFFH".equals(data.T19))? redFont : blackFont));
								if(arr.contains("T19")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 20 ){
								c1 = new PdfPCell(new Paragraph(data.T20, ("OFF".equals(data.T20) || "OFFH".equals(data.T20))? redFont : blackFont));
								if(arr.contains("T20")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 21 ){
								c1 = new PdfPCell(new Paragraph(data.T21, ("OFF".equals(data.T21) || "OFFH".equals(data.T21))? redFont : blackFont));
								if(arr.contains("T21")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 22 ){
								c1 = new PdfPCell(new Paragraph(data.T22, ("OFF".equals(data.T22) || "OFFH".equals(data.T22))? redFont : blackFont));
								if(arr.contains("T22")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 23 ){
								c1 = new PdfPCell(new Paragraph(data.T23, ("OFF".equals(data.T23) || "OFFH".equals(data.T23))? redFont : blackFont));
								if(arr.contains("T23")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 24 ){
								c1 = new PdfPCell(new Paragraph(data.T24, ("OFF".equals(data.T24) || "OFFH".equals(data.T24))? redFont : blackFont));
								if(arr.contains("T24")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 25 ){
								c1 = new PdfPCell(new Paragraph(data.T25, ("OFF".equals(data.T25) || "OFFH".equals(data.T25))? redFont : blackFont));
								if(arr.contains("T25")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 26 ){
								c1 = new PdfPCell(new Paragraph(data.T26, ("OFF".equals(data.T26) || "OFFH".equals(data.T26))? redFont : blackFont));
								if(arr.contains("T26")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 27 ){
								c1 = new PdfPCell(new Paragraph(data.T27, ("OFF".equals(data.T27) || "OFFH".equals(data.T27))? redFont : blackFont));
								if(arr.contains("T27")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 28 ){
								c1 = new PdfPCell(new Paragraph(data.T28, ("OFF".equals(data.T28) || "OFFH".equals(data.T28))? redFont : blackFont));
								if(arr.contains("T28")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 29 ){
								c1 = new PdfPCell(new Paragraph(data.T29, ("OFF".equals(data.T29) || "OFFH".equals(data.T29))? redFont : blackFont));
								if(arr.contains("T29")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 30 ){
								c1 = new PdfPCell(new Paragraph(data.T30, ("OFF".equals(data.T30) || "OFFH".equals(data.T30))? redFont : blackFont));
								if(arr.contains("T30")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}
							if( titlSize >= 31 ){
								c1 = new PdfPCell(new Paragraph(data.T31, ("OFF".equals(data.T31) || "OFFH".equals(data.T31))? redFont : blackFont));
								if(arr.contains("T31")){
									c1.setBackgroundColor(new BaseColor(255,182,193));
								}
								c1.setHorizontalAlignment(Element.ALIGN_CENTER);
								table.addCell(c1);
							}

						}
					}


					//부서명
					Paragraph title3 = new Paragraph(g.getMessage("LABEL.D.D40.0026") , new Font(objBaseFont, 12));
					title3.setAlignment(Paragraph.ALIGN_LEFT); //정렬

					// 테이블을 생성한다.
					PdfPTable table2 = new PdfPTable(6);

					table2.setHorizontalAlignment(Element.ALIGN_LEFT);
			        table2.setWidthPercentage(60);
			        table2.setWidths(new int[]{20,40,60,20,40,60});

					PdfPCell c2 = new PdfPCell(new Paragraph( g.getMessage("LABEL.D.D13.0004"), new Font(objBaseFont, 9)));
					c2.setHorizontalAlignment(Element.ALIGN_CENTER);
					c2.setFixedHeight(18f);
					table2.addCell(c2);

					c2 = new PdfPCell(new Paragraph(g.getMessage("LABEL.D.D40.0027"), new Font(objBaseFont, 9)));
					c2.setHorizontalAlignment(Element.ALIGN_CENTER);
					table2.addCell(c2);

					c2 = new PdfPCell(new Paragraph(g.getMessage("LABEL.D.D40.0028"), new Font(objBaseFont, 9)));
					c2.setHorizontalAlignment(Element.ALIGN_CENTER);
					table2.addCell(c2);

					c2 = new PdfPCell(new Paragraph(g.getMessage("LABEL.D.D13.0004"), new Font(objBaseFont, 9)));
					c2.setHorizontalAlignment(Element.ALIGN_CENTER);
					table2.addCell(c2);

					c2 = new PdfPCell(new Paragraph(g.getMessage("LABEL.D.D40.0027"), new Font(objBaseFont, 9)));
					c2.setHorizontalAlignment(Element.ALIGN_CENTER);
					table2.addCell(c2);

					c2 = new PdfPCell(new Paragraph(g.getMessage("LABEL.D.D40.0028"), new Font(objBaseFont, 9)));
					c2.setHorizontalAlignment(Element.ALIGN_CENTER);
					table2.addCell(c2);

					if(T_TPROG.size()%2 != 0){
						D40TmSchkzPlanningChartCodeData addDt = new D40TmSchkzPlanningChartCodeData();
						addDt.CODE = "";
						addDt.TEXT = "";
						addDt.DESC = "";
						T_TPROG.addElement(addDt);
					}
					for( int i = 0; i < T_TPROG.size(); i++ ){
						D40TmSchkzPlanningChartCodeData data = (D40TmSchkzPlanningChartCodeData)T_TPROG.get(i);

						c2 = new PdfPCell(new Paragraph(data.CODE, new Font(objBaseFont, 9)));
						c2.setHorizontalAlignment(Element.ALIGN_CENTER);
						table2.addCell(c2);

						c2 = new PdfPCell(new Paragraph(data.TEXT, new Font(objBaseFont, 9)));
						c2.setHorizontalAlignment(Element.ALIGN_CENTER);
						table2.addCell(c2);

						c2 = new PdfPCell(new Paragraph(data.DESC, new Font(objBaseFont, 9)));
						c2.setHorizontalAlignment(Element.ALIGN_CENTER);
						table2.addCell(c2);

					}

					// preface에 추가합니다.
					preface.add(title);
					preface.add(image2);
					preface.add(title2);
					preface.add(title4);
					preface.add(image2);
					preface.add(table);
					preface.add(image2);
					preface.add(title3);
					preface.add(image2);
					preface.add(table2);

					// preface를 document에 저장합니다.
					document.add(preface);

					document.newPage();

					tempDept = deptData.ORGEH;
		        }
	    	}

		}catch(Exception e){

			Logger.debug.println(DataUtil.getStackTrace(e));

		}finally{

			if (document != null && document.isOpen()) {
				document.close();
            }
			if (writer != null) {
				writer.close();
            }
			if (sos != null) {
				sos.close();
			}

		}

	}




	%>
