package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustHouseEssentialChkRFC.java
 * 연말정산 -  세대주 여부 필수 여부 WEB용 확인 RFC 를 호출하는 Class
 *
 * @author lsa    2010/12/28   
 */
public class D11TaxAdjustHouseEssentialChkRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_HOUSEHOLD_CHECK_WEB" ;

    /**
     * 연말정산 - 연금구분/유형 조회 RFC 호출하는 Method 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getYn( String Pernr , String Year   ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, Pernr ,Year );
            excute(mConnection, function);

            String E_CHECK    = getField("E_CHECK",    function);  // 세대주 여부
            return E_CHECK;

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
    private void setInput(JCO.Function function,  String Pernr , String Year    ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, Pernr );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, Year );  
    }
  
}
