package hris.E.E21Expense.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * E21ExpenceCheckRFC.java
 * 장학자금 예외자 CHECK - FLAG 가 'X'는 예외자로 장학자금신청되도록 함.
 *
 * @author  윤정현
 * @version 1.0, 2004/09/06
 */
public class E21ExpenceCheckRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_SCHOOL_CHECK" ;
    private String functionName = "ZGHR_RFC_SCHOOL_CHECK" ;

    public String getExceptFLAG( String pernr, String subty ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, pernr, subty ) ;
            excute( mConnection, function ) ;

            String E_FLAG    = getField( "E_FLAG", function ) ;

            return E_FLAG ;
        } catch( Exception ex ) {
            //Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String pernr, String subty ) throws GeneralException {
        String fieldName1 = "I_PERNR" ;
        setField( function, fieldName1, pernr ) ;

        //String fieldName2 = "SUBTY" ;  //  SUBTY - 1: 입학축하금  2:학자금  3:장학금
        //setField( function, fieldName2, subty ) ;
    }
}
