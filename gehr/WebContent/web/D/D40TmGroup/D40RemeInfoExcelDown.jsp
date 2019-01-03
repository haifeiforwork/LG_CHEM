<%@page import="org.apache.poi.ss.util.CellRangeAddress"%>
<%--
/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   사원지급 정보											*/
/*   Program Name	:   사원지급정보 Excel	Template						*/
/*   Program ID		: D40RemeInfoFrame										*/
/*   Description		: 사원지급정보 Excel Template download			*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/
--%>

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
							java.text.SimpleDateFormat" %>
<%@ page import="hris.D.D40TmGroup.*" %>
<%@ page import="hris.D.D40TmGroup.rfc.*" %>

<%

	Vector excelSheet1    = (Vector)request.getAttribute("excelSheet1");
	Vector excelSheet2    = (Vector)request.getAttribute("excelSheet2");	//유형
	Vector excelSheet3    = (Vector)request.getAttribute("excelSheet3");		//근태사유
	Vector excelSheet4    = (Vector)request.getAttribute("excelSheet4");		//근태사유

// 	excelSheet2.addAll(excelSheet4);
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
	String time = sf.format(nowTime);

	out.clear();
	out = pageContext.pushBody();
	response.reset(); // 이 문장이 없으면 excel 등의 파일에서 한글이 깨지는 문제 발생.

// 	String fileName = java.net.URLEncoder.encode("사원지급정보","UTF-8");
	String fileName = java.net.URLEncoder.encode(g.getMessage("LABEL.D.D40.0064"),"UTF-8");
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
	objWorkBook.setSheetName(0 , g.getMessage("LABEL.D.D40.0088"));	/* 사원지급정보 업로드 */
	objWorkBook.setSheetName(1 , g.getMessage("LABEL.D.D40.0089"));	/* 사원지급정보 Template 설명 */
	//행생성
	HSSFRow objRow = objSheet.createRow((short)0);
	HSSFRow objRow2 = objSheet2.createRow((short)0);
	//셀 생성
	HSSFCell objCell = null;
	//------------------------------------------------------------------------------------

	HSSFCellStyle styleHd = objWorkBook.createCellStyle();    //제목 스타일
	HSSFCellStyle styleCon = objWorkBook.createCellStyle();   //내용 스타일
	HSSFCellStyle styleCon2 = objWorkBook.createCellStyle();   //내용 스타일
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
		D40RemeInfoFrameData persData = (D40RemeInfoFrameData)excelSheet1.get(i);

		objRow = objSheet.createRow((short)i);
		objRow.setHeight ((short) 0x180);

		objCell = objRow.createCell((short)0);
		objCell.setCellValue(persData.A);	//*사번
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)1);
		objCell.setCellValue(persData.B);	//이름
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)2);
		objCell.setCellValue(persData.C);	//*일자
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)3);
		objCell.setCellValue(persData.D);	//*임금유형
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)4);
		objCell.setCellValue(persData.E);	//*시작시간
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)5);
		objCell.setCellValue(persData.F);	//*종료시간
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)6);
		objCell.setCellValue(persData.G);	//휴식시작시간
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)7);
		objCell.setCellValue(persData.H);	//휴식종료시간
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)8);
		objCell.setCellValue(persData.I);	//근무시간 수
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)9);
		objCell.setCellValue(persData.J);	//*사유코드
		if(i == 0){objCell.setCellStyle(styleHd);}else{objCell.setCellStyle(styleCon);}

		objCell = objRow.createCell((short)10);
		objCell.setCellValue(persData.K);	//상세사유 입력
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
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D15.0206"));	/* *일자 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D08.0004"));	/* *임금유형 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)5);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0020"));	/* *시작시간 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)6);
	objCell.setCellValue("*"+g.getMessage("LABEL.D.D12.0021"));	/* *종료시간 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)7);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0122"));	/* 휴식시작시간 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)8);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0123"));	/* 휴식종료시간 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)9);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0124"));	/* 근무시간 수  */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)10);
	objCell.setCellValue("(*)"+g.getMessage("LABEL.D.D12.0024"));	/* (*)사유코드 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)11);
	objCell.setCellValue("(*)"+g.getMessage("LABEL.D.D40.0065"));		/* (*)상세사유 입력 */
	objCell.setCellStyle(styleHd);

	for(int i = 1; i < 5; i++){
		objRow = objSheet2.createRow((short)i);
		objRow.setHeight ((short) 0x180);
		objCell = objRow.createCell((short)1);
		if(i == 1){objCell.setCellValue("00011111");}else if(i == 2){objCell.setCellValue("00022222");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)2);
		if(i == 1){objCell.setCellValue("홍길동");}else if(i == 2){objCell.setCellValue("김길동");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)3);
		if(i == 1){objCell.setCellValue("20171225");}else if(i == 2){objCell.setCellValue("20171225");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)4);
		if(i == 1){objCell.setCellValue("A1042");}else if(i == 2){objCell.setCellValue("A1036");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)5);
		if(i == 1){objCell.setCellValue("0900");}else if(i == 2){objCell.setCellValue("0900");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)6);
		if(i == 1){objCell.setCellValue("1500");}else if(i == 2){objCell.setCellValue("1200");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)7);
		if(i == 1){objCell.setCellValue("0900");}else if(i == 2){objCell.setCellValue("0900");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)8);
		if(i == 1){objCell.setCellValue("1500");}else if(i == 2){objCell.setCellValue("1200");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)9);
		if(i == 1){objCell.setCellValue("");}else if(i == 2){objCell.setCellValue("");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)10);
		if(i == 1){objCell.setCellValue("D03");}else if(i == 2){objCell.setCellValue("B01");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

		objCell = objRow.createCell((short)11);
		if(i == 1){objCell.setCellValue("교육참가");}else{objCell.setCellValue("");}
		objCell.setCellStyle(styleCon);

	}


	objRow = objSheet2.createRow((short)6);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0067"));	/* ※ 가이드 */
	objCell.setCellStyle(styleCon3);

	objRow = objSheet2.createRow((short)7);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0098"));	/* 필드명 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0099"));	/* 필수여부 */
	objCell.setCellStyle(styleHd);

	objSheet2.addMergedRegion(new CellRangeAddress(7,7,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0028"));	/* 설명 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleHd);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleHd);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleHd);

	objRow = objSheet2.createRow((short)8);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("1. "+g.getMessage("LABEL.D.D05.0005"));/* 1. 사번 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(8,8,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0102"));	/* 앞에 '0'은 입력하지 않아도 됨 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)9);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("2. "+g.getMessage("LABEL.D.D05.0006"));/* 2. 이름 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0101"));	/* 선택입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(9,9,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0103"));	/* 열삭제 금지 */
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
	objCell.setCellValue("3. "+g.getMessage("LABEL.D.D15.0206"));/* 3. 일자 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(10,10,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0104"));	/* YYYYMMDD 형식 */
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
	objCell.setCellValue("4. "+g.getMessage("LABEL.D.D40.0087"));/* 4. 임금항목 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(11,11,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0115"));	/* 아래 임금항목코드 존재시 필수 입력 */
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
	objCell.setCellValue("5. "+g.getMessage("LABEL.D.D12.0020"));/* 5. 시작시간 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0100"));	/* 필수입력 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(12,15,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0106"));	/* HHMM으로 입력  ex)  13시 30분 → 1330, 09시 30분 → 0930 */
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

	objRow = objSheet2.createRow((short)14);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("7. "+g.getMessage("LABEL.D.D40.0122"));/* 7. 휴식시작시간 */
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

	objRow = objSheet2.createRow((short)15);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("8. "+g.getMessage("LABEL.D.D40.0123"));/* 8. 휴식종료시간 */
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
	objCell.setCellValue("9. "+g.getMessage("LABEL.D.D40.0124"));/*9. 근무시간 수 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0108"));	/* 설명 참조 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(16,16,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0125"));	/* 시간을 아라비아 숫자로 표시됨 미입력 사항 */
	objCell.setCellStyle(styleCon2);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)17);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("10. "+g.getMessage("LABEL.D.D12.0024"));/*10. 사유코드 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0108"));	/* 설명 참조 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(17,17,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0116"));	/* 아래 유형별 사유코드  Y이면  필수입력 */
	objCell.setCellStyle(styleCon2);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);

	objRow = objSheet2.createRow((short)18);
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue("11. "+g.getMessage("LABEL.D.D40.0065"));/*11. 상세사유 입력 */
	objCell.setCellStyle(styleCon2);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0108"));	/* 설명 참조 */
	objCell.setCellStyle(styleCon);

	objSheet2.addMergedRegion(new CellRangeAddress(18,18,3,6));

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0114"));	/* 아래 상세사유 필수 'Y'일 시, 상세사유 자유입력. 'N'일 시 미입력 */
	objCell.setCellStyle(styleCon2);
	objCell = objRow.createCell((short)4);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)5);
	objCell.setCellStyle(styleCon);
	objCell = objRow.createCell((short)6);
	objCell.setCellStyle(styleCon);


	objRow = objSheet2.createRow((short)(21));
	objRow.setHeight ((short) 0x180);
	objCell = objRow.createCell((short)1);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0087"));	/* 임금항목 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)2);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0048"));	/* "텍스트" */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)3);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0038"));	/* 사유코드 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)4);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0109"));	/* 상세사유 텍스트 입력 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)6);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0087"));	/* 임금항목 */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)7);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0038"));	/* "사유코드" */
	objCell.setCellStyle(styleHd);

	objCell = objRow.createCell((short)8);
	objCell.setCellValue(g.getMessage("LABEL.D.D40.0048"));	/* "텍스트" */
	objCell.setCellStyle(styleHd);

	String val = "";
	int y = 0;
	int z = 0;
	int start = 0;
	if(excelSheet3.size() >= excelSheet4.size()){
		for(int i = 0; i < excelSheet3.size(); i++){
			z = (i + 22);

			objRow2 = objSheet2.createRow((short)(i+22));
			objRow2.setHeight ((short) 0x180);

			if(i < excelSheet4.size()){
				D40RemeInfoFrameData persData2 = (D40RemeInfoFrameData)excelSheet4.get(i);

				objCell = objRow2.createCell((short)1);
				objCell.setCellValue(persData2.CODE);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)2);
				objCell.setCellValue(persData2.TEXT);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)3);
				objCell.setCellValue(persData2.USEYN);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)4);
				objCell.setCellValue(persData2.USECYN);
				objCell.setCellStyle(styleCon);
			}

			//================================================================
			D40RemeInfoFrameData persData3 = (D40RemeInfoFrameData)excelSheet3.get(i);

			if(i == 0){
// 				val = persData3.PKEY;
				start = z;
			}
			//셀 병합 작업
			if(val.equals(persData3.PKEY)){
				y++;
				if((i+1) == excelSheet3.size()){
					objSheet2.addMergedRegion(new CellRangeAddress(start, (start+y),6,6));
				}
			}else{
				if(i != 0){
					objSheet2.addMergedRegion(new CellRangeAddress(start, (start+y),6,6));
				}
				start = z;
				y = 0;
				val = persData3.PKEY;
			}

			objCell = objRow2.createCell((short)6);
			objCell.setCellValue(persData3.PKEY);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)7);
			objCell.setCellValue(persData3.CODE);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)8);
			objCell.setCellValue(persData3.TEXT);
			objCell.setCellStyle(styleCon);

		}
	}else{
		for(int i = 0; i < excelSheet4.size(); i++){

			z = (i + 22);

			objRow2 = objSheet2.createRow((short)(i+22));
			objRow2.setHeight ((short) 0x180);

			if(i < excelSheet3.size()){
				D40RemeInfoFrameData persData3 = (D40RemeInfoFrameData)excelSheet3.get(i);

				if(i == 0){
// 					val = persData3.PKEY;
					start = z;
				}
				//셀 병합 작업
				if(val.equals(persData3.PKEY)){
					y++;
					if((i+1) == excelSheet3.size()){
						objSheet2.addMergedRegion(new CellRangeAddress(start, (start+y),6,6));
					}
				}else{
					if(i != 0){
						objSheet2.addMergedRegion(new CellRangeAddress(start, (start+y),6,6));
					}
					start = z;
					y = 0;
					val = persData3.PKEY;
				}

				objCell = objRow2.createCell((short)6);
				objCell.setCellValue(persData3.PKEY);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)7);
				objCell.setCellValue(persData3.CODE);
				objCell.setCellStyle(styleCon);

				objCell = objRow2.createCell((short)8);
				objCell.setCellValue(persData3.TEXT);
				objCell.setCellStyle(styleCon);

			}

			//================================================================

			D40RemeInfoFrameData persData2 = (D40RemeInfoFrameData)excelSheet4.get(i);

			objCell = objRow2.createCell((short)1);
			objCell.setCellValue(persData2.CODE);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)2);
			objCell.setCellValue(persData2.TEXT);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)3);
			objCell.setCellValue(persData2.USEYN);
			objCell.setCellStyle(styleCon);

			objCell = objRow2.createCell((short)4);
			objCell.setCellValue(persData2.USECYN);
			objCell.setCellStyle(styleCon);
		}
	}

	//----------------------------------------------------------------------------------------

	//길이 설정

	objSheet.setColumnWidth((short)0,(short)5000);
	objSheet.setColumnWidth((short)1,(short)5000);
	objSheet.setColumnWidth((short)2,(short)5000);
	objSheet.setColumnWidth((short)3,(short)4000);
	objSheet.setColumnWidth((short)4,(short)4000);
	objSheet.setColumnWidth((short)5,(short)4000);
	objSheet.setColumnWidth((short)6,(short)4000);
	objSheet.setColumnWidth((short)7,(short)4000);
	objSheet.setColumnWidth((short)8,(short)4000);
	objSheet.setColumnWidth((short)9,(short)4000);
	objSheet.setColumnWidth((short)10,(short)6000);
	objSheet.setColumnWidth((short)11,(short)5000);


	objSheet2.setColumnWidth((short)0,(short)1000);
	objSheet2.setColumnWidth((short)1,(short)5500);
	objSheet2.setColumnWidth((short)2,(short)5000);
	objSheet2.setColumnWidth((short)3,(short)5000);
	objSheet2.setColumnWidth((short)4,(short)6500);
	objSheet2.setColumnWidth((short)5,(short)4000);
	objSheet2.setColumnWidth((short)6,(short)4000);
	objSheet2.setColumnWidth((short)7,(short)4000);
	objSheet2.setColumnWidth((short)8,(short)6000);
	objSheet2.setColumnWidth((short)9,(short)4000);
	objSheet2.setColumnWidth((short)10,(short)4000);
	objSheet2.setColumnWidth((short)11,(short)6000);


	fileOut = response.getOutputStream();

	objWorkBook.write(fileOut);

	fileOut.close();

%>


