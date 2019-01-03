package hris.D.D11TaxAdjust.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D11TaxAdjust.* ;

/**
 * D11TaxAdjustMedicalRFC.java
 * �������� - Ư������ �Ƿ�� ��û/����/��ȸ RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2004/11/24
 * @version 1.1, 2006/11/22 change�߰�
 */
public class D11TaxAdjustMedicalRFC extends SAPWrap {

    private String functionName = "ZSOLYR_RFC_MEDI_YEA" ;

    /**
     * �������� - Ư������ �Ƿ�� ��ȸ RFC ȣ���ϴ� Method 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getMedical( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "1", empNo, targetYear );
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
     * �������� - Ư������ �Ƿ�� ��ȸ RFC ȣ���ϴ� Method(9402 Infotype�� data�� ��ȸ)
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getMedical2( String empNo, String targetYear ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "2", empNo, targetYear );
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
     * �������� - Ư������ �Ƿ�� �Է� RFC ȣ���ϴ� Method @v1.1
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String empNo, String targetYear, Vector medical_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, "5", empNo, targetYear);

            setInput(function, medical_vt, "MEDI_T");

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
    private void setInput(JCO.Function function, String cont_type, String empNo, String targetYear) throws GeneralException {
        String fieldName1 = "P_CONF_TYPE";
        setField( function, fieldName1, cont_type );
        String fieldName2 = "PERNR";
        setField( function, fieldName2, empNo );
        String fieldName3 = "WORK_YEAR";
        setField( function, fieldName3, targetYear );
        String fieldName4 = "BEGDA";
        setField( function, fieldName4, "" );
        String fieldName5 = "ENDDA";
        setField( function, fieldName5, "" );
        String fieldName6 = "P_FLAG";
        setField( function, fieldName6, "" );
        String fieldName7 = "D_FLAG";
        setField( function, fieldName7, "" );
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
        String entityName = "hris.D.D11TaxAdjust.D11TaxAdjustMedicalData";
        String tableName  = "MEDI_T";

        return getTable(entityName, function, tableName);
    }
}
