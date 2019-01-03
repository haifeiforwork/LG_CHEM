package hris.D.D03Vocation.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D03CheckDataRFC extends SAPWrap  {
//	private String functionName = "ZHR_RFC_LEAVE_CHECK";
	private String functionName = "ZGHR_RFC_LEAVE_CHECK";

	public String checks(String PERNR)throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, PERNR);
            excute(mConnection, function);
            return getReturn().MSGTX;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, keycode);
    }
}
