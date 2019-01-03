package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D01OT.D01OTListData;

/**
 * D01OTOvertimeInputRFC.java
 * 초과근무 실적입력 RFC 를 호출하는 Class
 *
 * @author 성환희
 * @version 1.0, 2018/06/08
 */
public class D01OTOvertimeInputRFC extends SAPWrap {
	
	private String functionName = "ZGHR_RFC_NTM_OT_RESULT_INPUT";
	
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
	
	public void save(String I_PERNR, String I_YYYYMM, Vector<D01OTListData> T_LIST) throws GeneralException {
		
		JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            
            JCO.Function function = createFunction(functionName) ;
            
            setField(function, "I_ACTIO", "INS");
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_YYYYMM", I_YYYYMM);
            setTable(function, "T_LIST", T_LIST);
            
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
        Vector T_LIST = getTable(hris.D.D01OT.D01OTListData.class, function, "T_LIST");
        
        ret.addElement(T_PERNR);
        ret.addElement(T_HEADER);
        ret.addElement(T_LIST);
        
        return ret ;
        
    }

}
