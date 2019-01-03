package hris.common.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

/**
 * CurrentDateRFC.java
 * ���� ��¥�� �������� RFC �� ȣ���ϴ� Class                        
 *
 * @author ������
 * @version 1.0, 2002/02/16
 */
public class CurrentDateRFC extends SAPWrap {

    private String functionName = "ZHRW_GET_SYS_DATUM";

    /**
     * ���糯¥ RFC ȣ���ϴ� Method
     *
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getCurrent() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            String ret = getOutput(function);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    private String getOutput(JCO.Function function) throws GeneralException {

        String fieldName = "E_SY_DATUM";      // RFC Export ������� ����
        return getField(fieldName, function);
   }

}

