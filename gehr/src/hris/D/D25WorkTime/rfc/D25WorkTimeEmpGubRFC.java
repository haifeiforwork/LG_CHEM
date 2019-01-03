package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.D.D25WorkTime.D25WorkTimeAgreeData;

/**
 * D25WorkTimeEmpGubRFC.java
 * ����� ����(type) ��ȸ RFC �̸� �Ʒ� ������ return �Ѵ�.
 * 2018-06-05  ������    [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��
 * @author ������
 * @version 1.0, 2018/06/05
 */
public class D25WorkTimeEmpGubRFC extends SAPWrap {

	private static String functionName = "ZGHR_RFC_NTM_GET_EMPGUB";

    /**
     * �繫���� ������ ��ȸ�ϴ� RFC�� ȣ���ϴ� Method
     * E_EMPGUB : S(�繫��) , H(������)
	 * E_TPGUB : A(�繫���Ϲ�),B(�������Ϲ�),C(�繫�� ���ñٷ�),D(������ ���ñٷ�)
	 * E_WORK : X(����), ����(����)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getEmpGub(String empNo, String date) throws GeneralException {  

        JCO.Client mConnection = null;
        Vector ret = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, date);   
            excute(mConnection, function);
            
             ret = getOutput(function);
                   
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
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_DATUM"; 
        
        setField(function, fieldName, value);
        setField(function, fieldName1, value1); 
        
    }
    
  
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	
    	Vector ret = new Vector();

    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
    	ret.addElement(getField("E_EMPGUB", function));
    	ret.addElement(getField("E_TPGUB", function));
    	ret.addElement(getField("E_WORK", function));
        
        return ret;
    } 
}
