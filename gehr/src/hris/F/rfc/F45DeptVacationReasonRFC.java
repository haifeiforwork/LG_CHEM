/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : ����                                                        */
/*   Program Name : �μ��� �ް� ��� ��Ȳ                                       */
/*   Program ID   : F41DeptVacationRFC                                          */
/*   Description  : �μ��� �ް� ��� ��Ȳ ��ȸ�� ���� RFC ����                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-21 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F41DeptVacationRFC
 * �μ��� ���� ��ü �μ����� �ް� ��� ��Ȳ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F45DeptVacationReasonRFC extends SAPWrap {

   // private String functionName = "ZHRA_RFC_GET_HOLI_WORK_LIST";
	 private String functionName = "ZGHR_RFC_GET_HOLI_WORK_LIST";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� �ް���������Ʈ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptVacation(String i_orgeh, String i_check,  String i_yymm, String i_gubun) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check, i_yymm,i_gubun);
            excute(mConnection, function);
			ret = getOutput(function);

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
    private void setInput(JCO.Function function, String i_orgeh, String i_check,  String i_yymm, String i_gubun) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
        String fieldName2 = "I_DATE";
        setField(function, fieldName2, i_yymm);
        String fieldName3 = "I_GUBUN";
        setField(function, fieldName3, i_gubun);
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

    	// Export ���� ��ȸ
    	/*String fieldName1 = "E_RETURN";        // �����ڵ�
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";      // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName2, function) ;*/

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	// Table ��� ��ȸ
    	Vector T_EXPORT = getTable(hris.F.F45DeptVacationReasonData.class,  function, "T_RESULT");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

}


