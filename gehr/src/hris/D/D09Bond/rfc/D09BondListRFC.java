package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondListRFC.java
 * 채권 압류 현황을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/02/27
 */
public class D09BondListRFC extends SAPWrap {

    //private String functionName = "ZHRP_RFC_BOND_PRESENTSTATE" ;
	private String functionName = "ZGHR_RFC_BOND_PRESENTSTATE" ;

    /**
     * 채권 압류 현황을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondList( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                D09BondListData data = ( D09BondListData ) ret.get( i ) ;

                data.CRED_AMNT = Double.toString( Double.parseDouble( data.CRED_AMNT ) * 100.0 ) ;  // 가압류액
                data.GIVE_AMNT = Double.toString( Double.parseDouble( data.GIVE_AMNT ) * 100.0 ) ;  // 지급액
                data.REST_AMNT = Double.toString( Double.parseDouble( data.REST_AMNT ) * 100.0 ) ;  // 가압류잔액
                data.DPOT_CHRG = Double.toString( Double.parseDouble( data.DPOT_CHRG ) * 100.0 ) ;  // 공탁수수료
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
     * 공탁수수료를 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_DPOT_CHRG( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_DPOT_CHRG" ;
            String ret       = getField( fieldName, function ) ;

            Logger.debug.println( this, "E_G_DPOT_CHRG : " + ret ) ;

            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // 공탁수수료

            Logger.debug.println( this, "E_G_DPOT_CHRG : " + ret ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * 미배당공탁액을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_DPOT_REST( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_DPOT_REST" ;
            String ret       = getField( fieldName, function ) ;

            Logger.debug.println( this, "E_G_DPOT_REST : " + ret ) ;

            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // 미배당공탁액

            Logger.debug.println( this, "E_G_DPOT_REST : " + ret ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * 가압류 잔액 계를 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getG_REST_AMNT( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_G_REST_AMNT" ;
            String ret       = getField( fieldName, function ) ;

            Logger.debug.println( this, "E_G_REST_AMNT : " + ret ) ;

            ret = Double.toString( Double.parseDouble( ret ) * 100.0 ) ;  // 가압류 잔액 계를

            Logger.debug.println( this, "E_G_REST_AMNT : " + ret ) ;

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
        String fieldName = "I_PERNR" ;
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
        String entityName = "hris.D.D09Bond.D09BondListData" ;
        //String tableName  = "IT" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
        //return getTable( getExportFields(entityName, function,""), function, tableName ) ;
    }

}
