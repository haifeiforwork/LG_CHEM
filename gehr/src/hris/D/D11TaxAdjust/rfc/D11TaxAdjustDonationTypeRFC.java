package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*; 

/**
 * D11TaxAdjustDonationTypeRFC.java
 * ��α��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author LSA
 * @version 1.0, 2005/11/23
 */
public class D11TaxAdjustDonationTypeRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_YEAR_DONATION_PE";
 
    /**
     * ��α��������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDonationType(String targetYear, String Pernr  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,  targetYear,Pernr );
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String targetYear, String Pernr ) throws GeneralException {
 
        String fieldName1 = "I_YEAR";
        setField( function, fieldName1, targetYear ); 
        String fieldName2 = "I_PERNR";  //C20121213_34842
        setField( function, fieldName2, Pernr ); 
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "RESULT";
        return getCodeVector(function, tableName);
    }
}