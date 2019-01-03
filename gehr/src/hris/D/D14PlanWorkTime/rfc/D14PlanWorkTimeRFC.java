package hris.D.D14PlanWorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D14PlanWorkTimeRFC extends SAPWrap {
	private String functionName = "ZGHR_RFC_MOD_WSR" ;
	
	/**
	 * ��ȸ����, ��ȸ�μ��ڵ�� ���ϱٹ����� �����͸� ������/����
	 * @param i_datum		������
	 * @param i_orgeh
	 * @param i_sprsl		���Ű
	 * @param i_molga		����Ű
	 * @param i_molga		����Ű
	 * @param I_LOWERYN		 CHAR 	 1 	�����μ�('Y':�����μ�����)
	 * @return
	 * @throws GeneralException
	 */
	public Vector getScheduleRuleForOrgeh( String i_datum, String i_orgeh, String i_loweryn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

//            setInputForOrgeh( function, i_datum, i_orgeh, "SEE" );
            setInputForOrgeh( function, i_datum, i_orgeh, i_loweryn );
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
	 * ��ȸ����, ��ȸ�����ȣ�� ���ϱٹ����� �����͸� ������
	 * @param i_datum
	 * @param i_orgeh
	 * @return
	 * @throws GeneralException
	 */
	public Vector getScheduleRuleForPernr( String i_datum, String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;
            
//            setInputForPernr( function, i_datum, i_pernr, "SEE" );
            setInputForPernr( function, i_datum, i_pernr, "1" );
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
	
	public Vector setScheduleRuleForOrgeh( String i_datum, String i_orgeh, String i_loweryn, Vector scheduleChangeData_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

//            setInputDataForOrgeh( function, i_datum, i_orgeh, i_loweryn, scheduleChangeData_vt, "INS" );
            setInputDataForOrgeh( function, i_datum, i_orgeh, i_loweryn, scheduleChangeData_vt, "2" );
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
	
	public Vector setScheduleRuleForPernr( String i_datum, String i_pernr, String i_loweryn, Vector scheduleChangeData_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

//            setInputDataForPernr( function, i_datum, i_pernr, i_loweryn, scheduleChangeData_vt, "INS" );
            setInputDataForPernr( function, i_datum, i_pernr, i_loweryn, scheduleChangeData_vt, "2" );
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
	 * ��ȸ����, �μ��ڵ�, I_COMMAND �Է��Ѵ�
	 * @param function
	 * @param i_datum
	 * @param i_orgeh
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputForOrgeh(JCO.Function function, String i_datum, String i_orgeh, String i_loweryn) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_ORGEH", i_orgeh );
        setField( function, "I_LOWERYN", i_loweryn );
        setField( function, "I_GTYPE", "1"    		);
//        setField( function, "I_COMMAND", i_command );
    }
	
	/**
	 * ��ȸ����, �����ȣ, I_COMMAND �Է��Ѵ�
	 * @param function
	 * @param i_datum
	 * @param i_pernr
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputForPernr(JCO.Function function, String i_datum, String i_pernr, String i_command) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_PERNR", i_pernr );
        setField( function, "I_GTYPE", i_command );
        setField( function, "I_GTYPE", i_command );
//        setField( function, "I_COMMAND", i_command );
    }
	
	/**
	 * ����� ���ϱٹ����� ����
	 * @param function
	 * @param i_datum
	 * @param i_orgeh
	 * @param scheduleChangeData_vt
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputDataForOrgeh(JCO.Function function, String i_datum, String i_orgeh, String i_loweryn, Vector scheduleChangeData_vt, String i_command) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_ORGEH", i_orgeh );
        setField( function, "I_LOWERYN", i_loweryn );
        setTable( function, "T_RESULT", scheduleChangeData_vt);
        setField( function, "I_GTYPE", i_command );
//        setField( function, "I_COMMAND", i_command );
    }
	
	/**
	 * ����� ���ϱٹ����� ����
	 * @param function
	 * @param i_datum
	 * @param i_pernr
	 * @param scheduleChangeData_vt
	 * @param i_command
	 * @throws GeneralException
	 */
	private void setInputDataForPernr(JCO.Function function, String i_datum, String i_pernr, String i_loweryn, Vector scheduleChangeData_vt, String i_command) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_PERNR", i_pernr );
        setField( function, "I_LOWERYN", i_loweryn );
        setTable( function, "T_RESULT", scheduleChangeData_vt);
        setField( function, "I_GTYPE", i_command );
//        setField( function, "I_COMMAND", i_command );
    }
	
	/**
	 * ���ϱٹ����� ����
	 * @param function
	 * @return
	 * @throws GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        
        Vector T_RESULT  = getTable(hris.D.D14PlanWorkTime.D14PlanWorkTimeData.class, function, "T_RESULT");
    	
    	String E_RETURN   = getReturn().MSGTY ;	// S or N
    	String E_MESSAGE  = getReturn().MSGTX;
    	
    	ret.addElement(T_RESULT);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	
        return ret;
    }
}
