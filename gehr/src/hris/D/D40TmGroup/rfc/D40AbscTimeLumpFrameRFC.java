/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ��ٹ�/�ٹ�                                                           					*/
/*   Program Name	: ��ٹ�/�ٹ�(�ϰ�)                                   						*/
/*   Program ID		: D40AbscTimeLumpFrameRFC.java									*/
/*   Description		: ��ٹ�/�ٹ�(�ϰ�)														*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/


package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40AbscTimeFrameData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40AbscTimeLumpFrameRFC.java
 * ����������-�ٹ�/��ٹ�
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40AbscTimeLumpFrameRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_AWART";
    /**
     * ��ٹ�,�ٹ�(�ϰ�) ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getAbscTimeLump(String empNo, String I_ACTTY, String I_SCHKZ, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_SCHKZ", I_SCHKZ);

            setTable(function, "T_IMPERS", T_IMPERS);

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
        String entityName = "hris.D.D40TmGroup.D40AbscTimeFrameData";

        String E_RETURN   = getReturn().MSGTY;
        String E_MESSAGE   = getReturn().MSGTX;

        String E_BEGDA 		= getField("E_BEGDA", function) ;	//��ȸ������
        String E_ENDDA 		= getField("E_ENDDA", function) ;	//��ȸ������
        String E_SAVE_CNT 	= getField("E_SAVE_CNT", function) ;	//����� �Ǽ� ī��Ʈ �ȳ�����
        String E_INFO  		= getField("E_INFO", function) ;		// �ȳ�����


        Vector OBJPS_OUT1  = getTable(entityName, function, "T_EXLIST");		//��ȸ������
        Vector OBJPS_OUT2	 = getTable(entityName, function, "T_SCHKZ");		//��ȹ�ٹ�	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT3	 = getTable(entityName, function, "T_WTMCODE");//����	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT4	 = getTable(entityName, function, "T_REASON");	//���»���	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT5  = getTable(entityName, function, "T_EXCEP");	//���� ��Ÿ

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_BEGDA);			//��ȸ������
    	ret.addElement(E_ENDDA);			//��ȸ������
    	ret.addElement(E_SAVE_CNT);	//����� �Ǽ� ī��Ʈ �ȳ�����
    	ret.addElement(E_INFO);			// �ȳ�����
    	ret.addElement(OBJPS_OUT1);	//��ȸ������
    	ret.addElement(OBJPS_OUT2);	//��ȹ�ٹ�	�ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT3);	//���»���	�ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT4);	//���»���	�ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT5);	//��Ÿ

        return ret;
    }

	/**
     * ��ٹ�,�ٹ�(�ϰ�) ���� ���ø� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getAbscTimeLumpExcelDown(String empNo, String I_ACTTY,	String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{

        	mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            //setField(function, "I_YYYYMM", I_SELTAB);

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
        String entityName = "hris.D.D40TmGroup.D40AbscTimeFrameData";
        String tableName  = "T_SHEET1";
    	Vector OBJPS_OUT1  = getTable(entityName, function, tableName);
    	String tableName2  = "T_WTMCODE";
    	Vector OBJPS_OUT2  = getTable(entityName, function, tableName2);
    	String tableName3  = "T_REASON";
    	Vector OBJPS_OUT3  = getTable(entityName, function, tableName3);
    	String tableName4  = "T_YN_DATA";
    	Vector OBJPS_OUT4  = getTable(entityName, function, tableName4);

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(OBJPS_OUT1);
    	ret.addElement(OBJPS_OUT2);
    	ret.addElement(OBJPS_OUT3);
    	ret.addElement(OBJPS_OUT4);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

        return ret;
    }

	/**
     * ��ٹ�,�ٹ�(�ϰ�) ���� ���ε� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveRow(String empNo, String I_ACTTY,	Vector<D40AbscTimeFrameData> excelResultList) throws GeneralException {
		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);

            setTable(function, "T_IMLIST", excelResultList); // ����Row�� ȸ�ŵ�.

            excute(mConnection, function);

            Vector ret = new Vector();

            Vector T_EXLIST = getTable(D40AbscTimeFrameData.class, function, "T_EXLIST");

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
     * ��ٹ�,�ٹ�(�ϰ�) ���� ���ε� �� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveTable(String empNo, String I_ACTTY,	Vector<D40AbscTimeFrameData> excelResultList) throws GeneralException {
		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);

            setTable(function, "T_IMLIST", excelResultList); // ����Row�� ȸ�ŵ�.

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

    	Vector OBJPS_OUT1  = getTable(D40AbscTimeFrameData.class, function, "T_EXLIST");		//��ȸ������
//        Vector OBJPS_OUT2	 = getTable(D40AbscTimeFrameData.class, function, "T_SCHKZ");		//��ȹ�ٹ�	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT3	 = getTable(D40AbscTimeFrameData.class, function, "T_WTMCODE");	//����	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT4	 = getTable(D40AbscTimeFrameData.class, function, "T_REASON");		//���»���	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT5  = getTable(D40AbscTimeFrameData.class, function, "T_EXCEP");	//���� ��Ÿ

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String E_INFO  = getField("E_INFO", function) ;
    	String E_SAVE_CNT  = getField("E_SAVE_CNT", function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_SAVE_CNT);
    	ret.addElement(OBJPS_OUT1);	//��ȸ������
    	ret.addElement(OBJPS_OUT3);	//����	�ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT4);	//���»���	�ڵ�-�ؽ�Ʈ
    	ret.addElement(OBJPS_OUT5);	//��Ÿ
        return ret;
    }

	/**
     * ��ٹ�,�ٹ�(����) �� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getOverTimeOne(String empNo, String I_ACTTY,	Vector T_IMLIST) throws GeneralException {

		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);

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

    	Vector OBJPS_OUT1  = getTable(D40AbscTimeFrameData.class, function, "T_EXLIST");	//��ȸ�� ����

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);		//return message code
    	ret.addElement(E_MESSAGE);		//return message
    	ret.addElement(OBJPS_OUT1);	//��ȸ�� ����
    	ret.addElement(E_RETURN);	//RETURN

    	return ret;
	}



}


