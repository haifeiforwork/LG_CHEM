package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.*;

/**
 * A08licenceDetailRFC.java
 * �ڰ��� ���� List �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ֿ�ȣ   
 * @version 1.0, 2001/12/19
 */
public class A08LicenseDetailAlloRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_LICENSE_ALLOWANCE";

    /**
     * �ڰ��� ���� List �� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLicenseDetailAllo(String PERNR) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setField(function, "I_PERNR", PERNR);

            excute(mConnection, function);

            Vector<A08LicenseDetailAlloData> ret = getTable(A08LicenseDetailAlloData.class, function, "T_LIST");
            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, value);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A08LicenseDetailAlloData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}

