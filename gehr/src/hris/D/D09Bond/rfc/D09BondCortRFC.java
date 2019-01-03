package hris.D.D09Bond.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D09Bond.* ;

/**
 * D09BondCortRFC.java
 * 채권 이력 현황을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/02/28
 */
public class D09BondCortRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_BOND_CORT" ;

    /**
     * 채권 이력 현황을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *             java.lang.String 채권자 ID
     *             java.lang.String 일련번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBondCort( String empNo, String CRED_NUMB, String SEQN_NUMB ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, CRED_NUMB, SEQN_NUMB ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

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
    private void setInput( JCO.Function function, String empNo, String CRED_NUMB, String SEQN_NUMB ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_CRED_NUMB" ;
        setField( function, fieldNam1, CRED_NUMB ) ;

        String fieldNam2 = "I_SEQN_NUMB" ;
        setField( function, fieldNam2, SEQN_NUMB ) ;
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.D.D09Bond.D09BondCortData" ;
        String tableName  = "T_IT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
