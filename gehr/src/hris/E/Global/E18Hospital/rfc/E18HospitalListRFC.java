package hris.E.Global.E18Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;
import hris.E.Global.E18Hospital.E18HospitalListData;

/**
 * E18HospitalListRFC.java
 *  사원의 의료비 내역을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18HospitalListRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_MEDICAL_DISPLAY" ;
    private String functionName = "ZGHR_RFC_MEDICAL_DISPLAY" ;

    /**
     * 사원의 의료비 내역을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getHospitalList( String empNo ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo ) ;
            excute( mConnection, function ) ;

            //Vector ret = getOutput( function ) ;

            String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;

        	Vector ret = new Vector();

        	// Table 결과 조회
        	Vector T_EXPORT  = getTable( E18HospitalListData.class, function, "T_ITAB" );

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
        	ret.addElement(T_EXPORT);

            /*for( int i = 0 ; i < ret.size() ; i++ ) {
                E18HospitalListData data = ( E18HospitalListData ) ret.get( i ) ;

                if( data.WAERS.equals("KRW") ) {          // KRW인 경우에만 100을 곱한다.
                    data.EMPL_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) * 100.0 ) ;  // 본인납부액
                    data.COMP_WONX = Double.toString( Double.parseDouble( data.COMP_WONX ) * 100.0 ) ;  // 회사지원액
                    data.YTAX_WONX = Double.toString( Double.parseDouble( data.YTAX_WONX ) * 100.0 ) ;  // 연말정산반영액
                    data.RFUN_AMNT = Double.toString( Double.parseDouble( data.RFUN_AMNT ) * 100.0 ) ;  // 반납액
                }
            }*/

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
    	Vector ret = new Vector();

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	// Table 결과 조회
    	//String entityName = "hris.E.Global.E18Hospital.E18HospitalListData" ;
    	Vector T_EXPORT  = getTable( E18HospitalListData.class, function, "T_ITAB" );

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

}
