package hris.D.D07TimeSheet.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D07TimeSheetPayDateRFCUsa.java
 * Pay Date Raage 유형을 가져오는 RFC를 호출하는 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */
public class D07TimeSheetPayDateRFCUsa extends SAPWrap {

    private String functionName = "HR_GET_ESS_SUBTYPES";

    /**
     * Pay Date Raage 유형을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getPayDateType(String country) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "INFTY", "0006" );
            setField( function, "MOLGA", country );
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "SUBTYTAB";
        return getCodeVector(function, tableName);
    }
}