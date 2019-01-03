package hris.E.Global.E17Hospital.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E17Hospital.* ;

/**
 * E17MedicCheckYNRFC.java
 * 배우자 공제한도 예외자로 등록되었는지 여부
 *
 * @author  김도신
 * @version 1.0, 2003/03/14
 */
public class E17MedicCheckYNRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_MEDIC_CHECK_YN" ;

    public String getE_FLAG( String i_yearc, String i_pernr ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, i_yearc, i_pernr ) ;
            excute( mConnection, function ) ;

            String fieldName = "E_FLAG" ;
            String E_FLAG    = getField( fieldName, function ) ;

            return E_FLAG ;
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
    private void setInput( JCO.Function function, String i_yearc, String i_pernr ) throws GeneralException {
        String fieldName1 = "I_YEARC" ;
        setField( function, fieldName1, i_yearc ) ;

        String fieldName2 = "I_PERNR" ;
        setField( function, fieldName2, i_pernr ) ;
    }
}
