package hris.A.A18Deduct.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.A.A18Deduct.* ;

/**
 *  A18CertiPrint02RFC.java
 *  갑종근로소득 영수증 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint02RFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_READ_YEA_RESULT_PRIN2" ;

    /**
     * 연말정산 결과내역를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empNo, String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainf_seqn);
            excute(mConnection, function);
            
            return getOutput( function );
         } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사번
     * @param ainf_seqn java.lang.String 결재번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String ainf_seqn) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_AINF_SEQN";
        setField( function, fieldName2, ainf_seqn ) ;
    }
// Export Return type이 Vector 인 경우 중 Vector의 Element type 가 com.sns.jdf.util.CodeEntity 일 경우 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

//      Table 조회
        String entityName      = "hris.A.A18Deduct.A18CertiPrintBusiData";
        Vector T_BUSINESSPLACE = getTable(entityName,  function, "T_BUSINESSPLACE");
        String entityName2     = "hris.A.A18Deduct.A18CertiPrint02Data";
        Vector T_RESULT        = getTable(entityName2, function, "T_RESULT");

        A18CertiPrintBusiData dataBus = new A18CertiPrintBusiData();
        if( T_BUSINESSPLACE.size() > 0 ) {     dataBus = (A18CertiPrintBusiData)T_BUSINESSPLACE.get(0);     }
        
        ret.addElement(dataBus);
        ret.addElement(T_RESULT);

        return ret;
    }

}