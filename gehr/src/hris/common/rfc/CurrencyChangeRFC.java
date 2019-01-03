package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class CurrencyChangeRFC  extends SAPWrap {
	 //private String functionName = "ZHR_EXCHANGE_CURRENCY";
	 private String functionName = "ZGHR_EXCHANGE_CURRENCY";
	    public String getCurrencyChange(String waers1,String waers2,String betrg) throws GeneralException {
	        JCO.Client mConnection = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;
	            setInput(function,waers1,waers2,betrg);
	            excute(mConnection, function);
	            return getField("E_EX_BETRG", function);
	        } catch(Exception ex){
	            //Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }

	    // get exchange rate  --liukuo add 2010.12.21
	    public String getExchangeRate(String waers1,String waers2,String betrg) throws GeneralException {
	        JCO.Client mConnection = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;
	            setInput(function,waers1,waers2,betrg);
	            excute(mConnection, function);
	            return getField("E_EX_CHANGE", function);
	        } catch(Exception ex){
	            //Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }

	    private void setInput(JCO.Function function, String waers1, String waers2, String betrg) throws GeneralException {
	        String fieldName  = "I_WAERS1";
	        setField(function, fieldName,  waers1);
	        String fieldName1 = "I_WAERS2";
	        setField(function, fieldName1, waers2);
	        String fieldName2 = "I_BETRG";
	        setField(function, fieldName2, betrg);
	    }
}
