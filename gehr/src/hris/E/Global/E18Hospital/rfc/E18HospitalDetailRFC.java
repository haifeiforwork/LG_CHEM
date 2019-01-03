package hris.E.Global.E18Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E18Hospital.* ;

/**
 * E18HospitalDetailRFC.java
 *  사원의 의료비 상세 내역을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18HospitalDetailRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_MEDIC_DETAIL" ;

    /**
     * 사원의 의료비 상세 내역을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *             java.lang.String 관리번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getHospitalDetail( String empNo, String CTRL_NUMB, String GUEN_CODE , String REGNO ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, CTRL_NUMB, GUEN_CODE,REGNO ) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                E18HospitalDetailData data = ( E18HospitalDetailData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW인 경우에만 100을 곱한다.
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // 본인 실납부액
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }  // 연말정산반영액
                }
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
    private void setInput( JCO.Function function, String empNo, String CTRL_NUMB, String GUEN_CODE, String REGNO ) throws GeneralException {
        String fieldName = "PERNR" ;
        setField( function, fieldName, empNo ) ;
        String fieldNam1 = "CTRL_NUMB" ;
        setField( function, fieldNam1, CTRL_NUMB ) ;
        String fieldNam2 = "GUEN_CODE" ;
        setField( function, fieldNam2, GUEN_CODE ) ;
        String fieldNam3 = "REGNO" ;
        setField( function, fieldNam3, REGNO ) ;
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        String entityName = "hris.E.E18Hospital.E18HospitalDetailData" ;
        String tableName  = "RESULT" ;

        return getTable( entityName, function, tableName ) ;
    }

}
