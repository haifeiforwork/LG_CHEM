package hris.E.E15General.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E15General.*;

/**
 * GuenCodeRFC.java
 * ����,����� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2001/12/13
 */
public class GuenCodeRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_P_GUEN_CODE";
    private String functionName = "ZGHR_RFC_P_GUEN_CODE";

    /**
     * ����,����� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
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

