package	hris.D.D05Mpay.rfc;

import hris.D.D05Mpay.D05MpayDetailData4;
import hris.D.D05Mpay.D05MpayDetailData5;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D05MpayDetailRFCEurp.java
 * 개인의 월급여 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author yji
 * @version 1.0, 2010/07/29
 */
public class D05MpayDetailRFCEurp extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO2";

    /**
     * 개인의 월급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getMpayDetail( String empNo, String year, String ocrsn, String flag,  String seqnr) throws GeneralException {  // 5월 21일 순번 추가 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr);   
            excute(mConnection, function);
            
            Vector ret = null;
            ret = getOutput1(function);          
   
            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
    public Object getPerson(String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5월 21일 순번 추가

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5월 21일 순번 추가
            excute(mConnection, function);
            Object ret = getOutput4(function, ( new D05MpayDetailData4() ));
          
            return ret;
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }  
      
    public Object getPaysum(String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5월 21일 순번 추가

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5월 21일 순번 추가
            excute(mConnection, function);
            Object ret = getOutput5(function, ( new D05MpayDetailData5() ));
         
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
    private void setInput(JCO.Function function, String value, String value1, String value2, String value3, String value4) throws GeneralException {  // 5월 21일 순번 추가
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_INPER";
        String fieldName2 = "I_PAYTY";
        String fieldName3 = "I_PAYID";
        String fieldName4 = "I_BONDT";  // 5월 21일 순번 추가
        /*
        String fieldName1 = "I_DATE";
        String fieldName2 = "I_ZOCRSN";
        String fieldName3 = "I_FLAG";
        String fieldName4 = "I_SEQNR";  // 5월 21일 순번 추가
        */
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);
        setField(function, fieldName2, value2);
        setField(function, fieldName3, value3);
        setField(function, fieldName4, value4);  // 5월 21일 순번 추가 
        
    }
    
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
    	Vector sum = new Vector();
        String entityName1 = "hris.D.D05Mpay.D05MpayDetailData1";
        String tableName1  = "T_SOCIAL";
        Vector SOCIAL = getTable(entityName1, function, tableName1);
        
        String entityName2 = "hris.D.D05Mpay.D05MpayDetailData2";
        String tableName2  = "T_PAYLST";
        Vector PAYLST = getTable(entityName2, function, tableName2);
        
        String entityName3 = "hris.D.D05Mpay.D05MpayDetailData3";
        String tableName3  = "T_TAXLST";
        Vector TAXLST = getTable(entityName3, function, tableName3);
        
        sum.addElement(SOCIAL);
        sum.addElement(PAYLST);
        sum.addElement(TAXLST); 
      
        return sum;
 
    }
 
   
// 급여명세표 - 개인정보/환율 내역    
    private Object getOutput4(JCO.Function function, Object data) throws GeneralException {
        String structureName = "S_PERSON_INFO";      // RFC Export1 
        return getStructor( data, function, structureName);
    }
// 지급내역/공제내역 합    
    private Object getOutput5(JCO.Function function, Object data) throws GeneralException {
        String structureName = "S_PAYSUM_INFO";      // RFC Export2 
        return getStructor( data, function, structureName);
    }
    


}