package hris.common.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * CurrencyDecimalRFC.java
 * 통화키별로 소수자리수를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/02/15
 */
public class CurrencyDecimalRFC extends SAPWrap {

    //private String functionName = "ZHRW_GET_MONETARY_UNIT";
    private String functionName = "ZGHR_GET_MONETARY_UNIT";

    /**
     *  통화키별로 소수자리수를 가져오는 RFC를 호출하는 Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getCurrencyDecimal() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getCodeVector( function, "T_RESULT", "CURRKEY", "CURRDEC" );//getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        //String tableName  = "T_RESULT";      // RFC Export 구성요소 참조
        //String codeField  = "CURRKEY";
        //String valueField = "CURRDEC";
        return getCodeVector( function, "T_RESULT", "CURRKEY", "CURRDEC" );
    }
}


