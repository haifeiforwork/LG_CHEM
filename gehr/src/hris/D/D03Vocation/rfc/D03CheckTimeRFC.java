package hris.D.D03Vocation.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D03CheckTimeRFC extends SAPWrap{
//	 private String functionName = "ZHR_RFC_TIME_CHECK";
	 private String functionName = "ZGHR_RFC_TIME_CHECK";

	    public String check( String BEGUZ, String ENDUZ ) throws GeneralException {

	        JCO.Client mConnection = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;
	            setInput(function, BEGUZ, ENDUZ);
	            excute(mConnection, function);
	            String ret = getOutput(function);
	            return ret;
	        } catch(Exception ex){
	            Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }


	    private void setInput(JCO.Function function, String BEGUZ, String ENDUZ ) throws GeneralException {
	        String fieldName1 = "I_ANZHL_ST";
	        setField( function, fieldName1, BEGUZ );
	        String fieldName2 = "I_ANZHL_ED";
	        setField( function, fieldName2, ENDUZ );
        }

	    private String getOutput(JCO.Function function) throws GeneralException {
	        String ret = getField("E_FLAG", function);
	        return ret ;
	    }
	}
