package hris.J.J02CompetencyList.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J01JobMatrix.*;

/**
 * J02CompetencyListRFC.java
 * Competency List를 조회하는 RFC를 호출하는 Class                        
 *
 * @author 원도연
 * @version 1.0, 2003/05/13
 */
public class J02CompetencyListRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_COMPETENCY_LIST";

    public Vector getDetail( String i_gubun, String i_inx_s, String i_inx_e, String i_find, String i_QKid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, i_gubun, i_inx_s, i_inx_e, i_find, i_QKid);
            excute(mConnection, function);

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
    private void setInput(JCO.Function function, String i_gubun , String i_inx_s, String i_inx_e, String i_find, String i_QKid ) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField(function, fieldName1, i_gubun);
        String fieldName2 = "I_INX_S";
        setField(function, fieldName2, i_inx_s);
        String fieldName3 = "I_INX_E";
        setField(function, fieldName3, i_inx_e);
        String fieldName4 = "I_FIND";
        setField(function, fieldName4, i_find);
        String fieldName5 = "I_OBJID";
        setField(function, fieldName5, i_QKid);        
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.J.J01JobMatrix.J01JobMatrixData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }


}

