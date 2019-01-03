/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : Global��������                                                    */
/*   Program Name : ���籸�к� Global��������                                      */
/*   Program ID   : F70GlobalClassRFC.java                                   */
/*   Description  : ���籸�к� Global�������� ��ȸ�� ���� RFC ����                 */
/*   Note         : ����                                                        */
/*   Creation     : 2006-03-15 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc; 

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
 

/**
 * F70GlobalClassRFC
 * �μ��� ���� ���籸�к� Global�������� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F70GlobalClassRFC extends SAPWrap {
 
    private String functionName = "ZHRA_RFC_GET_GLOBAL_STATE";

    /** 
     * �μ��ڵ忡 ���� ���籸�к� Global�������� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, ��������.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public Vector getDeptPositionClass(String i_orgeh, String i_lower,String i_today, String i_pool) throws GeneralException {
         
        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_lower,i_today,i_pool);
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
    private void setInput(JCO.Function function, String i_orgeh, String i_lower,String i_today, String i_pool ) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_TODAY"; 
        setField(function, fieldName1, i_today);
        String fieldName2 = "I_LOWERYN"; 
        setField(function, fieldName2, i_lower);
        String fieldName3 = "I_POOL";    //01: HPI02: ����������03: HPI&����������04: ����MBA05: HPI&����MBA06: �����屳���̼���07: Ȯ��MBA08: �ؿ�������09: R&D�ڻ�10: �����ܱ��αٹ���11: �߱�����������12: �߱�������������13: TOEIC 800�� �̻���14: HSK 5��� �̻���15: LGA 3.5�� �̻���16: �߱��� ������17: ����&�߱��� ������
        setField(function, fieldName3, i_pool);
        Logger.sap.println(this, "setInput :i_orgeh "+i_orgeh+"I_POOL:"+i_pool);
        
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
    	String entityName1 = "hris.F.F70GlobalClassTitleData";	// Ÿ��Ʋ.
    	Vector T_EXPORTA = getTable(entityName1,  function, "T_EXPORTA");
    	String entityName2 = "hris.F.F70GlobalClassNoteData";     // ����Ÿ.        	
    	Vector T_EXPORTB = getTable(entityName2,  function, "T_EXPORTB");

    	ret.addElement(T_EXPORTA);
    	ret.addElement(T_EXPORTB);
   	
    	return ret;
    }  
            
}


