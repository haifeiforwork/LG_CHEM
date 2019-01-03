/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : ��� �˻�                                                   */
/*   Program ID   : OrganPersListRFC.java                                       */
/*   Description  : ���������� �������� �˻��ϴ� RFC ����                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-21 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common.rfc;

import hris.common.OrganPersListData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * OrganPersListRFC.java
 * ���������� �������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �����
 * @version 1.0, 2005/01/21
 * @version 1.0, 2013/11/08  ����߰� C20140121_73638
 */
public class OrganPersListRFC extends SAPWrap {

  //  private String functionName = "ZHRA_RFC_GET_ORGEH_PERS_LIST";
	  private String functionName = "ZGHR_RFC_GET_ORGEH_PERS_LIST";

    /**
     * ����ID�� ���������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ����ID
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersonList( String i_orgeh, String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh,pernr);
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

    public Vector getPersonList( String i_orgeh, String pernr, String I_IMWON ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh,pernr);
            setField(function, "I_IMWON" ,I_IMWON);

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
    private void setInput(JCO.Function function, String i_orgeh, String pernr) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName,  i_orgeh);
        String fieldName1  = "I_DEPT";
        setField(function, fieldName1,  pernr);

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
    	String E_RETURN   =getReturn().MSGTY;
    	String E_MESSAGE  =getReturn().MSGTX;

    	// Table ��� ��ȸ
    	Vector T_EXPORTA  = getTable(OrganPersListData.class,  function, "T_RESULT");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORTA);

    	return ret;
    }
}


