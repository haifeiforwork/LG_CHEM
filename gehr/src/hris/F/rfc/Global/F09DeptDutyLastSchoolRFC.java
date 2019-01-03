/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 직무별/최종학력별                                           */
/*   Program ID   : F09DeptDutyLastSchoolRFC                                    */
/*   Description  : 직무별/최종학력별 조회를 위한 RFC 파일                      */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-04 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc.Global;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * F09DeptDutyLastSchoolRFC 부서에 따른 직무별/최종학력별 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 유용원
 * @version 1.0
 */
public class F09DeptDutyLastSchoolRFC extends SAPWrap {

	private String functionName = "ZHRA_RFC_GET_OPFS_STATE";

	/**
	 * 부서코드에 따른 직무별/최종학력별 정보를 가져오는 RFC를 호출하는 Method
	 *
	 * @param java.lang.String
	 *            부서코드, 하위여부.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptDutyLastSchool(String i_orgeh, String i_lower)
			throws GeneralException {

		JCO.Client mConnection = null;
		Vector ret = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setInput(function, i_orgeh, i_lower);
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
	private void setInput(JCO.Function function, String i_orgeh, String i_lower)
			throws GeneralException {
		String fieldName = "I_ORGEH";
		setField(function, fieldName, i_orgeh);
		String fieldName1 = "I_LOWERYN";
		setField(function, fieldName1, i_lower);
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
		String entityName1 = "hris.F.Global.F06DeptPositionClassServiceTitleData"; // 타이틀.
		Vector T_EXPORTA = getTable(entityName1, function, "T_EXPORTA");
		// String entityName2 = "hris.F.F08DeptDutySchoolNoteData"; // 데이타.
		// Vector T_EXPORTB = getTable(entityName2, function, "T_EXPORTB");

		ret.addElement(T_EXPORTA);
		// ret.addElement(T_EXPORTB);

		return ret;
	}

}
