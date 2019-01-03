/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �ڽ�Ʈ����                                                  */
/*   Program Name : �μ��� �ڽ�Ʈ���� ��ȸ                                      */
/*   Program ID   : F61DeptCostCenterRFC                                        */
/*   Description  : �μ��� �ڽ�Ʈ���� ��ȸ�� ���� RFC ����                      */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-21 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
 

/**
 * F61DeptCostCenterRFC
 * �μ��� ���� ��ü �μ��� �ڽ�Ʈ���� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F61DeptCostCenterRFC extends SAPWrap {
 
    private String functionName = "ZHRA_RFC_GET_ORGEH_COST_CENTER";

    /** 
     * �μ��ڵ忡 ���� ��ü �μ��� �ڽ�Ʈ���� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptCostCenter(String i_orgeh, String i_check) throws GeneralException {
         
        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check);
            excute(mConnection, function);
			ret = getOutput(function);
			
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } 
        return ret;
    }
    
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_orgeh, String i_check) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
    } 
  
    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */        
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	// Export ���� ��ȸ
    	String fieldName1 = "E_RETURN";        // �����ڵ�
    	String E_RETURN   = getField(fieldName1, function) ;
    	
    	String fieldName2 = "E_MESSAGE";      // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName2, function) ;
    	
    	// Table ��� ��ȸ
    	String entityName = "hris.F.F61DeptCostCenterData";
    	Vector T_EXPORT = getTable(entityName,  function, "T_EXPORTA");
    	
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);
    	 
    	return ret;
    }  
            
}


