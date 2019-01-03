package hris.A.A18Deduct.rfc;

import hris.A.A01PersonalZHRH001SData;
import hris.A.A01PersonalZHRH010SData;
import hris.A.A01PersonalZHRH012SData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * A18DeductPrintGunroSodukBinaryRFC.java
 * �ٷμҵ� ��õ¡�� ������ PDF Data�� �����ϴ� RFC�� ȣ���ϴ� Class
 * [CSR ID:1639484] ESS ��õ¡�� ������ ��� PDF ��ȯ 2010.04.09   ������
 * @author  ������
 * @version 1.0, 2010/03/19
 */
public class A18DeductPrintGunroSodukBinaryRFC extends SAPWrap {
	
	//private String functionName = "zhrp_rfc_yea_result_prin4";
    private static String functionName = "zhrp_rfc_yea_result_prin4";
    
    /**
     * �ٷμҵ� ��õ¡�� ������ PDF Binary Table�� �����ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @param  java.lang.String �����ȣ
     * @param  java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getData(String P_PERNR, String P_AINF) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_PERNR, P_AINF );
            excute(mConnection, function);
            return  getBinary(function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    public String getSize(String P_PERNR, String P_AINF) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_PERNR, P_AINF );
            excute(mConnection, function);
            return  getOutput(function);
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
    private void setInput(JCO.Function function, String P_PERNR, String P_AINF ) throws GeneralException {
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

        Logger.sap.println(this, "===result : "+result.toString());
    	return result;
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private String getOutput(JCO.Function function) throws GeneralException { 
   
        // Export ���� ��ȸ
        String R_PDF_SIZE    = getField("R_PDF_SIZE",    function);  // ȸ���ڵ� 

        return R_PDF_SIZE;
    }    
}