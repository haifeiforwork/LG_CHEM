package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;

/**
 * C02CurriInfoRFC.java
 * 세부 교육과정 이벤트유형 내용을 가져오는 RFC를 호출하는 Class
 *
 * @author 박영락   
 * @version 1.0, 2002/01/14
 */
public class C02CurriInfoRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_EVENT_INFORM2";

    /**
     * 세부 교육과정 내용를 가져오는 RFC를 호출하는 Method
     * @param java.lang.Object hris.C.C02Curri.C02CurriInfoData Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCurriInfo( String OBJID, String SOBID ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, OBJID, SOBID );
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;

        } catch(Exception ex) {
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
     * @param java.lang.String OBJID 오브젝트ID
     * @param java.lang.String SOBID 관련오브젝트ID
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2) throws GeneralException{
        String fieldName1 = "P_OBJID";
        setField(function, fieldName1, key1);
        String fieldName2 = "P_SOBID";
        setField(function, fieldName2, key2);
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
        
        String entityName1 = "hris.C.C02Curri.C02CurriEventInfoData";//이벤트유형안내정보
        Vector P_EVENT_INFORM = getTable(entityName1, function, "P_EVENT_INFORM");
        
        String entityName2 = "hris.C.C02Curri.C02CurriEventData";//이벤트유형정보
        Vector P_EVENT_TYPE = getTable(entityName2, function, "P_EVENT_TYPE");
        
        String entityName3 = "hris.C.C02Curri.C02CurriData";//선이수과정
        Vector P_PRE_COURSE = getTable(entityName3, function, "P_PRE_COURSE");
        
        String entityName4 = "hris.C.C02Curri.C02CurriData";//자격요건획득
        Vector P_PRE_GET = getTable(entityName4, function, "P_PRE_GET");
        
        String entityName5 = "hris.C.C02Curri.C02CurriData";//선수자격요건
        Vector P_PRE_GRANT = getTable(entityName5, function, "P_PRE_GRANT");

        ret.addElement(P_EVENT_INFORM);
        ret.addElement(P_EVENT_TYPE);
        ret.addElement(P_PRE_COURSE);
        ret.addElement(P_PRE_GET);
        ret.addElement(P_PRE_GRANT);

        return ret;
    }
}
