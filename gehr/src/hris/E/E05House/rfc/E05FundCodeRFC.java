package hris.E.E05House.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;

/**
 * E05FundCodeRFC.java
 * �ڱݿ뵵 Code�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 */
public class E05FundCodeRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_FUND_CODE";
    private String functionName = "ZGHR_RFC_GET_FUND_CODE";

    /**
     * �ڱݿ뵵 Code�� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFundCode() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getTable(E05FundCodeData.class, function, "T_FUND_TAB"); //getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}

