package hris.common.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * CurrencyCodeRFC.java
 * 통화키 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/05
 */
public class CurrencyCodeRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_P_CURRENCY";
    private String functionName = "ZGHR_RFC_P_CURRENCY";

    /**
     *  통화키 가져오는 RFC를 호출하는 Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getCurrencyCode() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);

            String codeField  = "WAERS";
            String valueField = "WAERS";

            Vector ret = getCodeVector( function, "T_RESULT", codeField, valueField );//getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}


