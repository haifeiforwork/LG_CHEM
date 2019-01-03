package	hris.D.D06Ypay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DateTime;

import hris.D.D06Ypay.D06YpayDetailData4_to_year;

/**
 * D06YpayDetail2_to_yearRFC.java
 * 2003/01/13  ������������ ���� ���޿� ���� 
 * ������ ���޿� ������ ���������� �����´�.
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2003/01/13
 *   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��  
 */
public class D06YpayDetail2_to_yearRFC extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO2"; //ZHRP_GET_PAY_INFO2

    /**
     * ������ ���޿� ������ ���������� �������� RFC�� ȣ���ϴ� Method 
     * 		2016-11-11 (�ѹ�ȣ��� ����) getYpayDetail2 + getYpayDetail3 + getperson *ksc
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYpayDetail( String empNo, String year, String ocrsn, String flag, String seqnr,String  webUserId) throws GeneralException {  // 5�� 21�� ���� �߰� 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5�� 21�� ���� �߰� ,   [CSR ID:2353407]
            excute(mConnection, function);
            
            Vector ret = new Vector();
                        
            ret.addElement( getTable(hris.D.D06Ypay.D06YpayDetailData2_to_year.class, function,  "T_TAXLST"));
            ret.addElement( getTable(hris.D.D06Ypay.D06YpayDetailData3_to_year.class, function, "T_PAYLST"));
            ret.addElement( getStructor( ( new D06YpayDetailData4_to_year() ), function, "S_PERSON_INFO"));
             
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getYpayDetail2( String empNo, String year, String ocrsn, String flag, String seqnr,String  webUserId) throws GeneralException {  // 5�� 21�� ���� �߰� 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5�� 21�� ���� �߰� ,   [CSR ID:2353407]
            excute(mConnection, function);
            
            Vector ret = null;
                        
            ret = getTable(hris.D.D06Ypay.D06YpayDetailData2_to_year.class, function,  "T_TAXLST");
             
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector getYpayDetail3( String empNo, String year, String ocrsn, String flag, String seqnr,String  webUserId) throws GeneralException {  // 5�� 21�� ���� �߰� 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5�� 21�� ���� �߰�
            excute(mConnection, function);
            
            Vector ret = null;
                        
            ret = getTable(hris.D.D06Ypay.D06YpayDetailData3_to_year.class, function, "T_PAYLST");
             
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Object getPerson(String empNo, String year, String ocrsn, String flag, String seqnr,String  webUserId) throws GeneralException {  // 5�� 21�� ���� �߰�

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5�� 21�� ���� �߰�
            excute(mConnection, function);
            Object ret = getStructor( ( new D06YpayDetailData4_to_year() ), function, "S_PERSON_INFO");
         
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
    private void setInput(JCO.Function function, String value, String value1, String value2, String value3, String value4, String value5) throws GeneralException {  // 5�� 21�� ���� �߰�
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_DATE";
        String fieldName2 = "I_ZOCRSN";
        String fieldName3 = "I_FLAG";
        String fieldName4 = "I_SEQNR";  // 5�� 21�� ���� �߰�
        String fieldName5 = "I_ID";  // 5�� 21�� ���� �߰�
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);
        setField(function, fieldName2, value2);
        setField(function, fieldName3, value3);
        setField(function, fieldName4, value4);  // 5�� 21�� ���� �߰� 
        setField(function, fieldName5, value5);  // 5�� 21�� ���� �߰� 

		DateTime ymd = null; 
        String value6 = ymd.getShortDateString();
        setField(function, "I_DATUM", value6);  
        
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    
    private Vector getOutput2(JCO.Function function) throws GeneralException {
        return getTable(hris.D.D06Ypay.D06YpayDetailData3_to_year.class, function, "T_PAYLST");
    }
    // �޿���ǥ - ��������/ȯ�� ����    
    private Object getOutput4(JCO.Function function, Object data) throws GeneralException {
        return getStructor( data, function, "S_PERSON_INFO");
    }
    
}