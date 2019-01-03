package hris.E.E21Expense.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E21Expense.*;

/**
 * E21ExpenseBreakRFC.java
 * 학자금/장학금 신청시 휴직기간을 체크 Class
 *
 * @author 최영호
 * @version 1.0, 2003/06/18
 */
public class E21ExpenseBreakRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_BREAK_CHK";
    private String functionName = "ZGHR_RFC_BREAK_CHK";

    public String check( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", empNo );
            excute(mConnection, function);

            String E_FLAG = null;
            E_FLAG = getField("E_FLAG", function);//getOutput(function);

            return E_FLAG;

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


