/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : Global����POOL                                              */
/*   Program Name : Global����POOL ������ ��ȭ��                              */
/*   Program ID   : F71GlobalDetailListRFC                                      */
/*   Description  : Global����POOL ������ ��ȭ�� ��ȸ�� ���� RFC ����         */
/*   Note         : ����                                                        */
/*   Creation     : 2006-03-16 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.F.rfc; 

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*; 
 

/** 
 * F71GlobalDetailListRFC
 * Global����POOL ������ ��ȭ�� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F71GlobalDetailListRFC extends SAPWrap {
 
    private String functionName = "ZHRA_RFC_GET_GLOBAL_DETAI_LIST";

    /**  
     * Global����POOL ������ ��ȭ�� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getDeptDetailList(String i_gubun,  String i_deptId, String i_checkYN,
    								                String i_paramA, String i_paramB, String i_paramC, 
								                    String i_paramD  ) throws GeneralException {
         
        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_gubun, i_deptId, i_checkYN, i_paramA, i_paramB, i_paramC, i_paramD);
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
    private void setInput(JCO.Function function, String i_gubun,  String i_deptId, String i_checkYN,
				                                         String i_paramA, String i_paramB, String i_paramC, 
												                         String i_paramD  ) throws GeneralException {
        String fieldName1  = "I_GUBUN";     //����pool ������      
        String fieldName2  = "I_ORGEH";     //����ID               
        String fieldName3  = "I_LOWERYN";   //������������ üũ����
        String fieldName4  = "I_OBJID";     //����ID               
        String fieldName5  = "I_STEXT";     //�����ڵ��           
        String fieldName6  = "I_TITLACD";   //�������׷�         
        String fieldName7  = "I_TITLBCD";   //������               
        setField(function, fieldName1, i_gubun);
        setField(function, fieldName2, i_deptId);
        setField(function, fieldName3, i_checkYN);
        setField(function, fieldName4, i_paramA);
        setField(function, fieldName5, i_paramB);
        setField(function, fieldName6, i_paramC);
        setField(function, fieldName7, i_paramD);
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
    	    	
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

        // Table ��� ��ȸ
    	String entityName = "hris.F.F71GlobalDetailListData";      // ����Ÿ.        	
    	Vector T_EXPORTA = getTable(entityName,  function, "T_EXPORTA");
    	ret.addElement(T_EXPORTA);
   	
    	return ret;
    }  
            
}

