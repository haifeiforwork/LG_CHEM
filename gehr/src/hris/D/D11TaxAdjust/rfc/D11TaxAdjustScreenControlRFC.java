package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustYearCheckRFC.java
 * �������� - ,ȸ�纰 PDF ���� :ȭ�е� �ߵ��Ի���(�׷��Ի���2/1������ �� ���)  PDF���ε� ���� , Ȯ�����μ������� ��ȸ
 *
 * @author  lsa
 * @version 1.0, 2013/11/22
 *
 * update    		2018/01/07 cykim [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��
 */
public class D11TaxAdjustScreenControlRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_SCREEN_CONTROL" ;

    /**
     * �������� - Ȯ�� ���� ��ȸ
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getFLAG( String empNo, String targetYear, String curDate ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput(function, empNo, targetYear,curDate ) ;
            excute(mConnection, function) ;
            Vector ret = getOutput(function);
            return ret;

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
    private void setInput(JCO.Function function, String empNo, String targetYear, String curDate ) throws GeneralException {
        String fieldName1 = "P_PERNR";
        setField( function, fieldName1, empNo );
        String fieldName2 = "P_ENDDA";
        setField( function, fieldName2, curDate );
        String fieldName3 = "P_YEAR";
        setField( function, fieldName3, targetYear );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        String E_PDF    = getField("E_PDF",    function);  //PDF ��� ����
        ret.addElement(E_PDF);
        String E_CONFIRM    = getField("E_CONFIRM",    function);  //Ȯ�� ���μ��� ��� ����
        ret.addElement(E_CONFIRM);
        /*[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� �� start */
        String E_LAST    = getField("E_LAST",    function);  //���ٹ��� ������ ����
        ret.addElement(E_LAST);
        /*[CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� �� end*/

        return ret;

    }
}