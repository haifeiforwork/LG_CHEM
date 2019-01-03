package hris.J.J03JobCreate.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J03JobCreate.*;

/**
 * J03FileDownLoadRFC.java
 * KSEA, Process PPT File을 서버에서 다운로드하는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2003/07/01
 */
public class J03FileDownLoadRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_PPT_DOWNLOAD";

    /**
     * KSEA, Process PPT File을 서버에서 다운로드하는 RFC를 호출하는 Method
     * @param java.lang.String
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFile(String i_gubun, String i_filename) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput( function, i_gubun, i_filename );
            excute(mConnection, function);
            return getOutput(function);
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
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_gubun, String i_filename) throws GeneralException{
        String fieldName = "I_WK_KIND";
        setField(function, fieldName, i_gubun);
        String fieldName2 = "I_FILENAME";
        setField(function, fieldName2, i_filename);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    protected Vector getOutput(JCO.Function function ) throws GeneralException{
        Vector retvt = new Vector();
        try{
            JCO.Table table = function.getTableParameterList().getTable("P_BITMAP");

            String temp = "BINARY";
            retvt.addElement(temp);
            for( int i = 0 ; i < table.getNumRows() ; i++ ) {
                table.setRow(i);

                byte[] data = table.getByteArray("LINE");

                retvt.addElement(data);
            }
            Logger.debug.println(this, retvt.toString());
        } catch ( Exception ex ){
            Logger.debug.println(this, "getTable(String entityName, JCO.Function function, String functionName)에서 예외발생 " );
            Logger.debug.println(this, "entityName는 Package 경로가 잡혀있어야함 .. 확인요 " );
            throw new GeneralException(ex);
        }
        return retvt;
    }
}



    