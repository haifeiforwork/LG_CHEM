/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : �ҼӺ� ����,���� �ο���Ȳ
*   Program ID   : F10DeptRaceClassGlobalRFC
*   Description  : �ҼӺ� ����,���� �ο���Ȳ ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F10DeptRaceClassTitleGlobalData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F10DeptRaceClassGlobalRFC �μ��� ���� �ҼӺ� ����,���� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F10DeptRaceClassGlobalRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPEG_STATE";

	/**
	 * �μ��ڵ忡 ���� ������/�����зº� ������ �������� RFC�� ȣ���ϴ� Method
	 *
	 * @param java.lang.String
	 *            �μ��ڵ�, ��������.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptRaceClass(String I_ORGEH, String I_LOWERYN, String I_MOLGA)throws GeneralException {

		JCO.Client mConnection = null;
		Vector resultList = new Vector();
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_MOLGA", I_MOLGA);

			excute(mConnection, function);

			// Table ��� ��ȸ
        	resultList.addElement(getTable(F10DeptRaceClassTitleGlobalData.class,  function, "T_EXPORTA"));

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
