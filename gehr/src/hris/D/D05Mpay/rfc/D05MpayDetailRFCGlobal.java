package	hris.D.D05Mpay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D05Mpay.D05MpayDetailData4;
import hris.D.D05Mpay.D05MpayDetailData5;

/**
 * D05MpayDetailRFC.java
 * 개인의 월급여 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/28
 */
public class D05MpayDetailRFCGlobal extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO";

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
            
        	Vector sum = new Vector();
            Vector SOCIAL = getTable(hris.D.D05Mpay.D05MpayDetailData1.class, function, "T_SOCIAL");
            Vector PAYLST = getTable(hris.D.D05Mpay.D05MpayDetailData2.class, function, "T_PAYLST");
            Vector TAXLST = getTable(hris.D.D05Mpay.D05MpayDetailData3.class, function, "T_TAXLST");
            
            sum.addElement(SOCIAL);
            sum.addElement(PAYLST);
            sum.addElement(TAXLST); 
          
            return sum;
            
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
            Object ret = getStructor( new D05MpayDetailData4(), function,  "S_PERSON_INFO"); // 급여명세표 - 개인정보/환율 내역
          
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
            Object ret = getStructor( new D05MpayDetailData5(), function, "S_PAYSUM_INFO");// 지급내역/공제내역 합  
         
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