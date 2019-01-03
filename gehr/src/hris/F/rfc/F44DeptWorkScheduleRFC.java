/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : ����                                                        */
/*   Program Name : �ٹ� ��ȹǥ                                                 */
/*   Program ID   : F44DeptWorkScheduleRFC                                      */
/*   Description  : �μ��� �ٹ� ��ȹǥ ��ȸ�� ���� RFC ����                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-18 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F44DeptWorkScheduleRFC
 * �μ��� ���� ��ü �ٹ� ��ȹǥ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F44DeptWorkScheduleRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_WORK_SCHEDULE";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� �ٹ� ��ȹǥ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ����/�ϰ� ����, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptWorkSchedule(SAPType sapType,String i_orgeh, String i_lower,String i_yyyymm ) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, i_orgeh, i_lower,i_yyyymm);
            excute(mConnection, function);
			if (!sapType.isLocal())   ret = getOutputGlobal(function);
			else ret = getOutput(function);
			Logger.debug.println(this, " ret = " + ret);
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
    private void setInput(JCO.Function function, String i_orgeh, String i_lower, String i_yyyymm) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_lower);
        String fieldName2  = "I_YYYYMM";
        setField(function, fieldName2, i_yyyymm);
        Logger.debug.println(this, " i_orgeh = " + i_orgeh);
        Logger.debug.println(this, " I_LOWERYN = " + i_lower);
        Logger.debug.println(this, " I_YYYYMM = " + i_yyyymm);
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

    	String fieldName3 = "E_BEGDA";       // ���۳��
    	String E_BEGDA  = getField(fieldName3, function) ;

    	String fieldName4 = "E_ENDDA";       // ������
    	String E_ENDDA  = getField(fieldName4, function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
        // Table ��� ��ȸ

    	Vector T_EXPORTA = getTable(hris.F.F44DeptWorkScheduleTitleData.class,  function, "T_EXPORTA");// Ÿ��Ʋ
    	Vector T_EXPORTB = getTable(hris.F.F44DeptWorkScheduleNoteData.class,  function, "T_EXPORTB"); // ����Ÿ.
    	Vector T_TPROG = getTable(hris.D.D40TmGroup.D40TmSchkzPlanningChartCodeData.class,  function, "T_TPROG"); //���ϱٹ����� ���� �߰� 2018-02-09

    	ret.addElement(T_EXPORTA);
    	ret.addElement(T_EXPORTB);
    	ret.addElement(E_BEGDA);
    	ret.addElement(E_ENDDA);
    	ret.addElement(T_TPROG);	//���ϱٹ����� ���� �߰� 2018-02-09

    	return ret;
    }
    private Vector getOutputGlobal(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();


    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

    	Vector T_EXPORTA = getTable(hris.F.Global.F44DeptWorkScheduleTitleData.class,  function, "T_EXPORTA");
    	Vector T_EXPORTB = getTable(hris.F.Global.F44DeptWorkScheduleNoteData.class,  function, "T_EXPORTB");

    	ret.addElement(T_EXPORTA);
    	ret.addElement(T_EXPORTB);

    	return ret;
    }

}


