/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청    남경법인 이직확인서 리스트                                         */
/*   Program Name : 재직증명서 신청    남경법인 이직확인서 리스트                                         */
/*   Program ID   : A15CertiProvidRFC                                             */
/*   Description  : 남경법인 이직확인서 리스트              */
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

public class A15CertiProvidRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_CERT_PROVID_F4";

	/**
	 * Provid List
	 * @return
	 * @throws GeneralException
	 */
	public Vector getProvidList() throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			excute(mConnection, function);

			return getCodeVector(function, "T_RESULT", "PROVID", "PROVTX");

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
}
