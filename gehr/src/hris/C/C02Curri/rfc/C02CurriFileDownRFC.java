package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriFileDownRFC.java
 * 교육과정 문서파일를 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/14
 */
public class C02CurriFileDownRFC extends SAPWrap {

    private String functionName = "ZHRS_RFC_OPEN_FILES";

    /**
     * 교육과정 문서링크를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFile( String P_PHIO_ID, String P_STOR_CAT ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, P_PHIO_ID, P_STOR_CAT );
            excute(mConnection, function);
            return getOutput(function);
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2) throws GeneralException{
        String fieldName = "P_PHIO_ID";
        setField(function, fieldName, key1);
        String fieldName2 = "P_STOR_CAT";
        setField(function, fieldName2, key2);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    protected Vector getOutput(JCO.Function function ) throws GeneralException{
        Vector retvt = new Vector();
        try{
            JCO.Table table = function.getTableParameterList().getTable("G_CONTENT_BIN");
            JCO.Table table1 = function.getTableParameterList().getTable("G_CONTENT_CHAR");

            if( table.getNumRows() > 0 ) {
                String temp = "BINARY";
                retvt.addElement(temp);
                for (int i = 0; i < table.getNumRows(); i++) {
                    table.setRow(i);

                    byte[] data = table.getByteArray("LINE");

                    retvt.addElement(data);
                }
            } else {
                String temp = "CHAR";
                retvt.addElement(temp);
                for (int i = 0; i < table1.getNumRows(); i++) {
                    table.setRow(i);

                    String data = table1.getString("LINE");

                    retvt.addElement(data);
                }
            }
            Logger.debug.println(this, retvt.toString());
        } catch ( Exception ex ){
            Logger.debug.println(this, "getTable(String entityName, JCO.Function function, String functionName)에서 예외발생 " );
            Logger.debug.println(this, "entityName는 Package 경로가 잡혀있어야함 .. 확인요 " );
            throw new GeneralException(ex);
        }
        return retvt;
    }
}



    