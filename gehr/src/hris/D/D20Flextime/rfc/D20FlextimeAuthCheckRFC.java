package	hris.D.D20Flextime.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D20FlextimeAuthCheckRFC.java
 * Flextime ����üũ(�繫��,������) RFC�� ȣ���ϴ� Class
 * 2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û
 * @author eunha
 * @version 1.0, 2017/08/02
 */
public class D20FlextimeAuthCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_AVAILABLE_FLEXTIME";

    /**
     * Flextime ����üũ(�繫��,������) RFC�� ȣ���ϴ� Method
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