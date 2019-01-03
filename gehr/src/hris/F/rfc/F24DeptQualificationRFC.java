/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 자격 소지자 조회                                     */
/*   Program ID   : F24DeptQualificationRFC                                     */
/*   Description  : 부서별 자격 소지자 조회를 위한 RFC 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-31 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import hris.F.F24DeptQualificationData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F24DeptQualificationRFC
 * 부서에 따른 전체 부서원의 자격 소지자 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F24DeptQualificationRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_ORGEH_LICN";
    private String functionName = "ZGHR_RFC_GET_ORG_LICN_INFO";

    /**
     * 부서코드에 따른 전체 부서원의 자격 소지자 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptQualification(String i_orgeh, String i_check) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check);
            excute(mConnection, function);
			ret =  getTable(F24DeptQualificationData.class,  function, "T_EXPORTA");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_orgeh, String i_check) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
    }


}


