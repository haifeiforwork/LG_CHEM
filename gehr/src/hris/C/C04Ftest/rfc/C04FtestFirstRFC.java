package	hris.C.C04Ftest.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C04Ftest.*;

/**
 * C04FtestFirstRFC.java
 * 어학능력 검정 일정을 가져오는 class
 *
 * @author 이형석
 * @version 1.0, 2002/01/04
 */
public class C04FtestFirstRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_FIRST";

    /**
     * 어학능력점정 일정을 가져오는 RFC를 호출하는 Method
     * @param java.lang.String사원번호 java.lang.String 시험코드
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFtestFirst(String empNo, String lang_code) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, lang_code);
            
            excute(mConnection, function);
            
            Vector ret = getOutput(function);
            Logger.debug.println(this, "ret"+ret.toString());
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
     * @param function com.sap.mw.jco.JCO.Function java.lang.String java.lang.String
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String empNo, String lang_code) throws GeneralException {
        String fieldName1 = "PERNR"          ;
        setField(function, fieldName1, empNo);

        String fieldName2 = "LANG_CODE"          ;
        setField(function, fieldName2, lang_code);
           
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C04Ftest.C04FtestFirstData";
        String tableName  = "ITAB";
        return getTable(entityName, function, tableName);
    }
}
