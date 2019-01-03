package hris.F.rfc.Global;

import hris.common.util.AppUtil;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

/**
 * F00DeptDetailListRFCUsa.java
 * �ο���Ȳ ������ ��ȭ�� ������ �������� RFC�� ȣ���ϴ� Class (USA)
 *
 * @author jungin
 * @version 1.0, 2010-11-05
 */
public class F00DeptDetailListRFCUsa extends SAPWrap {

   // private String functionName = "ZHRE_RFC_TIME_DETAIL_EMP";

    //private String functionName1 = "ZHRA_RFC_TIME_DETAIL_ORG";

	 private String functionName = "ZGHR_RFC_TIME_DETAIL_EMP";
	 private String functionName1 = "ZGHR_RFC_TIME_DETAIL_ORG";

    /**
     * �ο���Ȳ ������ ��ȭ�� ������ �������� RFC�� ȣ���ϴ� Method
     * @param paramF
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptDetailEmpList(String I_PERNR, String I_BEGDA, String I_ENDDA, String I_ABSTY) throws GeneralException {
        JCO.Client mConnection = null;
        Vector ret = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            setInput(function, I_PERNR, I_BEGDA, I_ENDDA, I_ABSTY);
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

    public Vector getDeptDetailOrgList(String I_ORGEH, String I_BEGDA, String I_ENDDA, String I_ABSTY,  String I_LOWERYN) throws GeneralException {
        JCO.Client mConnection = null;
        Vector ret = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1);
            setInput1(function, I_ORGEH, I_BEGDA, I_ENDDA, I_ABSTY, I_LOWERYN);
            excute(mConnection, function);
			ret = getOutput1(function);
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
     * @param paramF
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String I_PERNR, String I_BEGDA, String I_ENDDA, String I_ABSTY) throws GeneralException {

        String fieldName1  = "I_PERNR";
        setField(function, fieldName1, I_PERNR);
        String fieldName2  = "I_BEGDA";
        setField(function, fieldName2, I_BEGDA);
        String fieldName3  = "I_ENDDA";
        setField(function, fieldName3, I_ENDDA);
        String fieldName4  = "I_ABSTY";
        setField(function, fieldName4, I_ABSTY);
    }

    private void setInput1(JCO.Function function, String I_ORGEH, String I_BEGDA, String I_ENDDA, String I_ABSTY, String I_LOWERYN) throws GeneralException {

        String fieldName1  = "I_ORGEH";
        setField(function, fieldName1, I_ORGEH);
        String fieldName2  = "I_BEGDA";
        setField(function, fieldName2, I_BEGDA);
        String fieldName3  = "I_ENDDA";
        setField(function, fieldName3, I_ENDDA);
        String fieldName4  = "I_ABSTY";
        setField(function, fieldName4, I_ABSTY);
        String fieldName5  = "I_LOWERYN";
        setField(function, fieldName5, I_LOWERYN);
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
    	//String fieldName1 = "E_MESSAGE";      // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	//String E_MESSAGE  = getField(fieldName1, function);

    	String E_MESSAGE  = getReturn().MSGTY;


    	ret.addElement(E_MESSAGE);

        // Table ��� ��ȸ
    	Vector ITAB = getTable(hris.F.Global.F00DeptDetailListDataUsa.class,  function, "T_ITAB");
    	ret.addElement(ITAB);

    	return ret;
    }

    private Vector getOutput1(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	// Export ���� ��ȸ
    	//String fieldName1 = "E_MESSAGE";      // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	//String E_MESSAGE  = getField(fieldName1, function);
    	String E_MESSAGE  = getReturn().MSGTY;

    	ret.addElement(E_MESSAGE);

        // Table ��� ��ȸ
    	//String entityName = "hris.F.Global.F00DeptDetailListDataUsa";      // ����Ÿ
    	Vector ITAB = getTable(hris.F.Global.F00DeptDetailListDataUsa.class,  function, "T_EXPORT");
    	ret.addElement(ITAB);

    	return ret;
    }

}
