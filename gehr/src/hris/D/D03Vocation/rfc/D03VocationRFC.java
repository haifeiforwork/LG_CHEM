package	hris.D.D03Vocation.rfc;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

import hris.D.D03Vocation.D03VocationData;
import hris.common.approval.ApprovalSAPWrap;

/**
 * D03VocationRFC.java
 * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/21
 * 
 * Update       : 2018-05-17  ��ȯ�� [WorkTime52] �����ް� �߰� ��
 */
public class D03VocationRFC extends ApprovalSAPWrap {
 
    //private String functionName = "ZHRW_RFC_HOLIDAY_REQUEST";
    private static String functionName = "ZGHR_RFC_HOLIDAY_REQUEST";

    /**
     * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocation(String keycode, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, "1","");

            excuteDetail(mConnection, function);
            
            Vector ret = getOutput(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �ް���û �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */ 
    public String  build(String keycode, Object vocation, String P_A002_SEQN, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            D03VocationData data = (D03VocationData)vocation;

            Vector vocationVector = new Vector();
            vocationVector.addElement(data);

            setInput(function, keycode, null, "2",P_A002_SEQN);

            setInput(function, vocationVector, "T_RESULT");//P_RESULT

            /* ����Ͽ��� ������� ���� ó�� */
            if(box.getObject("T_IMPORTA") != null)
                setTable(function, "T_IMPORTA", (Vector) box.getObject("T_IMPORTA"));

            return executeRequest(mConnection, function, box, req);

//        	Vector ret = new Vector();
//        	// Export ���� ��ȸ
//        	String fieldName1 = "E_RETURN";        // �����ڵ�
//        	String E_RETURN   = getField(fieldName1, function) ;
//        	
//        	String fieldName2 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
//        	String E_MESSAGE  = getField(fieldName2, function) ; 
//        	ret.addElement(E_RETURN);
//        	ret.addElement(E_MESSAGE);
//            return ret;            

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �ް���û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public Vector change(String keycode, String seqn, Object vocation, String P_A002_SEQN ,Box box,  HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            D03VocationData data = (D03VocationData)vocation;

            Vector vocationVector = new Vector();
            vocationVector.addElement(data);

            setInput(function, keycode, seqn, "3",P_A002_SEQN);

            setInput(function, vocationVector, "T_RESULT");

            executeChange(mConnection, function, box, req);

        	Vector ret = new Vector();
        	// Export ���� ��ȸ
//        	String fieldName1 = "E_RETURN";        // �����ڵ�
//        	String E_RETURN   = getField(fieldName1, function) ;
//        	
//        	String fieldName2 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
//        	String E_MESSAGE  = getField(fieldName2, function) ; 
//        	ret.addElement(E_RETURN);
//        	ret.addElement(E_MESSAGE);
            return ret;            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �ް���û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete(String keycode, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, "4","");
            return executeDelete(mConnection, function);

        } catch(Exception ex){
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String seqn, String jobcode,String P_A002_SEQN) throws GeneralException {
        String fieldName1 = "I_ITPNR"          ;//P_PERNR
        setField(function, fieldName1, keycode);
        
        String fieldName2 = "I_AINF_SEQN"          ;//P_AINF_SEQN
        setField(function, fieldName2, seqn)  ;
        
        String fieldName3 = "I_GTYPE"      ;//P_CONT_TYPE
        setField(function, fieldName3, jobcode);

        String fieldName4 = "I_A002_SEQN";//P_A002_SEQN
        setField(function, fieldName4, P_A002_SEQN);               

        setField(function, "I_NTM", "X");
    }

// Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D03Vocation.D03VocationData";
        String tableName  = "T_RESULT";
        return getTable(entityName, function, tableName);
    }
}