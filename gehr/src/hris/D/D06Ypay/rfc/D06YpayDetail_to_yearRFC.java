package	hris.D.D06Ypay.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * D06YpayDetail_to_yearRFC.java
 * 2003/01/13  연말정산으로 인한 연급여 생성
 * 개인의 연급여 내역 정보를 가져오는 RFC를 호출하는 Class
 * @author 최영호
 * @version 1.0, 2003/01/13
 *   Update       : 2013-06-24 [CSR ID:2353407] sap에 추가암검진 추가 건  
 */
public class D06YpayDetail_to_yearRFC extends SAPWrap { 

    private String functionName = "ZGHR_RFC_GET_TOTAL_SALARY2";
    
    /**
     * 개인의 연급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getYpayDetail( String empNo, String from_year,String  to_year ,String webUserId) throws GeneralException {
    
        JCO.Client mConnection = null;

        if(!g.getSapType().isLocal()) functionName="ZGHR_RFC_GET_TOTAL_SALARY";
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, empNo, from_year, to_year,webUserId); // [CSR ID:2353407]
            excute(mConnection, function);
            
            Vector ret = getTable(hris.D.D06Ypay.D06YpayDetailData_to_year.class, function, "T_TOTAL");
                        
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
    private void setInput(JCO.Function function, String value, String value1, String value2,String value3) throws GeneralException {
       
        setField(function,  "I_PERNR", value);
        setField(function, "I_BEGYM", value1);
        setField(function, "I_ENDYM", value2);
        setField(function, "I_ID", value3);
    }
    
    
    
    
}