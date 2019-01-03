/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ���ϱ��� �Է� ��Ȳ										*/
/*   Program Name	:   ���ϱ��� �Է� ��Ȳ										*/
/*   Program ID		: D40TmDailyRFC.java									*/
/*   Description		: ���ϱ��� �Է� ��Ȳ										*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmDailyData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmDailyRFC.java
 * ���ϱ��� �Է� ��Ȳ
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40TmDailyRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_DAILY";
    /**
     * ���ϱ��� �Է� ��Ȳ ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmDaily(String empNo, String I_SCHKZ,String I_BEGDA, String I_ENDDA, String I_SELTAB, Vector OBJID, Vector T_IMPERS, Vector T_IMINFTY,Vector T_IMWTMCD) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);				//��� ��ȣ
            setField(function, "I_SCHKZ", I_SCHKZ);			//���õ� ��ȹ�ٹ�
            setField(function, "I_BEGDA", I_BEGDA);			//��ȸ������
            setField(function, "I_ENDDA", I_ENDDA);			//��ȸ������

            setTable(function, "T_IMPERS", T_IMPERS);			//���õ� �����ȣ
            setTable(function, "T_IMINFTY", T_IMINFTY);		//���õ� ����Ÿ��
            setTable(function, "T_IMWTMCD", T_IMWTMCD);	//���õ� ����

            if("A".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTA", OBJID);
            }else if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }
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

    	Vector T_EXLIST  = getTable(D40TmDailyData.class, function, "T_EXLIST");				//�Է���Ȳ��ȸ
    	Vector T_SCHKZ  = getTable(D40TmDailyData.class, function, "T_SCHKZ");				//��ȹ�ٹ� �ڵ�-�ؽ�Ʈ
//    	Vector T_WTMCODE  = getTable(D40TmDailyData.class, function, "T_WTMCODE");		//���� �ڵ�-�ؽ�Ʈ

    	Vector T_EXINFTY  = getTable(D40TmDailyData.class, function, "T_EXINFTY");			//���õ� ����Ÿ��
    	Vector T_EXWTMCD  = getTable(D40TmDailyData.class, function, "T_EXWTMCD");		//���õ� ����

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_BEGDA";	//��ȸ������
    	String fieldName2 = "E_ENDDA";	//��ȸ������

    	String E_BEGDA  = getField(fieldName1, function);
    	String E_ENDDA  = getField(fieldName2, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(T_EXLIST);		//�Է���Ȳ��ȸ
    	ret.addElement(T_SCHKZ);			//��ȹ�ٹ�
    	ret.addElement(T_EXINFTY);		//���õ� ����Ÿ��
    	ret.addElement(T_EXWTMCD);	//���õ� ����
    	ret.addElement(E_BEGDA);			//��ȸ������
    	ret.addElement(E_ENDDA);			//��ȸ������

    	return ret;
    }



}


