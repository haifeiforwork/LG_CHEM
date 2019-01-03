package	hris.D.D06Ypay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D06Ypay.D06YpayDetailData4;

/**
 * D06YpayDetail2RFC.java
 * 개인의 연급여 내역중 과세정보를 가져온다.
 *
 * @author 최영호
 * @version 1.0, 2002/07/23
 */
public class D06YpayDetail2RFC extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO";

    /**
     * 개인의 연급여 내역중 과세정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    
    public Vector getYpayDetail2( String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5월 21일 순번 추가 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5월 21일 순번 추가
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
    
    public Vector getYpayDetail3( String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5월 21일 순번 추가 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5월 21일 순번 추가
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
    
    public Object getPerson(String empNo, String year, String ocrsn, String flag, String seqnr) throws GeneralException {  // 5월 21일 순번 추가

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr);  // 5월 21일 순번 추가
            excute(mConnection, function);
            Object ret =  getStructor( ( new D06YpayDetailData4() ), function, "S_PERSON_INFO");  // 급여명세표 - 개인정보/환율 내역  
         
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
        
        setField(function, "I_PERNR", value);
        setField(function, "I_DATE", value1);
        setField(function, "I_ZOCRSN", value2);
        setField(function, "I_FLAG", value3);
        setField(function, "I_SEQNR", value4);  // 5월 21일 순번 추가 
        
    }
    
    
   
    
}