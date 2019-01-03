package hris.A.A10Annual.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.A10Annual.*;

/**
 * A10AnnualAgreementRFC.java
 * ����������ǿ��� �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa   
 * @version 1.0, 2007/06/20
 * 2016-03-09      [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û
 */
public class A10AnnualAgreementRFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_ANNUAL_AGREEMENT";

    /**
     * ������࿩�� �� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String PERNR �����ȣ
     * @param java.lang.String DATE �ý��۳�¥
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAnnualAgreeYn( String I_PERNR,String I_CONT_TYPE,String I_YEAR ,String companyCode) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, I_PERNR,I_CONT_TYPE,I_YEAR,companyCode );

            excute(mConnection, function);
            
            Vector ret = new Vector();
            
            ret = getOutput(function);       
                 

            return ret ;
            
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
    private void setInput(JCO.Function function, String key1 , String key2, String key3,String companyCode) throws GeneralException{
        String fieldName1 = "I_BUKRS";
        setField(function, fieldName1, companyCode);
        String fieldName2 = "I_PERNR";
        setField(function, fieldName2, key1);
        String fieldName3 = "I_CONT_TYPE";
        setField(function, fieldName3, key2);
        String fieldName4 = "I_YEAR";
        setField(function, fieldName4, key3);
    }
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        String fieldName = "E_AGRE_FLAG" ;
        String E_AGRE_FLAG    = getField( fieldName, function ) ;

        String fieldName1  = "E_BETRG" ;
        String E_BETRG   = getField( fieldName1, function ) ;
        //[CSR ID:3006173] 
        String fieldName2  = "E_BETRG2" ;
        String E_BETRG2   = getField( fieldName2, function ) ;
             
        E_BETRG = Double.toString(Double.parseDouble( E_BETRG ) * 100.0 );
        E_BETRG2 = Double.toString(Double.parseDouble( E_BETRG2 ) * 100.0 );

        ret.addElement(E_AGRE_FLAG);
        ret.addElement(E_BETRG);
        ret.addElement(E_BETRG2);

        return ret;
    }
  
    
}
