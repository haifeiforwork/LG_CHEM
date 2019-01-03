package hris.F.rfc;

import hris.F.F78JobFamilyContractTypeNoteData;
import hris.F.F78JobFamilyContractTypeTitleData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F78JobFamilyContractTypeRFC 직군별 계약 유형 정보를 가져오는 RFC를 호출하는 Class
 * @author
 * @version 1.0
 */
public class F78JobFamilyContractTypeRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPJ_CONTRACT";

    /**
     * 직군코드에 따른 전체 부서원의 계약 유형 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDeptJobFamilyContractType(String I_ORGEH, String I_DATUM, String I_LOWERYN, String I_MOLGA) throws GeneralException {

		JCO.Client mConnection = null;
		Vector resultList = new Vector();
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_ORGEH", I_ORGEH);
			setField(function, "I_DATUM", I_DATUM);
			setField(function, "I_LOWERYN", I_LOWERYN);
			setField(function, "I_MOLGA", I_MOLGA);

			excute(mConnection, function);

			// Table 결과 조회
			resultList.addElement(getTable(F78JobFamilyContractTypeTitleData.class, function, "T_EXPORTA"));
			resultList.addElement(getTable(F78JobFamilyContractTypeNoteData.class,  function, "T_EXPORTB"));
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
