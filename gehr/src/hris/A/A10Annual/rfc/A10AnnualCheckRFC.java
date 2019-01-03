package hris.A.A10Annual.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.A10Annual.*;

/**
 * A10AnnualCheckRFC.java
 * ������࿩�� �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ڿ���   
 * @version 1.0, 2002/01/10
 */
public class A10AnnualCheckRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_CHECK_SAL_TYPE";

    /**
     * ������࿩�� �� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String PERNR �����ȣ
     * @param java.lang.String DATE �ý��۳�¥
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public String getAnnualCheck( String I_PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, I_PERNR );

            excute(mConnection, function);

            String ret = getOutput(function);

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
     * @param java.lang.String PERNR �����ȣ
     * @param java.lang.String DATE �ý��۳�¥
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1 ) throws GeneralException{
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, key1);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String  getOutput(JCO.Function function) throws GeneralException {
        String fieldName = "E_TRFAR";
        return getField(fieldName, function);
    }
}
