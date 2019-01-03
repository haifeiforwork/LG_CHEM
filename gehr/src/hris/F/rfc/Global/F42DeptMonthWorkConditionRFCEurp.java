/********************************************************************************/
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Organization & Staffing                                             */
/*   2Depth Name  : Time Management                                                        */
/*   Program Name : Monthly Time Statement                                       */
/*   Program ID   : F42DeptMonthWorkConditionRFCEurp                                */
/*   Description  : �μ��� ����/�ϰ� ���� ����ǥ ��ȸ�� ���� RFC ����[����]          */
/*   Note         : ����                                                        */
/*   Creation     : 2010-07-22 yji                                           */
/********************************************************************************/

package hris.F.rfc.Global;

import hris.F.Global.F42DeptMonthWorkConditionDataEurp;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F42DeptMonthWorkConditionRFCEurp
 * �μ��� ���� ��ü �μ����� 4���� ���ȭ �� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  yji
 * @version 1.0, 2010-07-22
 */
public class F42DeptMonthWorkConditionRFCEurp extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_MONTH_QUOTA2";
	private String functionName = "ZGHR_RFC_GET_MONTH_QUOTA2";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� ����/�ϰ� ���� ����ǥ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ����/�ϰ� ����, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptMonthWorkCondition(String i_orgeh, String i_today,  String i_lower) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_today, i_lower);
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
    private void setInput(JCO.Function function, String i_orgeh, String i_today, String i_lower) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_YYYYMM";
        setField(function, fieldName1, i_today);
        String fieldName2 = "I_LOWERYN";
        setField(function, fieldName2, i_lower);
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
    	String fieldName1 = "E_RETURN";        // �����ڵ�
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";      // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName2, function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

       	Vector T_EXPORTC = getTable(F42DeptMonthWorkConditionDataEurp.class,  function, "T_EXPORTA");//�ϰ�
       	ret.addElement(T_EXPORTC);

       	Vector T_EXPORTB = getTable(F42DeptMonthWorkConditionDataEurp.class,  function, "T_EXPORTB");//����
       	ret.addElement(T_EXPORTB);
    	return ret;
    }

}


