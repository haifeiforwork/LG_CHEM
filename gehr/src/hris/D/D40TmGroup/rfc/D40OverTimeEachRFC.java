/********************************************************************************/
/*																				*/
/*   System Name	: MSS														*/
/*   1Depth Name	: �μ�����													*/
/*   2Depth Name	: �ʰ��ٹ�                                                         	*/
/*   Program Name	: �ʰ��ٹ�(����)                                  			*/
/*   Program ID		: D40OverTimeEachRFC.java									*/
/*   Description	: �ʰ��ٹ�(����)												*/
/*   Note			: ����														*/
/*   Creation  		: 2017-12-08 ������											*/
/*   Update   		: 2017-12-08 ������											*/
/*   		   		: 2018-06-18 ��ȯ�� [WorkTime52]								*/
/*																				*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D40TmGroup.D40OverTime50OverWeekData;
import hris.D.D40TmGroup.D40OverTimeFrameData;
import hris.D.D40TmGroup.D40TmSchkzFrameData;


/**
 * D40OverTimeEachRFC.java
 * ����������-�ʰ��ٹ�(����) ��ȸ/����/Excel
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OverTimeEachRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_OVERTIME";
	/**
     * �ʰ��ٹ�(����) ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getDailScheEach(String empNo, String I_ACTTY, String I_BEGDA, String I_ENDDA, String I_SCHKZ, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);		//��� ��ȣ
            setField(function, "I_BEGDA", I_BEGDA);	//��ȸ������
            setField(function, "I_ENDDA", I_ENDDA);	//��ȸ������
            setField(function, "I_ACTTY", I_ACTTY);	//������
            setField(function, "I_SCHKZ", I_SCHKZ);	//��ȹ�ٹ�Key
            setField(function, "I_NTM", "X");		//WorkTime52

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

    	Vector OBJPS_OUT1  = getTable(D40OverTimeFrameData.class, function, "T_SCHKZ");		//��ȹ�ٹ� �ڵ�-�ؽ�Ʈ
    	Vector OBJPS_OUT2  = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");	//��ȸ�� ����
    	Vector OBJPS_OUT3  = getTable(D40OverTimeFrameData.class, function, "T_REASON");	//���»��� �ڵ�-�ؽ�Ʈ
    	Vector OBJPS_OUT4  = getTable(D40OverTimeFrameData.class, function, "T_REASON_F");	//���»��� �ڵ�-�ؽ�Ʈ
    	Vector OBJPS_OUT5  = getTable(D40OverTimeFrameData.class, function, "T_EXCEP");	//���� ��Ÿ

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_INFO";     // �ȳ�����
    	String fieldName2 = "E_BEGDA";	//��ȸ������
    	String fieldName3 = "E_ENDDA";	//��ȸ������

    	String E_INFO  = getField(fieldName1, function);
    	String E_BEGDA  = getField(fieldName2, function);
    	String E_ENDDA  = getField(fieldName3, function);


    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_INFO);			//�ȳ�����
    	ret.addElement(E_BEGDA);			//��ȸ������
    	ret.addElement(E_ENDDA);			//��ȸ������
    	ret.addElement(OBJPS_OUT1);	//��ȹ�ٹ�
    	ret.addElement(OBJPS_OUT2);	//��ȸ�� ����
    	ret.addElement(OBJPS_OUT3);	//���»��� �ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT4);	//���»��� �ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT5);	//���»��� �ڵ�-�ؽ�Ʈ
        return ret;
    }

	/**
     * �ʰ��ٹ�(����) ���� ���ø�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmSchkzExcelDown(String empNo, String I_ACTTY, String I_SELTAB, Vector OBJID) throws GeneralException {

		JCO.Client mConnection = null;
        try{

        	mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            //setField(function, "I_YYYYMM", I_SELTAB);
            setField(function, "I_NTM", "X");		//WorkTime52

//            setTable(function, "T_IMPORTA", OBJID);
            if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }else if("A".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTA", OBJID);
            }

            excute(mConnection, function);
            Vector ret = getOutputExcel(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private Vector getOutputExcel(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        String entityName = "hris.D.D40TmGroup.D40TmSchkzFrameData";
        String tableName  = "T_SHEET1";
    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);
    	String tableName2  = "T_SHEET2";
    	Vector OBJPS_OUT2  = getTable(entityName, function, tableName2);

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(OBJPS_OUT);
    	ret.addElement(OBJPS_OUT2);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

        return ret;
    }

	/**
     * �ʰ��ٹ�(����) ���� ���ε� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveRow(String empNo, String I_ACTTY,	Vector<D40TmSchkzFrameData> excelResultList) throws GeneralException {
		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_NTM", "X");		//WorkTime52

            setTable(function, "T_IMLIST", excelResultList); // ����Row�� ȸ�ŵ�.

            excute(mConnection, function);
            Vector ret = new Vector();
            Vector T_EXLIST = getTable(D40TmSchkzFrameData.class, function, "T_EXLIST");
            String E_RETURN   = getReturn().MSGTY;
        	String E_MESSAGE   = getReturn().MSGTX;
        	String E_SAVE_CNT   = getField("E_SAVE_CNT", function) ;

        	ret.addElement(E_RETURN);
        	ret.addElement(E_MESSAGE);
        	ret.addElement(T_EXLIST);
        	ret.addElement(E_SAVE_CNT);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	/**
     * �ʰ��ٹ�(����) ȭ�� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveTable(String empNo, String I_ACTTY,	Vector<D40OverTimeFrameData> dataList,String I_BEGDA, String I_ENDDA) throws GeneralException {

		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_BEGDA", I_BEGDA);
            setField(function, "I_ENDDA", I_ENDDA);
            setField(function, "I_NTM", "X");		//WorkTime52

            setTable(function, "T_IMLIST", dataList); // ȭ�鿡�� ������ ����Ʈ
//            setTable(function, "T_TEMP", dataList2); // ��������Ʈ

            excute(mConnection, function);

            Vector ret = getOutput2( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private Vector getOutput2(JCO.Function function) throws GeneralException {

		Vector ret = new Vector();

    	Vector OBJPS_OUT1  = getTable(D40OverTimeFrameData.class, function, "T_SCHKZ");	//��ȹ�ٹ�
    	Vector OBJPS_OUT2  = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");	//��ȸ�� ����
    	Vector OBJPS_OUT3  = getTable(D40OverTimeFrameData.class, function, "T_REASON");	//���»���
    	Vector OBJPS_OUT4  = getTable(D40OverTimeFrameData.class, function, "T_REASON_F");	//���»���
    	Vector OBJPS_OUT5  = getTable(D40OverTimeFrameData.class, function, "T_EXCEP");	//���� ��Ÿ
    	Vector OBJPS_OUT6  = getTable(D40OverTime50OverWeekData.class, function, "T_50HOVER");	//�� 50�ð� �ʰ���

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName1 = "E_INFO";     // �ȳ�����
    	String fieldName2 = "E_BEGDA";	//��ȸ������
    	String fieldName3 = "E_ENDDA";	//��ȸ������
    	String fieldName4 = "E_SAVE_CNT";	//��ȸ������

    	String E_INFO  = getField(fieldName1, function);
    	String E_BEGDA  = getField(fieldName2, function);
    	String E_ENDDA  = getField(fieldName3, function);
    	String E_SAVE_CNT  = getField(fieldName4, function);

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(E_INFO);			//�ȳ�����
    	ret.addElement(E_BEGDA);			//��ȸ������
    	ret.addElement(E_ENDDA);			//��ȸ������
    	ret.addElement(E_SAVE_CNT);	//����� �Ǽ� ī��Ʈ �ȳ�����
    	ret.addElement(OBJPS_OUT1);	//��ȹ�ٹ�
    	ret.addElement(OBJPS_OUT2);	//��ȸ�� ����
    	ret.addElement(OBJPS_OUT3);	//���ϱٹ�
    	ret.addElement(OBJPS_OUT4);	//���ϱٹ�
    	ret.addElement(OBJPS_OUT5);	//��Ÿ
    	ret.addElement(OBJPS_OUT6);	//�� 50�ð� �ʰ���

        return ret;

    }

	/**
     * �ʰ��ٹ�(����) �� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getOverTimeEachOne(String empNo, String I_ACTTY,	Vector T_IMLIST) throws GeneralException {

		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_NTM", "X");		//WorkTime52

            setTable(function, "T_IMLIST", T_IMLIST); // ����Row�� ȸ�ŵ�.

            excute(mConnection, function);

            Vector ret = getOutput3( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	private Vector getOutput3(JCO.Function function) throws GeneralException {

		Vector ret = new Vector();

    	Vector OBJPS_OUT1  = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");	//��ȸ�� ����

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(OBJPS_OUT1);	//��ȸ�� ����

    	return ret;
	}

}


