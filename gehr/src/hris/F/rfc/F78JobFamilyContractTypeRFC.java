package hris.F.rfc;

import hris.F.F78JobFamilyContractTypeNoteData;
import hris.F.F78JobFamilyContractTypeTitleData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F78JobFamilyContractTypeRFC ������ ��� ���� ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F78JobFamilyContractTypeRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPJ_CONTRACT";

    /**
     * �����ڵ忡 ���� ��ü �μ����� ��� ���� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
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

			// Table ��� ��ȸ
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
