package hris.D.D12Rotation.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.D.D12Rotation.* ;

/**
 * D12RotationRFC.java
 * ���� ���� �Է� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2004/02/24
 */
public class D12RotationRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_DAY_SAVE" ;

    /**
     * ���� ���� �Է� - �۾� Data�� �����ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector  saveData( Vector main_vt ,String i_orgeh,String i_date) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, main_vt,     "T_RESULT",i_orgeh,i_date  );

            excute( mConnection, function );
        	Vector ret = new Vector();
        	// Export ���� ��ȸ
        	/*String fieldName1 = "E_RETURN";        // �����ڵ�
        	String E_RETURN   = getField(fieldName1, function) ;

        	String fieldName2 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
        	String E_MESSAGE  = getField(fieldName2, function) ;
        	*/
        	String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * Import Parameter �� Vector(Table) �� ���
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName,String i_orgeh,String i_date ) throws GeneralException {
        setTable(function, tableName, entityVector);
        String fieldName = "I_ORGEH";
        setField( function, fieldName, i_orgeh );
        String fieldName1 = "I_BEGDA";
        setField( function, fieldName1, i_date );
    }

}