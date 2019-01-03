/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ��������ǥ												*/
/*   Program Name	:   ��������ǥ �ϰ�, ����									*/
/*   Program ID		: D40RemeInfoEachRFCV.java							*/
/*   Description		: ��������ǥ �ϰ�, ����									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40DailStateData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40DailStateRFC.java
 * ��������ǥ
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40DailStateRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_GET_WORK_CONDUCT";
    /**
     * ��������ǥ ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDailState(String empNo, String I_ACTTY, String I_DATUM, String I_BEGDA, String I_ENDDA, String I_SCHKZ, String I_GUBUN, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);		//��� ��ȣ
            setField(function, "I_BEGDA", I_BEGDA);	//��ȸ������
            setField(function, "I_ENDDA", I_ENDDA);	//��ȸ������
            setField(function, "I_SCHKZ", I_SCHKZ);	//��ȹ�ٹ�Key
            setField(function, "I_ACTTY", I_ACTTY);	//������
            setField(function, "I_GUBUN", I_GUBUN);	//1:����,2:����

            setTable(function, "T_IMPERS", T_IMPERS);	//���õ� �����ȣ

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

    	Vector T_EXPORTA  = getTable(D40DailStateData.class, function, "T_EXPORTA");	//�ϰ�����ǥ TITLE
    	Vector T_EXPORTB  = getTable(D40DailStateData.class, function, "T_EXPORTB");	//�ϰ�����ǥ DATA
    	Vector T_EXPORTC  = getTable(D40DailStateData.class, function, "T_EXPORTC");	//��������ǥ DATA
    	Vector T_EXPORTD  = getTable(D40DailStateData.class, function, "T_EXPORTD");	//�ϰ�����ǥ ��¥
    	Vector T_SCHKZ  = getTable(D40DailStateData.class, function, "T_SCHKZ");		//��ȹ�ٹ� �ڵ�-�ؽ�Ʈ

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_BEGDA";	//��ȸ������
    	String fieldName2 = "E_ENDDA";	//��ȸ������
    	String fieldName3 = "E_DAY_CNT";	//���ڼ�
    	String fieldName4 = "E_INFO";     // �ȳ�����

    	String E_BEGDA  = getField(fieldName1, function);
    	String E_ENDDA  = getField(fieldName2, function);
    	String E_DAY_CNT  = getField(fieldName3, function);
    	String E_INFO  = getField(fieldName4, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_BEGDA);			//��ȸ������
    	ret.addElement(E_ENDDA);			//��ȸ������
    	ret.addElement(E_DAY_CNT);		//���ڼ�
    	ret.addElement(E_INFO);			//�ȳ�����
    	ret.addElement(T_EXPORTA);		//�ϰ�����ǥ TITLE
    	ret.addElement(T_EXPORTB);		//�ϰ�����ǥ DATA
    	ret.addElement(T_EXPORTC);		//��������ǥ DATA
    	ret.addElement(T_EXPORTD);		//�ϰ�����ǥ ��¥
    	ret.addElement(T_SCHKZ);			//��ȹ�ٹ� �ڵ�-�ؽ�Ʈ
        return ret;
    }



}


