/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 월간/일간 근태 집계표                                       		*/
/*   Program ID   : F42DeptMonthWorkConditionRFC                                */
/*   Description  : 부서별 월간/일간 근태 집계표 조회를 위한 RFC 파일          		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : 2005-02-17 유용원                                           		*/
/*   Update       : 2018-07-19 성환희 [Worktime52] 월간 RFC 변경					*/
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import hris.common.WebUserData;

import java.util.*;

import com.common.constant.Area;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F42DeptMonthWorkConditionRFC
 * 부서에 따른 전체 부서원의 4개년 상대화 평가 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F42DeptMonthWorkConditionRFC extends SAPWrap {

//	 private String functionName = "ZHRA_RFC_GET_WORK_CONDUCT";
	 private String functionName = "ZGHR_RFC_GET_WORK_CONDUCT";
	 private String functionNameNtm = "ZGHR_RFC_NTM_GET_WORK_CONDUCT";
	 private String functionName1 = "ZGHR_RFC_GET_MONTH_QUOTA";
	 private String functionName2 = "ZGHR_RFC_GET_MONTH_QUOTA2";

    /**
     * 부서코드에 따른 전체 부서원의 월간/일간 근태 집계표 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 월간/일간 구분, 하위여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptMonthWorkCondition( String i_orgeh, String i_today, String i_yyyymm, String i_gubun, String i_lower,SAPType sapType, Area area) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{

        	String excuteFunction ="";

        	if (  i_gubun.equals("1")){
        		 if (sapType.isLocal()) excuteFunction = functionNameNtm;
        		 else {
        			 if (area==Area.CN)	 excuteFunction = functionName1;
        			 else  excuteFunction = functionName2;
        		 }

        	}else {
        		if (sapType.isLocal()) excuteFunction = functionNameNtm;
        		else excuteFunction = functionName;
        	}
            mConnection = getClient();
            JCO.Function function = createFunction(excuteFunction) ;
            WebUserData userMolga = new WebUserData();
            userMolga.setArea(area);
            setInput(function, i_orgeh, i_today,i_yyyymm, i_gubun, i_lower,sapType);
            excute(mConnection, function,userMolga);
			ret = getOutput(function, i_gubun,sapType);

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
    private void setInput(JCO.Function function, String i_orgeh, String i_today,String i_yyyymm, String i_gubun, String i_lower,SAPType sapType) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);

        if (sapType.isLocal()) {
            String fieldName1 = "I_TODAY";
            setField(function, fieldName1, i_today);
        	String fieldName2 = "I_GUBUN";
            setField(function, fieldName2, i_gubun);
        }else{
            String fieldName1 = "I_YYYYMM";
            setField(function, fieldName1, i_yyyymm);
        }
        String fieldName3 = "I_LOWERYN";
        setField(function, fieldName3, i_lower);
    }


    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function, String i_gubun,SAPType sapType) throws GeneralException {
    	Vector ret = new Vector();

    	// Export 변수 조회
    	/*String fieldName1 = "E_RETURN";        // 리턴코드
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";      // 다이얼로그 인터페이스에 대한 메세지텍스트
    	String E_MESSAGE  = getField(fieldName2, function) ;*/

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);


    	 if (sapType.isLocal()) {
        // Table 결과 조회
    	//1:월간 2:일일 구분,
    	    	String fieldName3 = "E_YYYYMON";      // 조회년월
    	    	String E_YYYYMON  = getField(fieldName3, function) ;
    	    	ret.addElement(E_YYYYMON);
    		 if( i_gubun.equals("1") ){
    			 	Vector T_EXPORTC = getTable(hris.F.F42DeptMonthWorkConditionData.class,  function, "T_EXPORTC");//월간
    			 	ret.addElement(T_EXPORTC);
    		 }else{
    			   String fieldName4 = "E_DAY_CNT";      // 일자수
    			   String E_DAY_CNT  = getField(fieldName4, function) ;
    			   Vector T_EXPORTA = getTable(hris.F.F43DeptDayTitleWorkConditionData.class,  function, "T_EXPORTA");//일간 타이틀.
    			   Vector T_EXPORTB = getTable(hris.F.F43DeptDayDataWorkConditionData.class,  function, "T_EXPORTB"); //일간 데이타.
    			   ret.addElement(T_EXPORTA);
    			   ret.addElement(T_EXPORTB);
    			   ret.addElement(E_DAY_CNT);
    		 }
    	}else{

    		if( i_gubun.equals("1") ){
    			Vector T_EXPORTA = getTable(hris.F.Global.F42DeptMonthWorkConditionData.class,  function, "T_EXPORTA");	//월간
    			ret.addElement(T_EXPORTA);
    			Vector T_EXPORTB = getTable(hris.F.Global.F42DeptMonthWorkConditionData.class,  function, "T_EXPORTB");//월간
    			ret.addElement(T_EXPORTB);
    		} else{
    			Vector T_EXPORTA = getTable(hris.F.Global.F43DeptDayTitleWorkConditionData.class, function, "T_EXPORTA");// 일간
    			Vector T_EXPORTB = getTable(hris.F.Global.F43DeptDayDataWorkConditionData.class, function, "T_EXPORTB");// 일간
    			ret.addElement(T_EXPORTA);
    			ret.addElement(T_EXPORTB);
    		}
    	}

    	return ret;
    }

}


