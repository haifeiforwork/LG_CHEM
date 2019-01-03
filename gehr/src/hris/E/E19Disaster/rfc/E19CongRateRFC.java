package hris.E.E19Disaster.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Disaster.*;

/**
 * E19CongRateRFC.java
 * 경조금 지급 기준 possible entry RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/18
 */
public class E19CongRateRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_P_CONGCOND_RATE";
	 private String functionName = "ZGHR_RFC_P_CONGCOND_RATE";

    /**
     * 경조금 지급 기준 possible entry RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongRate( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            Vector ret = getTable(E19CongcondData.class, function, "T_RESULT");

            return ret;
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
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }

}


