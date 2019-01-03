package	hris.A.A14Bank.rfc;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;

import hris.A.A14Bank.A14BankStockFeeData;
import hris.common.approval.ApprovalSAPWrap;

/**
 * A14BankStockFeeRFC.java
 * ������� ��û ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/07
 */
public class A14BankStockFeeRFC extends ApprovalSAPWrap {

    private static String functionName = "ZGHR_RFC_BANK_STOCK_FEE_LIST"; //ZHRH_RFC_BANK_STOCK_FEE_LIST

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
            
            //excute(mConnection, function);
            excuteDetail(mConnection, function);
            Vector ret=null;

            if(!g.getSapType().isLocal()){
            	
                ret = getTable(hris.A.A14Bank.A14BankStockFeeData.class, function, "T_ENTR_RESULT");
            	//          20160204 start
	            if(ret.size()!=0){
	            	A14BankStockFeeData ret1 = new A14BankStockFeeData();
		            ret1 = (A14BankStockFeeData)ret.get(0);
		            ret1.VORNA = ret1.VORNA.replaceAll("#", " ");
		            ret.set(0, ret1) ;
	            }
	            //            20160204 end
            }else{

                ret = getTable(hris.A.A14Bank.A14BankStockFeeData.class, function, "T_ENTR_RESULT1");
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
     * ������� �Է� RFC ȣ���ϴ� �ؿ�Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */ 
    public String buildGlobal(String keycode, String bankflag, Object bankstock, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            A14BankStockFeeData data = (A14BankStockFeeData)bankstock;

            Vector bankstockVector = new Vector();
            bankstockVector.addElement(data);
            
            setInput(function, keycode,  "", bankflag, "2");

            setTable(function,  "T_ENTR_RESULT", bankstockVector);
            return executeRequest(mConnection, function, box, req);
            
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    

    /**
     * ������� �Է� RFC ȣ���ϴ� ����Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */ 
    public String build(	String keycode, String seqn, String bankflag, Object bankstock, Box box, HttpServletRequest req)
    			throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
 
            Vector bankstockVector = new Vector();
            bankstockVector.addElement(bankstock); 
            
            setInput(function, keycode, seqn, bankflag, "2");
            Logger.debug.println(this, "----==== bankstockVector : " + bankstock);
            setTable(function,  "T_ENTR_RESULT1", bankstockVector);

            return executeRequest(mConnection, function, box, req);
            
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
    public String changeGlobal(String keycode, String seqn, String bankflag, Object bankstock) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            A14BankStockFeeData data = (A14BankStockFeeData)bankstock;

            Vector bankstockVector = new Vector();
            bankstockVector.addElement(data);

            setInput(function, keycode, seqn, bankflag, "3");
            setTable(function,   "T_ENTR_RESULT", bankstockVector); // ITAB
            //setInput(function, bankstockVector, "ITAB");

            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Vector change(String keycode, String seqn, String bankflag, Object bankstock) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            A14BankStockFeeData data = (A14BankStockFeeData)bankstock;

            Vector bankstockVector = new Vector();
            bankstockVector.addElement(data);

            setInput(function, keycode, seqn, bankflag, "3");
            
            //setInput(function, bankstockVector, "T_ENTR_RESULT1");
            setTable(function,   "T_ENTR_RESULT1", bankstockVector);
            excute(mConnection, function);

            Vector ret = null;//getOutput1(function);
            
            Logger.debug.println(this, "build 6:ret "+ret.toString());
            
            return ret;
            
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
    public RFCReturnEntity delete(String keycode, String seqn, String bankflag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, seqn, bankflag, "4");
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
    private void setInput(JCO.Function function, String keycode, String seqn, String bankflag, String jobcode) throws GeneralException {
        
        setField(function,  "I_ITPNR" , keycode);        
        setField(function,  "I_AINF_SEQN", seqn)   ;        
        setField(function, "I_BANK_FLAG", bankflag);        
        setField(function, "I_GTYPE", jobcode); //I_CONT_TYPE
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


    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException

    
    private Vector getOutput1(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();        
    	A14BankMessageData a14BankMessageData = new A14BankMessageData();  // ��������
    	getStructor( a14BankMessageData, function, "E_RETURN");

        ret.add(a14BankMessageData); 
        return ret;        
        
    }
     */
}