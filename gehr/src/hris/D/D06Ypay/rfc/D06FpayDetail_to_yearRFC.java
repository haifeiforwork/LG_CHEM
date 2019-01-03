package	hris.D.D06Ypay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D06Ypay.D06FpayDetailData;

/**
 * D06FpayDetail_to_yearRFC.java
 * 2003/01/13  연말정산으로 인한 연급여 생성
 * 개인의 국내급여 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2003/01/13
 */
public class D06FpayDetail_to_yearRFC extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO";

    /**
     * 개인의 국내급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
 
    public Object getFpayDetail(String empNo, String year, String ocrsn, String flag) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag);
            excute(mConnection, function);
            Object ret = getStructor( ( new D06FpayDetailData() ), function,  "S_PERSON_INFO");  // 급여명세표 - 개인정보/환율 내역
                      
            return ret;
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }  

     public Vector getMpayDetail( String empNo, String year, String ocrsn, String flag) throws GeneralException {
    
        JCO.Client mConnection = null;
        
      try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, year, ocrsn, flag);
            excute(mConnection, function);
            
            Vector ret = null;
                        
             ret = getTable(hris.D.D06Ypay.D06FpayDetailData1_to_year.class, function, "T_PAYLST");

            return ret;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String value, String value1, String value2, String value3) throws GeneralException {
        
        setField(function, "I_PERNR", value);
        setField(function, "I_DATE", value1);
        setField(function, "I_ZOCRSN", value2);
        setField(function, "I_FLAG", value3);
    }


  
    
}