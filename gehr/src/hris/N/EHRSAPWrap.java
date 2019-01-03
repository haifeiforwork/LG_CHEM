package hris.N;

/**
 * PROJ   : LGȭ�� ��ȭ
 * NAME   : EHRSAPWrap.java
 * DESC   : Sap RFC ��� ��� parameter, table�� Vector, HashMap �������� �������� ���� Ŭ����
 * Author : marco
 * VER    : v1.0
 * Copyright 2007 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                 ��    ��    ��   ��
 *------------------------------------------------------------------------------
 *    DATE          AUTHOR                      DESCRIPTION
 * ----------    ------   ---------------------------------------------------------
 * 2015.05.21       marco                       ���� ���α׷� �ۼ�
 *
 *----------------------------------------------------------------------------*
 */



import com.sap.mw.jco.JCO;
import com.sap.mw.jco.JCO.FieldIterator;
import com.sap.mw.jco.JCO.ParameterList;
import com.sap.mw.jco.JCO.Structure;
import com.sap.mw.jco.JCO.Table;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Vector;
/**
 * Sap RFC ��� ��� parameter, table�� LData�������� �������� ���� Ŭ����
 */
public class EHRSAPWrap{

    /**
     * RFC �����(���̺�, ��Ʈ��������) �� Table��, Vector( HashMap(�÷���, ����Ÿ) ) ) ���� ���� �����´�
     *
     * ���� ����
     * ��Ʈ���ĸ� ȣ��� getAllExportParameter(function) ���
     * ���̺� ȣ���  getAllExportTable(function) ���
     *
     * @param function ����Ÿ�� ������ RFC function
     * @return Vector(Table��, Vector( HashMap(�÷���, ����Ÿ) ) ) ����
     * @author marco
     *  2015. 05. 21
     */
    public static Vector getAllStruture( JCO.Function function) throws Exception {
    	Vector ldResult = new Vector();

        ldResult.add(getAllExportParameter(function));
        ldResult.add(getAllExportTable(function));

        return ldResult;
    }

    /**
     * structure ȣ��� ����Ѵ�.
     * ��� ExportParameterList�� HashMap�������� �����´�.
     * ����� HashMap(Table��, Vector( HashMap(�÷���, ����Ÿ) ) )
     * @param function ����Ÿ�� ������ RFC function
     * @return HashMap(Table��, Vector( HashMap(�÷���, ����Ÿ) ) )
     * @author marco
     *  2015. 05. 21
     */
    public static HashMap getAllExportParameter(JCO.Function function) throws Exception{
    	HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Parameter ����Ÿ�� �������� �κ� */
        ParameterList pl = function.getExportParameterList();
        int nTableSize =0;
        // null ó�� ���ش�. NullPointException�߻�
        if(pl != null)
        	nTableSize = pl.getNumFields();
        	for(int n = 0; n < nTableSize; n++) {
	            Vector vRow = new Vector();
	            HashMap<String, String> ldField = new HashMap<String, String>();
	            try{
		            Structure structure = pl.getStructure(n);

		            int nFieldSize = structure.getFieldCount();

		            for(int m = 0; m < nFieldSize; m++) {
		                com.sap.mw.jco.JCO.Field field = structure.getField(m);
		                ldField.put(field.getName(), WebUtil.nvl(field.getString()));
		            }

		            vRow.add(ldField);
		            ldResult.put(pl.getName(n), vRow);
	            } catch(JCO.ConversionException eConversion) {


	            }
	        }

        return ldResult;
    }

    /**
     * ��� Export Table�� ���� �����´�
     *
     * @param function ����Ÿ�� ������ RFC function
     * @return HashMap(Table��, Vector( HashMap(�÷���, ����Ÿ) ) ) ����
     * @throws Exception
     * @author marco
     *  2015. 05. 21
     */
    public static HashMap getAllExportTable(JCO.Function function) throws Exception{
       HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Table ����Ÿ�� �������� �κ� */
        ParameterList pl = function.getTableParameterList();
        int nTableSize = 0;
        if(pl != null) nTableSize = pl.getFieldCount();

        //��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for(int n = 0; n < nTableSize; n++) {
            Vector vRow = new Vector();
            Table table = pl.getTable(n);    //�ش����̺��� �����´�
            int nRow = table.getNumRows();   //��� �ο��
            int nCol = table.getNumFields();     //��� �÷���
            //���̺��� ����Ÿ�� �������� �κ� Vector�� �ο�(Ldata��)�� ���ʷ� �ִ´�
            for(int i = 0; i < nRow; i++) {
                HashMap<String, String> ldCol = new HashMap<String, String>();   //�ʵ��, �� �������� �ִ´�
                for(int m = 0; m < nCol; m++) {
                    ldCol.put(table.getField(m).getName(), WebUtil.nvl(table.getField(m).getString()));
                }
                vRow.add(ldCol); //�ش�ο��� ������ ���Ϳ� ��´�
                table.nextRow(); //table Cursor�� �Ѵܰ������ �ű��.
            }
            ldResult.put(pl.getName(n), vRow);    //�ش� Table��, ���̺� �����
        }
        return ldResult;
    }


//      String sResult = "";
//
//      Vector vMessage = (Vector) ldResult.get("E_RETURN");
//
//      if(vMessage != null) {
//          LData ldMessage = (LData) vMessage.get(0);
//          String sType = ldMessage.getString("TYPE");
//
//          if(!"S".equals(sType)) {
//              sResult = ldMessage.getString("MESSAGE");
//          } else sResult = "S";
//      }
//
//      return sResult;
//  }


    /**
     * Return �Ǵ� ��� Export�Ķ���� ���� ������ �´�.
     * @param function ����Ÿ�� ������ RFC function
     * @return  LData(Field��, Value)
     * @throws Exception
     * @author marco
     *  2015. 10. 06
     */
    public static HashMap getExportParameter(JCO.Function function) throws Exception{
    	HashMap<String, String> ldResult = new HashMap<String, String>();

        ParameterList pl = function.getExportParameterList();

        int nTableSize =0;

        if(pl != null)
        	nTableSize = pl.getNumFields();

        for(int n = 0; n < nTableSize; n++) {
           com.sap.mw.jco.JCO.Field field = pl.getField(n);
           ldResult.put( field.getName(), EHRCommonUtil.nullToEmpty(field.getString()));
        }

        return ldResult;
    }
//

    /**
     * �׽�Ʈ �̿Ϸ�
     * Ư�� Table(Structure)�� �ش��ϴ� ����� Vector(LData(�÷���, ����Ÿ)) ������ �����ش�
     * @param function ����Ÿ�� ������ RFC function
     * @param sStructureName  ����Ÿ�� ������ Table(Structure) ��
     * @return Vector(LData(�÷���, ����Ÿ))
     * @throws Exception
     * @author ������
     *  2007. 08. 24
     */
    public static Vector getExportTable(JCO.Function function, String sStructureName) throws Exception{
        Vector vResult = new Vector();

        /* Export Parameter ����Ÿ�� �������� �κ� */
        ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sStructureName);  //�ش� ���̺��� �����´�

        int nRow = table.getNumRows();   //��� �ο��
        int nCol = table.getNumFields();     //��� �÷���

        //���̺��� ����Ÿ�� �������� �κ� Vector�� �ο�(Ldata��)�� ���ʷ� �ִ´�
        for(int i = 0; i < nRow; i++) {

        	HashMap<String, String> ldCol = new HashMap<String, String>();   //�ʵ��, �� �������� �ִ´�

            for(int m = 0; m < nCol; m++) {
                ldCol.put(table.getField(m).getName(), table.getField(m).getString());
            }

            vResult.add(ldCol); //�ش�ο��� ������ ���Ϳ� ��´�

            table.nextRow(); //table Cursor�� �Ѵܰ������ �ű��.
        }

        return vResult;
    }

    /**
     * LData�� �Ѿ�� ������ function�� �ʵ尪�� ä���
     * function�� �����ϴ� field�� �����Ͽ� ä���
     * @param function ���� ä�� function
     * @param ldParam field���� ä�� LData
     * @throws Exception
     * @author ������
     *  2007. 09. 13
     */
    public static void setFieldForLData(JCO.Function function, Box  ldParam) throws Exception {
        java.util.Iterator iter = ldParam.keySet().iterator();

        ParameterList paramList = function.getImportParameterList();

        //LLog.info.println("[SAPWrapForLData] ========================================= ");

        while(iter.hasNext()) {
            String sKey = iter.next().toString();

            if(paramList.hasField(sKey)) {
                paramList.setValue(WebUtil.nvl(ldParam.getString(sKey)), sKey);
               // LLog.info.println("[SAPWrapForLData] input field : " + sKey + " = " + WebUtil.nvl(ldParam.getString(sKey)));
            }
        }
       // LLog.info.println("[SAPWrapForLData] ========================================= ");

    }

    /**
     * LMultiData�� �Ѿ�� ���� function table�� field�� ��� ä���
     * @param function ���� ä�� function
     * @param lMultiData field, table�� ä�� function
     * @throws Exception
     *  2007. 11. 05
     *  @author ������
     */
//    public static void setAllDataForLMultiData (JCO.Function function,Box lMultiData) throws Exception {
//        EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//        EHRSAPWrap.setTableForLMultiData(function, lMultiData);
//    }
    /**
     * LMultiData�� �Ѿ�� ���� function table�� field�� ��� ä���
     * @param function ���� ä�� function
     * @param lMultiData field, table�� ä�� function
     * @throws Exception
     *  2007. 11. 05
     *  @author ������
     */
//    public static void setAllDataForLMultiData (JCO.Function function,Box lMultiData, String sLikeTableName) throws Exception {
//        EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//        EHRSAPWrap.setTableForLMultiData(function, lMultiData, sLikeTableName);
//    }

    /**
     * Box�� �Ѿ�� ������ function �ʵ尪�� ä���
     * @param function ���� ä�� function
     * @param lMultiData field���� ä�� LMultiData
     * @throws Exception
     * @author marco257
     *  2015. 05. 21
     */
    public static void setFieldForLMultiData(JCO.Function function,Box lMultiData) throws Exception {
        //java.util.Iterator iter = ldParam.keySet().iterator();

        ParameterList paramList = function.getImportParameterList();    //function param list�� �����´�
        FieldIterator iter = paramList.fields();

       // LLog.info.println("[setFieldForLMultiData] ========================================= ");
        //field�� loop�� ���� �ش� �ʵ带 �ִ´�
        while(iter.hasNextFields()) {
            com.sap.mw.jco.JCO.Field field = iter.nextField();
            String sFieldName = field.getName();
            String sValue = "";
            if(lMultiData.containsKey(sFieldName)) {
                sValue = WebUtil.nvl(lMultiData.getString(sFieldName));    //field�� �Ѱ��̹Ƿ� LMultiData�� Ű�� ù��°������ �����´�

                paramList.setValue(sValue, sFieldName);
                Logger.debug("[setFieldForLMultiData] input field : " + sFieldName + " = " + sValue);
            }
        }
        //LLog.info..info.println("[setFieldForLMultiData] ========================================= ");
    }

    /**
     * Ư�� table �� Ư�� �ʵ带  �����ؼ� insert�Ѵ�.
     * long Text �� ���
     * rfc function �� ��� ���̺� ������ ���ش�
     * @param function rfc function name
     * @param sLikeTableName �ش��̸��� �����ϴ� ���̺� ���� �Է��Ѵ�.
     * @throws Exception
     * @author marco
     *  2015. 05. 28
     */
    public static void setInsertTable(JCO.Function function,Vector  vtData, String sLikeTableName, String fieldName) throws Exception {
        /* Export Table ����Ÿ�� �������� �κ� */
    	HashMap<String, Object> hashtable = new HashMap<String, Object >();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); //���̺� ũ��

        //��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for(int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    //�ش����̺��� �����´�
            String sTableName = pl.getName(n);
            if(sTableName.indexOf(sLikeTableName) > -1) {  //���̺���� ������ ���� �����Ѵٸ�
                int nRowSize = vtData.size(); //���ذ��� ���̸� �������� �ο����� �ȴ�

               // //LLog.info..info.println("\n[setTableForLMultiData]   Set Table [" + pl.getName(n) + "]" + sPointField + "  Size " + nRowSize);
                for(int nRow = 0; nRow < nRowSize; nRow++) {
                   // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  //���̺� row�� �߰�����
                    hashtable = (HashMap)vtData.get(nRow);
                    String sValue = WebUtil.nvl((String)hashtable.get(fieldName));
                    Logger.debug("sValue : " + sValue);
                    table.setValue(sValue, fieldName);


                }

                //��� ���̺��� �����Ѵ�
                pl.setValue(table, pl.getName(n));
            }
        }
        ////LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * Ư�� Table�� insert�Ѵ�.
     * @param function
     * @param vtData
     * @param sLikeTableName
     * @throws Exception
     */
    public static void setTableForLMultiData(JCO.Function function,Vector  vtData, String sLikeTableName) throws Exception {
        /* Export Table ����Ÿ�� �������� �κ� */
    	HashMap<String, Object> hashtable = new HashMap<String, Object >();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); //���̺� ũ��

        //��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for(int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    //�ش����̺��� �����´�
            String sTableName = pl.getName(n);
            if(sTableName.indexOf(sLikeTableName) > -1) {  //���̺���� ������ ���� �����Ѵٸ�
                int nRowSize = vtData.size(); //���ذ��� ���̸� �������� �ο����� �ȴ�

               // //LLog.info..info.println("\n[setTableForLMultiData]   Set Table [" + pl.getName(n) + "]" + sPointField + "  Size " + nRowSize);
                for(int nRow = 0; nRow < nRowSize; nRow++) {
                   // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  //���̺� row�� �߰�����
                    hashtable = (HashMap)vtData.get(nRow);

                    FieldIterator iter = table.fields();
                    while(iter.hasNextFields()){
                      com.sap.mw.jco.JCO.Field field = iter.nextField();
                      String sFieldName = field.getName();
                      String sValue = "";

                      if(hashtable.containsKey(sFieldName))
                          sValue = WebUtil.nvl((String)hashtable.get(sFieldName));

                      /*
                       * table�� �ʵ忡 �ش��ϴ� ���� ��������
                       * null ���� �����Ѵ�
                       */
                      table.setValue(sValue, sFieldName);
                     // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
                  }
              }
            }

           //��� ���̺��� �����Ѵ�
           pl.setValue(table, pl.getName(n));

        }
        ////LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * JDF���� �����ϴ� Box�� jco�� �̿��Ͽ� ���̺� insert�� �ش�
     * rfc function �� ��� ���̺� ������ ���ش�
     * @param function rfc function name
     * @param lMultiData request�� �Ѿ�� LMulitData
     * @throws Exception
     * @author marco257
     *  2015. 05.28
     */
//    public static void setTableForLMultiData(JCO.Function function,Box box) throws Exception {
//        /* Export Table ����Ÿ�� �������� �κ� */
//        ParameterList pl = function.getTableParameterList();
//        int nTableSize = pl.getFieldCount(); //���̺� ũ��
//
//       // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
//
//        //��� ���̺� �� ��ŭ ������ ���� ����� ��������
//        for(int n = 0; n < nTableSize; n++) {
//
//            Table table = pl.getTable(n);    //�ش����̺��� �����´�
//
//            String sPointField = table.getField(0).getName();   //���̺��� ù��° �ʵ带 ���ذ����� �Ѵ�
//            int nRowSize = box.gets(sPointField); //���ذ��� ���̸� �������� �ο����� �ȴ�
//
//           // //LLog.info..info.println("\n[setTableForLMultiData]   Set Table [" + pl.getName(n) + "] Size " + nRowSize);
//            for(int nRow = 0; nRow < nRowSize; nRow++) {
//                ////LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
//                table.appendRow();  //���̺� row�� �߰�����
//
//                FieldIterator iter = table.fields();
//
//                while(iter.hasNextFields()){
//                    com.sap.mw.jco.JCO.Field field = iter.nextField();
//                    String sFieldName = field.getName();
//                    String sValue = "";
//
//                    if(lMultiData.containsKey(sFieldName))
//                        sValue = WebUtil.nvl(lMultiData.getString(sFieldName, nRow));
//
//                    /*
//                     * table�� �ʵ忡 �ش��ϴ� ���� ��������
//                     * null ���� �����Ѵ�
//                     */
//                    table.setValue(sValue, sFieldName);
//                   // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
//                }
//            }
//
//            //��� ���̺��� �����Ѵ�
//            pl.setValue(table, pl.getName(n));
//        }
//       // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
//    }



    /**
     * R3�� table�ȿ� ���Ե� structure�� �ƴ� import�Ķ������ structure ����
     * Changing ������ ����
     * @param function
     * @param lMultiData
     * @throws Exception
     * marco257
     * 2015. 05. 29
     */
    public static void setImportStructureMultiData(JCO.Function function,Box lMultiData, String struName) throws Exception {

        ParameterList pl = function.getImportParameterList();
    	JCO.Structure structure = pl.getStructure(struName);
        int nTableSize = structure.getFieldCount(); //���̺� ũ��

        //��� ���̺� �� ��ŭ ������ ���� ����� ��������
        for(int n = 0; n < nTableSize; n++) {
            String  sFieldName = structure.getField(n).getName();

            if(lMultiData.containsKey(sFieldName)){
            	structure.setValue( WebUtil.nvl(lMultiData.getString(sFieldName)) , sFieldName);
        	}
        }
        function.getImportParameterList().setValue(structure, struName);
    }




    /**
     * LData�� �ִ� ������ �ش� Ŭ������ ä�� �Ѱ��ش�
     * param������ �Ѿ�� LData�� ������ �����ؼ� �Ѿ�� Ŭ������ ����Ÿ ���� �Է� ��
     * �ش� Class�� �Ѱ��ش�
     * @param ldParam EntityClass�� ������ LData
     * @param sClassName ����� �Ѱܹ��� Class
     * @return
     * @author ������
     *  2007. 09. 07
     */
    public static Object getLDataToClass(Box ldParam, String sClassName) throws Exception{
        Object obj = null;

        try{
            Class klass = Class.forName(sClassName);    //�ش� Ŭ������������
            obj = klass.newInstance();                            //��ü ����
            Field[] fields = klass.getFields();                    //�ش� Ŭ�������� �ʵ尡������

            for(int n = 0; n < fields.length; n++) {
                Field field = fields[n];
                String sValue = ldParam.getString(field.getName());

                //���� LData�� �ش� ���� �������� ������ �ʵ尪�� ü���� �ʴ´�
                if( !"".equals(WebUtil.nvl(sValue)) )
                    field.set(obj, sValue);
            }
        } catch(Exception e) {
            //LLog.info..err.println("[ SAPWrapForLData.getLDataToClass ERROR ] Class �ۼ��� ���� : Ŭ������ Ȯ��");
            throw new Exception(e);
        }

        return obj;
    }

    /**
     *  LData�� �ִ� ������ �ش� Ŭ������ ä�� �Ѱ��ش�
     * param������ �Ѿ�� LData�� ������ �����ؼ� �Ѿ�� Ŭ������ ����Ÿ ���� �Է� ��
     * Ŭ������ ���� ��ü�� �����Ͽ� Vector(��ü�迭)�� �Ѱ��ش�
     * ldParam���� �ִ� ���� �ش� Ŭ�������� �ʵ忡 �����Ѵ�
     * @param ldParam   EntityClass�� ������ LData
     * @param vClassName ����� �Ѱܹ��� Class�迭 �ߺ��� Ŭ�������� �Ѱ��� ��ȯ�ȴ�
     * @return  sClassName�� �ش��ϴ� ��ü Map
     * @throws Exception
     * @author ������
     *  2007. 09. 07
     */
//    public static LData getLDataToClasses(Box ldParam, Vector vClassName) throws Exception {
//        HashMap<String, String> ldResult = new HashMap<String, String>();  //�����
//
//        for(int n = 0; n < vClassName.size(); n++) {
//            try {   //�߰� Ŭ������ �����ص� ����� �Ѱ��ش�
//                ldResult.put(vClassName.get(n), getLDataToClass(ldParam, vClassName.get(n).toString()));
//            }catch(Exception e){
////                //LLog.info..err.println(e.getMessage());
//            }
//        }
//
//        return ldResult;
//    }

    /**
     * sap�� raw�� ����� file download
     * @param function function
     * @param sTableName table��
     * @param sFieldName raw�� ������ �ʵ��
     * @param sFilePath ���� ������(���ϸ� ����) ex( c:\\test.txt)
     * @return ����� ���� ��� req�� �Ѿ�� sFilePath ���н� ""
     * @author ������
     *  2007. 12. 07
     */
    public static String downFileFromSap(JCO.Function function, String sTableName, String sFieldName, String sFilePath) {
        String sResult = sFilePath;
        ////LLog.info..debug.println("sFilePath : " + sFilePath);
        ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sTableName);    //�ش����̺��� �����´�

        int nRow = table.getNumRows();         //��� �ο��
        //int nCol = table.getNumFields();     //��� �÷���
        File file = null;

        BufferedInputStream bin = null;     //BufferedInputStream
        BufferedOutputStream bout = null;   //BufferedOutputStream
        try{

            //��ΰ� ���� ��� ����
        	String sDir = "";
        	try{
        		sDir = sFilePath.substring(0, sFilePath.lastIndexOf("\\"));
        	} catch(Exception e) {
        		sDir = sFilePath.substring(0, sFilePath.lastIndexOf("/"));
        	}

            File fDir = new File(sDir);

            //�������� 1�� ����
            if( !fDir.getAbsolutePath().equals(fDir.getCanonicalPath())){
            	try {
            		throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
            	} catch (Exception e) {
            		Logger.debug.println(e.getMessage());
            	}
            }
            ////LLog.info..debug.println("[SAPWrapForLData] sFilePath : " + sFilePath + " read : " + fDir.canRead() + " write : " + fDir.canWrite());
            fDir.mkdirs();

            file = new File(sFilePath);

            //�������� 1�� ����
            if( !file.getAbsolutePath().equals(file.getCanonicalPath())){
            	try {
            		throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
            	} catch (Exception e) {
            		Logger.debug.println(e.getMessage());
            	}
            }



            bout = new BufferedOutputStream(new FileOutputStream(file));

            //���̺��� ����Ÿ�� �������� �κ� Vector�� �ο�(Ldata��)�� ���ʷ� �ִ´�
            for(int i = 0; i < nRow; i++) {
                com.sap.mw.jco.JCO.Field field = table.getField(sFieldName);

                bin = new BufferedInputStream(field.getBinaryStream());

                int n = 0;
                while((n = bin.read()) > -1) {
                    //sb.append(n);
                    bout.write(n);
                }

                bin.close();

                table.nextRow(); //table Cursor�� �Ѵܰ������ �ű��.
            }

        } catch (Exception e) {
            sResult = "";

            if(file.exists()) {
                file.delete();
            }

           ////LLog.info..debug.println("[ SAPWrapForLData.downFileFromSap ERROR ] FILE Download Fail \n" + e.getMessage());
        } finally {

            if(bout != null) {
                try{
                    bout.close();
                    bin.close();
                } catch (Exception ex) {}
            }
            if(bout != null) {
                try{
                    bout.close();
                    bin.close();
                } catch (Exception ex) {}
            }
        }

        return sResult;
    }


    /**
     * getAllStructure�� ������ ��ü ����Ÿ �� �޼��� ó��
     * @param ldResult �����ϰ�� S, �����ϰ�� ���и޼���
     * @return
     * @author marco257
     *  2015. 05. 21
     */
//    public static String getReturnMessage(Vector ldResult) {
//        String sResult = "";
//
//        HashMap vMessage = (HashMap) ldResult.("RETURN");
//
//        if(vMessage != null) {
//            LData ldMessage = (LData) vMessage.get(0);
//            String sType = ldMessage.getString("TYPE");
//
//            if(!"S".equals(sType)) {
//                sResult = ldMessage.getString("MESSAGE");
//            } else sResult = "S";
//        }
//
//        return sResult;
//    }

    /**
     * getAllStructure�� ������ ��ü ����Ÿ �� �޼��� ó��
     * @param ldResult �����ϰ�� S, �����ϰ�� ���и޼���
     * @return
     * @author ������
     *  2007. 12. 20
     */
//    public static String getEReturnEMessage(LData ldResult) {
//        String sResult = "";
//
//        Vector vMessage = (Vector) ldResult.get("E_RETURN");
//
//        if(vMessage != null) {
//            LData ldMessage = (LData) vMessage.get(0);
//            String sType = ldMessage.getString("TYPE");
//
//            if(!"S".equals(sType)) {
//                sResult = ldMessage.getString("MESSAGE");
//            } else sResult = "S";
//        }
//
//        return sResult;
//    }

}


