package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustHouseHoleCheckRFC.java
 * 연말정산 -  세대주여부 저장 및 조회 RFC를 호출하는 Class
 *
 * @author lsa    2010/12/09   
 */
public class D11TaxAdjustHouseHoleCheckRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_HOUSEHOLD_CHECK" ;

    /**
     * 연말정산 - 연금구분/유형 조회 RFC 호출하는 Method 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String getChk( String Pernr , String Year,String Begda ,String Endda, String iChk) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, Pernr,Year, Begda,Endda,"1",iChk );
            excute(mConnection, function);

            String E_HOLD    = getField("E_HOLD",    function);  // 세대주 여부
            return E_HOLD;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }  
    public void build(   String Pernr , String Year,String Begda ,String Endda, String iChk  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, Pernr,Year, Begda,Endda,"5",iChk );
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
    private void setInput(JCO.Function function,  String Pernr , String Year,String Begda ,String Endda,String pConfType,String iChk ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, Pernr );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, Year );
        String fieldName3 = "I_BEGDA";
        setField( function, fieldName3,Begda );  
        String fieldName4 = "I_ENDDA";
        setField( function, fieldName4,Endda );  
        String fieldName5 = "P_CONF_TYPE";
        setField( function, fieldName5,pConfType );  
        String fieldName6 = "I_CHK";
        setField( function, fieldName6,iChk );  
    }
  
}
