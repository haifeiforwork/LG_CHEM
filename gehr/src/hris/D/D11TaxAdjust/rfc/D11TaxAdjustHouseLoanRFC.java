package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustHouseLoanRFC.java
 * @2015 연말정산 - 주택자금상환 신청/수정/조회 RFC를 호출하는 Class
 *
 * @author 이지은
 * @version 1.0, 2015/12/29
 */
public class D11TaxAdjustHouseLoanRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_HOUSE_LOAN" ;

    /**
     * 연말정산 - 주택자금상환 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     *
     * CONSTANTS : SELECT VALUE '1',   "조회
            INSERT VALUE '2',   "생성 ( 안씀)
            UPDATE VALUE '3',
            DELETE VALUE '4',
            SAVE   VALUE '5',
            PDF_UP VALUE '6'.
     */
    public Vector getHouseLoan( String empNo, String targetYear  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, targetYear, "1");
            excute(mConnection, function);
            Vector ret =  new Vector();
            ret = getOutput(function);

            for( int i = 0 ; i < ret.size() ; i++ ){
            	D11TaxAdjustHouseLoanData data = (D11TaxAdjustHouseLoanData)ret.get(i);

                if(data.NAM01.equals("")){ data.NAM01=""; }else{ data.NAM01=Double.toString(Double.parseDouble(data.NAM01) * 100.0); }  // 금액
            }


            return ret;

        } catch(GeneralException gex){
            // NO_DATA_FOUND 오류시 빈백터를 담은 Object를 리턴한당.com.sap.mw.jco.JCO$AbapException
            String exMsg = "com.sap.mw.jco.JCO$AbapException: (126) NO_DATA_FOUND: 해당 일자에 INFOTYPE 정보 없음";
            StackTraceElement[] stackTraceBuffer = gex.getStackTrace();

            if( exMsg.equals(stackTraceBuffer.toString( )) ){
                Vector ret = new Vector();
                return ret;
            } else {
                throw new GeneralException(gex);
            }
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 연말정산 - 주택자금 상환 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String empNo, String targetYear, Vector houseLoan_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            for( int i = 0 ; i < houseLoan_vt.size() ; i++ ){
            	D11TaxAdjustHouseLoanData data = (D11TaxAdjustHouseLoanData)houseLoan_vt.get(i);

                if(data.NAM01.equals("")) { data.NAM01=""; } else{ data.NAM01=Double.toString(Double.parseDouble(data.NAM01)   / 100.0); }  // 금액
            }

            setInput(function, empNo, targetYear, "2");

            setInput(function, houseLoan_vt, "RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public void change( String empNo, String targetYear, Vector houseLoan_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for( int i = 0 ; i < houseLoan_vt.size() ; i++ ){
            	D11TaxAdjustHouseLoanData data = (D11TaxAdjustHouseLoanData)houseLoan_vt.get(i);

                if(data.NAM01.equals("")) { data.NAM01=""; } else{ data.NAM01=Double.toString(Double.parseDouble(data.NAM01)   / 100.0); }  // 금액
            }

            setInput(function, empNo, targetYear, "5");

            setInput(function, houseLoan_vt, "RESULT");

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
    private void setInput(JCO.Function function, String empNo, String targetYear, String conftype) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3, "" );
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4, "" );
        String fieldName5 = "P_CONF_TYPE";
        setField( function, fieldName5, conftype );
        String fieldName6 = "P_FLAG";
        setField( function, fieldName6, "Y" );
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
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustHouseLoanData";
        String tableName  = "RESULT";

        return getTable(entityName, function, tableName);
    }
}