package hris.D.D09ContractExtension.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * D09ContractExtensionTypeRFC.java
 * Contract Extension Type을 조회하는 RFC 를 호출하는 Class
 * 
 * @author jungin
 * @version 1.0, 2010/10/13
 */
public class D09ContractExtensionTypeRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_CTTYP_F4";

	/**
	 * Contract Extension Type을 조회하는 RFC 호출하는 Method
	 */
	public Vector getContractExtensionType(String I_CTTYP)
			throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_CTTYP", I_CTTYP);
			setField(function, "I_SPRSL", "EN");

			excute(mConnection, function);

			return getCodeVector(function, "T_RESULT", "CTTYP", "CTTXT");

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

}
