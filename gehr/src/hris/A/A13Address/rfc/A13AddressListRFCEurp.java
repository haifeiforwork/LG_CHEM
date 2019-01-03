package hris.A.A13Address.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * A13AddressListRFCEurp.java 개인의 주소 정보를 가져오는 RFC를 호출하는 Class
 * 
 * @author yji
 * @version 2010/07/19
 */
public class A13AddressListRFCEurp extends SAPWrap {
	
	private String functionName = "ZHRE_RFC_ADDRESS_LIST2";		

	/**
	 * 개인의 주소 정보를 가져오는 RFC를 호출하는 Method
	 * 
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	public Vector getAddressList(String keycode, String subty)
			throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			// subty = "";
			JCO.Function function = createFunction(functionName);

			setInput(function, keycode, subty, "1");

			excute(mConnection, function);

			Vector ret = getOutput(function);

			return ret;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * 주소 입력 RFC 호출하는 Method
	 * 
	 * @return java.util.Vector
	 *            java.lang.String 회사코드
	 * @exception GeneralException
	 */
	public String build(String keycode, String subty, Vector reportVector)
			throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setInput(function, keycode, subty, "2");

			setInput(function, reportVector, "ITAB");

			excute(mConnection, function);

			return getField("E_MESSAG", function);

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	public String change(String keycode, String subty, Vector reportVector)
			throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setInput(function, keycode, subty, "3");

			setInput(function, reportVector, "ITAB");

			excute(mConnection, function);

			return getField("E_MESSAG", function);
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
	 *            java.lang.String 사번
	 * @exception GeneralException
	 */
	private void setInput(JCO.Function function, String keycode, String subty,
			String jobcode) throws GeneralException {
		String fieldName1 = "I_PERNR";
		setField(function, fieldName1, keycode);

		String fieldName2 = "I_SUBTY";
		setField(function, fieldName2, subty);

		String fieldName3 = "I_GTYPE";
		setField(function, fieldName3, jobcode);
	}

	// Import Parameter 가 Vector(Table) 인 경우
	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @param entityVector
	 *            java.util.Vector
	 * @exception GeneralException
	 */
	private void setInput(JCO.Function function, Vector entityVector,
			String tableName) throws GeneralException {
		setTable(function, tableName, entityVector);
	}

	/**
	 * RFC 실행후 Export 값을 Vector 로 Return 한다. 반드시
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * 가 호출된후에 실행되어야하는 메소드
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {
		String entityName = "hris.A.A13Address.A13AddressListData";
		String tableName = "ITAB";
		return getTable(entityName, function, tableName);
	}
	
}
