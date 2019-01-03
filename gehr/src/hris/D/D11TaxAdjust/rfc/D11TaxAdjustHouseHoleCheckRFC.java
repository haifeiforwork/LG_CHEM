package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustHouseHoleCheckRFC.java
 * �������� -  �����ֿ��� ���� �� ��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author lsa    2010/12/09   
 */
public class D11TaxAdjustHouseHoleCheckRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_HOUSEHOLD_CHECK" ;

    /**
     * �������� - ���ݱ���/���� ��ȸ RFC ȣ���ϴ� Method 
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

            String E_HOLD    = getField("E_HOLD",    function);  // ������ ����
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
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
