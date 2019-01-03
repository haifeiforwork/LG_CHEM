package com.common;

import com.common.constant.Excel;
import com.common.vo.ReadExcelInputVO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.WebUtil;

import net.sf.jxls.transformer.XLSTransformer;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.poifs.filesystem.NPOIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.Field;
import java.util.*;

/**
 * Created by manyjung on 2016-07-14.
 * 2017. 05. 25          eunha                  [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치
 */
public class ExcelUtils {

    public static void writeExcel(HttpServletRequest request, HttpServletResponse response, ExcelMap excelMap) throws Exception {
        Workbook wb = null;
        Properties properties = Utils.getBean("prop");

        if(StringUtils.isNotEmpty(excelMap.getTemplateName())) {
            //template으로 할건지 일반적으로 다운 받을 것인지.
            XLSTransformer transformer = new XLSTransformer();
            FileInputStream fis = null;
            try {

            	//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            	//fis = new FileInputStream(
                //        new File(request.getSession().getServletContext().getRealPath(properties.getProperty("template.root")) + "/excel/" + excelMap.getTemplateName()));
            	File f =new File(request.getSession().getServletContext().getRealPath(properties.getProperty("template.root")) + "/excel/" + excelMap.getTemplateName());
                if ( ! f.getAbsolutePath().equals(f.getCanonicalPath()) ){
             	   throw new GeneralException("파일경로 및 파일명을 확인하십시오.");
             	}
                fis = new FileInputStream(f);
              //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
                wb = transformer.transformXLS(fis, excelMap);
            } catch(Exception e) {
                Logger.error(e);
            } finally {
                if(fis != null) fis.close();
            }
        } else {
            LinkedHashMap<String, String> headerMap = (LinkedHashMap<String, String>) excelMap.get(Excel.HEADER);
            List<? extends Object> contentList = (List<? extends Object>) excelMap.get(Excel.CONTENTS);

            wb = new HSSFWorkbook();

            Sheet sheet = wb.createSheet();

            int rowIndex = 0;

            rowIndex++;

            //header 작성
            Row headerRow = sheet.createRow(rowIndex++);

            int colIndex = 0;
            Iterator<String> headerKey = headerMap.keySet().iterator();

            HSSFCellStyle cs = (HSSFCellStyle) wb.createCellStyle();
            HSSFFont font = (HSSFFont) wb.createFont();
            //font.setFontHeight((short)12);
            font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
            font.setFontName("Arial");

            cs.setFont(font);
            cs.setAlignment(HSSFCellStyle.ALIGN_CENTER);	// cell 정렬
            cs.setWrapText( true );
            //셀 색 추가~
            cs.setFillBackgroundColor(HSSFColor.WHITE.index);
            cs.setFillForegroundColor(HSSFColor.YELLOW.index);
            cs.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

            while(headerKey.hasNext()) {
                Cell cell = headerRow.createCell(colIndex++);
                cell.setCellValue(headerMap.get(headerKey.next()));
                cell.setCellStyle(cs);
            }

            //contents 작성
            for(Object row : contentList) {
                colIndex = 0;
                headerKey = headerMap.keySet().iterator();
                Row contentRow = sheet.createRow(rowIndex++);
                while(headerKey.hasNext()) {
                    String colName = headerKey.next();
                    Cell cell = contentRow.createCell(colIndex++);

                    Field field;
                    if((field = row.getClass().getField(colName)) == null) continue;

                    Class cellType = field.get(row).getClass();
                    Object value = field.get(row);  //PropertyUtils.getProperty(row, colName);

                    if(value != null) {
                        if(value instanceof Integer) {
                            cell.setCellType(Cell.CELL_TYPE_NUMERIC);
                            cell.setCellValue((Integer) value);
                        } else if(value instanceof Number) {
                            cell.setCellType(Cell.CELL_TYPE_NUMERIC);

//                            cell.setCellValue((Double) value);
                            cell.setCellValue(NumberUtils.toDouble(value.toString()));
                        } else if(cellType == Date.class) {
                            cell.setCellValue((Date) value);
                        } else {
                            cell.setCellValue((String) value);
                        }
                    }
                }
            }
        }
        if(wb == null) throw new Exception("Fail to create fail!!");

        response.setContentType("application/octect-stream; charset=UTF-8");

        String sClientVersion = request.getHeader("User-Agent");

        String fileName = excelMap.getFileName().replaceAll("\\+", "%20");

        if (sClientVersion.indexOf("MSIE 5.5") > -1) {
            response.setHeader("Content-Disposition", "filename=\"UTF-8\"" + fileName + "\";");
        } else {
            response.setHeader("Content-Disposition", "attachment" + "; filename=\"" + fileName + "\"");
        }

        response.setHeader("Content-Transfer-Encoding", "binary;");
        response.setHeader("Pragma", "no-cache;");
        response.setHeader("Expires", "-1;");

        wb.write(response.getOutputStream());
        response.getOutputStream().close();
    }

    /**
     * excel 데이타의 table 형식의 데이타를 읽어와 List<Entity>형식의 데이타로 리턴한다.
     * ex)
     *        File file = new File("C:\\Temp\\template_result.xls");    //업로드된 엑셀

             ReadExcelInputVO excelInput = new ReadExcelInputVO(file, ExcelTemplateEntity.class,
             Arrays.asList("code_group", "group_nm", "biz_cd"), 2); //엑셀을 읽기위한 기본 정보들

             Logger.debug(ExcelUtils.readExcel(excelInput));  //엑셀을 읽어와 데이타 출력
     * @param inputVO
     * @return
     * @throws Exception
     */
    public static Vector readExcel(ReadExcelInputVO inputVO) throws Exception {

        Workbook wb = null;
        Vector resultList = new Vector();

        try {

            if (StringUtils.equalsIgnoreCase("xlsx", StringUtils.substringAfterLast(inputVO.getFile().getName(), "."))) {
            /*NPOIFSFileSystem fs = new NPOIFSFileSystem(inputVO.getFile().getInputStream());*/
                wb = new XSSFWorkbook(inputVO.getFile().getInputStream());
            } else /*(StringUtils.equalsIgnoreCase("xls", StringUtils.substringAfterLast(inputVO.getFile().getName(), ".")))*/ {
                NPOIFSFileSystem fs = new NPOIFSFileSystem(inputVO.getFile().getInputStream());
                wb = new HSSFWorkbook(fs.getRoot(), true);
            }

            Sheet sheet = wb.getSheetAt(0);

            int endRow = Math.max(6, sheet.getLastRowNum());

            for (int rowNum = inputVO.getStartRow(); rowNum <= endRow; rowNum++) {
                Row row = sheet.getRow(rowNum);
                if (row == null) continue;

                Object rowValue = inputVO.getClazz().newInstance();
                for (int colNum = 0; colNum < Utils.getSize(inputVO.getColumnNameList()); colNum++) {   //컬럼 0부터 시작
                    Cell cell = row.getCell(colNum, Row.RETURN_BLANK_AS_NULL);

                    if (cell == null) {
                        // The spreadsheet is empty in this cell
                    } else {

                        cell.setCellType(Cell.CELL_TYPE_STRING);    /* cell type string 으로 강제 변환 */
/*
                    Object cellValue = null;

                    switch (cell.getCellType()) {
                        case Cell.CELL_TYPE_BOOLEAN:
                            cellValue = cell.getBooleanCellValue();
                            break;
                        case Cell.CELL_TYPE_NUMERIC:
                            cellValue = cell.getNumericCellValue();
                            break;
                        case Cell.CELL_TYPE_STRING:
                            cellValue = cell.getStringCellValue();
                            break;
                    }*/

                        String cellValue = cell.getStringCellValue();

                        if (cellValue != null)
                            Utils.setFieldValue(rowValue, inputVO.getColumnNameList().get(colNum), ObjectUtils.toString(cellValue));
                    }
                }
                resultList.add(rowValue);
            }
        } catch(Exception e) {
            Logger.error(e);
        }

        return resultList;
    }
}
