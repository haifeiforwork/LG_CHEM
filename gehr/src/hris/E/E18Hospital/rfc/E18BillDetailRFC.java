package hris.E.E18Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E18Hospital.* ;

/**
 * E18BillDetailRFC.java
 *  사원의 진료비 계산서 내역을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18BillDetailRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_MEDIC_BILL" ;
    private String functionName = "ZGHR_RFC_MEDIC_BILL" ;

    /**
     * 사원의 진료비 계산서 내역을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *             java.lang.String 관리번호
     *             java.lang.String 영수증번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getBillDetail( String empNo, String CTRL_NUMB, String RCPT_NUMB, String GUEN_CODE ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, CTRL_NUMB, RCPT_NUMB, GUEN_CODE ) ;
            excute( mConnection, function ) ;

            Vector ret = getTable( E18BillDetailData.class, function, "T_RESULT" );//getOutput( function ) ;

            for( int i = 0 ; i < ret.size() ; i++ ) {
                E18BillDetailData data = ( E18BillDetailData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW인 경우에만 100을 곱한다.
                    data.TOTL_WONX = Double.toString( Double.parseDouble( data.TOTL_WONX ) * 100.0 ) ;  // 총 진료비
                    data.ASSO_WONX = Double.toString( Double.parseDouble( data.ASSO_WONX ) * 100.0 ) ;  // 조합 부담금
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // 본인 부담금
                    data.MEAL_WONX = Double.toString( Double.parseDouble( data.MEAL_WONX ) * 100.0 ) ;  // 식대
                    data.APNT_WONX = Double.toString( Double.parseDouble( data.APNT_WONX ) * 100.0 ) ;  // 지정 진료비
                    data.ROOM_WONX = Double.toString( Double.parseDouble( data.ROOM_WONX ) * 100.0 ) ;  // 상급 병실료 차액
                    data.CTXX_WONX = Double.toString( Double.parseDouble( data.CTXX_WONX ) * 100.0 ) ;  // C T
                    data.MRIX_WONX = Double.toString( Double.parseDouble( data.MRIX_WONX ) * 100.0 ) ;  // M R I
                    data.SWAV_WONX = Double.toString( Double.parseDouble( data.SWAV_WONX ) * 100.0 ) ;  // 초음파
                    data.DISC_WONX = Double.toString( Double.parseDouble( data.DISC_WONX ) * 100.0 ) ;  // 할인금액
                    data.ETC1_WONX = Double.toString( Double.parseDouble( data.ETC1_WONX ) * 100.0 ) ;  // 기타1 의 금액
                    data.ETC2_WONX = Double.toString( Double.parseDouble( data.ETC2_WONX ) * 100.0 ) ;  // 기타2 의 금액
                    data.ETC3_WONX = Double.toString( Double.parseDouble( data.ETC3_WONX ) * 100.0 ) ;  // 기타3 의 금액
                    data.ETC4_WONX = Double.toString( Double.parseDouble( data.ETC4_WONX ) * 100.0 ) ;  // 기타4 의 금액
                    data.ETC5_WONX = Double.toString( Double.parseDouble( data.ETC5_WONX ) * 100.0 ) ;  // 기타5 의 금액
                }
            }

            return ret ;
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
    private void setInput( JCO.Function function, String empNo, String CTRL_NUMB, String RCPT_NUMB, String GUEN_CODE ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;
        String fieldNam1 = "I_CTRL_NUMB" ;
        setField( function, fieldNam1, CTRL_NUMB ) ;
        String fieldNam2 = "I_RCPT_NUMB" ;
        setField( function, fieldNam2, RCPT_NUMB ) ;
        String fieldNam3 = "I_GUEN_CODE" ;
        setField( function, fieldNam3, GUEN_CODE ) ;
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput( JCO.Function function ) throws GeneralException {
        //String entityName = "hris.E.E18Hospital.E18BillDetailData" ;
        //String tableName  = "RESULT" ;

        return getTable( E18BillDetailData.class, function, "T_RESULT" ) ;
    }

}
