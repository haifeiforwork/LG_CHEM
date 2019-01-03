package hris.A.A14Bank.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class A14BankProvinceRFC extends SAPWrap {
//	private String functionName = "ZHRH_RFC_BANK_REGIO_ENTRY";
	private String functionName = "ZGHR_RFC_BANK_REGIO_ENTRY";
	
	public Vector getProvinceCode(String keycode) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
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
    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_LAND1"          ;
        setField(function, fieldName1, keycode);
    }
    
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A14Bank.A14BankProvinceData";
        return getCodeVector( function, "T_ITAB");
    }
}
