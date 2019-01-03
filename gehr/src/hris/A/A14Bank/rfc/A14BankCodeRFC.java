package	hris.A.A14Bank.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.A.A14Bank.*;

/**
 * A14BankCodeRFC.java
 * ������� �ڵ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/07
 */
public class A14BankCodeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_P_BANK_CODE";//ZHRH_RFC_P_BANK_CODE

    /**
     * ������ �������ϱ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBankCode(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            excute(mConnection, function);
            Vector ret =null;
            if(!g.getSapType().isLocal()){
            	 ret = getOutput1(function);
            }else{
                 ret = getTable(hris.A.A14Bank.A14BankCodeData.class, function,  "T_RESULT");//P_RESULT
            }
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     *  RFC�� ȣ���ϴ� Method(Global)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBankValue(String keycode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode);
            
            excute(mConnection, function);
            
            Vector ret = getOutput1(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * �������ϱ� �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     
    public void build(String keycode, String seqn, Object entrance) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E21EntranceData data = (E21EntranceData)entrance;

            Vector entranceVector = new Vector();
            entranceVector.addElement(data);

            setInput(function, keycode, seqn, "2");

            setInput(function, entranceVector, "P_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �������ϱ� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     
    public void change(String keycode, String seqn, Object entrance) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            E21EntranceData data = (E21EntranceData)entrance;

            Vector entranceVector = new Vector();
            entranceVector.addElement(data);

            setInput(function, keycode, seqn, "3");

            setInput(function, entranceVector, "P_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �������ϱ� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     
    public void delete(String keycode, String seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, "4");
            excute(mConnection, function);

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
    private void setInput(JCO.Function function, String keycode) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;//P_PERNR
        setField(function, fieldName1, keycode);
    }

// Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }
    */

    private Vector getOutput1(JCO.Function function) throws GeneralException {
    	Vector v = getTable(hris.A.A14Bank.A14BankCodeData.class, function, "T_ITAB");//ITAB
    	
    	/** Test�� ���� �ӽ÷� �ѱ� -ksc **/
    	if (v.size()==0){
    		A14BankCodeData data               = new A14BankCodeData();
    		data.BANK_CODE = "1001";
        	data.BANK_NAME = "Text Bank";
        	v.add(0, data);
    	}
    	
        return v; 
    }
}