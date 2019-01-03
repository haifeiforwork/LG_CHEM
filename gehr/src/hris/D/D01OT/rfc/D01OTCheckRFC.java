package hris.D.D01OT.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D01OTCheckRFC.java
 * 초과근무 해당여부를 첵크하는 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/03/15
 */
@SuppressWarnings("rawtypes")
public class D01OTCheckRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_IS_AVAIL_OVERTIME";// "ZHRW_RFC_IS_AVAIL_OVERTIME";

    public Vector check(String PERSNO, String BEGDA, String ENDDA, String BEGTI, String ENDTI) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            setInput(function, PERSNO, BEGDA, ENDDA, BEGTI, ENDTI, null);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 초과근무 조회 RFC 호출하는 Method
     * 
     * @return java.util.Vector
     * @param java.lang.String 결재정보 일련번호
     * @param java.lang.String 사원번호
     * @param java.lang.String 사원번호
     * @param java.lang.String 사원번호
     * @param java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     * @[WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME 파라미터 추가(I_NTM = X)
     */
    public Vector check(String PERSNO, String BEGDA, String ENDDA, String BEGTI, String ENDTI, String NTM) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            setInput(function, PERSNO, BEGDA, ENDDA, BEGTI, ENDTI, NTM);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * 
     * @param function com.sap.mw.jco.JCO.Function
     * @param java.lang.String 사원번호
     * @param java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     * @[WorkTime52] ZGHR_RFC_IS_AVAIL_OVERTIME 파라미터 추가(I_NTM = X)
     */
    private void setInput(JCO.Function function, String PERSNO, String BEGDA, String ENDDA, String BEGTI, String ENDTI, String NTM) throws GeneralException {
        setField(function, "I_PERNR", PERSNO);
        setField(function, "I_BEGDA", BEGDA);
        setField(function, "I_ENDDA", ENDDA);
        setField(function, "I_BEGUZ", BEGTI);
        setField(function, "I_ENDUZ", ENDTI);
        if (NTM != null)
            setField(function, "I_NTM", NTM);
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * 
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {

        Vector ret = getTable(hris.D.D01OT.D01OTCheckData.class, function, "T_RESULT");
        return ret;
    }

}