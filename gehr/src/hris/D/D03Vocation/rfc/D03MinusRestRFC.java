package hris.D.D03Vocation.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.D.D03Vocation.*;


/**
 * D03MinusRestRFC.java
 * 마이너스 휴가를 신청할수 있는 사람과 마이너스 휴가 한계를 조회하는 Class                        
 *
 * @author  김도신
 * @version 1.0, 2002/05/29
 */
public class D03MinusRestRFC extends SAPWrap {

//    private String functionName = "ZHRW_RFC_MINUS_REST";
    private String functionName = "ZGHR_RFC_MINUS_REST";

    /**
     * 장치교대근무자 체크 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String check( String i_pernr, String i_bukrs, String i_date ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, i_pernr, i_date );
            excute(mConnection, function);
            
            String urlzk = getField("E_URLZK", function);
//          마이너스 휴가 적용의 경우 - 석유화학의 경우 모든 사원에 대해서 마이너스 휴가 신청 가능하다.
            if( i_bukrs.equals("N100") || (i_bukrs.equals("C100") && urlzk.equals("3")) ) {
                return getField("E_QTNEG", function);       // 마이너스 휴가 한계 값
            } else {
                return "0";
            }
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public String getE_ANZHL( String i_pernr, String i_date ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, i_pernr, i_date );
            excute(mConnection, function);
            
            String anzhl = getField("E_ANZHL", function);
            return anzhl;
        } catch(Exception ex){
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
	   * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String i_pernr, String i_date ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, i_pernr );
        String fieldName2 = "I_DATE";
        setField( function, fieldName2, i_date );
    }
}


