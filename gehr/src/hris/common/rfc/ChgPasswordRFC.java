package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.common.ChangePasswordResultData;

import java.util.Vector;

/**
 * ChgPasswordRFC.java
 * password ���� RFC�� ȣ���ϴ� Class
 *
 * @author ��α�   
 * @version 1.0, 2004/03/28
 * [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����
 */
public class ChgPasswordRFC extends SAPWrap {

    private String functionName = "ZGHR_CHANGE_PASSWORD";

    /**
     * password ���� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ���� �߰���
     */
    public ChangePasswordResultData chgPassword(String webUserId, String webUserPwd, String newWebUserPwd1, String newWebUserPwd2 ) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ID", webUserId);
            setField(function, "I_PASSWORD1", webUserPwd);
            setField(function, "I_PASSWORD2", newWebUserPwd1);
            setField(function, "I_PASSWORD3", newWebUserPwd2);

            excute(mConnection, function);

            ChangePasswordResultData resultData = getStructor(ChangePasswordResultData.class, function, "E_RETURN", null);
            resultData.E_FLAG = getField("E_FLAG", function);

            return resultData;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ���� ������
     */
    private void setInput(JCO.Function function, String webUserId, String webUserPwd) throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, webUserId);
		String fieldName2 = "PASSWORD";
        setField(function, fieldName2, webUserPwd);
    }
    
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ���� �߰���
     */
    private void setInput(JCO.Function function, String webUserId, String webUserPwd, String newWebUserPwd1, String newWebUserPwd2) throws GeneralException{
        String fieldName = "PERNR";
        setField(function, fieldName, webUserId);
		String fieldName1 = "PASSWORD1";
        setField(function, fieldName1, webUserPwd);
        String fieldName2 = "PASSWORD2";
        setField(function, fieldName2, newWebUserPwd1);
        String fieldName3 = "PASSWORD3";
        setField(function, fieldName3, newWebUserPwd2);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        //String fieldName = "E_FLAG";      // RFC Export ������� ����
        //return getField(fieldName, function);
    	Vector ret = new Vector();
    	String fieldName = "E_FLAG";
		String E_FLAG     = getField(fieldName, function) ;
		String fieldName1 = "E_RETURN";
		String E_RETURN     = getField(fieldName1, function) ; 
		String fieldName2    = "E_MESSAGE"; 
		String E_MESSAGE     = getField(fieldName2, function) ;
		ret.addElement(E_FLAG);
		ret.addElement(E_RETURN);
		ret.addElement(E_MESSAGE);
        return ret;
    	
    }
}

