package hris.G.rfc;

import hris.G.G004CongraReasonData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * G004CongraReasonRFC.java
 * 경조금 결재시 사유  Code를 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2013/09/04
 */
public class G004CongraReasonRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_DOMAIN_NAME";
    private String functionName = "ZGHR_RFC_GET_DOMAIN_NAME";

    /**
     * 경조 결재사유 Code를 가져오는 RFC를 호출하는 Method
     * @param companyCode java.lang.String 회사코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCode( String name) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, name);
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String name) throws GeneralException {
        String fieldName = "I_NAME";
        setField( function, fieldName, name );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

        return getTable(G004CongraReasonData.class, function,  "T_EXPORT");
    }

}


