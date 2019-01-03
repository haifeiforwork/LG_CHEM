package hris.D.D12Rotation.rfc ;

import hris.A.A17Licence.A17LicenceData;
import hris.D.D12Rotation.D12RotationBuild2Data;
import hris.D.D12Rotation.D12RotationBuildData;
import hris.D.D12Rotation.D12ZHRA112TData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;

/**
 * D12RotationBuildRFC.java
 * �����μ����� ��ȸ,����,����,�ݷ� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2009/02/26
 */
public class D12RotationBuildRFC  extends ApprovalSAPWrap {

    //private String functionName = "ZHRW_RFC_DAY_CHART" ;
    //private String functionName2 = "ZHRW_RFC_DAY_OFF" ;

    private String functionName = "ZGHR_RFC_DAY_CHART" ;
    private String functionName2 = "ZGHR_RFC_DAY_OFF" ;

    public String  build(D12ZHRA112TData T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName2 ) ;

            Logger.debug.println("==========setInput ������==========");
            setInput( function, T_RESULT );

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���� ���� �Է� - �۾� Data�� ��ȸ�ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetailForOrgeh( String i_month, String orgeh ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForOrgeh(function, i_month, orgeh);
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

    /**
     * ���� ���� �Է� - �۾� Data�� ��ȸ�ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetailForPernr( String i_month, String i_pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInputForPernr(function, i_month, i_pernr);
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

    /**
     * ���� ���� �Է� - �۾� Data�� ��ȸ�ϴ� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getDetail( String AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, AINF_SEQN );
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


    public void getDetailApproval(String AINF_SEQN) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName2 ) ;

            setInput( function, AINF_SEQN );
            excuteDetail(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �����û ����
     * @param AINF_SEQN
     * @return
     * @throws GeneralException
     */

    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName2) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * ���� ����
     * @param AINF_SEQN
     * @return
     * @throws GeneralException
     */
    public Vector accept( String AINF_SEQN ) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName2 ) ;

            setField( function, "AINF_SEQN", AINF_SEQN );
            setField( function, "I_GTYP", "8" );
            excute( mConnection, function );

            Vector ret = getOutput2( function );

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���� �ݷ�
     * @param AINF_SEQN
     * @return
     * @throws GeneralException
     */
    public Vector reject( String AINF_SEQN) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName2 ) ;

            setField( function, "AINF_SEQN", AINF_SEQN );
            setField( function, "I_GTYP", "9" );

            excute( mConnection, function );

            Vector ret = getOutput2( function );

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
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInputForOrgeh(JCO.Function function, String i_month, String orgeh) throws GeneralException {
        setField( function, "I_MONTH", i_month );
        setField( function, "I_ORGEH", orgeh );
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInputForPernr(JCO.Function function, String i_month, String i_pernr) throws GeneralException {
    	setField( function, "I_MONTH", i_month );
        setField( function, "I_PERNR", i_pernr );
    }

    /**
     * I_COMMAND, I_AINF_SEQN(�������) �� ���ڷ� �޴´�(���������� ����,����,�ݷ� ���μ����� ���)
     * @param function
     * @param AINF_SEQN
     * @param I_COMMAND
     * @throws GeneralException
     */
    private void setInput(JCO.Function function, String AINF_SEQN, String I_COMMAND) throws GeneralException {
        setField( function, "I_COMMAND", I_COMMAND );
        setField( function, "I_AINF_SEQN", AINF_SEQN );
    }

    /**
     * I_COMMAND, I_AINF_SEQN(�������) �� ���ڷ� �޴´�(���������� ����,����,�ݷ� ���μ����� ���)
     * @param function
     * @param AINF_SEQN
     * @param I_COMMAND
     * @throws GeneralException
     */
    private void setInput(JCO.Function function, String AINF_SEQN, String I_BIGO, String I_COMMAND) throws GeneralException {
    	setField( function, "I_AINF_SEQN", AINF_SEQN );
    	setField(function, "I_BIGO", I_BIGO);
    	setField( function, "I_COMMAND", I_COMMAND );

    }


    /**
     * �����ȣ�� ���������� �������� RFC�� ���
     * @param function
     * @param AINF_SEQN
     * @throws GeneralException
     */
    private void setInput(JCO.Function function, String AINF_SEQN) throws GeneralException {
        setField( function, "I_AINF_SEQN", AINF_SEQN );
    }

    /**
     * Import Parameter �� Vector(Table) �� ���
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }


    private void setInput(JCO.Function function, D12ZHRA112TData d12ZHRA112TData) throws GeneralException{

    	setField(function, "I_FROMDA", (String)Utils.getFieldValue(d12ZHRA112TData, "FROMDA"));
    	setField(function, "I_TODA", (String)Utils.getFieldValue(d12ZHRA112TData, "TODA"));
    	setField(function, "I_ORGEH", (String)Utils.getFieldValue(d12ZHRA112TData, "ORGEH") );
    	setTable(function, "T_ZHRA112T", Utils.asVector(d12ZHRA112TData));

    }
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
//      ��� �Է� ���� ���� ����Ʈ ��ȸ
    	Vector ret = new Vector();

        Vector P_PERNR  = getTable(D12RotationBuildData.class, function, "T_PERNR");
        Vector P_RESULT  = getTable(D12RotationBuildData.class, function, "T_RESULT");
        Vector P_STAT  = getTable(D12RotationBuild2Data.class, function, "T_STAT");


    	/*String E_RETURN   = getField("E_RETURN", function) ;
    	String E_MESSAGE  = getField("E_MESSAGE", function) ;*/
    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;
    	String E_FROMDA   = getField("E_FROMDA", function) ;
    	String E_TODA  = getField("E_TODA", function) ;
    	String E_ORGEH   = getField("E_ORGEH", function) ;
    	String E_STEXT  = getField("E_STEXT", function) ;
    	String E_BIGO  = getField("E_BIGO", function) ;

    	ret.addElement(P_PERNR);
    	ret.addElement(P_RESULT);
    	ret.addElement(P_STAT);
    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(E_FROMDA);
    	ret.addElement(E_TODA);
    	ret.addElement(E_ORGEH);
    	ret.addElement(E_STEXT);
    	ret.addElement(E_BIGO);

        return ret;
    }

    /**
     * �������� ����,����,�ݷ��� �����
     * @param function
     * @return
     * @throws GeneralException
     */
    private Vector getOutput2(JCO.Function function) throws GeneralException {

    	Vector ret = new Vector();

    	/*String E_RETURN   = getField("E_RETURN", function) ;
    	String E_MESSAGE  = getField("E_MESSAGE", function) ;*/
    	String E_RETURN   = getReturn().MSGTY;
    	String E_MESSAGE   = getReturn().MSGTX;

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);

        return ret;
    }
}