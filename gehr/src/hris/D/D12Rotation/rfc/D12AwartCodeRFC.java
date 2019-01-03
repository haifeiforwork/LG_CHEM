package hris.D.D12Rotation.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.D.D12Rotation.*;

/**
 * D12AwartCodeRFC.JAVA
 * 휴무유형 데이터를 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2008/11/10
 */
public class D12AwartCodeRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_AWART";
      private String functionName = "ZGHR_RFC_AWART";


    /**
     * 휴가 유형 데이터를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAwartCode() throws GeneralException {

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
        String entityName = "hris.D.D12Rotation.D12AwartData";
        String tableName  = "T_RESULT";
        return getTable(entityName, function, tableName);
    }
}

