package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * ZipcodeCheckRFC.java
 * Zipcode 유효성을 체크하는 RFC를 호출하는 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/05
 */
public class ZipcodeCheckRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_POSTAL_CODE_CHECK";
    
    /**
     * Zipcode 유효성을 체크하는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector getZipcodeCheck(String i_land1, String i_state, String i_pstlz) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, i_land1, i_state, i_pstlz) ;
            excute(mConnection, function);
            Vector ret = new Vector();
			ret = getOutput(function);
			return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);

        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행 전에 Import 값을 setting 한다.
     * 
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param LAND1
     * @exception GeneralException
     */
    private void setInput( JCO.Function function, String i_land1, String i_state, String i_pstlz) throws GeneralException {
        String fieldName = "I_LAND1";
        setField(function, fieldName, i_land1);
        String fieldName1 = "I_REGIO" ;
        setField(function, fieldName1, i_state);
        String fieldName2 = "I_PSTLZ" ;
        setField(function, fieldName2, i_pstlz);
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
		Vector<String> ret = new Vector<String>();
		
		String fieldName = "E_RETURN";
		String E_RETURN = getField(fieldName, function);
		String fieldName1 = "E_MESSAGE";
		String E_MESSAGE = getField(fieldName1, function);

		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);
		
		return ret;
    }  
   
}
