package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * GetPhotoURLRFC.java
 * 사진의 URL를 가져오는 RFC를 호출하는 Class
 * @author 박영락   
 * @version 1.0, 2002/01/30
 */
public class GetPhotoURLRFC extends SAPWrap {

    private String functionName = "ZHRW_ARCHIVEOBJECT_GET_URI";

    /**
     * 사진의 URL를 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사번
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getPhotoURL( String PERNR ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            String ServerName = conf.get("com.sns.jdf.SAP_CONTENT_SERVER_NAME");

            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, PERNR, ServerName);
            excute(mConnection, function);
            String ret = getOutput(function);
            Logger.debug.println(this, ret.toString()+"   ServerName : "+ServerName);
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key, String ServerName ) throws GeneralException{
        String fieldName = "I_OBJECTTYPE";
        setField(function, fieldName, ServerName);
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, key);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException {
        String tableName = "T_RESULT";
        Vector vt = getCodeVector( function, tableName, "MANDT", "URI");
        String uri = "";
        try{
         CodeEntity code = (CodeEntity)vt.get(0);
         uri = code.value;
        } catch( ArrayIndexOutOfBoundsException e ){
            uri = "";
        }
        return uri;
    }
}

