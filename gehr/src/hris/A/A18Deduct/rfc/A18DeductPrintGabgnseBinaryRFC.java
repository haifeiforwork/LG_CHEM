package hris.A.A18Deduct.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * A18DeductPrintGunroSodukBinaryRFC.java
 *���ټ�  PDF Data�� �����ϴ� RFC�� ȣ���ϴ� Class
 * [CSR ID:1639484] ESS ���ټ�  ��� PDF ��ȯ 2012.07.23   
 * @author  lsa
 * @version 1.0, 2012/07/23
 */
public class A18DeductPrintGabgnseBinaryRFC extends SAPWrap {
	
	//private String functionName = "ZHRP_RFC_PTX_PRINT";
	private static String functionName = "ZHRP_RFC_PTX_PRINT"; 
    
    /**
     * ���ټ� PDF Binary Table�� �����ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @param  java.lang.String �����ȣ
     * @param  java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getData(String P_PERNR, String P_AINF ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_PERNR, P_AINF  );
            excute(mConnection, function);
            return  getBinary(function);
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
	 * @param java.lang.String �����ȣ
     * @param java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_PERNR, String P_AINF  ) throws GeneralException {
 	
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, P_PERNR );
        String fieldName2 = "I_AINF_SEQN";
        setField( function, fieldName2, P_AINF );
    }
    /**
     * RFC ������ Binary Table�� Vector�� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getBinary(JCO.Function function) throws GeneralException {
    	Vector result = new Vector();
    	result = getTable(function, "E_TABLE");
    	return result;
    }
}