/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Organization & Staffing
*   2Depth Name  : Headcount
*   Program Name : Org.Unit/Distance
*   Program ID   : F73DistanceInKilometersEurpGlobalRFC
*   Description  : �μ��� ���� ������ ��/��ٰŸ� ������ȸ�� ���� RFC ����
*   Note         : ����
*   Creation     :
********************************************************************************/

package hris.F.rfc;

import hris.F.F73DistanceInKilometersEurpGlobalData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F73DistanceInKilometersEurpGlobalRFC �μ��� ������ ��/��ٰŸ� ������ �������� RFC�� ȣ���ϴ� Class
 * @author
 * @version 1.0
 */
public class F73DistanceInKilometersEurpGlobalRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_DISTANCE";

	/**
	 * �μ��ڵ忡 ���� ������ ��/��ٰŸ� ������ �������� RFC�� ȣ���ϴ� Method
	 * @param java.lang.String �μ��ڵ�, ��������.
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDistanceInKilometers(String I_ORGEH, String I_LOWERYN, String I_DATUM, String I_MOLGA) throws GeneralException {

		JCO.Client mConnection = null;
		Vector resultList = new Vector();
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_MOLGA", I_MOLGA);

			excute(mConnection, function);

			// Table ��� ��ȸ
        	resultList.addElement(getTable(F73DistanceInKilometersEurpGlobalData.class,  function, "T_EXPORTA"));
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
		return resultList;
	}
}
