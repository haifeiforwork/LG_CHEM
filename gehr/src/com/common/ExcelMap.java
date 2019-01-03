package com.common;

import com.common.constant.Excel;
import com.common.vo.BaseVO;
import org.apache.commons.lang.StringUtils;

import java.util.*;


/**
 * Created by manyjung on 2016-07-13.
 */
public class ExcelMap extends HashMap {
    private String fileName;
    private String templateName;

    private ExcelMap() {}

    private ExcelMap(String fileName) {
        this();
        this.fileName = fileName;
    }

    private ExcelMap(String fileName, String templateName) {
        this(fileName);
        this.templateName = templateName;
    }
    public static ExcelMap getInstance() {
        return new ExcelMap();
    }

    /**
     *
     * @param fileName 저장할 엑셀 파일명 - 확장자 포함
     * @return
     */
    public static ExcelMap getInstance(String fileName) {
        return new ExcelMap(fileName);
    }

    /**
     * @param fileName 저장할 엑셀 파일명 - 확장자 포함
     * @param templateName template 파일명
     * @return
     */
    public static ExcelMap getInstance(String fileName, String templateName) {
        return new ExcelMap(fileName, templateName);
    }

    public String getFileName() {
        return StringUtils.defaultString(fileName,
                this.fileName = "excel_" + Calendar.getInstance() + " .xls");
    }

    /**
     * header 부 작성 - template 사용하지 않을 경우 사용함
     * 리스트의 column의 key값과 value(헤더명)을 등록한다
     * key값은 contents부의 vo의 필드명을 작성
     * value값은 엑셀에 리스트의 헤더부의 표시될 명칭
     * @param header
     */
    public void setHeader(LinkedHashMap<String, String> header) {
        put(Excel.HEADER, header);
    }

    /**
     * VO(get set)형태로 내용부 작성
     * @param contents
     */
    public void setContents(List<? extends Object> contents) {
        put(Excel.CONTENTS, contents);
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getTemplateName() {
        return templateName;
    }

    public void setTemplateName(String templateName) {
        this.templateName = templateName;
    }

}
