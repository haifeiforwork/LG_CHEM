package hris.E.E02Medicare.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E02Medicare.*;
import hris.common.approval.ApprovalSAPWrap;


/**
 * E02MedicareRFC.java
 * �ǰ������� ����/��߱� ��ȸ/��û/����/���� RFC �� ȣ���ϴ� Class
 *
 * @author �ڿ���
 * @version 1.0, 2002/01/28
 */
public class E02MedicareRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRW_RFC_HEALTH_INSURANCE";
	private String functionName = "ZGHR_RFC_HEALTH_INSURANCE";

    /**
     * �ǰ������� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail( String P_AINF_SEQN , String P_PERNR ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "1");
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector<E02MedicareData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(E02MedicareData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ǰ������� ��û RFC ȣ���ϴ� Method
  	 * @param java.lang.String �������� �Ϸù�ȣ
     * @param java.lang.String �����ȣ
	 * @param java.util.Vector �ǰ���������û Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String P_AINF_SEQN, String P_PERNR, Vector createVector ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "2", createVector);
            excute(mConnection, function);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String build(Vector<E02MedicareData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setTable(function, "T_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ǰ������� ���� RFC ȣ���ϴ� Method
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param java.lang.String �����ȣ
     * @param java.util.Vector �ǰ������� Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change( String P_AINF_SEQN, String P_PERNR, Vector createVector  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "3", createVector);
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ǰ������� ���� RFC ȣ���ϴ� Method
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String P_AINF_SEQN, String P_PERNR  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "4");
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

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
	 * @param java.lang.String �����ȣ
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2, String job) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, key1 );
        String fieldName1 = "P_PERNR";
        setField( function, fieldName1, key1 );
        String fieldName2 = "P_CONF_TYPE";
        setField( function, fieldName2, job );

    }


    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param java.lang.String �������� �Ϸù�ȣ
     * @param java.lang.String �����ȣ
     * @param job java.lang.String �������
     * @param job java.util.Vector entityVector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_AINF_SEQN, String P_PERNR, String job, Vector entityVector) throws GeneralException {
        String fieldName = "P_AINF_SEQN";
        setField( function, fieldName, P_AINF_SEQN );
        String fieldName2 = "P_PERNR";
        setField( function, fieldName2, P_PERNR );
        String fieldName3 = "P_CONF_TYPE";
        setField( function, fieldName3, job );
        String tableName = "P_RESULT";
        setTable(function, tableName, entityVector);
    }



    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E02Medicare.E02MedicareData";
        Vector  ret = getTable(entityName, function, "P_RESULT");
        return ret ;
    }
}


