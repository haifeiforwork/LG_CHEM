package com.common.vo;

import org.apache.commons.fileupload.disk.DiskFileItem;

import java.util.List;

/**
 * Created by manyjung on 2016-07-15.
 */
public class ReadExcelInputVO extends BaseVO {

    private int startRow = 0;
    private Class clazz;
    private List<String> columnNameList;
    private DiskFileItem file;

    /**
     * Excel�� �б� ���� �⺻ ���� ���
     * @param startRow  ������ ���° row���� ���� ������ ������ 0
     * @param clazz     row�� ����� Entity class
     * @param columnNameList    Entity class�� �÷��� �� ������ �÷� ������� - ������ Entity�� mapping�ϱ� ���� �۾�
     */
    public ReadExcelInputVO(DiskFileItem file, Class clazz, List<String> columnNameList, int startRow) {
        this.startRow = startRow;
        this.clazz = clazz;
        this.columnNameList = columnNameList;
        this.file = file;
    }

    public Class getClazz() {
        return clazz;
    }

    public void setClazz(Class clazz) {
        this.clazz = clazz;
    }

    public int getStartRow() {
        return startRow;
    }

    public void setStartRow(int startRow) {
        this.startRow = startRow;
    }

    public List<String> getColumnNameList() {
        return columnNameList;
    }

    public void setColumnNameList(List<String> columnNameList) {
        this.columnNameList = columnNameList;
    }

    public DiskFileItem getFile() {
        return file;
    }

    public void setFile(DiskFileItem file) {
        this.file = file;
    }
}
