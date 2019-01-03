package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.ChangePasswordResultData;

import java.util.Vector;

/**
 * ChgPasswordRFC.java
 * password 변경 RFC를 호출하는 Class
 *
 * @author 배민규   
 * @version 1.0, 2004/03/28
 * [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정
 */
public class ChgPasswordRFC extends SAPWrap {

    private String functionName = "ZGHR_CHANGE_PASSWORD";

    /**
     * password 변경 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 추가됨
     */
    public ChangePasswordResultData chgPassword(String webUserId, String webUserPwd, String newWebUserPwd1, String newWebUserPwd2 ) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ID", webUserId);
            setField(function, "I_PASSWORD1", webUserPwd);
            setField(function, "I_PASSWORD2", newWebUserPwd1);
            setField(function, "I_PASSWORD3", newWebUserPwd2);

            excute(mConnection, function);

            ChangePasswordResultData resultData = getStructor(ChangePasswordResultData.class, function, "E_RETURN", null);
            resultData.E_FLAG = getField("E_FLAG", function);

            return resultData;
        } catch(Exception ex) {
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
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 사용안함
     */
    private void setInput(JCO.Function function, String webUserId, String webUserPwd) throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, webUserId);
		String fieldName2 = "PASSWORD";
        setField(function, fieldName2, webUserPwd);
    }
    
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정 추가됨
     */
    private void setInput(JCO.Function function, String webUserId, String webUserPwd, String newWebUserPwd1, String newWebUserPwd2) throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, webUserId);
		String fieldName1 = "PASSWORD1";
        setField(function, fieldName1, webUserPwd);
        String fieldName2 = "PASSWORD2";
        setField(function, fieldName2, newWebUserPwd1);
        String fieldName3 = "PASSWORD3";
        setField(function, fieldName3, newWebUserPwd2);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        //String fieldName = "E_FLAG";      // RFC Export 구성요소 참조
        //return getField(fieldName, function);
    	Vector ret = new Vector();
    	String fieldName = "E_FLAG";
		String E_FLAG     = getField(fieldName, function) ;
		String fieldName1 = "E_RETURN";
		String E_RETURN     = getField(fieldName1, function) ; 
		String fieldName2    = "E_MESSAGE"; 
		String E_MESSAGE     = getField(fieldName2, function) ;
		ret.addElement(E_FLAG);
		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);
        return ret;
    	
    }
}

