package hris.N;

/**
 * PROJ   : LG화학 고도화
 * NAME   : EHRSAPWrap.java
 * DESC   : Sap RFC 결과 모든 parameter, table를 Vector, HashMap 형식으로 가져오기 위한 클래스
 * Author : marco
 * VER    : v1.0
 * Copyright 2007 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                 변    경    사   항
 *------------------------------------------------------------------------------
 *    DATE          AUTHOR                      DESCRIPTION
 * ----------    ------   ---------------------------------------------------------
 * 2015.05.21       marco                       최초 프로그램 작성
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
 * Sap RFC 결과 모든 parameter, table를 LData형식으로 가져오기 위한 클래스
 */
public class EHRSAPWrap{

    /**
     * RFC 모든결과(테이블, 스트럭쳐포함) 를 Table명, Vector( HashMap(컬럼명, 데이타) ) ) 형식 으로 가져온다
     *
     * 참고 사항
     * 스트럭쳐만 호출시 getAllExportParameter(function) 사용
     * 테이블 호출시  getAllExportTable(function) 사용
     *
     * @param function 데이타를 가져오 RFC function
     * @return Vector(Table명, Vector( HashMap(컬럼명, 데이타) ) ) 형식
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
     * structure 호출시 사용한다.
     * 모드 ExportParameterList를 HashMap형식으로 가져온다.
     * 결과는 HashMap(Table명, Vector( HashMap(컬럼명, 데이타) ) )
     * @param function 데이타를 가져오 RFC function
     * @return HashMap(Table명, Vector( HashMap(컬럼명, 데이타) ) )
     * @author marco
     *  2015. 05. 21
     */
    public static HashMap getAllExportParameter(JCO.Function function) throws Exception{
    	HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Parameter 데이타를 가져오는 부분 */
        ParameterList pl = function.getExportParameterList();
        int nTableSize =0;
        // null 처리 해준다. NullPointException발생
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
     * 모든 Export Table의 값을 가져온다
     *
     * @param function 데이타를 가져오 RFC function
     * @return HashMap(Table명, Vector( HashMap(컬럼명, 데이타) ) ) 형식
     * @throws Exception
     * @author marco
     *  2015. 05. 21
     */
    public static HashMap getAllExportTable(JCO.Function function) throws Exception{
       HashMap<String, Vector> ldResult = new HashMap<String, Vector>();
        /* Export Table 데이타를 가져오는 부분 */
        ParameterList pl = function.getTableParameterList();
        int nTableSize = 0;
        if(pl != null) nTableSize = pl.getFieldCount();

        //결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for(int n = 0; n < nTableSize; n++) {
            Vector vRow = new Vector();
            Table table = pl.getTable(n);    //해당테이블을 가져온다
            int nRow = table.getNumRows();   //결과 로우수
            int nCol = table.getNumFields();     //결과 컬럼수
            //테이블에서 데이타를 가져오는 부분 Vector에 로우(Ldata형)를 차례로 넣는다
            for(int i = 0; i < nRow; i++) {
                HashMap<String, String> ldCol = new HashMap<String, String>();   //필드명, 값 형식으로 넣는다
                for(int m = 0; m < nCol; m++) {
                    ldCol.put(table.getField(m).getName(), WebUtil.nvl(table.getField(m).getString()));
                }
                vRow.add(ldCol); //해당로우의 값들을 벡터에 담는다
                table.nextRow(); //table Cursor를 한단계앞으로 옮긴다.
            }
            ldResult.put(pl.getName(n), vRow);    //해당 Table명, 테이블 결과값
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
     * Return 되는 모든 Export파라미터 값을 가지고 온다.
     * @param function 데이타를 가져오 RFC function
     * @return  LData(Field명, Value)
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
     * 테스트 미완료
     * 특정 Table(Structure)에 해당하는 결과를 Vector(LData(컬럼명, 데이타)) 형으로 돌려준다
     * @param function 데이타를 가져오 RFC function
     * @param sStructureName  데이타를 가져올 Table(Structure) 명
     * @return Vector(LData(컬럼명, 데이타))
     * @throws Exception
     * @author 정진만
     *  2007. 08. 24
     */
    public static Vector getExportTable(JCO.Function function, String sStructureName) throws Exception{
        Vector vResult = new Vector();

        /* Export Parameter 데이타를 가져오는 부분 */
        ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sStructureName);  //해당 테이블을 가져온다

        int nRow = table.getNumRows();   //결과 로우수
        int nCol = table.getNumFields();     //결과 컬럼수

        //테이블에서 데이타를 가져오는 부분 Vector에 로우(Ldata형)를 차례로 넣는다
        for(int i = 0; i < nRow; i++) {

        	HashMap<String, String> ldCol = new HashMap<String, String>();   //필드명, 값 형식으로 넣는다

            for(int m = 0; m < nCol; m++) {
                ldCol.put(table.getField(m).getName(), table.getField(m).getString());
            }

            vResult.add(ldCol); //해당로우의 값들을 벡터에 담는다

            table.nextRow(); //table Cursor를 한단계앞으로 옮긴다.
        }

        return vResult;
    }

    /**
     * LData로 넘어온 값들을 function의 필드값에 채운다
     * function에 존재하는 field만 선택하여 채운다
     * @param function 값을 채울 function
     * @param ldParam field값을 채울 LData
     * @throws Exception
     * @author 정진만
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
     * LMultiData로 넘어온 값들 function table과 field에 모두 채운다
     * @param function 값을 채울 function
     * @param lMultiData field, table을 채울 function
     * @throws Exception
     *  2007. 11. 05
     *  @author 정진만
     */
//    public static void setAllDataForLMultiData (JCO.Function function,Box lMultiData) throws Exception {
//        EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//        EHRSAPWrap.setTableForLMultiData(function, lMultiData);
//    }
    /**
     * LMultiData로 넘어온 값들 function table과 field에 모두 채운다
     * @param function 값을 채울 function
     * @param lMultiData field, table을 채울 function
     * @throws Exception
     *  2007. 11. 05
     *  @author 정진만
     */
//    public static void setAllDataForLMultiData (JCO.Function function,Box lMultiData, String sLikeTableName) throws Exception {
//        EHRSAPWrap.setFieldForLMultiData(function, lMultiData);
//        EHRSAPWrap.setTableForLMultiData(function, lMultiData, sLikeTableName);
//    }

    /**
     * Box로 넘어온 값들을 function 필드값에 채운다
     * @param function 값을 채울 function
     * @param lMultiData field값을 채울 LMultiData
     * @throws Exception
     * @author marco257
     *  2015. 05. 21
     */
    public static void setFieldForLMultiData(JCO.Function function,Box lMultiData) throws Exception {
        //java.util.Iterator iter = ldParam.keySet().iterator();

        ParameterList paramList = function.getImportParameterList();    //function param list를 가져온다
        FieldIterator iter = paramList.fields();

       // LLog.info.println("[setFieldForLMultiData] ========================================= ");
        //field를 loop를 돌아 해당 필드를 넣는다
        while(iter.hasNextFields()) {
            com.sap.mw.jco.JCO.Field field = iter.nextField();
            String sFieldName = field.getName();
            String sValue = "";
            if(lMultiData.containsKey(sFieldName)) {
                sValue = WebUtil.nvl(lMultiData.getString(sFieldName));    //field는 한개이므로 LMultiData의 키중 첫번째값만을 가져온다

                paramList.setValue(sValue, sFieldName);
                Logger.debug("[setFieldForLMultiData] input field : " + sFieldName + " = " + sValue);
            }
        }
        //LLog.info..info.println("[setFieldForLMultiData] ========================================= ");
    }

    /**
     * 특정 table 에 특정 필드를  지정해서 insert한다.
     * long Text 시 사용
     * rfc function 에 모든 테이블에 셋팅을 해준다
     * @param function rfc function name
     * @param sLikeTableName 해당이름을 포함하는 테이블 만을 입력한다.
     * @throws Exception
     * @author marco
     *  2015. 05. 28
     */
    public static void setInsertTable(JCO.Function function,Vector  vtData, String sLikeTableName, String fieldName) throws Exception {
        /* Export Table 데이타를 가져오는 부분 */
    	HashMap<String, Object> hashtable = new HashMap<String, Object >();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); //테이블 크기

        //결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for(int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    //해당테이블을 가져온다
            String sTableName = pl.getName(n);
            if(sTableName.indexOf(sLikeTableName) > -1) {  //테이블명을 포함한 값이 존재한다면
                int nRowSize = vtData.size(); //기준값의 길이를 가져오자 로우사이즈가 된다

               // //LLog.info..info.println("\n[setTableForLMultiData]   Set Table [" + pl.getName(n) + "]" + sPointField + "  Size " + nRowSize);
                for(int nRow = 0; nRow < nRowSize; nRow++) {
                   // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  //테이블 row를 추가하자
                    hashtable = (HashMap)vtData.get(nRow);
                    String sValue = WebUtil.nvl((String)hashtable.get(fieldName));
                    Logger.debug("sValue : " + sValue);
                    table.setValue(sValue, fieldName);


                }

                //결과 테이블을 셋팅한다
                pl.setValue(table, pl.getName(n));
            }
        }
        ////LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * 특정 Table에 insert한다.
     * @param function
     * @param vtData
     * @param sLikeTableName
     * @throws Exception
     */
    public static void setTableForLMultiData(JCO.Function function,Vector  vtData, String sLikeTableName) throws Exception {
        /* Export Table 데이타를 가져오는 부분 */
    	HashMap<String, Object> hashtable = new HashMap<String, Object >();
        ParameterList pl = function.getTableParameterList();
        int nTableSize = pl.getFieldCount(); //테이블 크기

        //결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for(int n = 0; n < nTableSize; n++) {

            Table table = pl.getTable(n);    //해당테이블을 가져온다
            String sTableName = pl.getName(n);
            if(sTableName.indexOf(sLikeTableName) > -1) {  //테이블명을 포함한 값이 존재한다면
                int nRowSize = vtData.size(); //기준값의 길이를 가져오자 로우사이즈가 된다

               // //LLog.info..info.println("\n[setTableForLMultiData]   Set Table [" + pl.getName(n) + "]" + sPointField + "  Size " + nRowSize);
                for(int nRow = 0; nRow < nRowSize; nRow++) {
                   // //LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
                    table.appendRow();  //테이블 row를 추가하자
                    hashtable = (HashMap)vtData.get(nRow);

                    FieldIterator iter = table.fields();
                    while(iter.hasNextFields()){
                      com.sap.mw.jco.JCO.Field field = iter.nextField();
                      String sFieldName = field.getName();
                      String sValue = "";

                      if(hashtable.containsKey(sFieldName))
                          sValue = WebUtil.nvl((String)hashtable.get(sFieldName));

                      /*
                       * table에 필드에 해당하는 값을 셋팅하자
                       * null 값은 제거한다
                       */
                      table.setValue(sValue, sFieldName);
                     // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
                  }
              }
            }

           //결과 테이블을 셋팅한다
           pl.setValue(table, pl.getName(n));

        }
        ////LLog.info..info.println("[setTableForLMultiData] ========================================= ");
    }

    /**
     * JDF에서 제공하는 Box와 jco를 이용하여 테이블에 insert해 준다
     * rfc function 에 모든 테이블에 셋팅을 해준다
     * @param function rfc function name
     * @param lMultiData request로 넘어온 LMulitData
     * @throws Exception
     * @author marco257
     *  2015. 05.28
     */
//    public static void setTableForLMultiData(JCO.Function function,Box box) throws Exception {
//        /* Export Table 데이타를 가져오는 부분 */
//        ParameterList pl = function.getTableParameterList();
//        int nTableSize = pl.getFieldCount(); //테이블 크기
//
//       // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
//
//        //결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
//        for(int n = 0; n < nTableSize; n++) {
//
//            Table table = pl.getTable(n);    //해당테이블을 가져온다
//
//            String sPointField = table.getField(0).getName();   //테이블의 첫번째 필드를 기준값으로 한다
//            int nRowSize = box.gets(sPointField); //기준값의 길이를 가져오자 로우사이즈가 된다
//
//           // //LLog.info..info.println("\n[setTableForLMultiData]   Set Table [" + pl.getName(n) + "] Size " + nRowSize);
//            for(int nRow = 0; nRow < nRowSize; nRow++) {
//                ////LLog.info..info.println("[setTableForLMultiData] " + nRow +" Row ----------------------------------------- ");
//                table.appendRow();  //테이블 row를 추가하자
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
//                     * table에 필드에 해당하는 값을 셋팅하자
//                     * null 값은 제거한다
//                     */
//                    table.setValue(sValue, sFieldName);
//                   // //LLog.info..info.println("[setTableForLMultiData] [" + pl.getName(n) + "] setField [" + sFieldName + "] = " + sValue);
//                }
//            }
//
//            //결과 테이블을 셋팅한다
//            pl.setValue(table, pl.getName(n));
//        }
//       // //LLog.info..info.println("[setTableForLMultiData] ========================================= ");
//    }



    /**
     * R3의 table안에 포함된 structure가 아닌 import파라미터의 structure 셋팅
     * Changing 구조에 적용
     * @param function
     * @param lMultiData
     * @throws Exception
     * marco257
     * 2015. 05. 29
     */
    public static void setImportStructureMultiData(JCO.Function function,Box lMultiData, String struName) throws Exception {

        ParameterList pl = function.getImportParameterList();
    	JCO.Structure structure = pl.getStructure(struName);
        int nTableSize = structure.getFieldCount(); //테이블 크기

        //결과 테이블 수 많큼 루프를 돌려 결과를 가져오자
        for(int n = 0; n < nTableSize; n++) {
            String  sFieldName = structure.getField(n).getName();

            if(lMultiData.containsKey(sFieldName)){
            	structure.setValue( WebUtil.nvl(lMultiData.getString(sFieldName)) , sFieldName);
        	}
        }
        function.getImportParameterList().setValue(structure, struName);
    }




    /**
     * LData에 있는 값들을 해당 클래스에 채워 넘겨준다
     * param값으로 넘어온 LData의 값들을 추출해서 넘어온 클래스의 데이타 값에 입력 후
     * 해당 Class로 넘겨준다
     * @param ldParam EntityClass로 변경할 LData
     * @param sClassName 결과로 넘겨받을 Class
     * @return
     * @author 정진만
     *  2007. 09. 07
     */
    public static Object getLDataToClass(Box ldParam, String sClassName) throws Exception{
        Object obj = null;

        try{
            Class klass = Class.forName(sClassName);    //해당 클래스가져오기
            obj = klass.newInstance();                            //개체 생성
            Field[] fields = klass.getFields();                    //해당 클래스에서 필드가져오기

            for(int n = 0; n < fields.length; n++) {
                Field field = fields[n];
                String sValue = ldParam.getString(field.getName());

                //만약 LData에 해당 값이 존재하지 않으면 필드값을 체우지 않는다
                if( !"".equals(WebUtil.nvl(sValue)) )
                    field.set(obj, sValue);
            }
        } catch(Exception e) {
            //LLog.info..err.println("[ SAPWrapForLData.getLDataToClass ERROR ] Class 작성중 에러 : 클래스명 확인");
            throw new Exception(e);
        }

        return obj;
    }

    /**
     *  LData에 있는 값들을 해당 클래스에 채워 넘겨준다
     * param값으로 넘어온 LData의 값들을 추출해서 넘어온 클래스의 데이타 값에 입력 후
     * 클래스명에 대한 개체를 생성하여 Vector(개체배열)로 넘겨준다
     * ldParam값에 있는 값을 해당 클래스들의 필드에 셋팅한다
     * @param ldParam   EntityClass로 변경할 LData
     * @param vClassName 결과로 넘겨받을 Class배열 중복된 클래스명은 한개만 반환된다
     * @return  sClassName에 해당하는 개체 Map
     * @throws Exception
     * @author 정진만
     *  2007. 09. 07
     */
//    public static LData getLDataToClasses(Box ldParam, Vector vClassName) throws Exception {
//        HashMap<String, String> ldResult = new HashMap<String, String>();  //결과값
//
//        for(int n = 0; n < vClassName.size(); n++) {
//            try {   //중간 클래스가 실패해도 결과를 넘겨준다
//                ldResult.put(vClassName.get(n), getLDataToClass(ldParam, vClassName.get(n).toString()));
//            }catch(Exception e){
////                //LLog.info..err.println(e.getMessage());
//            }
//        }
//
//        return ldResult;
//    }

    /**
     * sap의 raw에 저장된 file download
     * @param function function
     * @param sTableName table명
     * @param sFieldName raw로 지정된 필드명
     * @param sFilePath 파일 절대경로(파일명 포함) ex( c:\\test.txt)
     * @return 저장된 파일 경로 req로 넘어온 sFilePath 실패시 ""
     * @author 정진만
     *  2007. 12. 07
     */
    public static String downFileFromSap(JCO.Function function, String sTableName, String sFieldName, String sFilePath) {
        String sResult = sFilePath;
        ////LLog.info..debug.println("sFilePath : " + sFilePath);
        ParameterList pl = function.getTableParameterList();

        Table table = pl.getTable(sTableName);    //해당테이블을 가져온다

        int nRow = table.getNumRows();         //결과 로우수
        //int nCol = table.getNumFields();     //결과 컬럼수
        File file = null;

        BufferedInputStream bin = null;     //BufferedInputStream
        BufferedOutputStream bout = null;   //BufferedOutputStream
        try{

            //경로가 없을 경우 생성
        	String sDir = "";
        	try{
        		sDir = sFilePath.substring(0, sFilePath.lastIndexOf("\\"));
        	} catch(Exception e) {
        		sDir = sFilePath.substring(0, sFilePath.lastIndexOf("/"));
        	}

            File fDir = new File(sDir);

            //보안진단 1차 개선
            if( !fDir.getAbsolutePath().equals(fDir.getCanonicalPath())){
            	try {
            		throw new Exception("파일경로 및 파일명을 확인하십시오.");
            	} catch (Exception e) {
            		Logger.debug.println(e.getMessage());
            	}
            }
            ////LLog.info..debug.println("[SAPWrapForLData] sFilePath : " + sFilePath + " read : " + fDir.canRead() + " write : " + fDir.canWrite());
            fDir.mkdirs();

            file = new File(sFilePath);

            //보안진단 1차 개선
            if( !file.getAbsolutePath().equals(file.getCanonicalPath())){
            	try {
            		throw new Exception("파일경로 및 파일명을 확인하십시오.");
            	} catch (Exception e) {
            		Logger.debug.println(e.getMessage());
            	}
            }



            bout = new BufferedOutputStream(new FileOutputStream(file));

            //테이블에서 데이타를 가져오는 부분 Vector에 로우(Ldata형)를 차례로 넣는다
            for(int i = 0; i < nRow; i++) {
                com.sap.mw.jco.JCO.Field field = table.getField(sFieldName);

                bin = new BufferedInputStream(field.getBinaryStream());

                int n = 0;
                while((n = bin.read()) > -1) {
                    //sb.append(n);
                    bout.write(n);
                }

                bin.close();

                table.nextRow(); //table Cursor를 한단계앞으로 옮긴다.
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
     * getAllStructure로 가져온 전체 데이타 중 메세지 처리
     * @param ldResult 성공일경우 S, 실패일경우 실패메세지
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
     * getAllStructure로 가져온 전체 데이타 중 메세지 처리
     * @param ldResult 성공일경우 S, 실패일경우 실패메세지
     * @return
     * @author 정진만
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


