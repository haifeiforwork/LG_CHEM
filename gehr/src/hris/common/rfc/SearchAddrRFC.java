package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * SearchAddrRFC.java
 * �ּ� �˻� List �� �������� RFC�� ȣ���ϴ� Class
 * @author �ڿ���   
 * @version 1.0, 2001/12/18
 */
public class SearchAddrRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_ZIPP_CODE";

    /**
     * �ּҰ˻� List �� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAddrDetail( String zippcode ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, zippcode);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Logger.debug.println(this, ret.toString());
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException{
        String fieldName = "ZIPP_CODE";
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
        String entityName = "hris.common.SearchAddrData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}

