/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: �ʰ��ٹ�                                                         						*/
/*   Program Name	: �ʰ��ٹ�(�ϰ�)                                  							*/
/*   Program ID		: D40OverTimeLumpFrameRFC.java									*/
/*   Description		: �ʰ��ٹ�(�ϰ�)															*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40OverTimeFrameData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmGroupPersRFC.java
 * ����������-�ʰ��ٹ�(�ϰ�) ��ȸ/����/Excel
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40OverTimeLumpFrameRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_OVERTIME";
    /**
     * �ʰ��ٹ�(�ϰ� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getOverTimeLump(String empNo, String I_ACTTY, String I_SCHKZ, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
//            setField(function, "I_DATUM", I_DATUM);
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
        String entityName = "hris.D.D40TmGroup.D40OverTimeFrameData";

        String E_RETURN   = getReturn().MSGTY;
        String E_MESSAGE   = getReturn().MSGTX;

        String E_BEGDA 		= getField("E_BEGDA", function) ;	//��ȸ������
        String E_ENDDA 		= getField("E_ENDDA", function) ;	//��ȸ������
        String E_SAVE_CNT 	= getField("E_SAVE_CNT", function) ;	//����� �Ǽ� ī��Ʈ �ȳ�����
        String E_INFO  		= getField("E_INFO", function) ;		// �ȳ�����


        Vector OBJPS_OUT1  = getTable(entityName, function, "T_EXLIST");		//��ȸ������
        Vector OBJPS_OUT2	 = getTable(entityName, function, "T_SCHKZ");		//��ȹ�ٹ�	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT3	 = getTable(entityName, function, "T_REASON");	//���»���	�ڵ�-�ؽ�Ʈ
        Vector OBJPS_OUT4	 = getTable(entityName, function, "T_REASON_F");	//���»���	�ڵ�-�ؽ�Ʈ
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
    	ret.addElement(OBJPS_OUT5);	//���»���	�ڵ�-�ؽ�Ʈ

        return ret;
    }


	private Vector getOutputExcel(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();
        String entityName = "hris.D.D40TmGroup.D40OverTimeFrameData";
        String tableName  = "T_SHEET1";
    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);
    	String tableName2  = "T_REASON";
    	Vector OBJPS_OUT2  = getTable(entityName, function, tableName2);
    	String tableName3  = "T_YN_DATA";
    	Vector OBJPS_OUT3  = getTable(entityName, function, tableName3);

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(OBJPS_OUT);
    	ret.addElement(OBJPS_OUT2);
    	ret.addElement(OBJPS_OUT3);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

        return ret;
    }

	/**
     * �ʰ��ٹ�(�ϰ�) ���� �ϰ� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveRow(String empNo, String I_ACTTY,	Vector<D40OverTimeFrameData> excelResultList) throws GeneralException {
		JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);

            setTable(function, "T_IMLIST", excelResultList); // ����Row�� ȸ�ŵ�.

            excute(mConnection, function);

            Vector ret = new Vector();

            Vector T_EXLIST = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");

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
     * �ʰ��ٹ�(�ϰ�) ȭ�� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveTable(String empNo, String I_ACTTY,	Vector<D40OverTimeFrameData> excelResultList) throws GeneralException {
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

    	Vector T_REASON  = getTable(D40OverTimeFrameData.class, function, "T_REASON");
    	Vector T_EXLIST = getTable(D40OverTimeFrameData.class, function, "T_EXLIST");
    	Vector OBJPS_OUT5  = getTable(D40OverTimeFrameData.class, function, "T_EXCEP");	//���� ��Ÿ

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String E_INFO  = getField("E_INFO", function) ;
    	String E_SAVE_CNT  = getField("E_SAVE_CNT", function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_SAVE_CNT);
    	ret.addElement(T_REASON);
    	ret.addElement(T_EXLIST);
    	ret.addElement(OBJPS_OUT5);
        return ret;
    }

	/**
     * �ʰ��ٹ�(�ϰ�) ���� ���ø� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getOverTimeLumpExcelDown(String empNo, String I_ACTTY,	String I_SELTAB, Vector OBJID) throws GeneralException {
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

}


