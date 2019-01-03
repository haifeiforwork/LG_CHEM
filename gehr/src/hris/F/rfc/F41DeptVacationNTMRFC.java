/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : ����                                                        		*/
/*   Program Name : �μ��� �ް� ��� ��Ȳ                                       		*/
/*   Program ID   : F41DeptVacationNTMRFC                                       */
/*   Description  : �μ��� �ް� ��� ��Ȳ ��ȸ�� ���� RFC ����                  		*/
/*   Note         : ����                                                        		*/
/*   Creation     : [WorkTime52] 2018-06-14 ��ȯ��                              		*/
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;


/**
 * F41DeptVacationNTMRFC
 * [WorkTime52]�μ��� ���� ��ü �μ����� �ް� ��� ��Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  ��ȯ��
 * @version 1.0
 */
public class F41DeptVacationNTMRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_NTM_GET_HOLIDAY_LIST";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� �ް� ��� ��Ȳ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptVacation(SAPType sapType, String i_orgeh, String i_check) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check);
            excute(mConnection, function);
			if (!sapType.isLocal())   ret = getOutputGlobal(function);
			else ret = getOutput(function);
	    	Logger.debug.println(this, "ret : "+ ret);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_orgeh, String i_check) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	// Table ��� ��ȸ
    	Vector T_EXPORT = getTable(hris.F.F41DeptVacationData.class,  function, "T_EXPORTA");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

    private Vector getOutputGlobal(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	String E_RETURN   = getReturn().MSGTY;
    	String fieldName = "E_LINE";
    	String E_MESSAGE  = getField(fieldName, function) ;
    	// Table ��� ��ȸ
    	Vector T_EXPORT = getTable(hris.F.Global.F41DeptVacationData.class,  function, "T_ITAB");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

}


