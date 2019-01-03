package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D11TaxAdjust.*;

/**
 * D11TaxAdjustDonationTypeRFC.java
 * ��α��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author LSA
 * @version 1.0, 2005/11/23
 * @version 1.0, 2013/12/10 CSR ID:C20140106_63914 �δ�������ó���� �߰� 
 */
public class D11TaxAdjustGibuBusiNameRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_GET_DONATION";
 
    /**
     * ��α��������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBusiName(String busiCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, busiCode);
            excute(mConnection, function);
            
            String fieldName = "E_DONA_COMP" ;
            String E_DONA_COMP       = getField( fieldName, function ) ;
            
	    //CSR ID:C20140106_63914 �δ�������ó����
            String fieldName1 = "E_FLAG" ;
            String E_FLAG       = getField( fieldName1, function ) ;
            Vector ret = new Vector();
            ret.addElement(E_DONA_COMP);
            ret.addElement(E_FLAG);
            return ret ; 
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
    private void setInput(JCO.Function function, String busiCode) throws GeneralException {
        String fieldName1 = "I_DONA_NUMB";
        setField( function, fieldName1, busiCode );
    }

}