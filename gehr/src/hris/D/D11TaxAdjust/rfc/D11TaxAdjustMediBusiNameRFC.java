package	hris.D.D11TaxAdjust.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D11TaxAdjust.*;

/**
 * D11TaxAdjustMediBusiNameRFC.java
 * ��α��������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author LSA
 * @version 1.0, 2005/11/23
 */ 
public class D11TaxAdjustMediBusiNameRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_GET_MEDI";
 
    /**
     * ��α��������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getBusiName(String busiCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        	
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, busiCode) ;
            excute(mConnection, function) ;

            String fieldName = "E_BIZ_NAME" ;
            String ret       = getField( fieldName, function ) ;
            
            return ret ;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException66 : "+ex.toString());
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
        String fieldName1 = "I_BIZNO";
        setField( function, fieldName1, busiCode );
    }

}