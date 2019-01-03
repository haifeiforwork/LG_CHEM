/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : ������/�����зº�
*   Program ID   : F09DeptDutyLastSchoolRFC
*   Description  : ������/�����зº� ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F09DeptDutyLastSchoolTitleGlobalData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * F09DeptDutyLastSchoolRFC �μ��� ���� ������/�����зº� ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F09DeptDutyLastSchoolGlobalRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPFS_STATE";

	/**
	 * �μ��ڵ忡 ���� ������/�����зº� ������ �������� RFC�� ȣ���ϴ� Method
	 * @param java.lang.String �μ��ڵ�, ��������.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptDutyLastSchool(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

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
        	resultList.addElement(getTable(F09DeptDutyLastSchoolTitleGlobalData.class,  function, "T_EXPORTA"));

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
