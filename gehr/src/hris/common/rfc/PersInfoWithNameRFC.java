package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * PersInfoWithNameRFC.java
 * 사원 이름으로 개인정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class PersInfoWithNameRFC extends SAPWrap {

    //private static String functionName = "ZHRA_RFC_GET_ENAME_INFORMATION";
	private static String functionName = "ZGHR_RFC_GET_ENAME_TASK"; //[CSR ID:3525213] Flextime 시스템 변경 요청

    /**
     * 사원 이름으로 개인정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사원이름
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getApproval( String ename, String objid , String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ename, objid, pernr);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ename, String objid , String pernr) throws GeneralException {
        String fieldName  = "I_ENAME";
        setField(function, fieldName,  ename);
        String fieldName1 = "I_OBJID";
        setField(function, fieldName1, objid);
        String fieldName2 = "I_PERNR";
        setField(function, fieldName2, pernr);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        /*String entityName = "hris.common.PersInfoData";
        String tableName = "PER_INFO";
        return getTable(entityName, function, tableName);*/
        return getTable(PersonData.class, function, "T_RESULT","E_");
    }
}


