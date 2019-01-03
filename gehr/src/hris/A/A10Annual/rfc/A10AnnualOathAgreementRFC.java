package hris.A.A10Annual.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;

import java.util.Vector;

/**
 * A10AnnualOathAgreementRFC.java
 * �ӿ��������ǿ��� �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author rdcamel   
 * @version 1.0, 2016-03-25
 * [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û                                                       
 */
public class A10AnnualOathAgreementRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_OATH_AGREEMENT";

    /**
     * �ӿ��������ǿ��� �� �������� RFC�� ȣ���ϴ� Method
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAnnualAgreeYn( String I_PERNR,String I_GTYPE,String I_YEAR ,String companyCode) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setField(function, "I_GTYPE", I_GTYPE);
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_YEAR", I_YEAR);//[CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��

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

    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        String fieldName = "E_AGRE_FLAG" ;
        String E_AGRE_FLAG    = getField( fieldName, function ) ;

        String fieldName1  = "E_BETRG" ;
        String E_BETRG   = getField( fieldName1, function ) ;
             
        E_BETRG = DataUtil.changeLocalAmount(E_BETRG, "KRW");

        ret.addElement(E_AGRE_FLAG);
        ret.addElement(E_BETRG);

        return ret;
    }
  
    
}
