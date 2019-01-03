package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * GetPasswordRFC.java 사번에 대한 password를 가져오는 RFC를 호출하는 Class
 * 
 * @author 김성일
 * @version 1.0, 2002/02/27
 */
public class GetPasswordGlobalRFC extends SAPWrap {

	private String functionName = "ZHRS_GET_PASSWORD";

	private String functionName1 = "ZHRS_RFC_LOGIN";

	/**
	 * 사진의 URL를 가져오는 RFC를 호출하는 Method
	 * 
	 * @param java.lang.String
	 *            사번
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	public Vector getPassword(String webUserId) throws GeneralException {
		return getPassword(webUserId, "");
	}

	public Vector getPassword(String webUserId, String flag)
			throws GeneralException {
		return getPassword(webUserId, flag,"");
	}
	
	public Vector getPassword(String webUserId, String flag, String Name)
	throws GeneralException {
		
		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			
			setInput(function, webUserId, flag, Name);
			excute(mConnection, function);
			Vector ret = new Vector();
			ret = getOutput(function);
			return ret;
			
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
	
	public Vector getPassword1(String webUserId, String I_PERNR, String I_COMP) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName1);
			setInput1(function, webUserId, I_PERNR, I_COMP);
			excute(mConnection, function);
			Vector ret = new Vector();
			ret = getOutput(function);
			return ret;

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @exception GeneralException
	 */
	private void setInput(JCO.Function function, String webUserId)
	throws GeneralException {
		String fieldName = "I_ID";
		setField(function, fieldName, webUserId);
	}
	
	private void setInput(JCO.Function function, String webUserId, String flag)
	throws GeneralException {
		String fieldName = "I_ID";
		setField(function, fieldName, webUserId);
		setInput(function,webUserId);
		String fieldName1 = "I_FLAG";
		setField(function, fieldName, flag);	
	}
	
	private void setInput(JCO.Function function, String webUserId, String flag, String name)
	throws GeneralException {
		/*
		String fieldName = "I_ID";
		setField(function, fieldName, webUserId);
		setInput(function,webUserId,flag);
		*/
		String fieldName = "I_ID";
		setField(function, fieldName, webUserId);
		String fieldName1 = "I_FLAG";
		setField(function, fieldName1, flag);
		String fieldName2 = "I_ENAME";
		setField(function, fieldName2, name);
	}
	
	private void setInput1(JCO.Function function, String webUserId, String I_PERNR, String I_COMP)
	throws GeneralException {
		String fieldName = "I_ID";
		setField(function, fieldName, webUserId);
		setInput(function,webUserId);
		String fieldName1 = "I_PERNR";
		setField(function, fieldName1, I_PERNR);	
		String fieldName2 = "I_COMP";
		setField(function, fieldName2, I_COMP);	
	}

	/**
	 * RFC 실행후 Export 값을 String 로 Return 한다. 반드시
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * 가 호출된후에 실행되어야하는 메소드
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.lang.String
	 * @exception GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {
		Vector<String> ret = new Vector<String>();
		String fieldName = "E_PASSWORD"; // RFC Export 구성요소 참조
		String E_PASSWORD = getField(fieldName, function);
		String fieldName2 = "E_IP";
		String E_IP = getField(fieldName2, function);
		String fieldName3 = "E_RETURN";
		String E_RETURN = getField(fieldName3, function);
		String fieldName4 = "E_MESSAGE";
		String E_MESSAGE = getField(fieldName4, function);
		ret.addElement(E_PASSWORD);
		ret.addElement(E_IP);
		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);
		return ret;
	}
}
