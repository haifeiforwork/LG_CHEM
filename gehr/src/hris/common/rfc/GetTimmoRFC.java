package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.common.*;

/**
 * GetTimmoRFC.java
 * R/3에서 T569R의 정보를 읽어 초과근무와 휴가 신청을 막도록 한다.
 *
 * @author  김도신
 * @version 1.0, 2003/01/29
 */
public class GetTimmoRFC extends SAPWrap {

   // private String functionName = "ZHRP_RFC_GET_TIMMO";
	 private String functionName = "ZGHR_RFC_GET_TIMMO";

    public String GetTimmo( String i_bukrs ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, i_bukrs );
            excute(mConnection, function);

            return getField("E_RRDAT", function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    private void setInput( JCO.Function function, String i_bukrs ) throws GeneralException {
        String fieldName1 = "I_BUKRS";
        setField( function, fieldName1, i_bukrs );
    }
}


