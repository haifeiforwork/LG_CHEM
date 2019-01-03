/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   ����														*/
/*   2Depth Name		:   �⺻������												*/
/*   Program Name	:   �⺻������												*/
/*   Program ID		: D40RemeInfoEachRFCV.java							*/
/*   Description		: �⺻������													*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40DefaultSettingData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40DefaultSettingRFC.java
 * �⺻������
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40DefaultSettingRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_SELECT_OPTION";
    /**
     * �⺻�� ���� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDefaultSetting(String empNo, String I_SCREEN) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);			//��� ��ȣ
            setField(function, "I_SCREEN", I_SCREEN);	//���� ��ũ��(ȭ��)

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

    	Vector T_WTMCODE  = getTable(D40DefaultSettingData.class, function, "T_WTMCODE");	//����
    	Vector T_REASON  = getTable(D40DefaultSettingData.class, function, "T_REASON");	//����
    	Vector T_YN_DATA  = getTable(D40DefaultSettingData.class, function, "T_YN_DATA");	//�Է¿���Y/N
    	Vector T_EXCEP  = getTable(D40DefaultSettingData.class, function, "T_EXCEP");	//�Է¿���Y/N

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_WTMCODE);	//����
    	ret.addElement(T_REASON);		//����
    	ret.addElement(T_YN_DATA);		//�Է¿���Y/N
    	ret.addElement(T_EXCEP);			//��Ÿ

    	return ret;
    }



}


