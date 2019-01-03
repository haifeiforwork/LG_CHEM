package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ; 

/**
 * D11TaxAdjustCardRFC.java
 * �������� - �ſ�ī��.���ݿ�����.����� ��û/����/��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author lsa    2006/11/23   
 */
public class D11TaxAdjustCardRFC extends SAPWrap {

    private static String functionName = "ZSOLYR_RFC_YEAR_ETC" ;

    /**
     * �������� - �ſ�ī��.���ݿ�����.����� ��ȸ RFC ȣ���ϴ� Method 
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
     * �������� - �ſ�ī��.���ݿ�����.����� ��ȸ RFC ȣ���ϴ� Method(9402 Infotype�� data�� ��ȸ)
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
     * �������� - �ſ�ī��.���ݿ�����.����� �Է� RFC ȣ���ϴ� Method @v1.1
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
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
        setField( function, fieldName8, p_tab ); //1-�ſ�/���� 2-����
    }


    // Import Parameter �� Vector(Table) �� ���
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
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
