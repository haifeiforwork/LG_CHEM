/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ��������ǥ												*/
/*   Program Name	:   ���ϱ��� �Է� ��Ȳ �˾�								*/
/*   Program ID		: D40DailStatePopupRFC.java							*/
/*   Description		: ���ϱ��� �Է� ��Ȳ �˾�									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40DailStatePopupData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40DailStatePopupRFC.java
 * ����������-���� ���ϱ��� �Է� ��Ȳ
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40DailStatePopupRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_DAY_DETAIL";
    /**
     * ���ϱ��� �Է� ��Ȳ ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDailState(String I_PERNR, String I_BEGDA, String I_ENDDA) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_PERNR", I_PERNR);	//��� ��ȣ
            setField(function, "I_BEGDA", I_BEGDA);	//��ȸ������
            setField(function, "I_ENDDA", I_ENDDA);	//��ȸ������

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

    	Vector T_EXLIST  = getTable(D40DailStatePopupData.class, function, "T_EXLIST");		//�Է���Ȳ��ȸ

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_ENAME";	//����

    	String E_ENAME  = getField(fieldName1, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_ENAME);			//�̸�
    	ret.addElement(T_EXLIST);		//�Է���Ȳ��ȸ

        return ret;
    }



}


