package	hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.F.*;

/**
 * F72MajorPeCodeRFC.java
 * 전공 코드, 명을 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2006/03/15
 */
public class F72MajorPeCodeRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_MAJOR_PE";

    /**
     * 전공 코드, 명을 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getMajorPe(String FAART) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_FAART", FAART);
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
        String tableName = "TAB";
        return getCodeVector(function, tableName, "FAART", "FTEXT");
    }
}