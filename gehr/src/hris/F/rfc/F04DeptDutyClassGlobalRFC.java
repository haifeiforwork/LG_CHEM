/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : �ο���Ȳ
*   Program Name : ������/���޺� �ο���Ȳ
*   Program ID   : F04DeptDutyClassGlobalRFC
*   Description  : ������/���޺� �ο���Ȳ ��ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F.rfc;

import hris.F.F04DeptDutyClassTitleGlobalData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * F04DeptDutyClassGlobalRFC �μ��� ���� ������/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F04DeptDutyClassGlobalRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_OPJL_STATE";
//
	/**
	 * �μ��ڵ忡 ���� ������/���޺� �ο���Ȳ ������ �������� RFC�� ȣ���ϴ� Method
	 * @param java.lang.String �μ��ڵ�, ��������.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDeptDutyClass(String I_ORGEH, String I_LOWERYN, String I_MOLGA) throws GeneralException {

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
        	resultList.addElement(getTable(F04DeptDutyClassTitleGlobalData.class,  function, "T_EXPORTA"));

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
