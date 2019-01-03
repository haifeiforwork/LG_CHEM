package	hris.D.D20Flextime.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D20FlextimeAuthCheckRFC.java
 * Flextime 권한체크(사무직,간부직) RFC를 호출하는 Class
 * 2017-08-01  eunha    [CSR ID:3438118] flexible time 시스템 요청
 * @author eunha
 * @version 1.0, 2017/08/02
 */
public class D20FlextimeAuthCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_AVAILABLE_FLEXTIME";

    /**
     * Flextime 권한체크(사무직,간부직) RFC를 호출하는 Method
     * @return String
     * @exception com.sns.jdf.GeneralException
     */
    public String getE_AVAILABLE(String I_PERNR) throws GeneralException {

    	JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function) ;

            return getField( "E_AVAILABLE", function ) ;

        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
}