package hris.A.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A01SelfDetailLicenseData;

import java.util.Vector;

/**
 * A01SelfDetailLicenseRFC.java
 * 신상 RFC를 호출하는 Class
 *
 * @author 정진만
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailLicenseRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_LICENSE_LIST";

    /**
     * 자격 조회하는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<A01SelfDetailLicenseData> getLicenseList(String I_PERNR, String I_MOLGA, String I_CFORM) throws GeneralException {
        
        JCO.Client mConnection = null;
        Vector<A01SelfDetailLicenseData> resultList = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_MOLGA", I_MOLGA);
            setField(function, "I_CFORM", I_CFORM);


            excute(mConnection, function);

            resultList = getTable(A01SelfDetailLicenseData.class, function, "T_LIST");
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;
    }

}

