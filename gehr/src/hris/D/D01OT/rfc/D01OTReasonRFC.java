package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * overtime reason for G170 pangxiaolin
 * @author 10101718
 *
 */
public class D01OTReasonRFC extends SAPWrap {
	private String functionName = "ZHRW_RFC_OVERTIME_REASON";
//	private String functionName = "ZGHR_RFC_OVERTIME_REASON";
	
	public Vector getTypeCode(String keycode) throws GeneralException {
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
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, keycode);
    }
    
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName  = "ITAB";//zhr0044t
        return getTable(hris.D.D01OT.D01OTReasonData.class, function, tableName);
    }
}
