package hris.F.rfc;

import hris.F.F79QuotaPlanResultStatusData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F79QuotaPlanResultStatusRFCUsa.java
 * 월별/조직별 인원계획 대비 실적 현황 정보를 가져오는 RFC를 호출하는 Class
 * @author
 * @version 1.0
 */
public class F79QuotaPlanResultStatusRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_QUOTA_PLAN_RESULT";

    /**
     * 월별/조직별 인원계획 대비 실적 현황 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getQuotaPlanResultStatus(String I_ORGEH, String I_PLNYR, String I_LOWERYN, String I_MOLGA) throws GeneralException {

		JCO.Client mConnection = null;
		Vector resultList = new Vector();
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_ORGEH", I_ORGEH);
			setField(function, "I_PLNYR", I_PLNYR);
			setField(function, "I_LOWERYN", I_LOWERYN);
			setField(function, "I_MOLGA", I_MOLGA);

			excute(mConnection, function);

			// Table 결과 조회
			resultList.addElement(getTable(F79QuotaPlanResultStatusData.class, function, "T_EXPORTA"));

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
