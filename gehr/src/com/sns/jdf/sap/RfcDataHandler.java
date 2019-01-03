/********************************************************************************/
/*   System Name  : 
/*   1Depth Name  : 
/*   2Depth Name  : 
/*   Program Name : 
/*   Program ID   : RfcDataHandler.java
/*   Description  : 
/*   Note         : 
/*   Creation     : [WorkTime52] 2018-05-04 유정우
/*   Update       : 
/********************************************************************************/

package com.sns.jdf.sap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.ObjectUtils;

import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.Field;
import com.sap.mw.jco.JCO.FieldIterator;
import com.sap.mw.jco.JCO.Function;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Table;

public class RfcDataHandler {

    private RfcDataHandler() {}

    /**
     * Import parameter data 입력
     * 
     * @param function
     * @param importData
     */
    public static void setImportData(Function function, Map<String, Object> importData) {

        if (MapUtils.isEmpty(importData)) return;

        ParameterList importParamList = function.getImportParameterList();
        for (String fieldName : importData.keySet()) {
            if (importParamList.hasField(fieldName)) {
                importParamList.setValue(ObjectUtils.toString(importData.get(fieldName)), fieldName);
            }
        }
    }

    /**
     * Tables parameter data 입력
     * 
     * @param function
     * @param tableData
     */
    public static void setTablesData(Function function, Map<String, List<Map<String, Object>>> tableData) {

        if (MapUtils.isEmpty(tableData)) return;

    	for (String tableName : tableData.keySet()) {
    		setTableData(function, tableName, tableData.get(tableName));
    	}
    }

    /**
     * Table parameter data 입력
     * 
     * @param function
     * @param tableName
     * @param tableData
     */
    public static void setTableData(Function function, String tableName, List<Map<String, Object>> tableData) {

        if (CollectionUtils.isEmpty(tableData)) return;

		Table table = function.getTableParameterList().getTable(tableName);

		if (table == null) return;

		int i = 0;
		table.appendRows(tableData.size());
		for (Map<String, Object> rowData : tableData) {
			table.setRow(i++);
			for (String fieldName : rowData.keySet()) {
			    if (table.hasField(fieldName)) {
			        table.setValue(ObjectUtils.toString(rowData.get(fieldName)), fieldName);
			    }
			}
		}
    }

    /**
     * Export parameter data 추출
     * 
     * @param function
     * @return
     */
    public static Map<String, Object> getExportData(Function function) {

    	Map<String, Object> exportData = new HashMap<String, Object>();

    	ParameterList exportParamList = function.getExportParameterList();
        if (exportParamList != null) {
            FieldIterator exportFields = exportParamList.fields();
            while (exportFields.hasNextFields()) {
            	Field exportField = exportFields.nextField();
                exportData.put(exportField.getName(), exportField.getType() == JCO.TYPE_STRUCTURE ? getStructureData(exportField) : exportField.getString());
            }
        }

        return exportData;
    }

    /**
     * Tables parameter data 추출
     * 
     * @param function
     * @return
     */
    public static Map<String, List<Map<String, Object>>> getTablesData(Function function) {

    	Map<String, List<Map<String, Object>>> tableData = new HashMap<String, List<Map<String, Object>>>();

    	ParameterList tableParamList = function.getTableParameterList();
        if (tableParamList != null) {
            FieldIterator tableFields = tableParamList.fields();
            while (tableFields.hasNextFields()) {
            	Field tableField = tableFields.nextField();
            	tableData.put(tableField.getName(), getTableData(tableField));
            }
        }

        return tableData;
    }

    /**
     * E_RETURN Export structure로 부터 RFC 호출 성공여부를 판단하여 return
     *  
     * @param rfcResultData
     * @return
     */
    public static boolean isSuccess(Map<String, Object> rfcResultData) {

        if (MapUtils.isEmpty(rfcResultData) || !rfcResultData.containsKey("EXPORT")) {
            return false;
        }

        Map<String, Object> exportData = (Map<String, Object>) rfcResultData.get("EXPORT");
        if (MapUtils.isEmpty(exportData) || !exportData.containsKey("E_RETURN")) {
            return false;
        }

        Map<String, Object> eReturn = (Map<String, Object>) exportData.get("E_RETURN");
        if (!eReturn.containsKey("MSGTY") || "E".equals((String) eReturn.get("MSGTY"))) {
            return false;
        }

        return true;
    }

    /**
     * E_RETURN Export structure로 부터 message를 추출
     * 
     * @param rfcResultData
     * @return
     */
    public static String getMessage(Map<String, Object> rfcResultData) {

        if (MapUtils.isEmpty(rfcResultData) || !rfcResultData.containsKey("EXPORT")) {
            return null;
        }

        Map<String, Object> exportData = (Map<String, Object>) rfcResultData.get("EXPORT");
        if (MapUtils.isEmpty(exportData) || !exportData.containsKey("E_RETURN")) {
            return null;
        }

        Map<String, Object> eReturn = (Map<String, Object>) exportData.get("E_RETURN");
        if (!eReturn.containsKey("MSGTX")) {
            return null;
        }

        return (String) eReturn.get("MSGTX");
    }

    /**
     * Export structure parameter data 추출
     * 
     * @param field Structure field
     * @return
     */
    private static Map<String, Object> getStructureData(Field field) {

    	Map<String, Object> structureData = new HashMap<String, Object>();

		FieldIterator structureFields = field.getStructure().fields();
        while (structureFields.hasNextFields()) {
        	Field structureField = structureFields.nextField();
        	structureData.put(structureField.getName(), structureField.getString());
        }

        return structureData;
    }

    /**
     * Table parameter data 추출
     * 
     * @param field Table field
     * @return
     */
    private static List<Map<String, Object>> getTableData(Field field) {

    	List<Map<String, Object>> tableData = new ArrayList<Map<String, Object>>();

    	Table table = field.getTable();
    	if (table != null && !table.isEmpty()) {
	    	List<String> fieldNameList = new ArrayList<String>();
	    	FieldIterator rowFields = table.fields();
	        while (rowFields.hasNextFields()) {
	        	fieldNameList.add(rowFields.nextField().getName());
	        }

    		int rowCount = table.getNumRows();
    		for (int i = 0; i < rowCount; i++) {
    			table.setRow(i);

    			Map<String, Object> rowData = new HashMap<String, Object>();
    			for (String fieldName : fieldNameList) {
    				rowData.put(fieldName, table.getString(fieldName));
    			}

    			tableData.add(rowData);
    		}
    	}

        return tableData;
    }

}