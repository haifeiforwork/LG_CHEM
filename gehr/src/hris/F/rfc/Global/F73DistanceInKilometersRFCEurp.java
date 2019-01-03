/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Headcount                                                    */
/*   Program Name : Org.Unit/Distance                                    */
/*   Program ID   : F73DistanceInKilometersRFCEurp                                     */
/*   Description  : 부서에 따른 거주지 출/퇴근거리 정보조회를 위한 RFC 파일               */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-08-02 yji                                           */
/********************************************************************************/

package hris.F.rfc.Global;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F73DistanceInKilometersRFCEurp 부서별 거주지 출/퇴근거리 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author yji
 * @version 1.0
 */
public class F73DistanceInKilometersRFCEurp extends SAPWrap {

	private String functionName = "ZHR_RFC_GET_DISTANCE";

	/**
	 * 부서코드에 따른 거주지 출/퇴근거리 정보를 가져오는 RFC를 호출하는 Method
	 *
	 * @param java.lang.String
	 *            부서코드, 하위여부.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDistanceInKilometers(String i_orgeh, String i_lower, String i_datum)
			throws GeneralException {

		JCO.Client mConnection = null;
		Vector ret = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, i_orgeh, i_lower, i_datum);
			excute(mConnection, function);
			ret = getOutput(function);

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return ret;
	}

	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @exception com.sns.jdf.GeneralException
	 */
	private void setInput(JCO.Function function, String i_orgeh, String i_lower, String i_datum)
			throws GeneralException {
		String fieldName = "I_ORGEH";
		setField(function, fieldName, i_orgeh);

		String fieldName1 = "I_DATUM";
		setField(function, fieldName1, i_datum);

		String fieldName2 = "I_LOWERYN";
		setField(function, fieldName2, i_lower);
	}

	/**
	 * RFC 실행후 Export 값을 String 로 Return 한다. 반드시
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * 가 호출된후에 실행되어야하는 메소드
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {
		Vector ret = new Vector();

		// Export 변수 조회
		String fieldName1 = "E_RETURN"; // 리턴코드
		String E_RETURN = getField(fieldName1, function);

		String fieldName2 = "E_MESSAGE"; // 다이얼로그 인터페이스에 대한 메세지텍스트
		String E_MESSAGE = getField(fieldName2, function);

		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);

		// Table 결과 조회
		String entityName1 = "hris.F.Global.F73DistanceInKilometersDataEurp"; // 타이틀.
		Vector T_EXPORTA = getTable(entityName1, function, "ITAB");

		ret.addElement(T_EXPORTA);

		return ret;
	}

}
