package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.D.D11TaxAdjust.*;

/**
 * D11TaxAdjustPreWorkSearchRFC.java
 * 전근무지 사업장명, 사업자등록번호를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2005/12/02
 */
public class D11TaxAdjustPreWorkSearchRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PRE_WORK_PE2";

    /**
     * 전근무지 사업장명, 사업자등록번호 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSearch(String COM01) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, COM01);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Logger.debug.println(this, ret.toString());
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
     * @exception com.sns.jdf.GeneralException
     */
    
    private void setInput(JCO.Function function, String value) throws GeneralException{
        String fieldName = "I_COM01";
        setField(function, fieldName, value);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPreWorkSearchData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}