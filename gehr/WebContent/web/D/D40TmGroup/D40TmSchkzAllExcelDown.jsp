<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   계획근무일정												*/
/*   Program Name	:   계획근무일정	(일괄)	 엑셀템플릿다운로드			*/
/*   Program ID		: D40TmSchkzAllExcelDown.jsp						*/
/*   Description		: 계획근무일정(일괄)	엑셀템플릿다운로드				*/
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

	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

	out.clear();
	out = pageContext.pushBody();
	response.reset(); // 이 문장이 없으면 excel 등의 파일에서 한글이 깨지는 문제 발생.

// 	String fileName = java.net.URLEncoder.encode("계획근무일정","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0019"),"UTF-8");
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
	objWorkBook.setSheetName(0 , g.getMessage("LABEL.D.D40.0091"));	/* 계획근무일정 업로드 */
	objWorkBook.setSheetName(1 , g.getMessage("LABEL.D.D40.0092"));	/* 계획근무 일정 Template 설명 */
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
// 	styleHd.setb
// 	styleHd.setBoldweight(HSSFCellStyle.BORDER_HAIR); //볼드 (굵게)

	//내용 스타일에 폰트 적용
	styleCon.setFont(font2);
	styleCon.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	styleCon.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);

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

	//Sheet1 엑셀템플릿 SAP 데이터
	for(int i = 0; i < excelSheet1.size(); i++){
		D40TmSchkzFrameData persData = (D40TmSchkzFrameData)excelSheet1.get(i);

		objRow = objSheet.createRow((short)i);
		objRow.setHeight ((short) 0x180);

		objCell = objRow.createCell((short)0);
		objCell.setCellValue(persData.A);
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)1);
		objCell.setCellValue(persData.B);
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)2);
		objCell.setCellValue(persData.C);
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)3);
		objCell.setCellValue(persData.D);
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)4);
		objCell.setCellValue(persData.E);
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}
	}

	//Sheet2
	objRow = objSheet2.createRow((short)0);	//엑셀 row 생성 (첫번째 줄)
	objRow.setHeight ((short) 0x180);				//row 높이 설정
	objCell = objRow.createCell((short)1);		//엑셀 cell 생성 (엑셀 첫번재 줄 B라인에 생성 : 숫자가 증가 할 수록 A ~ 증가  시작은 0 )
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0017"));/* *사번 */
	objCell.setCellStyle(styleHd);						// cell 스타일 적용

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
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D40.0019"));	/* 계획근무일정 */
	objCell.setCellStyle(styleHd);

	objRow = objSheet2.createRow((short)1);	//엑셀 row 생성 (두번째 줄)
	objRow.setHeight ((short) 0x180);			//row 높이 설정
	objCell = objRow.createCell((short)1);	//엑셀 cell 생성 (엑셀 두번재 줄 B라인에 생성)
	objCell.setCellValue("00011111");			// cell 값 설정
	objCell.setCellStyle(styleCon);				// cell 스타일 적용

	objCell = objRow.createCell((short)2);
	objCell.setCellValue("홍길동");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellValue("20170101");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue("99991231");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellValue("437AA220");
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)2);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)3);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)4);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0067"));	/* ※ 가이드 */
	objCell.setCellStyle(styleCon3);

	objRow = objSheet2.createRow((short)5);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0098"));	/* 필드명 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0099"));	/* 필수여부 */
	objCell.setCellStyle(styleHd);

	//셀병합 0부터 시작하기 때문에 row는 6번째 ~ 6번째,  cell은 D ~ F  병합
	objSheet2.addMergedRegion(new CellRangeAddress(5,5,3,5));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0028"));	/* 설명 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleHd);

	objRow = objSheet2.createRow((short)6);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("1. "+g.getMessage("LABEL.D.D05.0005"));/* 1. 사번 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(6,6,3,5));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0102"));	/* 앞에 '0'은 입력하지 않아도 됨 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)7);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("2. "+g.getMessage("LABEL.D.D05.0006"));/* 2. 이름 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(7,7,3,5));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0103"));	/* 열삭제 금지 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)8);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("3. "+g.getMessage("LABEL.D.D15.0152"));/* 3. 시작일 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	//셀병합 0부터 시작하기 때문에 row는 9번째 ~ 10번째,  cell은 D ~ F  병합
	objSheet2.addMergedRegion(new CellRangeAddress(8,9,3,5));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0104"));	/* YYYYMMDD 형식 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)9);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("4. "+g.getMessage("LABEL.D.D15.0153"));/* 4. 종료일 */
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

	objRow = objSheet2.createRow((short)10);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("5. "+g.getMessage("LABEL.D.D40.0019"));/* 5. 계획근무일정 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(10,10,3,5));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0113"));	/* 계획근무 일정은 아래 사항을 참조하여 코드로 입력해 주세요. */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);

	//계획근무일정 SAP 데이터
	for(int i = 0; i < excelSheet2.size(); i++){
		D40TmSchkzFrameData persData = (D40TmSchkzFrameData)excelSheet2.get(i);

		objRow2 = objSheet2.createRow((short)(i+14));
		objRow2.setHeight ((short) 0x180);

		objCell = objRow2.createCell((short)1);
		objCell.setCellValue(persData.A);
		//첫번째 헤더만 다른 스타일로
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow2.createCell((short)2);
		objCell.setCellValue(persData.B);
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

	}
	//----------------------------------------------------------------------------------------

	//길이 설정

	objSheet.setColumnWidth((short)0,(short)6000);
	objSheet.setColumnWidth((short)1,(short)6000);
	objSheet.setColumnWidth((short)2,(short)5000);
	objSheet.setColumnWidth((short)3,(short)5000);
	objSheet.setColumnWidth((short)4,(short)7000);

	objSheet2.setColumnWidth((short)0,(short)1000);
	objSheet2.setColumnWidth((short)1,(short)6000);
	objSheet2.setColumnWidth((short)2,(short)7000);
	objSheet2.setColumnWidth((short)3,(short)5000);
	objSheet2.setColumnWidth((short)4,(short)5000);
	objSheet2.setColumnWidth((short)5,(short)7000);

	fileOut = response.getOutputStream();

	objWorkBook.write(fileOut);

	fileOut.close();



%>


