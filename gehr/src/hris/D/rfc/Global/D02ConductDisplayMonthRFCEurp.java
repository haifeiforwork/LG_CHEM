/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Personal HR Info                                               */
/*   2Depth Name  : Time Management                                                        */
/*   Program Name : Time & Attendance                                                */
/*   Program ID   : D02ConductDisplayMonthRFCEurp[À¯·´]                                       */
/*   Description  : Time & Attendance RFC                     */
/*   Note         :                                                             */
/*   Creation     : 2010-07-24  yji                                       */
/********************************************************************************/
package hris.D.rfc.Global;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D02ConductDisplayMonthRFCEurp.java
 *  the RFC class to get monthly total
 *
 * @author yji
 * @version 1.0
 * 2010/07/23
 */
public class D02ConductDisplayMonthRFCEurp extends SAPWrap{


	private String functionName = "ZGHR_RFC_TIME_DISPLAY2";


	  public Vector getMonAndDay( String empNo, String year, String month ) throws GeneralException {

		    JCO.Client mConnection = null ;

		    Vector return_vt = new Vector();

	        try {
	            mConnection = getClient() ;
	            JCO.Function function = createFunction( functionName ) ;

	            setInput( function, empNo, year, month ) ;
	            excute( mConnection, function ) ;

	            return_vt = getOutput(function);

	            return return_vt ;

	        } catch( Exception ex ) {
	            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
	            throw new GeneralException( ex ) ;
	        } finally {
	            close( mConnection ) ;
	        }
	    }



	  private void setInput( JCO.Function function, String empNo, String year, String month ) throws GeneralException {
	        String fieldName = "I_PERNR" ;
	        setField( function, fieldName, empNo ) ;

	        String fieldNam1 = "I_YEAR" ;
	        setField( function, fieldNam1, year ) ;

	        String fieldNam2 = "I_MONTH" ;
	        setField( function, fieldNam2, month ) ;
	    }


	  private Vector getOutput(JCO.Function function){

		     Vector return_vt = new Vector();
		     Vector dayDetial_vt = new Vector();
		     Vector monthTotal_vt = new Vector();

	         try{
	         		 String E_RETURN   = getReturn().MSGTY;
	         		 String E_MESSAGE   = getReturn().MSGTX;

	         	     return_vt.addElement(E_RETURN);
	         	     return_vt.addElement(E_MESSAGE);

	        	     dayDetial_vt = getTable(hris.D.Global.D02ConductDisplayDayData.class, function, "T_EXPORTA");
	        	     return_vt.addElement(dayDetial_vt);

	        	     monthTotal_vt = getTable(hris.D.Global.D02ConductDisplayMonthData.class, function, "T_EXPORTB");
	        	     return_vt.addElement(monthTotal_vt);

	            }catch(GeneralException e){

	            	Logger.debug.println("D02ConductDisplayMonthRFCEurp.getOutput exception");
	            }
	         return return_vt;

	    }

}
