package hris.common.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * HRUpmuCodeRFC.java
 * 업무코드 가져오는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class HRUpmuCodeRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_P_UPMU_CODE";
    private String functionName = "ZGHR_RFC_UPMU_CODE_F4";

    /**
     *  업무코드 가져오는 RFC를 호출하는 Method
     *  @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getUpmuCode( String I_BUKRS ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, I_BUKRS );
            excute(mConnection, function);
            Vector ret = getCodeVector(function, "T_RESULT", "UPMU_CODE", "UPMU_NAME");//getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField(function, fieldName, value);
    }

}


