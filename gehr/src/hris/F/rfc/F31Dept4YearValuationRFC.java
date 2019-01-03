/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 4개년 상대화 평가                                    */
/*   Program ID   : F31Dept4YearValuationRFC                                    */
/*   Description  : 부서별 4개년 상대화 평가 조회를 위한 RFC 파일               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-01 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.F.F31Dept4YearValuationData;

import java.util.Vector;


/**
 * F31Dept4YearValuationRFC
 * 부서에 따른 전체 부서원의 4개년 상대화 평가 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F31Dept4YearValuationRFC extends SAPWrap {


    private String functionName = "ZGHR_RFC_GET_ORG_APPR_INFO";

    /** 
     * 부서코드에 따른 전체 부서원의 4개년 상대화 평가 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<F31Dept4YearValuationData> getDept4YearValuation(String I_ORGEH, String I_LOWERYN) throws GeneralException {
         
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            //I_AYEAR 기준년도

            excute(mConnection, function);

            return getTable(F31Dept4YearValuationData.class, function, "T_EXPORTA");
			
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } 
    }
}


