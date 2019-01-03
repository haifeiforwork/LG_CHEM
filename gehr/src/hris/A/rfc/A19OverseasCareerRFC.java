/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 해외경험                                                    */
/*   Program Name : 해외경험 조회                                               */
/*   Program ID   : A19OverseasCareerRFC                                        */
/*   Description  : 해외경험 정보를 가져오는 RFC를 호출하는 Class               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

public class A19OverseasCareerRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_TRIP_LIST";

    /** 
     * 개인의 해외경험 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getOverseasDetail( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = null;

            ret = getOutput(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName  = "PERNR";
        setField(function, fieldName, empNo);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        // Export 변수 조회
        String fieldName1 = "E_RETURN";      // 리턴코드
        String E_RETURN   = getField(fieldName1, function) ;

        String fieldName2 = "E_MESSAGE";     // 다이얼로그 인터페이스에 대한 메세지텍스트
        String E_MESSAGE  = getField(fieldName2, function) ;

        // Table 결과 조회
        String entityName = "hris.A.A19OverseasCareerData";
        Vector T_EXPORT   = getTable(entityName,  function, "T_EXPORT");

        ret.addElement(E_RETURN);
        ret.addElement(E_MESSAGE);
        ret.addElement(T_EXPORT);

        return ret;
    }
}
