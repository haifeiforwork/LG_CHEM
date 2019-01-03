/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 인원현황 각각의 상세화면                                    */
/*   Program ID   : F00DeptDetailListRFC                                        */
/*   Description  : 인원현황 각각의 상세화면 조회를 위한 RFC 파일               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-07 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc.Global;

import hris.common.util.AppUtil;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F00DeptDetailListRFC
 * 인원현황 각각의 상세화면 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  유용원
 * @version 1.0
 */
public class F00DeptDetailListRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_STATE_DETAI_LIST";

    /**
     * 인원현황 각각의 상세화면 정보를 가져오는 RFC를 호출하는 Method
     * @param paramF
     * @param java.lang.String 부서코드, 하위여부.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptDetailList(String i_gubun,  String i_deptId, String i_checkYN,
    								 String i_paramA, String i_paramB, String i_paramC,
									 String i_paramD, String i_paramE, String paramF ) throws GeneralException {
        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, i_gubun, i_deptId, i_checkYN, i_paramA, i_paramB, i_paramC, i_paramD, i_paramE,paramF);
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
     * @param paramF
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_gubun,  String i_deptId, String i_checkYN,
				                                   String i_paramA, String i_paramB, String i_paramC,
												   String i_paramD, String i_paramE, String paramF ) throws GeneralException {
    	if(i_paramD.equals("SUBT"))
    		i_paramD = "SUBTO";
    	else if(i_paramD.equals("TOTA"))
    		i_paramD = "TOTAL";
        String fieldName1  = "I_GUBUN";
        String fieldName2  = "I_ORGEH";
        String fieldName3  = "I_LOWERYN";
        String fieldName4  = "I_PARM1";
        String fieldName5  = "I_PARM2";
        String fieldName6  = "I_PARM3";
        String fieldName7  = "I_PARM4";
        String fieldName8  = "I_PARM5";
        String fieldName9  = "I_PARM6";
        setField(function, fieldName1, i_gubun);
        setField(function, fieldName2, i_deptId);
        setField(function, fieldName3, i_checkYN);
        setField(function, fieldName4, i_paramA);
        setField(function, fieldName5, i_paramB);
        setField(function, fieldName6, i_paramC);
        setField(function, fieldName7, i_paramD);
        setField(function, fieldName8, i_paramE);
        setField(function, fieldName9, paramF);

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

        // Table 결과 조회
    	String entityName = "hris.F.Global.F00DeptDetailListData";      // 데이타.
    	Vector T_EXPORTA = getTable(entityName,  function, "T_EXPORTA");
    	ret.addElement(T_EXPORTA);

    	return ret;
    }

}


