package hris.common.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * CurrencyCodeRFC.java
 * ��ȭŰ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/05
 */
public class CurrencyCodeRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_P_CURRENCY";
    private String functionName = "ZGHR_RFC_P_CURRENCY";

    /**
     *  ��ȭŰ �������� RFC�� ȣ���ϴ� Method
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


