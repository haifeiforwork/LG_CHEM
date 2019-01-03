package hris.J.J03JobCreate.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * J03RequireLevelRFC.java
 * 컴피턴시 리스트 요구수준 RFC를 호출하는 Class
 *
 * @author  원도연   
 * @version 1.0, 2003/06/16
 */
public class J03RequireLevelRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_REQUIRE_LEVEL";   

    /**
     *  컴피턴시 리스트 요구수준 RFC를 호출하는 Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
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
        Vector ret = new Vector();
        
//      Table 결과 조회
        String entityName1 = "hris.J.J03JobCreate.J03RequireLevelData";
        Vector L_RESULT    = getTable(entityName1, function, "L_RESULT");        

//      Table 결과 조회
        String entityName2 = "hris.J.J03JobCreate.J03QKData";
        Vector QK_RESULT    = getTable(entityName2, function, "QK_RESULT");        
        
        ret.addElement(L_RESULT);
        ret.addElement(QK_RESULT);                      
        return ret;
    }
}


