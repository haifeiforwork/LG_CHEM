/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Time Management                                                        */
/*   Program Name : Daily Time Statement                                       */
/*   Program ID   : F43DeptDayWorkConditionRFCEurp                                */
/*   Description  : 부서별 월간/일간 근태 집계표 조회를 위한 RFC 파일[유럽용]          */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-08-05 yji                                           */
/********************************************************************************/

package hris.F.rfc.Global;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F43DeptDayWorkConditionRFCEurp
 * 부서에 따른 전체 부서원의 4개년 상대화 평가 정보를 가져오는 RFC를 호출하는 Class[유럽용]
 *
 * @author yji
 * @version 1.0
 */
public class F43DeptDayWorkConditionRFCEurp extends SAPWrap {

	private String functionName = "ZHRA_RFC_GET_DAY_QUOTA2";

	/**
	 * 부서코드에 따른 전체 부서원의 월간/일간 근태 집계표 정보를 가져오는 RFC를 호출하는 Method
	 *
	 * @param java.lang.String
	 *            부서코드, 월간/일간 구분, 하위여부.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptMonthWorkCondition(String i_orgeh, String i_today,
			String i_gubun, String i_lower) throws GeneralException {

		JCO.Client mConnection = null;
		Vector ret = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setInput(function, i_orgeh, i_today, "2", i_lower);
			excute(mConnection, function);
			ret = getOutput(function, i_gubun);

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
	private void setInput(JCO.Function function, String i_orgeh,
			String i_today, String i_gubun, String i_lower)
			throws GeneralException {
		String fieldName = "I_ORGEH";
		setField(function, fieldName, i_orgeh);
		String fieldName1 = "I_YYYYMM";
		setField(function, fieldName1, i_today);
		String fieldName3 = "I_LOWERYN";
		setField(function, fieldName3, i_lower);
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
	private Vector getOutput(JCO.Function function, String i_gubun)
			throws GeneralException {
		Vector ret = new Vector();

		// Export 변수 조회
		String fieldName1 = "E_RETURN"; // 리턴코드
		String E_RETURN = getField(fieldName1, function);

		String fieldName2 = "E_MESSAGE"; // 다이얼로그 인터페이스에 대한 메세지텍스트
		String E_MESSAGE = getField(fieldName2, function);
		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);

		// Table 결과 조회
		// 1:월간 2:일일 구분,
		if (i_gubun.equals("1")) {
			String entityName = "hris.F.F42DeptMonthWorkConditionData"; // 월간
			Vector T_EXPORTC = getTable(entityName, function, "T_EXPORTC");

			ret.addElement(T_EXPORTC);
		} else {
			String entityName1 = "hris.F.F43DeptDayTitleWorkConditionData"; // 일간
			// 타이틀.
			Vector T_EXPORTA = getTable(entityName1, function, "T_EXPORTA");
			String entityName2 = "hris.F.F43DeptDayDataWorkConditionData"; // 일간
			// 데이타.
			Vector T_EXPORTB = getTable(entityName2, function, "T_EXPORTB");

			ret.addElement(T_EXPORTA);
			ret.addElement(T_EXPORTB);
		}

		return ret;
	}

}
