package	hris.A.A13Address.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A13Address.*;

/**
 * A13AddressLiveTypeRFC.java
 * �ְ����� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2001/12/26
 */
public class A13AddressLiveTypeRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_P_ADDRESS_LIVE_TYPE";

    /**
     * �ְ����� �ڵ�, ���� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAddressLiveType() throws GeneralException {

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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "P_RESULT";
        return getCodeVector(function, tableName);
    }
}