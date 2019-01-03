package	hris.D.D06Ypay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D06Ypay.D06YpayDetailData4;

/**
 * D06YpayDetail2RFC.java
 * ������ ���޿� ������ ���������� �����´�.
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2002/07/23
 */
public class D06YpayDetail2RFC extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO";

    /**
     * ������ ���޿� ������ ���������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    
    public Vector getYpayDetail2( String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5�� 21�� ���� �߰� 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5�� 21�� ���� �߰�
            excute(mConnection, function);
            
            Vector ret = null;
                        
            ret = getTable(hris.D.D06Ypay.D06YpayDetailData2.class, function, "T_TAXLST");
             
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Vector getYpayDetail3( String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5�� 21�� ���� �߰� 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5�� 21�� ���� �߰�
            excute(mConnection, function);
            
            Vector ret = null;
                        
            ret = getTable(hris.D.D06Ypay.D06YpayDetailData3.class, function,  "T_PAYLST");
             
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Object getPerson(String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5�� 21�� ���� �߰�

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5�� 21�� ���� �߰�
            excute(mConnection, function);
            Object ret =  getStructor( ( new D06YpayDetailData4() ), function, "S_PERSON_INFO");  // �޿���ǥ - ��������/ȯ�� ����  
         
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
    
    private void setInput(JCO.Function function, String value, String value1, String value2, String value3, String value4) throws GeneralException {  // 5�� 21�� ���� �߰�
        
        setField(function, "I_PERNR", value);
        setField(function, "I_DATE", value1);
        setField(function, "I_ZOCRSN", value2);
        setField(function, "I_FLAG", value3);
        setField(function, "I_SEQNR", value4);  // 5�� 21�� ���� �߰� 
        
    }
    
    
   
    
}