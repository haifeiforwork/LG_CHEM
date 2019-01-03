package hris.D.D13ScheduleChange.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D13DayWorkScheduleRFC extends SAPWrap {
	private String functionName = "ZGHR_RFC_DWS" ;//ZHRW_RFC_DWS
	
	/**
	 * 조회일자로 근무일정유형 데이터를 가져옴
	 * @param i_datum
	 * @param i_orgeh
	 * @return
	 * @throws GeneralException
	 */
	public Vector getScheduleType( String i_datum, String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, i_datum, i_pernr);
            excute( mConnection, function );
            
            Vector ret = getOutput( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
	/**
	 * 조회일자를 입력한다
	 * @param function
	 * @param i_datum
	 * @param i_orgeh
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInput(JCO.Function function, String i_datum, String i_pernr) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_PERNR", i_pernr );
    }
	
	/**
	 * 근무일정유형 정보
	 * @param function
	 * @return
	 * @throws GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        
        Vector T_RESULT  = getTable("hris.D.D13ScheduleChange.D13DayWorkScheduleData", function, "T_RESULT");//P_RESULT
    		
    	
    	ret.addElement(T_RESULT);
    	
        return ret;
    }
}
