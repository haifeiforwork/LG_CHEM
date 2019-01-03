/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Time Management                                                        */
/*   Program Name : Daily Time Statement                                       */
/*   Program ID   : F43DeptDayWorkConditionRFCEurp                                */
/*   Description  : �μ��� ����/�ϰ� ���� ����ǥ ��ȸ�� ���� RFC ����[������]          */
/*   Note         : ����                                                        */
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
 * �μ��� ���� ��ü �μ����� 4���� ���ȭ �� ������ �������� RFC�� ȣ���ϴ� Class[������]
 *
 * @author yji
 * @version 1.0
 */
public class F43DeptDayWorkConditionRFCEurp extends SAPWrap {

	private String functionName = "ZHRA_RFC_GET_DAY_QUOTA2";

	/**
	 * �μ��ڵ忡 ���� ��ü �μ����� ����/�ϰ� ���� ����ǥ ������ �������� RFC�� ȣ���ϴ� Method
	 *
	 * @param java.lang.String
	 *            �μ��ڵ�, ����/�ϰ� ����, ��������.
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
	 * RFC �������� Import ���� setting �Ѵ�. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
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
	 * RFC ������ Export ���� String �� Return �Ѵ�. �ݵ��
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	private Vector getOutput(JCO.Function function, String i_gubun)
			throws GeneralException {
		Vector ret = new Vector();

		// Export ���� ��ȸ
		String fieldName1 = "E_RETURN"; // �����ڵ�
		String E_RETURN = getField(fieldName1, function);

		String fieldName2 = "E_MESSAGE"; // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
		String E_MESSAGE = getField(fieldName2, function);
		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);

		// Table ��� ��ȸ
		// 1:���� 2:���� ����,
		if (i_gubun.equals("1")) {
			String entityName = "hris.F.F42DeptMonthWorkConditionData"; // ����
			Vector T_EXPORTC = getTable(entityName, function, "T_EXPORTC");

			ret.addElement(T_EXPORTC);
		} else {
			String entityName1 = "hris.F.F43DeptDayTitleWorkConditionData"; // �ϰ�
			// Ÿ��Ʋ.
			Vector T_EXPORTA = getTable(entityName1, function, "T_EXPORTA");
			String entityName2 = "hris.F.F43DeptDayDataWorkConditionData"; // �ϰ�
			// ����Ÿ.
			Vector T_EXPORTB = getTable(entityName2, function, "T_EXPORTB");

			ret.addElement(T_EXPORTA);
			ret.addElement(T_EXPORTB);
		}

		return ret;
	}

}
