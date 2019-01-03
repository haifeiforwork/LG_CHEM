package	hris.D.D05Mpay.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D05Mpay.*;

/**
 * D05LatestPailRFC.java
 * �����ֱ� �޿����� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2002/01/29
 *   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��  
 */
public class D05LatestPaidRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_LATEST_PAID";

    /**
     * �����ֱ� �޿����� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLatestPaid(String empNo ,String  webUserId) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            Logger.debug.println(this, "[getLatestPaid1 ]empNo = "+empNo +"webUserId:"+webUserId);
            
            
            setInput(function, empNo,webUserId);// [CSR ID:2353407]
            excute(mConnection, function);

            Logger.debug.println(this, "[getLatestPaid1 excute  = " );
            
            
            Vector v= new Vector();
            
            v.addElement(getOutput1(function) );//E_PAYDT);            
            v.addElement(getOutput2(function) );//E_ZOCRSN);            
            v.addElement(getOutput3(function) );//E_SEQNR);            
            
            return v;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * �����ֱ� �޿����� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getLatestPaid1(String empNo ,String  webUserId) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            Logger.debug.println(this, "[getLatestPaid1 ]empNo = "+empNo +"webUserId:"+webUserId);
            
            
            setInput(function, empNo,webUserId);// [CSR ID:2353407]
            excute(mConnection, function);

            Logger.debug.println(this, "[getLatestPaid1 excute  = " );
            
            
            String E_PAYDT = null;
                        
            E_PAYDT = getOutput1(function);  
                        
            return E_PAYDT;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    
    public String getLatestPaid2(String empNo ,String  webUserId) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo,webUserId);
            excute(mConnection, function);
            
            String E_ZOCRSN = null;
                        
            E_ZOCRSN = getOutput2(function);  
                        
            return E_ZOCRSN;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 // 5�� 21�� ���� �߰�    
    public String getLatestPaid3(String empNo,String  webUserId) throws GeneralException {
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo,webUserId);
            excute(mConnection, function);
            
            String E_SEQNR = null;
                        
            E_SEQNR = getOutput3(function);  
                        
            return E_SEQNR;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String value,String webUserId) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, value);
        String fieldName1  = "I_ID";
        setField(function, fieldName1, webUserId);

        Logger.debug.println(this, "[getLatestPaid1 setInput ] value = "+value +"webUserId:"+webUserId);
        
        
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput1(JCO.Function function) throws GeneralException {
        String fieldName = "E_PAYDT";      // �޿������ ���� ������
        return getField(fieldName, function);
    }
    
    private String getOutput2(JCO.Function function) throws GeneralException {
        String fieldName = "E_ZOCRSN";      // �޿�����  
        return getField(fieldName, function);
    }
 // 5�� 21�� ���� �߰�    
    private String getOutput3(JCO.Function function) throws GeneralException {
        String fieldName = "E_SEQNR";      // ����   
        return getField(fieldName, function);
    }
}