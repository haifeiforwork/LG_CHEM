/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �ҼӺ�/���޺� ��ձټ�                                      */
/*   Program ID   : F06DeptPositionClassServiceRFC                              */
/*   Description  : �ҼӺ�/���޺� ��ձټ� ��ȸ�� ���� RFC ����                 */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-03 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc.Global;

import hris.F.F06DeptPositionClassServiceTitleData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F06DeptPositionClassServiceRFC �μ��� ���� �ҼӺ�/���޺� ��ձټ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �����
 * @version 1.0
 */
public class F06DeptPositionClassServiceRFC extends SAPWrap {

	private String functionName = "ZHRA_RFC_GET_OPC_STATE";

	/**
	 * �μ��ڵ忡 ���� �ҼӺ�/���޺� ��ձټ� ������ �������� RFC�� ȣ���ϴ� Method
	 *
	 * @param java.lang.String
	 *            �μ��ڵ�, ��������.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptPositionClassService(String i_orgeh, String i_lower)
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
	 * RFC �������� Import ���� setting �Ѵ�. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
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
		String entityName1 = "hris.F.Global.F06DeptPositionClassServiceTitleData"; // Ÿ��Ʋ.
		Vector T_EXPORTA = getTable(entityName1, function, "T_EXPORTA");
		// String entityName2 = "hris.F.F06DeptPositionClassServiceNoteData"; //
		// ����Ÿ.
		Vector T_EXPORTB = new Vector();
		T_EXPORTB.addElement(new F06DeptPositionClassServiceTitleData());

		ret.addElement(T_EXPORTA);
		ret.addElement(T_EXPORTB);

		return ret;
	}

}