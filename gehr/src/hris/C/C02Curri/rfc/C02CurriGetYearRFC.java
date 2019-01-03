package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriGetYear.java
 * ���� �������� �˻��Ⱓ�� �����´�.
 *
 * @author �ڿ���   
 * @version 1.0, 2002/03/15
 */
public class C02CurriGetYearRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_CAL_YEARS";

    /**
     * ���� �������� ���븦 �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYear( ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;

        } catch(Exception ex) {
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
        String E_SYEAR  = getField("E_SYEAR", function );   
        String E_EYEAR  = getField("E_EYEAR", function );
        Vector vt = new Vector(2);
        vt.addElement(E_SYEAR);
        vt.addElement(E_EYEAR);

        return vt;
    }
}
