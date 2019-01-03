package	hris.E.E12Stock.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E12Stock.*;

/**
 * E12BankStockFeeRFC.java
 * ���ǰ��� ��û ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/24
 */
public class E12BankStockFeeRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_BANK_STOCK_FEE_LIST";

    /**
     * ������ ������� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBankStockFee(String keycode, String seqn, String bankflag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, keycode, seqn, bankflag, "1");
            
            excute(mConnection, function);
            
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
     * ������� �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */ 
    public void build(String keycode, String seqn, String bankflag, Object bankstock) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E12BankStockFeeData data = (E12BankStockFeeData)bankstock;

            Vector bankstockVector = new Vector();
            bankstockVector.addElement(data);
            
            setInput(function, keycode, seqn, bankflag, "2");

            setInput(function, bankstockVector, "P_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * ������� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String keycode, String seqn, String bankflag, Object bankstock) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            E12BankStockFeeData data = (E12BankStockFeeData)bankstock;

            Vector bankstockVector = new Vector();
            bankstockVector.addElement(data);

            setInput(function, keycode, seqn, bankflag, "3");

            setInput(function, bankstockVector, "P_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * ������� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public void delete(String keycode, String seqn, String bankflag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, bankflag, "4");
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
    private void setInput(JCO.Function function, String keycode, String seqn, String bankflag, String jobcode) throws GeneralException {
        String fieldName1 = "P_PERNR"          ;
        setField(function, fieldName1, keycode);
        
        String fieldName2 = "P_AINF_SEQN"      ;
        setField(function, fieldName2, seqn)   ;
        
        String fieldName3 = "P_BANK_FLAG"      ;
        setField(function, fieldName3, bankflag);
        
        String fieldName4 = "P_CONT_TYPE"      ;
        setField(function, fieldName4, jobcode);
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
        String entityName = "hris.E.E12Stock.E12BankStockFeeData";
        String tableName  = "P_ENTR_RESULT";
        return getTable(entityName, function, tableName);
    }
}