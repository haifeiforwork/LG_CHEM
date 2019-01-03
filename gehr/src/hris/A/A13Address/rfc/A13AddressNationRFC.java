package	hris.A.A13Address.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A13Address.A13AddressNationData;

import java.util.Vector;

/**
 * A13AddressNationRFC.java
 * 국가 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2001/12/26
 */
public class A13AddressNationRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_LAND_NATIO_F4";

    /**
     * 국가 코드, 명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A13AddressNationData> getAddressNation() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);

            return getTable(A13AddressNationData.class,  function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
}