package hris.C.C02Curri.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.C.C02Curri.*;


/**
 * C02CurriGetFlagRFC.java
 * 신청하는 교육의 기간이 중복되는지를 체크하는 Class                        
 *
 * @author  김도신
 * @version 1.0, 2002/05/25
 */
public class C02CurriGetFlagRFC extends SAPWrap {

    private String functionName = "ZHRE_RFC_CHECK_YYMMDD";

    /**
     * 중복기간 체크 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String check( String Pernr, String Begda, String Endda, String Sobid ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput( function, Pernr, Begda, Endda, Sobid );
            excute(mConnection, function);
            
            return getField("YNO_FLAG", function);
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
	   * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String Pernr, String Begda, String Endda, String Sobid ) throws GeneralException {
        String fieldName1 = "E_PERNR";
        setField( function, fieldName1, Pernr );
        String fieldName2 = "E_BEGDA";
        setField( function, fieldName2, Begda );
        String fieldName3 = "E_ENDDA";
        setField( function, fieldName3, Endda );
        String fieldName4 = "E_SOBID";
        setField( function, fieldName4, Sobid );
    }
}


