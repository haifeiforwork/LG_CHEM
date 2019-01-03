package hris.D.D09ContractExtension.rfc;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.D.D09ContractExtension.D09ExtensionData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

/**
 * D09ContractExtensionRFC.java
 * Contract Extension 조회/신청/수정/삭제 RFC 를 호출하는 Class
 * 
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D09ContractExtensionRFC extends ApprovalSAPWrap {

	private String functionName = "ZGHR_RFC_CONTRACT_EXT_REQ";

	/**
	 * Contract Extension정보를 가져오는 RFC를 호출하는 Method
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public Map<String, D09ExtensionData> getDetail(String I_ITPNR) throws GeneralException {

		JCO.Client mConnection = null;

		try{
			Map<String, D09ExtensionData> resultData = new HashMap<String, D09ExtensionData>();

			mConnection = getClient();
			JCO.Function function = createFunction(functionName) ;

			setField(function, "I_ITPNR", I_ITPNR);

			excuteDetail(mConnection, function);

			resultData.put("T_CURRENT", (D09ExtensionData) Utils.indexOf(getTable(D09ExtensionData.class, function, "T_CURRENT"), 0));
			resultData.put("T_RESULT", (D09ExtensionData) Utils.indexOf(getTable(D09ExtensionData.class, function, "T_RESULT"), 0));

			return resultData;

		} catch(Exception ex){
			Logger.error(ex);
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * Contract Extension 입력 RFC 호출하는 Method
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public String build(Vector<D09ExtensionData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

		JCO.Client mConnection = null;
		try{
			mConnection = getClient();
			JCO.Function function = createFunction(functionName) ;

			setTable(function, "T_RESULT", T_RESULT);

			return executeRequest(mConnection, function, box, req);

		} catch(Exception ex){
			Logger.error(ex);
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * Contract Extension 삭제 RFC 호출하는 Method
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public RFCReturnEntity delete() throws GeneralException {

		JCO.Client mConnection = null;
		try{
			mConnection = getClient();
			JCO.Function function = createFunction(functionName) ;

			return executeDelete(mConnection, function);

		} catch(Exception ex){
			Logger.sap.println(this, "SAPException : "+ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}


}
