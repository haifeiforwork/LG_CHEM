package	hris.D.D05Mpay.rfc;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*; 

import hris.D.D05Mpay.*;

/**
 * D05CompensationRFC.java
 * 개인의 총보상명세서 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2012/07/27
 *                      2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
 */
public class D05CompensationRFC extends SAPWrap {

//    private static String functionName = "ZHRP_GET_TOTAL_COMPENSATION";
    private static String functionName = "ZGHR_GET_TOTAL_COMPENSATION";

    /**
     * 개인의 총보상명세서 내역 정보를 가져오는 RFC를 호출하는 Method
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
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
// * 개인의 총보상명세서 내역 정보를 가져오는 RFC를 호출하는 Class
// *
// * @author lsa
// * @version 1.0, 2012/07/27
// *                      2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
// */
//public class D05CompensationRFC extends SAPWrap {
//
//    private static String functionName = "ZGHR_GET_TOTAL_COMPENSATION";//ZHRP_GET_TOTAL_COMPENSATION
//
//    /**
//     * 개인의 총보상명세서 내역 정보를 가져오는 RFC를 호출하는 Method
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
//     * RFC 실행전에 Import 값을 setting 한다.
//     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
//     * @param function com.sap.mw.jco.JCO.Function
//     * @param value java.lang.String 사번
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