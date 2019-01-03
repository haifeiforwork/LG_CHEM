/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ����                                                           							*/
/*   Program Name	: ������ - ���,���� �˻�                   									*/
/*   Program ID		: D40OrganPersListRFC.java											*/
/*   Description		: ������ - ���,���� �˻�													*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;

import hris.D.D40TmGroup.D40OrganPersListData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40OrganPersListRFC.java
 * ���������� �������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OrganPersListRFC extends SAPWrap {

  //  private String functionName = "ZGHR_RFC_GET_ORGEH_PERS_LIST";
	  private String functionName = "ZGHR_RFC_TM_GET_ORGEH_PERS";
	  private String functionName2 = "ZGHR_RFC_TM_GET_DEPT_PERSONS";

    /**
     * ����ID�� ���������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersonEmpList( String i_dept, String i_pernr, String i_ename, String i_gubun, String i_retir ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName2) ;

            setInput(function, i_dept, i_pernr, i_ename, i_gubun, i_retir);
            excute(mConnection, function);
//            Vector ret = getOutput(function);
           // Vector ret =  getTable(D40OrganPersListData.class, function, "T_RESULT");
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
     * ���,���� �˻�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getPersonList( String empNo, String I_SELTAB, String I_DATUM, Vector OBJID ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

        	mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_DATUM", I_DATUM);
//            setField(function, "I_SELTAB", I_SELTAB);

            if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }else if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else{
            	setTable(function, "T_IMPORTA", OBJID);
            }

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
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_dept, String i_pernr, String i_ename, String i_gubun, String i_retir) throws GeneralException {
    	String fieldName  = "I_DEPT";
        setField(function, fieldName,  i_dept);
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
        String fieldName2 = "I_ENAME";
        setField(function, fieldName2, i_ename);
        String fieldName3 = "I_GUBUN";
        setField(function, fieldName3, i_gubun);
        String fieldName4 = "I_RETIR";
        setField(function, fieldName4, i_retir);

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
    	Vector T_EXPORTA  = getTable(D40OrganPersListData.class,  function, "T_RESULT");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORTA);

    	return ret;
    }
}


