/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                              */
/*   2Depth Name  : Headcount                                                    */
/*   Program Name : Org.Unit/Distance                                    */
/*   Program ID   : F73DistanceInKilometersRFCEurp                                     */
/*   Description  : �μ��� ���� ������ ��/��ٰŸ� ������ȸ�� ���� RFC ����               */
/*   Note         : ����                                                        */
/*   Creation     : 2010-08-02 yji                                           */
/********************************************************************************/

package hris.F.rfc.Global;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F73DistanceInKilometersRFCEurp �μ��� ������ ��/��ٰŸ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author yji
 * @version 1.0
 */
public class F73DistanceInKilometersRFCEurp extends SAPWrap {

	private String functionName = "ZHR_RFC_GET_DISTANCE";

	/**
	 * �μ��ڵ忡 ���� ������ ��/��ٰŸ� ������ �������� RFC�� ȣ���ϴ� Method
	 *
	 * @param java.lang.String
	 *            �μ��ڵ�, ��������.
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
	 * RFC �������� Import ���� setting �Ѵ�. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
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
	 * RFC ������ Export ���� String �� Return �Ѵ�. �ݵ��
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.lang.String
	 * @exception com.sns.jdf.GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {
		Vector ret = new Vector();

		// Export ���� ��ȸ
		String fieldName1 = "E_RETURN"; // �����ڵ�
		String E_RETURN = getField(fieldName1, function);

		String fieldName2 = "E_MESSAGE"; // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
		String E_MESSAGE = getField(fieldName2, function);

		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);

		// Table ��� ��ȸ
		String entityName1 = "hris.F.Global.F73DistanceInKilometersDataEurp"; // Ÿ��Ʋ.
		Vector T_EXPORTA = getTable(entityName1, function, "ITAB");

		ret.addElement(T_EXPORTA);

		return ret;
	}

}
