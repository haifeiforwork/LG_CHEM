package hris.D.D01OT.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D01OTCheck1RFC.java 초과근무 해당여부를 첵크하는 RFC 를 호출하는 Class
 * 
 * @author Yan Ning
 * @version 1.0, 2007/12/21
 */
public class D01OTCheck1RFC extends SAPWrap {

//	private String functionName = "ZHRW_RFC_OVERTIME_CHECK1";
	private String functionName = "ZGHR_RFC_OVERTIME_CHECK1";

	/**
	 * 초과근무 조회 RFC 호출하는 Method
	 * 
	 * @return java.lang.String
	 * @param java.lang.String
	 *            empNo
	 * @param java.lang.String
	 *            overtime date
	 * @param java.lang.String
	 *            overtime date
	 * @param java.lang.String
	 *            overtime time
	 * @param java.lang.String
	 *            overtime time
	 * @exception com.sns.jdf.GeneralException
	 */
	public void check(String PERSNO, String BEGDA, String BEGUZ, String ENDUZ)
			throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, PERSNO, BEGDA, BEGUZ, ENDUZ);
			excute(mConnection, function);
//			String ret = getField("E_MESSAGE", function);
//			return ret;
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
	 * @param java.lang.String
	 *            사원번호
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param job
	 *            java.lang.String 기능정보
	 * @exception com.sns.jdf.GeneralException
	 */
	private void setInput(JCO.Function function, String PERSNO, String BEGDA,
			String BEGUZ, String ENDUZ) throws GeneralException {
		String fieldName1 = "I_PERNR";
		setField(function, fieldName1, PERSNO);
		String fieldName2 = "I_BEGDA";
		setField(function, fieldName2, BEGDA);
		String fieldName3 = "I_ENDDA";
		setField(function, fieldName3, BEGDA);
		String fieldName4 = "I_BEGUZ";
		setField(function, fieldName4, BEGUZ);
		String fieldName5 = "I_ENDUZ";
		setField(function, fieldName5, ENDUZ);

	}

}
