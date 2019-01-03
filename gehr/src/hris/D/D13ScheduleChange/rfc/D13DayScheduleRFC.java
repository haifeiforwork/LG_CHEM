package hris.D.D13ScheduleChange.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D13DayScheduleRFC extends SAPWrap {
	private String functionName = "ZGHR_RFC_DAY_SCHEDULE" ;
	
	/**
	 * ��ȸ���ڷ����ϱٹ����� �����͸� ������
	 * @param i_datum
	 * @param i_orgeh
	 * @return
	 * @throws GeneralException
	 */
	public Vector getScheduleType( String i_begda, String i_endda, String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, i_begda, i_endda, i_pernr);
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
	 * ��ȸ���ڸ� �Է��Ѵ�
	 * @param function
	 * @param i_datum
	 * @param i_orgeh
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInput(JCO.Function function, String i_begda, String i_endda, String i_pernr) throws GeneralException {
        setField( function, "I_BEGDA", i_begda );
        setField( function, "I_ENDDA", i_endda );
        setField( function, "I_PERNR", i_pernr );
    }
	
	/**
	 * ���ϱٹ�����
	 * @param function
	 * @return
	 * @throws GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        
        Vector T_RESULT  = getTable("hris.D.D13ScheduleChange.D13DayScheduleData", function, "T_RESULT");
    		
    	
    	ret.addElement(T_RESULT);
    	
        return ret;
    }
}
