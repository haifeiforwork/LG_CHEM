package hris.D.D14PlanWorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D14WorkScheduleRuleRFC extends SAPWrap {
	private String functionName = "ZGHR_RFC_WSR" ;
	
	/**
	 * ��ȸ����, ��ȸ����� ���� �ٹ�������Ģ �����͸� ������
	 * @param i_datum		������
	 * @param i_orgeh		����
	 * @param i_sprsl		���Ű
	 * @param i_molga		����Ű
	 * @return
	 * @throws GeneralException
	 */
	public Vector getScheduleRuleType( String i_datum, String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, i_datum, i_pernr);
            excute( mConnection, function );
            
            Vector ret = getOutput( function );
            
            //Vector ret  = getTable(hris.D.D14PlanWorkTime.D14WorkScheduleRuleData.class, function, "P_RESULT");
            

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
	private void setInput(JCO.Function function, String i_datum, String i_pernr) throws GeneralException {
        setField( function, "I_DATUM", i_datum );
        setField( function, "I_PERNR", i_pernr );
        //setField( function, "I_SPRSL", i_sprsl );
        //setField( function, "I_MOLGA", i_molga );
    }
	
	/**
	 * �ٹ��������� ����
	 * @param function
	 * @return
	 * @throws GeneralException
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        
        Vector P_RESULT  = getTable(hris.D.D14PlanWorkTime.D14WorkScheduleRuleData.class, function, "T_RESULT");
    	
    	
    	
    	ret.addElement(P_RESULT);
    	
        return ret;
    }
}
