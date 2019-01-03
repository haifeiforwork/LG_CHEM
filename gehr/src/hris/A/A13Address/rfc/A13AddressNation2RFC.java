package hris.A.A13Address.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * A13AddressNationRFC.java
 * 국가 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/26
 */
public class A13AddressNation2RFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_P_ADDRESS_BIRTH";

    /**
     * 국가 코드, 명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector getAddressNation() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

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
     * @exception GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "ITAB";
        return getCodeVector(function, tableName);
    }
}