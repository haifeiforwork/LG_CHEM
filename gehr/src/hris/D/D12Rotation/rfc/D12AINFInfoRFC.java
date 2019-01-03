package hris.D.D12Rotation.rfc ;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D12AINFInfoRFC.java
 * �����ȣ�� / �� ����� �������� ��ȸ �ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2009/01/07
 */
public class D12AINFInfoRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_DOCU_STATUS" ;

    /**
     * ���� ���� �Է� - �۾� Data�� ��ȸ�ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getAINFInfo( String AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
        
            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, AINF_SEQN );
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
    private void setInput(JCO.Function function, String AINF_SEQN) throws GeneralException {
        setField( function, "I_AINF", AINF_SEQN );
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
        
        Vector T_EXPORTA  = getTable("hris.D.D12Rotation.D12RotationBuild2Data", function, "T_EXPORTA");
    	
    	
    	String E_RETURN   = getField("E_RETURN", function) ;
    	String E_MESSAGE  = getField("E_MESSAGE", function) ;
    	
    	ret.addElement(T_EXPORTA);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	
        return ret;
    }
}