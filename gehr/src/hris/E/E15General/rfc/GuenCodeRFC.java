package hris.E.E15General.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E15General.*;

/**
 * GuenCodeRFC.java
 * 본인,배우자 구분 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2001/12/13
 */
public class GuenCodeRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_P_GUEN_CODE";
    private String functionName = "ZGHR_RFC_P_GUEN_CODE";

    /**
     * 본인,배우자 구분 데이터를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGuenCode() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excute(mConnection, function);
            Vector ret = getCodeVector( function,"T_RESULT", "VALPOS", "DDTEXT"); //getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}

