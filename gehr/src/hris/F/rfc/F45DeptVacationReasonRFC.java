/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 부서별 휴가 사용 현황                                       */
/*   Program ID   : F41DeptVacationRFC                                          */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 RFC 파일                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F41DeptVacationRFC
 * 부서에 따른 전체 부서원의 휴가 사용 현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F45DeptVacationReasonRFC extends SAPWrap {

   // private String functionName = "ZHRA_RFC_GET_HOLI_WORK_LIST";
	 private String functionName = "ZGHR_RFC_GET_HOLI_WORK_LIST";

    /**
     * 부서코드에 따른 전체 부서원의 휴가사유리포트 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptVacation(String i_orgeh, String i_check,  String i_yymm, String i_gubun) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check, i_yymm,i_gubun);
            excute(mConnection, function);
			ret = getOutput(function);

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
    private void setInput(JCO.Function function, String i_orgeh, String i_check,  String i_yymm, String i_gubun) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
        String fieldName2 = "I_DATE";
        setField(function, fieldName2, i_yymm);
        String fieldName3 = "I_GUBUN";
        setField(function, fieldName3, i_gubun);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	// Export 변수 조회
    	/*String fieldName1 = "E_RETURN";        // 리턴코드
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";      // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_MESSAGE  = getField(fieldName2, function) ;*/

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	// Table 결과 조회
    	Vector T_EXPORT = getTable(hris.F.F45DeptVacationReasonData.class,  function, "T_RESULT");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

}


