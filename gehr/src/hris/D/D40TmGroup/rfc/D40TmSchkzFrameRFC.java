/********************************************************************************/
/*																											*/
/*   System Name	: MSS																		*/
/*   1Depth Name		: �μ�����																	*/
/*   2Depth Name		: ��ȹ�ٹ�����(�ϰ�)	                               						*/
/*   Program Name	: ��ȹ�ٹ�����(�ϰ�)  		                         						*/
/*   Program ID		: D40TmSchkzFrameRFC.java											*/
/*   Description		: ��ȹ�ٹ�����(�ϰ�)														*/
/*   Note				: ����																			*/
/*   Creation  			: 2017-12-08 ������														*/
/*   Update   			: 2017-12-08 ������														*/
/*																											*/
/********************************************************************************/

package hris.D.D40TmGroup.rfc;


import hris.D.D40TmGroup.D40TmSchkzFrameData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;


/**
 * D40TmSchkzFrameRFC.java
 * ��ȹ�ٹ�����(�ϰ�)  RFC
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40TmSchkzFrameRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_TM_SCHKZ";
    /**
     * ��ȹ�ٹ����� ��ȸ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector getTmSchkzFrame(String empNo, String I_ACTTY, String I_DATUM, String I_SCHKZ, Vector T_IMPERS, String I_SELTAB, Vector OBJID) throws GeneralException {
		JCO.Client mConnection = null;
        try{
        	mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField(function, "I_DEPT", empNo);
            setField(function, "I_ACTTY", I_ACTTY);
            setField(function, "I_DATUM", I_DATUM);
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
        String entityName = "hris.D.D40TmGroup.D40TmSchkzFrameData";
//        D40TmSchkzFrameData
        String tableName  = "T_SCHKZ";

    	Vector OBJPS_OUT  = getTable(entityName, function, tableName);

    	Vector OBJPS_OUT2  = getTable(D40TmSchkzFrameData.class, function, "T_EXLIST");

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName = "E_INFO";     // �ȳ�����
    	String E_INFO  = getField(fieldName, function) ;
    	String fieldName2 = "E_DATUM";     // ���ٹ����� ��ȸ������
    	String E_DATUM  = getField(fieldName2, function) ;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_INFO);
    	ret.addElement(OBJPS_OUT);
    	ret.addElement(E_DATUM);
    	ret.addElement(OBJPS_OUT2);
        return ret;
    }

	/**
     * ��ȹ�ٹ����� ���� ���ø�
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
     * ��ȹ�ٹ����� ���� ���ε� ����
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
     * ��ȹ�ٹ����� ȭ�� ����
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	public Vector saveTable(String empNo, String I_ACTTY,	Vector<D40TmSchkzFrameData> excelResultList) throws GeneralException {
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

    	Vector T_SCHKZ  = getTable(D40TmSchkzFrameData.class, function, "T_SCHKZ");
    	Vector T_EXLIST = getTable(D40TmSchkzFrameData.class, function, "T_EXLIST");

    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	String fieldName = "E_INFO";     // �ȳ�����
    	String E_INFO  = getField(fieldName, function) ;
    	String fieldName2 = "E_DATUM";     // �ȳ�����
    	String E_DATUM  = getField(fieldName2, function) ;
    	String E_SAVE_CNT  = getField("E_SAVE_CNT", function) ;

    	//    	ret.addElement(OBJPS_OUT);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_SCHKZ);
    	ret.addElement(T_EXLIST);
    	ret.addElement(E_DATUM);
    	ret.addElement(E_SAVE_CNT);
        return ret;
    }

}


