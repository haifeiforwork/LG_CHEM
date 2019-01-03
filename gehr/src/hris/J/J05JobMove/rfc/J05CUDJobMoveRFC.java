package	hris.J.J05JobMove.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

/**
 * J05CUDJobMoveRFC.java
 * 관계를 생성하는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/06/28
 */
public class J05CUDJobMoveRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_CUD_JOB_MOVE";

    /**
     * 관계를 생성,수정하는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param  java.lang.String
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector Create(String empNo, Vector j05Object_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);

            setInput(function, j05Object_vt, "P_RECORD");

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
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
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
        Vector P_MESSTAB   = getTable(entityName1, function, "P_MESSTAB");

        String entityName2 = "hris.J.J05JobMove.J05JobMoveData";
        Vector P_STEXT     = getTable(entityName2, function, "P_STEXT");
        
//      Export 변수 조회
        String fieldName1  = "E_SUBRC";
        String E_SUBRC     = getField(fieldName1, function);

        String fieldName2  = "E_HOLDER";
        String E_HOLDER    = getField(fieldName2, function);

        ret.addElement(P_MESSTAB);
        ret.addElement(E_SUBRC);
        ret.addElement(E_HOLDER);
        ret.addElement(P_STEXT);

        return ret;
    }
}