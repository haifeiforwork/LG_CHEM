package hris.D.rfc;

import hris.D.BetweenDateData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * BetweenDateRFC.java
 * The Class of get date between begindate and enddate
 *
 * @author zgw
 * @version 2007/09/12
 */
public class BetweenDateRFC extends SAPWrap{

	private String functionName = "ZGHR_RFC_GET_BETWEEN_DATES" ;


	 public Vector BetweenDate( String BEGDA, String ENDDA ) throws GeneralException {

		    JCO.Client mConnection = null ;

		    Vector ret = new Vector();

	        try {
	            mConnection = getClient() ;
	            JCO.Function function = createFunction( functionName ) ;

	            setInput( function, BEGDA, ENDDA ) ;

	            excute( mConnection, function ) ;

	            ret = getTable( hris.D.BetweenDateData.class, function, "T_ITAB" ) ;

	            return ret ;
	        } catch( Exception ex ) {
	            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
	            throw new GeneralException( ex ) ;
	        } finally {
	            close( mConnection ) ;
	        }
	    }

	 private void setInput( JCO.Function function,  String BEGDA, String ENDDA ) throws GeneralException {

		    String fieldNam1 = "I_BEGDA" ;
	        setField( function, fieldNam1, BEGDA ) ;

	        String fieldNam2 = "I_ENDDA" ;
	        setField( function, fieldNam2, ENDDA ) ;
	    }

}
