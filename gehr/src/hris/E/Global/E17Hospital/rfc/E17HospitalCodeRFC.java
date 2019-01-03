package hris.E.Global.E17Hospital.rfc;
import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

public class E17HospitalCodeRFC extends SAPWrap{
	    //private String functionName = "ZHRW_RFC_MEDICAL_TYPE_EXP";             //  ZHRS043S
	    private String functionName = "ZGHR_RFC_MEDICAL_TYPE_EXP";             //  ZHRS043S

	    public Vector getMediCode() throws GeneralException {

	        JCO.Client mConnection = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;

	            excute(mConnection, function);
	            Vector ret = getCodeVector( function, "T_ITAB");//getOutput(function);

	            return ret;
	        } catch(Exception ex){
	            //Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }

}
