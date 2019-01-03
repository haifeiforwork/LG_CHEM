package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustYearCheckRFC.java
 * 연말정산 - ,회사별 PDF 여부 :화학도 중도입사자(그룹입사일2/1일이후 인 경우)  PDF업로드 못함 , 확정프로세스여부 조회
 *
 * @author  lsa
 * @version 1.0, 2013/11/22
 *
 * update    		2018/01/07 cykim [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
 */
public class D11TaxAdjustScreenControlRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_SCREEN_CONTROL" ;

    /**
     * 연말정산 - 확정 여부 조회
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getFLAG( String empNo, String targetYear, String curDate ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, empNo, targetYear,curDate ) ;
            excute(mConnection, function) ;
            Vector ret = getOutput(function);
            return ret;

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String targetYear, String curDate ) throws GeneralException {
        String fieldName1 = "P_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "P_ENDDA";
        setField( function, fieldName2, curDate );
        String fieldName3 = "P_YEAR";
        setField( function, fieldName3, targetYear );
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

        String E_PDF    = getField("E_PDF",    function);  //PDF 사용 여부
        ret.addElement(E_PDF);
        String E_CONFIRM    = getField("E_CONFIRM",    function);  //확정 프로세스 사용 여부
        ret.addElement(E_CONFIRM);
        /*[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 start */
        String E_LAST    = getField("E_LAST",    function);  //전근무지 예외자 여부
        ret.addElement(E_LAST);
        /*[CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건 end*/

        return ret;

    }
}