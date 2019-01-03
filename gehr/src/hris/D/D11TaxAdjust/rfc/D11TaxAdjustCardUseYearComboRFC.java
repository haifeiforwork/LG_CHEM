package hris.D.D11TaxAdjust.rfc ;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * D11TaxAdjustCardUseYearComboRFC.java
 * 신용카드 입력 시 사용기한 구분 값을 가져오는 RFC를 호출하는 Class(@2014 연말정산 소득공제신고서에 추가된 항목)
 * ex)2014년上/2014년下/2013년
 *
 * @author 이지은
 * @version 1.0, 2014/12/18
 * @version 1.1, 2016/01/11
 */
public class D11TaxAdjustCardUseYearComboRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_ETC_CREDIT_PE";

    /**
     * 신용카드 사용년도를 입력할 수 있는 콤보 값을 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사번
     * @param java.lang.String 연말정산 년도
     * @return java.lang.String 부서구분번호
     * @exception com.sns.jdf.GeneralException
     *
     */
    public Vector getCardUseYearCombo() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

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
     * 신용카드 사용년도를 입력할 수 있는 콤보 값을 가져오는 RFC를 호출하는 Method
     * @param java.lang.String 사번
     * @param java.lang.String 연말정산 년도
     * @return java.lang.String 부서구분번호
     * @exception com.sns.jdf.GeneralException
     * @2015 연말정산 추가(parameter에 targetYear 추가)
     */
    public Vector getCardUseYearCombo(String targetYear) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, targetYear);

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

     * @exception com.sns.jdf.GeneralException

     */

    private void setInput(JCO.Function function, String targetYear) throws GeneralException {

        String fieldName = "I_YEAR";

        setField( function, fieldName, targetYear );

    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	String tableName = "RESULT";
        return getCodeVector(function, tableName);
    }
}

