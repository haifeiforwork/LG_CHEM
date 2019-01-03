/****************************************
 *  2015-06-19
 *  marco257
 *  
 *  e-HR ������ ��� ���� / ���� ����
 * 
 *****************************************/

package hris.N;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class WebAccessLog extends SAPWrap{
	
	/**
	 * �μ��� �������� �� ���� ȭ�� ��ȸ�� �α� ���
	 * @param menuCode
	 * @param mPernr
	 * @param ePernr
	 * @return
	 * @throws Exception
	 */
	public RFCReturnEntity setAccessLog(String menuCode, String mPernr, String ePernr, String sIP) throws GeneralException {
		JCO.Client mConnection = null;

	/*	if(!sapType.isLocal()) {
			RFCReturnEntity resultData =  new RFCReturnEntity();
			resultData.MSGTY = "S";
			return resultData;
		}*/
		try{
			mConnection = getClient();
			JCO.Function function = createFunction("ZGHR_RFC_RECORD_ACCESS") ;

			setField(function, "I_MENUC", menuCode);
			setField(function, "I_PERNR", mPernr);// ��ȸ��
			setField(function, "I_OBJECT", ePernr);//����ȸ��
			setField(function, "I_IP", sIP); //����� IP�߰�

			excute(mConnection, function);

			return getReturn();

		} catch(Exception ex){
			Logger.sap.println(this, "SAPException : "+ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}


	 /**
	  * ����� �ĺ���õ ���� ���
	  * @param ePernr
	  * @return
	  * @throws Exception
	  */
	 public RFCReturnEntity setBusnAccessLog(String ePernr) throws Exception {

		 JCO.Client mConnection = null;

		 try{
			 mConnection = getClient();
			 JCO.Function function = createFunction("ZGHR_RFC_RECORD_ACCESS2") ;

			 setField(function, "I_PERNR", ePernr);// ��ȸ��

			 excute(mConnection, function);

			 return getReturn();

		 } catch(Exception ex){
			 Logger.sap.println(this, "SAPException : "+ex.toString());
			 throw new GeneralException(ex);
		 } finally {
			 close(mConnection);
		 }

	 }
	 
	 /**
	  * ����� Role���� ����
	  * �α��� ������ �����
	  * @param role
	  * @return
	  * @throws Exception
	  */
	 public RFCReturnEntity setRoleCheckLog(String I_PERNR, String role) throws Exception {

		 JCO.Client mConnection = null;

		 try {
			 mConnection = getClient();
			 JCO.Function function = createFunction("ZGHR_RFC_CHECK_ROLE_NEW");

			 setField(function, "I_PERNR", I_PERNR);
			 setField(function, "I_ROLE", role);

			 excute(mConnection, function);

			 return getReturn();

		 } catch (Exception ex) {
			 Logger.sap.println(this, "SAPException : " + ex.toString());
			 throw new GeneralException(ex);
		 } finally {
			 close(mConnection);
		 }
	 }

}
