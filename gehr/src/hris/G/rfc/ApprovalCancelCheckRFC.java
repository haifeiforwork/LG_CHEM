/*
 * 작성된 날짜: 20013. 09. 20.
 *
 */
package hris.G.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * @author 손혜영
 *
 */
public class ApprovalCancelCheckRFC extends SAPWrap
{
//    private String functionName = "ZHRW_RFC_APPR_CANC_CHECK";
    private String functionName = "ZGHR_RFC_APPR_CANC_CHECK";
   
    public Vector get(String pernr, String ainfSeqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, ainfSeqn);            
            excute(mConnection, function);            
            Vector ret = new Vector();
        	// Export 변수 조회
//        	String fieldName1 = "E_RETURN";        // 리턴코드
//        	String E_RETURN   = getField(fieldName1, function) ;
        	
//        	String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
//        	String E_MESSAGE  = getField(fieldName2, function) ; 
//        	ret.addElement(E_RETURN);
//        	ret.addElement(E_MESSAGE);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Vector get2(String pernr, String ainfSeqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, ainfSeqn);       
            setField(function, "I_NTM", "X");
            excute(mConnection, function);            
            Vector ret = new Vector();
        	// Export 변수 조회
//        	String fieldName1 = "E_RETURN";        // 리턴코드
//        	String E_RETURN   = getField(fieldName1, function) ;
        	
//        	String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
//        	String E_MESSAGE  = getField(fieldName2, function) ; 
//        	ret.addElement(E_RETURN);
//        	ret.addElement(E_MESSAGE);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String pernr, String ainfSeqn) throws GeneralException {
        String fieldName1 = "I_PERNR"; //P_PERNR
        setField(function, fieldName1, pernr);
        
        String fieldName2 = "I_AINF_SEQN";//P_AINF_SEQN
        setField(function, fieldName2, ainfSeqn);        
    }

}
