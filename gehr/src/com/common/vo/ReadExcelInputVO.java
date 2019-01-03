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
     * Excel을 읽기 위한 기본 정보 등록
     * @param startRow  엑셀에 몇번째 row부터 읽을 것인지 시작은 0
     * @param clazz     row를 등록할 Entity class
     * @param columnNameList    Entity class의 컬럼명 을 엑셀에 컬럼 순서대로 - 엑셀과 Entity를 mapping하기 위한 작업
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
