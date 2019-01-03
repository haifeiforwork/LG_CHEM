package	hris.D.D05Mpay.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D05Mpay.*;

/**
 * D05HealthInsuranceRFC.java
 * ���⵵ �ǰ������ �հ踦 ���ϴ� rfc (N100 ����ȭ�� ����)
 *
 * @author  �赵��
 * @version 1.0, 2003/04/22
 */
public class D05HealthInsuranceRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_GET_HEALTH_INSURANCE";	
//    private String functionName = "ZGHR_RFC_GET_HEALTH_INSURANCE";	// E_SUM_BETRG �ǰ�������հ谡 ����

    /**
     * ���⵵ �ǰ������ �հ踦 ��ȸ��.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_SUM_BETRG( String i_pernr, String i_year ) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, i_pernr, i_year);
            excute(mConnection, function);
            
            String E_SUM_BETRG = "";
                        
            E_SUM_BETRG = getOutput(function);  
                        
            return E_SUM_BETRG;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_year ) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName,  i_pernr);
        String fieldName1 = "I_YEAR";
        setField(function, fieldName1, i_year);
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        String fieldName = "E_SUM_BETRG";  
        return getField(fieldName, function);
    }
}