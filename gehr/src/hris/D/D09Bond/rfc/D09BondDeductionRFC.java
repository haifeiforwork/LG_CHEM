package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondDeductionRFC.java
 * 채권 압류 공제 현황을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/23
 */
public class D09BondDeductionRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BOND_DEDUCTION" ;

    /**
     * 채권 압류 공제 현황을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondDeduction( String empNo, String BEGDA, String ENDDA ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, BEGDA, ENDDA ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                D09BondDeductionData data = ( D09BondDeductionData ) ret.get( i ) ;

                data.BETRG01 = Double.toString( Double.parseDouble( data.BETRG01 ) * 100.0 ) ;  // 정규급여
                data.BETRG02 = Double.toString( Double.parseDouble( data.BETRG02 ) * 100.0 ) ;  // 정규상여
                data.BETRG04 = Double.toString( Double.parseDouble( data.BETRG04 ) * 100.0 ) ;  // 비정규상여
                data.BETRG03 = Double.toString( Double.parseDouble( data.BETRG03 ) * 100.0 ) ;  // 퇴직금
                data.G_SUM   = Double.toString( Double.parseDouble( data.G_SUM   ) * 100.0 ) ;  // 공제액계
            }

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
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
    private void setInput( JCO.Function function, String empNo, String BEGDA, String ENDDA ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_BEGDA" ;
        setField( function, fieldNam1, BEGDA ) ;

        String fieldNam2 = "I_ENDDA" ;
        setField( function, fieldNam2, ENDDA ) ;
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.D.D09Bond.D09BondDeductionData" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
