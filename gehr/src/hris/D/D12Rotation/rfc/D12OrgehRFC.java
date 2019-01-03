package hris.D.D12Rotation.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D12Rotation.* ;

/**
 * D12OrgehRFC.java
 * �μ��� �⺻���� / �� ����� �������� ��ȸ �ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2009/01/07
 */
public class D12OrgehRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_DAY_READER" ;

    /**
     * ���� ���� �Է� - �۾� Data�� ��ȸ�ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetailForOrgeh( String datum, String orgeh ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForOrgeh( function, datum, orgeh );
            excute( mConnection, function );

            Vector ret = getOutput( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���� ���� �Է� - �۾� Data�� ��ȸ�ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetailForPernr( String datum, String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForPernr( function, datum, pernr );
            excute( mConnection, function );

            Vector ret = getOutput( function );

            return ret;

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
    private void setInputForOrgeh(JCO.Function function, String datum, String orgeh) throws GeneralException {
        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, datum );
        String fieldName2 = "I_ORGEH";
        setField( function, fieldName2, orgeh );
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInputForPernr(JCO.Function function, String datum, String pernr) throws GeneralException {
        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, datum );
        String fieldName2 = "I_PERNR";
        setField( function, fieldName2, pernr );
    }

    /**
     * Import Parameter �� Vector(Table) �� ���
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
//      ��� �Է� ���� ���� ����Ʈ ��ȸ
    	Vector ret = new Vector();
        String entityName = "hris.D.D12Rotation.D12RotationData";
        String tableName  = "T_RESULT";

    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);

    	/*String fieldName2 = "E_RETURN";        // �����ڵ�
    	String E_RETURN   = getField(fieldName2, function) ;

    	String fieldName3 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName3, function) ;*/

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName4 = "E_STATUS";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_STATUS  = getField(fieldName4, function) ;
    	String fieldName5 = "E_OTEXT";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_OTEXT  = getField(fieldName5, function) ;
    	String fieldName6 = "E_ORGEH";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_ORGEH  = getField(fieldName6, function) ;
    	ret.addElement(OBJPS_OUT);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_STATUS);
    	ret.addElement(E_OTEXT);
    	ret.addElement(E_ORGEH);
        return ret;
    }
}