/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 복리후생                                                    */
/*   Program Name : 부서별 복리후생 현황                                        */
/*   Program ID   : F51DeptWelfareRFC                                           */
/*   Description  : 부서별 복리후생 현황 조회를 위한 RFC 파일                   */
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
 * F51DeptWelfareRFC
 * 부서에 따른 전체 부서원의 복리후생 현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F51DeptWelfareRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_WELFARE_RECEIVERS";
	private String functionName = "ZGHR_RFC_GET_WELFARE_RECEIVERS";

    /**
     * 부서코드에 따른 전체 부서원의 복리후생 현황 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부, 구분, 검색시작일, 검색종료일.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptWelfare(String i_orgeh, String i_check, String i_gubun, String i_start, String i_end, String i_datum,SAPType sapType) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check, i_gubun, i_start, i_end,i_datum, sapType);
            excute(mConnection, function);
			ret = getOutput(function,sapType);

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
    private void setInput(JCO.Function function, String i_orgeh, String i_check, String i_gubun, String i_start, String i_end, String i_datum,SAPType sapType) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
        if(sapType.isLocal()){
        	String fieldName2 = "I_GUBUN";
            setField(function, fieldName2, i_gubun);
        }
        String fieldName3 = "I_BEGDA";
        setField(function, fieldName3, i_start);
        String fieldName4 = "I_ENDDA";
        setField(function, fieldName4, i_end);
        String fieldName5 = "I_DATUM";
        setField(function, fieldName5, i_datum);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function,SAPType sapType) throws GeneralException {
    	Vector ret = new Vector();
    	Vector T_EXPORT;
    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;
    	// Table 결과 조회
    	 if (!sapType.isLocal()) {
    		 T_EXPORT = getTable(hris.F.Global.F51DeptWelfareData.class,  function, "T_EXPORTA");
    	 } else {
    		 T_EXPORT = getTable(hris.F.F51DeptWelfareData.class,  function, "T_EXPORTA");
    	 }
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

}


