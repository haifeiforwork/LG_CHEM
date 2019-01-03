package hris.A.A14Bank.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * bankcard change 20151217 pangxiaolin
 * @author 10101718
 *
 */
public class A14BankTypeRFC extends SAPWrap {
//	private String functionName = "ZHRH_RFC_P_BANK_TYPE";
	private String functionName = "ZGHR_RFC_P_BANK_TYPE";
	
	public Vector getTypeCode(String keycode) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField(function, "I_PERNR" , keycode);
            
            excute(mConnection, function);
            
//            return  getTable(hris.A.A14Bank.A14BankTypeData.class, function,  "ITAB");
            return  getTable(hris.A.A14Bank.A14BankTypeData.class, function,  "T_ITAB");
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}
    
    
}
