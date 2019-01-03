package	hris.E.E05House.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E05House.*;

/**
 * E05HouseBankCodeRFC.java
 * �����ڱ� ��û�� ���� �ڵ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2012/04/12
 */
public class E05HouseBankCodeRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_LOAN_BANK_CODE";
    private String functionName = "ZGHR_RFC_LOAN_BANK_CODE";

    /**
     * ������ �������ϱ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBankCode() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //setInput(function, keycode);

            excute(mConnection, function);

            Vector ret = getTable(E05HouseBankCodeData.class, function, "T_RESULT"); //getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}