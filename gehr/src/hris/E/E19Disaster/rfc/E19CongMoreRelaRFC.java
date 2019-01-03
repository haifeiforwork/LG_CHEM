package hris.E.E19Disaster.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E19Disaster.*;

/**
 * E19CongMoreRelaRFC.java
 * 경조금 지급 기준 추가 데이터를 가져오는 RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/18
 */
public class E19CongMoreRelaRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_CONGCOND_COMMWAGE";
	private String functionName = "ZGHR_RFC_CONGCOND_COMMWAGE";

    /**
     * 경조금 지급 기준 추가 데이터를 가져오는 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongMoreRela( String empNo, String beginDate ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, beginDate);
            excute(mConnection, function);
            Vector ret =   getTable(E19CongcondData.class,function, "T_RESULT");

            for ( int i = 0 ; i < ret.size() ; i++ ) {
                E19CongcondData data = (E19CongcondData)ret.get(i);
                data.WAGE_WONX = Double.toString(Double.parseDouble(data.WAGE_WONX) * 100.0 ) ; // 경조금
            }

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
    private void setInput(JCO.Function function, String empNo, String beginDate ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
        fieldName = "I_BEGDA";
        setField( function, fieldName, beginDate );
    }

}


