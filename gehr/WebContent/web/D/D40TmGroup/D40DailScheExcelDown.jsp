<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   일일근무일정												*/
/*   Program Name	:   일일근무일정(일괄)	Excel Template download	*/
/*   Program ID		: D40DailScheEachExcel.jsp							*/
/*   Description		: 일일근무일정 (일괄) Excel Template download	*/
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

// 	String fileName = java.net.URLEncoder.encode("일일근무일정","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0035"),"UTF-8");
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
	objWorkBook.setSheetName(0 , g.getMessage("LABEL.D.D40.0075")  );	/* 일일근무 일정 */
	objWorkBook.setSheetName(1 , g.getMessage("LABEL.D.D40.0076")  );	/* 일일근무 일정 Template 설명 */
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

	//Sheet1
	for(int i = 0; i < excelSheet1.size(); i++){
		D40DailScheFrameData persData = (D40DailScheFrameData)excelSheet1.get(i);

		objRow = objSheet.createRow((short)i);
		objRow.setHeight ((short) 0x180);

		objCell = objRow.createCell((short)0);
		objCell.setCellValue(persData.A);		//사번
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)1);
		objCell.setCellValue(persData.B);		//이름
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)2);
		objCell.setCellValue(persData.C);		//시작일
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)3);
		objCell.setCellValue(persData.D);		//종료일
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)4);
		objCell.setCellValue(persData.E);		//일일근무일정
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

	}

	//Sheet2
	objRow = objSheet2.createRow((short)0);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0017"));	/* *사번 */
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
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D40.0035"));	/* *일일근무일정 */
	objCell.setCellStyle(styleHd);

	objRow = objSheet2.createRow((short)1);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("00011111");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue("홍길동");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)3);
	objCell.setCellValue("20170101");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue("20170101");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellValue("D098");
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)2);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue("");
	objCell.setCellStyle(styleCon);

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

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)10);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("5. "+g.getMessage("LABEL.D.D40.0035"));/* 5. 일일근무일정 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(10,10,3,5));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0105"));	/* 일일근무일정은 아래 사항을 참조하여 코드로 입력해 주세요. */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);

	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)11);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0078"));	/* ※ 기존 등록된 초과근무시간과 중복되면, 오류가 발생하니 주의하시기바랍니다. */
	objCell.setCellStyle(styleCon3);

	for(int i = 0; i < excelSheet2.size(); i++){
		D40DailScheFrameData persData = (D40DailScheFrameData)excelSheet2.get(i);

		objRow2 = objSheet2.createRow((short)(i+16));
		objRow2.setHeight ((short) 0x180);

		objCell = objRow2.createCell((short)1);
		objCell.setCellValue(persData.A);
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
	objSheet.setColumnWidth((short)4,(short)5000);
	objSheet.setColumnWidth((short)5,(short)7000);

	objSheet2.setColumnWidth((short)0,(short)1000);
	objSheet2.setColumnWidth((short)1,(short)6000);
	objSheet2.setColumnWidth((short)2,(short)7000);
	objSheet2.setColumnWidth((short)3,(short)5000);
	objSheet2.setColumnWidth((short)4,(short)5000);
	objSheet2.setColumnWidth((short)5,(short)5000);
	objSheet2.setColumnWidth((short)6,(short)7000);

	fileOut = response.getOutputStream();

	objWorkBook.write(fileOut);

	fileOut.close();



%>


