package	hris.C.C04Ftest.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.C04Ftest.*;

/**
 * PlanguageRFC.java
 * 어학검정 장소에 대한 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 이형석
 * @version 1.0, 2002/01/04
 */
public class PlanguageRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_P_LANGUAGE_LIST";

    /**
     * 어학검정 장소에 대한 정보를 가져오는 RFC를 호출하는 Method
     * @param  java.lang.String 회사코드  java.lang.String 개인의 시험코드  
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPlanguage(String p_burks, String p_lang_code) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, p_burks, p_lang_code);
            
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
     * @param function com.sap.mw.jco.JCO.Function java.lang.String 회사코드  java.lang.String 개인의 시험코드  
     * @exception com.sns.jdf.GeneralException
     */
   private void setInput(JCO.Function function, String p_burks, String p_lang_code) throws GeneralException {
      String fieldName1 = "P_BUKRS"          ;
      setField(function, fieldName1, p_burks);

      String fieldName2 = "P_LANG_CODE"          ;
      setField(function, fieldName2, p_lang_code);
           
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
     private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "P_RESULT";      // RFC Export 구성요소 참조
        return getCodeVector( function, tableName);
    }
}


