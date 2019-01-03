package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustYearCheckRFC.java
 * �������� - Ȯ�� ���� ��ȸ
 *
 * @author �赵��
 * @version 1.0, 2002/12/04
 */
public class D11TaxAdjustYearCheckRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_YEAR_CHECK" ;

    /**
     * �������� - Ȯ�� ���� ��ȸ
     *  @exception com.sns.jdf.GeneralException
     */
    public String getO_FLAG( String empNo, String targetYear ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, empNo, targetYear, "") ;
            excute(mConnection, function) ;

            String fieldName = "O_FLAG" ;
            String ret       = getField( fieldName, function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String targetYear, String flag) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "I_YEAR";
        setField( function, fieldName2, targetYear );
        String fieldName3 = "T_FLAG";
        setField( function, fieldName3, flag );
        String fieldName4 = "I_ESS";
        setField( function, fieldName4, "X" );
    }
}