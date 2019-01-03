/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청    남경법인 용도 리스트                                         */
/*   Program Name : 재직증명서 신청    남경법인 용도 리스트                                         */
/*   Program ID   : A15CertiUseCodeRFC                                             */
/*   Description  : 남경법인 용도 리스트              */
/*   Note         :                                                             */
/*   Creation     : 2016-09-22  정진만											*/
/*   Update       :                                                           */
/*                :                                                            */
/********************************************************************************/
package hris.A.A15Certi.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

public class A15CertiUseCodeRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_CERT_USECD_F4";

	/**
     * Provid List
	 * @return
     * @throws GeneralException
	 */
	public Vector getUseCodeList(String I_PERNR, String I_CERT_CODE) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_PERNR", I_PERNR);
			setField(function, "I_CERT_CODE", I_CERT_CODE);

			excute(mConnection, function);

			return getCodeVector(function, "T_RESULT", "CODE", "TEXT");

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
}
