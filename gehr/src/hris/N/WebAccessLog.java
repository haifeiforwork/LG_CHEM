/****************************************
 *  2015-06-19
 *  marco257
 *  
 *  e-HR 웹접근 기록 관리 / 권한 관리
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
	 * 부서별 개인정보 및 조직 화상도 조회시 로그 기록
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
			setField(function, "I_PERNR", mPernr);// 조회자
			setField(function, "I_OBJECT", ePernr);//피조회자
			setField(function, "I_IP", sIP); //사용자 IP추가

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
	  * 사업가 후보추천 접근 기록
	  * @param ePernr
	  * @return
	  * @throws Exception
	  */
	 public RFCReturnEntity setBusnAccessLog(String ePernr) throws Exception {

		 JCO.Client mConnection = null;

		 try{
			 mConnection = getClient();
			 JCO.Function function = createFunction("ZGHR_RFC_RECORD_ACCESS2") ;

			 setField(function, "I_PERNR", ePernr);// 조회자

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
	  * 사용자 Role변경 저장
	  * 로그인 시점에 사용함
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
