package	hris.C.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.C.*;

/**
 * C05FtestResultRFC.java
 * 개인의 어학능력 정보를 가져오는 RFC를 호출하는 Class
 * G-Mobile 어학능력 조회 RFC
 *
 * @author 이지은
 * @version 1.0, 2016-01-27
 * @[CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
 */
public class C05FtestResultRFC2 extends SAPWrap {

    private String functionName = "ZHRE_RFC_LANGUAGE_ABILITY2";

    /**
     * 개인의 어학능력 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getFtestResult( String empNo, String gubun ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = null;

            if( gubun == "1" ) {            // 어학능력
              ret = getOutput1(function);
            } else if( gubun == "2" ) {     // 어학능력 통계
              ret = getOutput2(function);
            }

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException {
        String fieldName = "P_PERNR";
        setField(function, fieldName, value);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C05FtestResult1Data";
        String tableName  = "P_TOTL_RESULT";
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.C.C05FtestResult2Data";
        String tableName  = "P_STAT_RESULT";
        return getTable(entityName, function, tableName);
    }
}