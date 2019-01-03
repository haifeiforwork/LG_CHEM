package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D01OT.D01OTReqtmData;
import hris.D.D01OT.D01OTResultData;

/**
 * D01OTOvertimeInputRFC.java
 * 초과근무 실적입력 RFC 를 호출하는 Class
 *
 * @author 성환희
 * @version 1.0, 2018/08/14
 */
public class D01OTOvertimeInput2RFC extends SAPWrap {
	
	private String functionName = "ZGHR_RFC_NTM_OT_RESULT_INPUT2";
	
	public Vector search(String I_PERNR, String I_YYYYMM, String isPop) throws GeneralException {
		
		JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            
            JCO.Function function = createFunction(functionName) ;
            
            setField(function, "I_ACTIO", "DIS");
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_YYYYMM", I_YYYYMM);
            
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
	
	public void save(String I_PERNR, String I_YYYYMM, Vector<D01OTReqtmData> T_REQTM, Vector<D01OTResultData> T_RESULT) throws GeneralException {
		
		JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            
            JCO.Function function = createFunction(functionName) ;
            
            setField(function, "I_ACTIO", "INS");
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_YYYYMM", I_YYYYMM);
            setTable(function, "T_REQTM", T_REQTM);
            setTable(function, "T_RESULT", T_RESULT);
            
            excute(mConnection, function);
            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
		
	}
	
	private Vector getOutput(JCO.Function function) throws GeneralException {
		
		Vector ret = new Vector();
		
        Vector T_PERNR = getTable(hris.D.D01OT.D01OTPernrData.class, function, "T_PERNR");
        Vector T_HEADER = getTable(hris.D.D01OT.D01OTHeaderData.class, function, "T_HEADER");
        Vector T_REQTM = getTable(hris.D.D01OT.D01OTReqtmData.class, function, "T_REQTM");
        Vector T_RESULT = getTable(hris.D.D01OT.D01OTResultData.class, function, "T_RESULT");
        
        ret.addElement(T_PERNR);
        ret.addElement(T_HEADER);
        ret.addElement(T_REQTM);
        ret.addElement(T_RESULT);
        
        return ret ;
        
    }

}
