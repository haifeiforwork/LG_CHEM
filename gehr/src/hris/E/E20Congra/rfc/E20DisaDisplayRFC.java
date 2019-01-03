package hris.E.E20Congra.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E20Congra.*;

/**
 * E20DisaDisplayRFC.java
 * 재해피해신고서조회 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2001/12/20
 */
public class E20DisaDisplayRFC extends SAPWrap {

    //private String functionName = "ZHRW_RFC_DISASTER_DISPLAY";
	private String functionName = "ZGHR_RFC_DISASTER_DISPLAY";

    /**
     * 재해피해신고서조회 RFC 호출하는 Method
     * @param empNo java.lang.String 사원번호
     * @param CONG_DATE java.lang.String 발생일자
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDisaDisplay( String empNo, String CONG_DATE ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, CONG_DATE);
            excute(mConnection, function);
            Vector ret = getTable(E20DisasterData.class, function, "T_RESULT");

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
     * @param empNo java.lang.String 사원번호
     * @param CONG_DATE java.lang.String 발생일자
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String CONG_DATE ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        String fieldName2 = "I_CONG_DATE";
        setField( function, fieldName1, empNo );
        setField( function, fieldName2, CONG_DATE );
    }
}