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
     * @param fileName ������ ���� ���ϸ� - Ȯ���� ����
     * @return
     */
    public static ExcelMap getInstance(String fileName) {
        return new ExcelMap(fileName);
    }

    /**
     * @param fileName ������ ���� ���ϸ� - Ȯ���� ����
     * @param templateName template ���ϸ�
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
     * header �� �ۼ� - template ������� ���� ��� �����
     * ����Ʈ�� column�� key���� value(�����)�� ����Ѵ�
     * key���� contents���� vo�� �ʵ���� �ۼ�
     * value���� ������ ����Ʈ�� ������� ǥ�õ� ��Ī
     * @param header
     */
    public void setHeader(LinkedHashMap<String, String> header) {
        put(Excel.HEADER, header);
    }

    /**
     * VO(get set)���·� ����� �ۼ�
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
