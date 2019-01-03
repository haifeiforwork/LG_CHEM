package hris.C.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.C.* ;

/**
 * C03LearnDetailRFC.java
 * 사원의 교육 이력 사항을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2001/12/20
 */
public class C03LearnDetailRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EDUCATION" ;

    /**
     * 사원의 교육 이력 사항을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getLearnDetail( String empNo) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                C03LearnDetailData data = ( C03LearnDetailData ) ret.get( i ) ;
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
    private void setInput( JCO.Function function, String empNo ) throws GeneralException {
        String fieldName = "PERNR" ;
        setField( function, fieldName, empNo ) ;
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.C.C03LearnDetailData" ;
        String tableName  = "IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
