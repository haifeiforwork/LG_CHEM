<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   초과근무													*/
/*   Program Name	:   초과근무(일괄)	 엑셀템플릿 다운로드				*/
/*   Program ID		: D40OverTimeExcelDown.jsp							*/
/*   Description		: 초과근무(일괄)	 엑셀템플릿 다운로드				*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

<%@page import="org.apache.poi.ss.util.CellRangeAddress"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/web/common/commonProcess.jsp" %>
<%@ page import="java.util.*,
							com.sun.org.apache.xalan.internal.xsltc.compiler.Parser,
							java.io.*,
							java.util.List,
							java.util.HashMap,
							org.apache.poi.hssf.usermodel.*,
							org.apache.poi.hssf.*,
							org.apache.poi.hssf.util.HSSFColor,
							org.apache.poi.hssf.util.Region,
							java.text.SimpleDateFormat" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%

	Vector excelSheet1    = (Vector)request.getAttribute("excelSheet1");
	Vector excelSheet2    = (Vector)request.getAttribute("excelSheet2");
	Vector excelSheet3    = (Vector)request.getAttribute("T_YN_DATA");

	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

	out.clear();
	out = pageContext.pushBody();
	response.reset(); // 이 문장이 없으면 excel 등의 파일에서 한글이 깨지는 문제 발생.

// 	String fileName = java.net.URLEncoder.encode("초과근무","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0036"),"UTF-8");
	fileName = fileName+time;
	fileName = fileName.replace("\r","").replace("\n","");

	response.setHeader("Content-Disposition","attachment;filename="+fileName+".xls");
	response.setContentType("application/vnd.ms-excel;charset=utf-8");

// 	response.setHeader("Content-Disposition","attachment;filename="+fileName+".csv");
// 	response.setContentType("text/csv;charset=utf-8");

	OutputStream fileOut = null;

	//워크북 생성
	HSSFWorkbook objWorkBook = new HSSFWorkbook();
	//워크시트 생성
	HSSFSheet objSheet = objWorkBook.createSheet("0");
	HSSFSheet objSheet2 = objWorkBook.createSheet("1");
	//시트 이름
	objWorkBook.setSheetName(0 , g.getMessage("LABEL.D.D40.0079") );	/* 초과근무 업로드 */
	objWorkBook.setSheetName(1 , g.getMessage("LABEL.D.D40.0080") );	/* 초과근무 Template 설명 */
	//행생성
	HSSFRow objRow = objSheet.createRow((short)0);
	HSSFRow objRow2 = objSheet2.createRow((short)0);
	//셀 생성
	HSSFCell objCell = null;
	//------------------------------------------------------------------------------------

	HSSFCellStyle styleHd = objWorkBook.createCellStyle();    //제목 스타일
	HSSFCellStyle styleCon = objWorkBook.createCellStyle();    //내용 스타일
	HSSFCellStyle styleCon2 = objWorkBook.createCellStyle();    //내용 스타일
	HSSFCellStyle styleCon3 = objWorkBook.createCellStyle();    //내용 스타일
	styleCon.setWrapText(true);
	styleCon2.setWrapText(true);

	//제목 폰트
	HSSFFont font = objWorkBook.createFont();
	font.setBoldweight((short)font.BOLDWEIGHT_BOLD);
	font.setFontName(g.getMessage("LABEL.D.D40.0093"));	/* 맑은고딕 */
	font.setFontHeight((short)(11*20));
	font.setBoldweight(font.BOLDWEIGHT_BOLD);

	//내용폰트
	HSSFFont font2 = objWorkBook.createFont();
	font2.setFontName(g.getMessage("LABEL.D.D40.0093"));	/* 맑은고딕 */
	font2.setFontHeight((short)(10*20));

	//제목 스타일에 폰트 적용, 정렬
	styleHd.setFont(font);
	styleHd.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	styleHd.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);

	//내용 스타일에 폰트 적용
	styleCon.setFont(font2);
	styleCon.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	styleCon.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);
	styleCon.setDataFormat((short) 0x31);

	styleCon2.setFont(font2);
	styleCon2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
	styleCon2.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);

	styleCon3.setFont(font);

	//셀에 색 넣기
	styleHd.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);// not BackgroundColor
	styleHd.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);

// 	styleCon2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);// not BackgroundColor
// 	styleCon2.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);

	//테두리 선
	styleHd.setBorderRight(HSSFCellStyle.BORDER_THIN);
	styleHd.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	styleHd.setBorderTop(HSSFCellStyle.BORDER_THIN);
	styleHd.setBorderBottom(HSSFCellStyle.BORDER_THIN);

	styleCon.setBorderRight(HSSFCellStyle.BORDER_THIN);
	styleCon.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	styleCon.setBorderTop(HSSFCellStyle.BORDER_THIN);
	styleCon.setBorderBottom(HSSFCellStyle.BORDER_THIN);

	styleCon2.setBorderRight(HSSFCellStyle.BORDER_THIN);
	styleCon2.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	styleCon2.setBorderTop(HSSFCellStyle.BORDER_THIN);
	styleCon2.setBorderBottom(HSSFCellStyle.BORDER_THIN);

	//Sheet1
	for(int i = 0; i < excelSheet1.size(); i++){
		D40OverTimeFrameData persData = (D40OverTimeFrameData)excelSheet1.get(i);

		objRow = objSheet.createRow((short)i);
		objRow.setHeight ((short) 0x180);

		objCell = objRow.createCell((short)0);
		objCell.setCellValue(persData.A);	//*사원번호
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)1);
		objCell.setCellValue(persData.B);	//이름
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)2);
		objCell.setCellValue(persData.C);	//*시작일
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)3);
		objCell.setCellValue(persData.D);	//*종료일
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)4);
		objCell.setCellValue(persData.E);	//시작시간
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)5);
		objCell.setCellValue(persData.F);	//종료시간
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)6);
		objCell.setCellValue(persData.G);	//휴식시작1
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)7);
		objCell.setCellValue(persData.H);	//휴식종료1
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)8);
		objCell.setCellValue(persData.I);	//휴식시작2
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)9);
		objCell.setCellValue(persData.J);	//휴식종료2
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)10);
		objCell.setCellValue(persData.K);	//이전일 반영여부
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)11);
		objCell.setCellValue(persData.L);	//사유코드
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)12);
		objCell.setCellValue(persData.M);	//상세사유 입력
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

	}

	//Sheet2
	objRow = objSheet2.createRow((short)0);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0017"));/* *사번 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D12.0018"));	/* 이름 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)3);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D15.0152"));	/* *시작일 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D15.0153"));	/* *종료일 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)5);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0020"));	/* *시작시간 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)6);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0021"));	/* *종료시간 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)7);
	objCell.setCellValue(g.getMessage("LABEL.D.D12.0068"));	/* 휴식 시작1 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)8);
	objCell.setCellValue(g.getMessage("LABEL.D.D12.0069"));	/* 휴식 종료1 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)9);
	objCell.setCellValue(g.getMessage("LABEL.D.D12.0070"));	/* 휴식 시작2 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)10);
	objCell.setCellValue(g.getMessage("LABEL.D.D12.0071"));	/* 휴식 종료2 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)11);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0094"));	/* 이전일 반영여부 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)12);
	objCell.setCellValue("(*)"+g.getMessage("LABEL.D.D12.0024"));	/* *사유코드 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)13);
	objCell.setCellValue("(*)"+g.getMessage("LABEL.D.D40.0065"));		/* 상세사유 입력 */
	objCell.setCellStyle(styleHd);

	for(int i = 1; i < 5; i++){
		objRow = objSheet2.createRow((short)i);
		objRow.setHeight ((short) 0x180);
		objCell = objRow.createCell((short)1);
		if(i == 1){objCell.setCellValue("00011111");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)2);
		if(i == 1){objCell.setCellValue("홍길동");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)3);
		if(i == 1){objCell.setCellValue("20171225");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)4);
		if(i == 1){objCell.setCellValue("20171225");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)5);
		if(i == 1){objCell.setCellValue("0900");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)6);
		if(i == 1){objCell.setCellValue("1800");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)7);
		objCell.setCellValue("");
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)8);
		objCell.setCellValue("");
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)9);
		objCell.setCellValue("");
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)10);
		objCell.setCellValue("");
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)11);
		objCell.setCellValue("");
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)12);
		if(i == 1){objCell.setCellValue("C01");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)13);
		objCell.setCellValue("");
		objCell.setCellStyle(styleCon);
	}



	objRow = objSheet2.createRow((short)7);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0067"));	/* ※ 가이드 */
	objCell.setCellStyle(styleCon3);

	objRow = objSheet2.createRow((short)8);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0098"));	/* 필드명 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0099"));	/* 필수여부 */
	objCell.setCellStyle(styleHd);

	objSheet2.addMergedRegion(new CellRangeAddress(8,8,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0028"));	/* 설명 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleHd);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleHd);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleHd);

	objRow = objSheet2.createRow((short)9);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("1. "+g.getMessage("LABEL.D.D05.0005"));/* 1. 사번 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(9,9,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0102"));	/* 앞에 '0'은 입력하지 않아도 됨 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)10);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("2. "+g.getMessage("LABEL.D.D05.0006"));/* 2. 이름 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(10,10,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0103"));	/* 열삭제 금지 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)11);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("3. "+g.getMessage("LABEL.D.D15.0152"));/* 3. 시작일 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(11,12,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0104"));	/* YYYYMMDD 형식 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)12);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("4. "+g.getMessage("LABEL.D.D15.0153"));/* 4. 종료일 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

// 	objSheet2.addMergedRegion(new CellRangeAddress(11,11,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0104"));	/* YYYYMMDD 형식 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)13);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("5. "+g.getMessage("LABEL.D.D12.0020"));/* 5. 시작시간 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(13,18,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0106"));	/* HHMM으로 입력  ex)  13시 30분 → 1330, 09시 30분 → 0930 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)14);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("6. "+g.getMessage("LABEL.D.D12.0021"));/* 6. 종료시간 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)15);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("7. "+g.getMessage("LABEL.D.D12.0068"));/*7. 휴식 시작1 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)16);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("8. "+g.getMessage("LABEL.D.D12.0069"));/*8. 휴식 종료1 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)17);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("9. "+g.getMessage("LABEL.D.D12.0070"));/*9. 휴식 시작2 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)18);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("10. "+g.getMessage("LABEL.D.D12.0071"));/*10. 휴식 종료2 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)19);
	objRow.setHeight((short) 0x720);
// 	objRow.setHeight((short)2048);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("11. "+g.getMessage("LABEL.D.D40.0094"));/* 11. 이전일 반영여부 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(19,19,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0107"));	/* X'로 입력(대소문자 구분없음)하며,  입력일자와 귀속일자 상이할때 전날일자로 초과근무를 반영할때 사용 예를들면  2017.11.15 N228(22:00 ~ 06:00) 근무자가  06:00 ~ 08:00(2시간) 동안 연장근무를 하였다면 초과근무은 날짜 기준으로  2017.11.16 06:00 ~ 08:00로 입력하고 이전일 Check하면 2017.11.15 연장근로로 인식합니다 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)20);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("12. "+g.getMessage("LABEL.D.D12.0024"));/*12. 사유코드 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0108"));	/* 설명 참조 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(20,20,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0117"));	/* 아래 초과근무사유 코드 'Y'이면 시, 필수입력 */
	objCell.setCellStyle(styleCon2);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)21);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("13. "+g.getMessage("LABEL.D.D40.0065"));/*13. 상세사유 입력 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0108"));	/* 설명 참조 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(21,21,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0114"));	/* 아래 상세사유 필수 'Y'일 시, 상세사유 자유입력. 'N'일 시 미입력 */
	objCell.setCellStyle(styleCon2);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)24);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0118"));	/* 사유 입력여부 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0119"));	/* 상세사유 입력여부 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0110"));	/* 초과근무사유 코드 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)5);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0048"));	/* 텍스트 */
	objCell.setCellStyle(styleHd);

	if(excelSheet3.size() >= excelSheet2.size()){
		for(int i = 0; i < excelSheet3.size(); i++){
			objRow2 = objSheet2.createRow((short)(i+25));
			objRow2.setHeight ((short) 0x180);

			if(i < excelSheet2.size()){
				D40OverTimeFrameData persData2 = (D40OverTimeFrameData)excelSheet2.get(i);

				objCell = objRow2.createCell((short)4);
				objCell.setCellValue(persData2.CODE);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)5);
				objCell.setCellValue(persData2.TEXT);
				objCell.setCellStyle(styleCon);
			}

			D40OverTimeFrameData persData3 = (D40OverTimeFrameData)excelSheet3.get(i);

			objCell = objRow2.createCell((short)1);
			objCell.setCellValue(persData3.USEYN);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)2);
			objCell.setCellValue(persData3.USECYN);
			objCell.setCellStyle(styleCon);
		}
	}else{
		for(int i = 0; i < excelSheet2.size(); i++){
			objRow2 = objSheet2.createRow((short)(i+25));
			objRow2.setHeight ((short) 0x180);

			if(i < excelSheet3.size()){
				D40OverTimeFrameData persData3 = (D40OverTimeFrameData)excelSheet3.get(i);

				objCell = objRow2.createCell((short)1);
				objCell.setCellValue(persData3.USEYN);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)2);
				objCell.setCellValue(persData3.USECYN);
				objCell.setCellStyle(styleCon);
			}
			D40OverTimeFrameData persData2 = (D40OverTimeFrameData)excelSheet2.get(i);

			objCell = objRow2.createCell((short)4);
			objCell.setCellValue(persData2.CODE);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)5);
			objCell.setCellValue(persData2.TEXT);
			objCell.setCellStyle(styleCon);
		}
	}

// 	for(int i = 0; i < excelSheet2.size(); i++){
// 		D40OverTimeFrameData persData = (D40OverTimeFrameData)excelSheet2.get(i);

// 		objRow2 = objSheet2.createRow((short)(i+22));
// 		objRow2.setHeight ((short) 0x160);

// 		objCell = objRow2.createCell((short)1);
// 		objCell.setCellValue(persData.A);
// 		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

// 		objCell = objRow2.createCell((short)2);
// 		objCell.setCellValue(persData.B);
// 		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

// 	}
	//----------------------------------------------------------------------------------------

	//길이 설정

	objSheet.setColumnWidth((short)0,(short)5000);
	objSheet.setColumnWidth((short)1,(short)5000);
	objSheet.setColumnWidth((short)2,(short)4000);
	objSheet.setColumnWidth((short)3,(short)4000);
	objSheet.setColumnWidth((short)4,(short)4000);
	objSheet.setColumnWidth((short)5,(short)4000);
	objSheet.setColumnWidth((short)6,(short)4000);
	objSheet.setColumnWidth((short)7,(short)4000);
	objSheet.setColumnWidth((short)8,(short)4000);
	objSheet.setColumnWidth((short)9,(short)4000);
	objSheet.setColumnWidth((short)10,(short)5000);
	objSheet.setColumnWidth((short)11,(short)5000);
	objSheet.setColumnWidth((short)12,(short)7000);

	objSheet2.setColumnWidth((short)0,(short)1000);
	objSheet2.setColumnWidth((short)1,(short)7000);
	objSheet2.setColumnWidth((short)2,(short)7000);
	objSheet2.setColumnWidth((short)3,(short)5000);
	objSheet2.setColumnWidth((short)4,(short)7000);
	objSheet2.setColumnWidth((short)5,(short)7000);
	objSheet2.setColumnWidth((short)6,(short)4000);
	objSheet2.setColumnWidth((short)7,(short)4000);
	objSheet2.setColumnWidth((short)8,(short)4000);
	objSheet2.setColumnWidth((short)9,(short)4000);
	objSheet2.setColumnWidth((short)10,(short)5000);
	objSheet2.setColumnWidth((short)11,(short)5000);
	objSheet2.setColumnWidth((short)12,(short)5000);
	objSheet2.setColumnWidth((short)13,(short)7000);

	fileOut = response.getOutputStream();

	objWorkBook.write(fileOut);

	fileOut.close();



%>


