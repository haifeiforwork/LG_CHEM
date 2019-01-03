package hris.J.J03JobCreate.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * J03ObjectPEntryRFC.java
 * Function, Objective, 대분류 P/E를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신   
 * @version 1.0, 2003/06/12
 */
public class J03ObjectPEntryRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_PENTRY_LIST";   

    /**
     *  Function, Objective, 대분류 P/E를 가져오는 RFC를 호출하는 Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getPEntry(String i_gubun, String i_objid, String i_pernr) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_gubun, i_objid, i_pernr);
            excute(mConnection, function);

            Vector ret = new Vector();
            
            if( i_gubun.equals("1") ) {
                ret = getOutput1(function);
            } else {
                ret = getOutput2(function);
            }

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
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_gubun, String i_objid, String i_pernr) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField(function, fieldName1, i_gubun);
        String fieldName2 = "I_OBJID";
        setField(function, fieldName2, i_objid);
        String fieldName3 = "I_PERNR";
        setField(function, fieldName3, i_pernr);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.J.J03JobCreate.J03PEntryListData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String tableName  = "P_RESULT";      // RFC Export 구성요소 참조
        String codeField  = "OBJID_D";
        String valueField = "STEXT_D";
        return getCodeVector( function, tableName, codeField, valueField );
    }
}


