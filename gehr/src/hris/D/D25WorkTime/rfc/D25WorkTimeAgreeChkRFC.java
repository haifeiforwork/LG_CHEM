package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D25WorkTime.D25WorkTimeAgreeData;

/**
 * D25WorkTimeAgreeChkRFC.java
 * �� �ٷνð� ���� ���� ��� ��ȸ RFC
 * 2018-06-05  ������    [CSR ID:3704184] �����ٷ��� ���� ���� ��� �߰� �� - Global HR Portal
 * @author ������
 * @version 1.0, 2018/06/05
 */
public class D25WorkTimeAgreeChkRFC extends SAPWrap {

	private static String functionName = "ZGHR_RFC_AGRE_MANAGE";

    /**
     * �� �ٷνð� ���� ���� ��� ��ȸ ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getAgreeFlag(String yyyy, String empNo) throws GeneralException {  

        JCO.Client mConnection = null;
        Vector ret = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, yyyy, empNo);   
            excute(mConnection, function);
            
             ret = getOutput(function,   new D25WorkTimeAgreeData() );
                   
            return ret;
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }   
    
    
    /**
     * �� �ٷνð� ���� ���� ��� ��ȸ ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector setAgreeFlag(String empNo) throws GeneralException {  

        JCO.Client mConnection = null;
        Vector ret = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);   
            excute(mConnection, function);
            
             ret = getOutput(function,   new D25WorkTimeAgreeData() );
                   
            return ret;
            
        }catch(Exception ex){
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
    private void setInput(JCO.Function function, String value, String value1 ) throws GeneralException {  
        String fieldName  = "I_GUBUN";//01 : ��ȸ , 02 : �Է�
        String fieldName1 = "I_YEAR"; 
        String fieldName2 = "I_PERNR"; 
        String fieldName3 = "I_AGRE_TYPE"; // ��������(01 : 2018 �ٷ���������)
        setField(function, fieldName, "01");
        setField(function, fieldName1, value); 
        setField(function, fieldName2, value1); 
        setField(function, fieldName3, "01");
        
    }
    
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value ) throws GeneralException {  
        String fieldName  = "I_GUBUN";//01 : ��ȸ , 02 : �Է�
        String fieldName1 = "I_PERNR"; 
        String fieldName2 = "I_AGRE_TYPE"; // ��������(01 : 2018 �ٷ���������)
        String fieldName3 = "I_AGRE_FLAG"; // ���� YN
        setField(function, fieldName, "02");
        setField(function, fieldName1, value); 
        setField(function, fieldName2, "01");
        setField(function, fieldName3, "Y");
        
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function, Object data) throws GeneralException {
    	
    	Vector ret = new Vector();
    	
    	Vector T_EXPORTA   = getTable(hris.D.D25WorkTime.D25WorkTimeAgreeData.class,  function, "T_AGRE_STAT");

    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
    	ret.addElement(T_EXPORTA);
        
        return ret;
    } 
}
