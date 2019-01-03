/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                             */
/*   2Depth Name  : Time Management                                                        */
/*   Program Name : Monthly Time Statement                                       */
/*   Program ID   : F42DeptMonthWorkConditionRFCEurp                                */
/*   Description  : 부서별 월간/일간 근태 집계표 조회를 위한 RFC 파일[유럽]          */
/*   Note         : 없음                                                        */
/*   Creation     : 2010-07-22 yji                                           */
/********************************************************************************/

package hris.F.rfc.Global;

import hris.F.Global.F42DeptMonthWorkConditionDataEurp;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F42DeptMonthWorkConditionRFCEurp
 * 부서에 따른 전체 부서원의 4개년 상대화 평가 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  yji
 * @version 1.0, 2010-07-22
 */
public class F42DeptMonthWorkConditionRFCEurp extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_MONTH_QUOTA2";
	private String functionName = "ZGHR_RFC_GET_MONTH_QUOTA2";

    /**
     * 부서코드에 따른 전체 부서원의 월간/일간 근태 집계표 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 월간/일간 구분, 하위여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptMonthWorkCondition(String i_orgeh, String i_today,  String i_lower) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_today, i_lower);
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
    private void setInput(JCO.Function function, String i_orgeh, String i_today, String i_lower) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_YYYYMM";
        setField(function, fieldName1, i_today);
        String fieldName2 = "I_LOWERYN";
        setField(function, fieldName2, i_lower);
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
    	String fieldName1 = "E_RETURN";        // 리턴코드
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";      // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_MESSAGE  = getField(fieldName2, function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

       	Vector T_EXPORTC = getTable(F42DeptMonthWorkConditionDataEurp.class,  function, "T_EXPORTA");//일간
       	ret.addElement(T_EXPORTC);

       	Vector T_EXPORTB = getTable(F42DeptMonthWorkConditionDataEurp.class,  function, "T_EXPORTB");//월간
       	ret.addElement(T_EXPORTB);
    	return ret;
    }

}


