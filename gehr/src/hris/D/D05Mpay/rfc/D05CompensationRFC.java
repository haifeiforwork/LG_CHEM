package	hris.D.D05Mpay.rfc;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*; 

import hris.D.D05Mpay.*;

/**
 * D05CompensationRFC.java
 * ������ �Ѻ������ ���� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2012/07/27
 *                      2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)
 */
public class D05CompensationRFC extends SAPWrap {

//    private static String functionName = "ZHRP_GET_TOTAL_COMPENSATION";
    private static String functionName = "ZGHR_GET_TOTAL_COMPENSATION";

    /**
     * ������ �Ѻ������ ���� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Object getDetail(String empNo, String begym, String endym) throws GeneralException {  

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, begym, endym );   
            excute(mConnection, function);
            Object ret = getOutput(function,   new D05CompensationData() );
                  
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
    private void setInput(JCO.Function function, String value, String value1, String value2 ) throws GeneralException {  
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_BEGYM"; 
        String fieldName2 = "I_ENDYM"; 
        setField(function, fieldName, value);
        setField(function, fieldName1, value1); 
        setField(function, fieldName2, value2); 
        
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        String structureName = "S_RESULT";      // RESULT RFC Export1 
        return getStructor( data, function, structureName);
    } 
    
    
}


//
//
//package	hris.D.D05Mpay.rfc;
//
//import com.sns.jdf.*;
//import com.sap.mw.jco.*;
//import com.sns.jdf.sap.*; 
//
//import hris.D.D05Mpay.*;
//
///**
// * D05CompensationRFC.java
// * ������ �Ѻ������ ���� ������ �������� RFC�� ȣ���ϴ� Class
// *
// * @author lsa
// * @version 1.0, 2012/07/27
// *                      2016-03-08 [CSR ID:2995203] ������� ����(Total Compensation)
// */
//public class D05CompensationRFC extends SAPWrap {
//
//    private static String functionName = "ZGHR_GET_TOTAL_COMPENSATION";//ZHRP_GET_TOTAL_COMPENSATION
//
//    /**
//     * ������ �Ѻ������ ���� ������ �������� RFC�� ȣ���ϴ� Method
//     * @return java.util.Vector
//     * @exception com.sns.jdf.GeneralException
//     */ 
//    public Object getDetail(String empNo, String begym, String endym) throws GeneralException {  
//
//        JCO.Client mConnection = null;
//        try{
//            mConnection = getClient();
//            JCO.Function function = createFunction(functionName) ;
//
//            setInput(function, empNo, begym, endym );   
//            excute(mConnection, function);
//            Object ret = getStructor( new D05CompensationData(), function, "S_RESULT"); // RESULT , RFC Export1 
//                  
//            return ret;
//            
//        }catch(Exception ex){
//            Logger.sap.println(this, "SAPException : "+ex.toString());
//            throw new GeneralException(ex);
//        } finally {
//            close(mConnection);
//        }
//    }   
//    /**
//     * RFC �������� Import ���� setting �Ѵ�.
//     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
//     * @param function com.sap.mw.jco.JCO.Function
//     * @param value java.lang.String ���
//     * @exception com.sns.jdf.GeneralException
//     */
//    private void setInput(JCO.Function function, String value, String value1, String value2 ) throws GeneralException {  
//        String fieldName  = "I_PERNR";
//        String fieldName1 = "I_BEGYM"; 
//        String fieldName2 = "I_ENDYM"; 
//        setField(function, fieldName, value);
//        setField(function, fieldName1, value1); 
//        setField(function, fieldName2, value2); 
//        
//    }
//     
//    
//}