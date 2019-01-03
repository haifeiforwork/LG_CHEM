package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustPensionCodeRFC.java
 * 연말정산 - 연금구분/유형  조회 RFC를 호출하는 Class
 *
 * @author lsa    2010/12/09
 * @2015 연말정산 주택자금상환 항목 추가를 위한 수정 : 주택자금대출 유형 항목 호출
 */
public class D11TaxAdjustPensionCodeRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_PENSION_PE" ;

    /**
     * 연말정산 - 연금구분/유형 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPension( String targetYear, String Code, String Gubn  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, targetYear, Code, Gubn );
            excute(mConnection, function);

            Vector ret = getOutput(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public Vector getPensionGubn( String targetYear, String Code, String Gubn  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, targetYear, Code, Gubn );
            excute(mConnection, function);

            Vector ret = getOutput1(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 연말정산 - 주택자금구분/유형 조회 RFC 호출하는 Method @2015 연말정산
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHouseLoanType( String targetYear, String Code, String pernr  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput2(function, targetYear, Code, pernr );
            excute(mConnection, function);

            Vector ret = getOutput(function);

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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String targetYear, String Code, String Gubn ) throws GeneralException {
        String fieldName1 = "I_CODE";
        setField( function, fieldName1, Code );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_GUBN";
        setField( function, fieldName3, Gubn );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String tableName = "T_GUBN";
        return getCodeVector( function, tableName);
    }
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustPensionCodeData";
        String tableName  = "T_GOJE";

        return getTable(entityName, function, tableName);
    }

    //@2015 연말정산 주택자금상환 시 콤보에 세팅할 항목 호출
    private void setInput2(JCO.Function function, String targetYear, String Code, String pernr ) throws GeneralException {
        String fieldName1 = "I_CODE";
        setField( function, fieldName1, Code );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_PERNR";
        setField( function, fieldName3, pernr );
    }
}
