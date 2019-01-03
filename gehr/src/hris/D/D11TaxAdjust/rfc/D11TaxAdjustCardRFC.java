package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ; 

/**
 * D11TaxAdjustCardRFC.java
 * 연말정산 - 신용카드.현금영수증.보험료 신청/수정/조회 RFC를 호출하는 Class
 *
 * @author lsa    2006/11/23   
 */
public class D11TaxAdjustCardRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_YEAR_ETC" ;

    /**
     * 연말정산 - 신용카드.현금영수증.보험료 조회 RFC 호출하는 Method 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCard( String empNo, String targetYear, String p_tab ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "1", empNo, targetYear,p_tab );
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
     * 연말정산 - 신용카드.현금영수증.보험료 조회 RFC 호출하는 Method(9402 Infotype의 data를 조회)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCard2( String empNo, String targetYear, String p_tab ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "2", empNo, targetYear,p_tab );
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
     * 연말정산 - 신용카드.현금영수증.보험료 입력 RFC 호출하는 Method @v1.1
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String empNo, String targetYear, Vector medical_vt, String p_tab ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "5", empNo, targetYear,p_tab);

            setInput(function, medical_vt, "RESULT");

            excute(mConnection, function);

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
    private void setInput(JCO.Function function, String cont_type, String empNo, String targetYear, String p_tab) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, "" );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, "" );
        String fieldName5 = "P_CONF_TYPE";
        setField( function, fieldName5, cont_type );
        String fieldName6 = "P_FLAG";
        setField( function, fieldName6, "" );
        String fieldName7 = "D_FLAG";
        setField( function, fieldName7, "" );
        String fieldName8 = "P_TAB";
        setField( function, fieldName8, p_tab ); //1-신용/현금 2-보험
    }


    // Import Parameter 가 Vector(Table) 인 경우
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustCardData";
        String tableName  = "RESULT";

        return getTable(entityName, function, tableName);
    }
}
