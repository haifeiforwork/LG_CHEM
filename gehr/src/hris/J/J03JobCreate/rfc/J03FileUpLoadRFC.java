package	hris.J.J03JobCreate.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import java.io.*;

/**
 * J03FileUpLoadRFC.java
 * Eloffice Server에 Job Unit별 KSEA, Job Process PPT File을 UpLoad하는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/06/20
 */
public class J03FileUpLoadRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_PPT_UPLOAD_CHECK";

    /**
     * Eloffice Server에 Job Unit별 KSEA, Job Process PPT File을 UpLoad하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param  java.lang.String
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector UpLoad(String gubun, String i_objid, String i_filename, String i_begda, String i_pernr) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, gubun, i_objid, i_filename, i_begda, i_pernr);
//            setInput(function, file_vt, "P_RECORD");

            excute(mConnection, function);

            //작업한 결과를 리턴받는다. - error 메시지, 작업 성공여부 값
            Vector ret = new Vector();
            
            ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
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
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String gubun, String i_objid, String i_filename, String i_begda, String i_pernr) throws GeneralException {
        String fieldName1 = "I_WK_KIND";
        setField(function, fieldName1, gubun);
        
        String fieldName2 = "I_OBJID";
        setField(function, fieldName2, i_objid);

        String fieldName3 = "I_FILENAME";
        setField(function, fieldName3, i_filename);

        String fieldName4 = "I_BEGDA";
        setField(function, fieldName4, i_begda);

        String fieldName5 = "I_PERNR";
        setField(function, fieldName5, i_pernr);
    }
    
// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();
        
//      Table 결과 조회
        String entityName1 = "hris.J.J03JobCreate.J03MessageData";
        Vector P_MESSTAB  = getTable(entityName1, function, "P_MESSTAB");
        
//      Export 변수 조회
        String fieldName1  = "E_SUBRC" ;
        String E_SUBRC     = getField(fieldName1, function) ;

        ret.addElement(P_MESSTAB);
        ret.addElement(E_SUBRC);
        return ret;
    }
}