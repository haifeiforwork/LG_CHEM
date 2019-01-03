/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        		*/
/*   Program Name : 부서별 휴가 사용 현황                                       		*/
/*   Program ID   : F41DeptVacationNTMRFC                                       */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 RFC 파일                  		*/
/*   Note         : 없음                                                        		*/
/*   Creation     : [WorkTime52] 2018-06-14 성환희                              		*/
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;


/**
 * F41DeptVacationNTMRFC
 * [WorkTime52]부서에 따른 전체 부서원의 휴가 사용 현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  성환희
 * @version 1.0
 */
public class F41DeptVacationNTMRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_NTM_GET_HOLIDAY_LIST";

    /**
     * 부서코드에 따른 전체 부서원의 휴가 사용 현황 정보를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 부서코드, 하위부서조회 여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptVacation(SAPType sapType, String i_orgeh, String i_check) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check);
            excute(mConnection, function);
			if (!sapType.isLocal())   ret = getOutputGlobal(function);
			else ret = getOutput(function);
	    	Logger.debug.println(this, "ret : "+ ret);

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

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	// Table 결과 조회
    	Vector T_EXPORT = getTable(hris.F.F41DeptVacationData.class,  function, "T_EXPORTA");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

    private Vector getOutputGlobal(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	String E_RETURN   = getReturn().MSGTY;
    	String fieldName = "E_LINE";
    	String E_MESSAGE  = getField(fieldName, function) ;
    	// Table 결과 조회
    	Vector T_EXPORT = getTable(hris.F.Global.F41DeptVacationData.class,  function, "T_ITAB");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

}


