package hris.F.rfc;

import hris.F.F77DeptUnitContractTypeNoteData;
import hris.F.F77DeptUnitContractTypeTitleData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F77DeptUnitContractTypeRFC.java
 * 부서별 계약 유형 정보를 가져오는 RFC를 호출하는 Class (USA)
 * @author
 * @version 1.0
 */
public class F77DeptUnitContractTypeRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPC_CONTRACT";

    /**
     * 부서코드에 따른 전체 부서원의 계약 유형 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDeptUnitContractType(String I_ORGEH, String I_DATLO, String I_LOWERYN, String I_MOLGA) throws GeneralException {

		JCO.Client mConnection = null;
		Vector resultList = new Vector();
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_ORGEH", I_ORGEH);
			setField(function, "I_DATUM", I_DATLO);
			setField(function, "I_LOWERYN", I_LOWERYN);
			setField(function, "I_MOLGA", I_MOLGA);

			excute(mConnection, function);

			//TABLE 결과조회
	    	resultList.addElement(getTable(F77DeptUnitContractTypeTitleData.class, function, "T_EXPORTA"));
	    	resultList.addElement(getTable(F77DeptUnitContractTypeNoteData.class,  function, "T_EXPORTB"));

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
