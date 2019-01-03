/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : �μ��� �˻�                                                 */
/*   Program ID   : SearchDeptNameRFC                                           */
/*   Description  : �μ��� �˻��ϴ� RFC ����                                    */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-20 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * SearchDeptNameRFC
 * ���ѿ� ���� �μ����� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0,
 */
public class SearchDeptNameRFC extends SAPWrap {

   // private String functionName = "ZHRA_RFC_GET_OBJTXT_LIST";
	 private String functionName = "ZGHR_RFC_GET_ORGEH_LIST";

    /**
     * ���ѿ� ���� �μ����� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ����ID, �����ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptName(String i_pernr, String i_objtxt, String i_authora) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objtxt, i_authora);
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
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr, String i_objtxt, String i_authora) throws GeneralException {
        String fieldName  = "I_PERNR";
        setField(function, fieldName, i_pernr);
        String fieldName1 = "I_OBJTXT";
        setField(function, fieldName1, i_objtxt);
        String fieldName2 = "I_AUTHOR";
        setField(function, fieldName2, i_authora);
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
    /*	String fieldName1 = "E_RETURN";        // �����ڵ�
    	String E_RETURN   = getField(fieldName1, function) ;

    	String fieldName2 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
    	String E_MESSAGE  = getField(fieldName2, function) ;*/

    	// Table ��� ��ȸ
    	Vector T_EXPORTA   = getTable(hris.common.SearchDeptNameData.class,  function, "T_EXPORTA");

    	ret.addElement(getReturn().MSGTY);
    	ret.addElement(getReturn().MSGTX);
    	ret.addElement(T_EXPORTA);

    	return ret;
    }

}


