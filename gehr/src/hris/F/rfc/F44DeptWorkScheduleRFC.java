/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 근무 계획표                                                 */
/*   Program ID   : F44DeptWorkScheduleRFC                                      */
/*   Description  : 부서별 근무 계획표 조회를 위한 RFC 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-18 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F44DeptWorkScheduleRFC
 * 부서에 따른 전체 근무 계획표 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F44DeptWorkScheduleRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_WORK_SCHEDULE";

    /**
     * 부서코드에 따른 전체 부서원의 근무 계획표 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 월간/일간 구분, 하위여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptWorkSchedule(SAPType sapType,String i_orgeh, String i_lower,String i_yyyymm ) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, i_orgeh, i_lower,i_yyyymm);
            excute(mConnection, function);
			if (!sapType.isLocal())   ret = getOutputGlobal(function);
			else ret = getOutput(function);
			Logger.debug.println(this, " ret = " + ret);
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
    private void setInput(JCO.Function function, String i_orgeh, String i_lower, String i_yyyymm) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_lower);
        String fieldName2  = "I_YYYYMM";
        setField(function, fieldName2, i_yyyymm);
        Logger.debug.println(this, " i_orgeh = " + i_orgeh);
        Logger.debug.println(this, " I_LOWERYN = " + i_lower);
        Logger.debug.println(this, " I_YYYYMM = " + i_yyyymm);
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

    	String fieldName3 = "E_BEGDA";       // 시작년월
    	String E_BEGDA  = getField(fieldName3, function) ;

    	String fieldName4 = "E_ENDDA";       // 종료년월
    	String E_ENDDA  = getField(fieldName4, function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
        // Table 결과 조회

    	Vector T_EXPORTA = getTable(hris.F.F44DeptWorkScheduleTitleData.class,  function, "T_EXPORTA");// 타이틀
    	Vector T_EXPORTB = getTable(hris.F.F44DeptWorkScheduleNoteData.class,  function, "T_EXPORTB"); // 데이타.
    	Vector T_TPROG = getTable(hris.D.D40TmGroup.D40TmSchkzPlanningChartCodeData.class,  function, "T_TPROG"); //일일근무일정 설명 추가 2018-02-09

    	ret.addElement(T_EXPORTA);
    	ret.addElement(T_EXPORTB);
    	ret.addElement(E_BEGDA);
    	ret.addElement(E_ENDDA);
    	ret.addElement(T_TPROG);	//일일근무일정 설명 추가 2018-02-09

    	return ret;
    }
    private Vector getOutputGlobal(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();


    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

    	Vector T_EXPORTA = getTable(hris.F.Global.F44DeptWorkScheduleTitleData.class,  function, "T_EXPORTA");
    	Vector T_EXPORTB = getTable(hris.F.Global.F44DeptWorkScheduleNoteData.class,  function, "T_EXPORTB");

    	ret.addElement(T_EXPORTA);
    	ret.addElement(T_EXPORTB);

    	return ret;
    }

}


