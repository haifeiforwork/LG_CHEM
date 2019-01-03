package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.D.D11TaxAdjust.*;

/**
 * D11TaxAdjustPreWorkSearchRFC.java
 * ���ٹ��� ������, ����ڵ�Ϲ�ȣ�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2005/12/02
 */
public class D11TaxAdjustPreWorkSearchRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PRE_WORK_PE2";

    /**
     * ���ٹ��� ������, ����ڵ�Ϲ�ȣ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSearch(String COM01) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, COM01);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Logger.debug.println(this, ret.toString());
            return ret;
        } catch(Exception ex){
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
        String fieldName = "I_COM01";
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
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPreWorkSearchData";
        String tableName = "RESULT";
        return getTable(entityName, function, tableName);
    }
}