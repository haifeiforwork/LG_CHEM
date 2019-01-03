package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.common.*;

/**
 * EpMyMenuRFC.java
 * 권한별 사번목록을 조회하는 RFC를 호출하는 Class
 *
 * @author 배민규
 * @version 1.0, 2005/10/02
 */
public class EpMyMenuRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_AUTH_SABUN";

    public Vector getDetail() throws GeneralException {

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
        String entityName = "hris.common.EpMyMenuData";
        String tableName  = "T_AUTH_SABUN";
        return getTable(entityName, function, tableName);
    }

}

