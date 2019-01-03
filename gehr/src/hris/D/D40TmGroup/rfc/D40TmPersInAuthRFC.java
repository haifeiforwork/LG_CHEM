/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   ��������													*/
/*   2Depth Name		:   ����/�ο���Ȳ - ������Ȳ								*/
/*   Program Name	:   �μ����´����											*/
/*   Program ID		: D40TmPersInAuthRFC.java							*/
/*   Description		: �μ����´����											*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmPersInAuthData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmPersInAuthRFC.java
 * �μ����´����
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40TmPersInAuthRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_PERS_IN_AUTH_LIST";
    /**
     * ����������-�μ����´���� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmPersInAuth(String deptId, String I_DATUM) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_ORGEH", deptId);		//���õ� ���� �ڵ�
            setField(function, "I_DATUM", I_DATUM);	//���õ� ����

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


	private Vector getOutput(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();

    	Vector T_EXLIST  = getTable(D40TmPersInAuthData.class, function, "T_EXLIST");	//�Է���Ȳ��ȸ

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_EXLIST);		//�Է���Ȳ��ȸ
        return ret;
    }



}


