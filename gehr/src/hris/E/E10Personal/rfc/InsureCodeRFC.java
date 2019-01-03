package hris.E.E10Personal.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E10Personal.*;

/**
 * GuenCodeRFC.java
 * 부인인가 난가 가져오는 RFC를 호출하는 Class
 *
 * @author 이형석   
 * @version 1.0, 2001/12/13
 */
public class InsureCodeRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_P_PENTION_INSURE";   

    /**
     *  업무코드 가져오는 RFC를 호출하는 Method
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInsureCode() throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
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
        String tableName = "IT";      // RFC Export 구성요소 참조
        return getCodeVector( function,tableName, "BANK_TYPE", "BANK_TEXT");
    }
}



