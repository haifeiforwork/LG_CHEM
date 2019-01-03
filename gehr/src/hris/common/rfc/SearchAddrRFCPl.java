package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * SearchAddrRFC.java �ּ� �˻� List �� �������� RFC�� ȣ���ϴ� Class
 * 
 * @author yji
 * @version 1.0, 2010/07/02
 */
public class SearchAddrRFCPl extends SAPWrap {

	private String functionName = "ZHRH_RFC_ZIPP_CODE";

	/**
	 * �ּҰ˻� List �� �������� RFC�� ȣ���ϴ� Method
	 * 
	 *            �����
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	public Vector getAddrDetail(String sVal) throws GeneralException {

		JCO.Client mConnection = null;

		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, sVal);
			excute(mConnection, function);
			Vector ret = getOutput(function);
			Logger.debug.println(this, ret.toString());
			return ret;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
    
	private void setInput(JCO.Function function, String sVal) throws GeneralException {
        setField( function, "I_BEZEI2", sVal );
    }
	/**
	 * RFC ������ Export ���� Vector �� Return �Ѵ�. �ݵ��
	 * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function)
	 * �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @return java.util.Vector
	 * @exception GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {
		String entityName = "hris.common.SearchAddrDataPl";
		String tableName = "ITAB";
		return getTable(entityName, function, tableName);
	}

}