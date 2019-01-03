/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청                                             */
/*   Program ID   : A15CertiCodeRFC                                             */
/*   Description  : Internal certificate type RFC                    */
/*   Note         :                                                             */
/*   Creation     : 2007-09-12  zhouguangwen    global e-hr update              */
/*   Update       :                                                           */
/*                :                                                            */
/********************************************************************************/


package hris.A.A15Certi.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;



/**
 * A15CertiCodeRFC.java
 *                         
 * Internal certificate type
 * 
 * @author zhouguangwen
 * @version 2007/09/12
 */
public class A15CertiCodeRFC  extends SAPWrap {

	private String functionName = "ZGHR_RFC_CERT_TYPE_F4";

	/**
	 * for Certi select
	 *
	 * @return java.util.Vector
	 * @throws GeneralException
	 */
	public Vector getCertiCode(String I_PERNR) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_PERNR", I_PERNR);
			excute(mConnection, function);

			return getCodeVector(function, "T_RESULT");

		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
}
