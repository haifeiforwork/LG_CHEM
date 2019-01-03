package hris.F.rfc;

import hris.F.F79QuotaPlanResultStatusData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F79QuotaPlanResultStatusRFCUsa.java
 * ����/������ �ο���ȹ ��� ���� ��Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F79QuotaPlanResultStatusRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_QUOTA_PLAN_RESULT";

    /**
     * ����/������ �ο���ȹ ��� ���� ��Ȳ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
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

			// Table ��� ��ȸ
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
