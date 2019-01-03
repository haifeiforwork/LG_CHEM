package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustPersonCheckRFC.java
 * 연말정산 -  인적공제변동여부 저장 및 조회 RFC를 호출하는 Class
 *
 * @author lsa    2010/12/09   
 * 2017연말정산 부터 사용하지 않음. rdcamel.
 */
public class D11TaxAdjustPersonCheckRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_PERSON_CHECK" ;

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

            String E_CHG    = getField("E_CHG",    function);  // 인적공제변동여부 
            return E_CHG;

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
        String fieldName6 = "P_FLAG";
        setField( function, fieldName6,"" );  
        String fieldName7 = "D_FLAG";
        setField( function, fieldName7,"" );  
        String fieldName8 = "I_CHG";
        setField( function, fieldName8,iChk );  
    }
  
}
