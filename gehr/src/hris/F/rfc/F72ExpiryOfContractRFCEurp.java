/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                              */
/*   2Depth Name  : Personel Info                                           */
/*   Program Name : Expiry of Contract                                    */
/*   Program ID   : F31Dept4YearValuationRFC                                    */
/*   Description  : 계약만료 현황 정보 조회를 위한 RFC 파일               */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-07-22 yji                                           */
/********************************************************************************/

package hris.F.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.F.F72ExpiryOfContractDataEurp;

import java.util.Vector;

/**
 * F72ExpiryOfContractRFCEurp
 * 계약만료현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  yji
 * @version 1.0
 */
public class F72ExpiryOfContractRFCEurp extends SAPWrap {
 
    private String functionName = "ZGHR_RFC_GET_ORG_EXPRCON_INFO";

    /** 
     * 계약만료현황 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<F72ExpiryOfContractDataEurp> getDept4YearValuation(String I_ORGEH, String I_BEGDA , String I_ENDDA, String I_LOWERYN) throws GeneralException {
         
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            setField(function, "I_BEGDA", I_BEGDA);
            setField(function, "I_ENDDA", I_ENDDA);

            excute(mConnection, function);

			return getTable(F72ExpiryOfContractDataEurp.class, function, "T_EXPORTA");
			
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } 
    }
}
