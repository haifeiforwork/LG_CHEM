package hris.E.E05House.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E05House.*;

/**
 * E05LoanCodeRFC.java
 * 주택융자유형 Code를 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class E05LoanCodeRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_GET_LOAN_TYPE";
    private String functionName = "ZGHR_RFC_GET_LOAN_TYPE";

    /**
     * 주택융자유형 Code를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLoanType() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getCodeVector( function, "T_LOAN_TAB");//getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}


