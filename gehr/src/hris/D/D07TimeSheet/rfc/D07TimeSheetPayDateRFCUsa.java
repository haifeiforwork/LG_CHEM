package hris.D.D07TimeSheet.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D07TimeSheetPayDateRFCUsa.java
 * Pay Date Raage ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */
public class D07TimeSheetPayDateRFCUsa extends SAPWrap {

    private String functionName = "HR_GET_ESS_SUBTYPES";

    /**
     * Pay Date Raage ������ �������� RFC�� ȣ���ϴ� Method
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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "SUBTYTAB";
        return getCodeVector(function, tableName);
    }
}