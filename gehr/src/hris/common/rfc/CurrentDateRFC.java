package hris.common.rfc;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

/**
 * CurrentDateRFC.java
 * 현재 날짜를 가져오는 RFC 를 호출하는 Class                        
 *
 * @author 이형석
 * @version 1.0, 2002/02/16
 */
public class CurrentDateRFC extends SAPWrap {

    private String functionName = "ZHRW_GET_SYS_DATUM";

    /**
     * 현재날짜 RFC 호출하는 Method
     *
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getCurrent() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            String ret = getOutput(function);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    private String getOutput(JCO.Function function) throws GeneralException {

        String fieldName = "E_SY_DATUM";      // RFC Export 구성요소 참조
        return getField(fieldName, function);
   }

}

