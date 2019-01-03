package hris.E.E19Congra.rfc;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E19Congra.E19CongcondGlobalData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;



/**
 * E19CongraRequestRFC.java
 * ������ ��ȸ/��û/����/���� RFC �� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/20
 */
public class E19CongraRequestGlobalRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_CONGCOND_REQUEST";

    /**
     * ������ ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */



    public Vector<E19CongcondGlobalData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            excuteDetail(mConnection, function);

            return getTable(E19CongcondGlobalData.class, function, "T_CONG_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ������ ��û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */

    public String  build(String empNo, String I_celty,String famsa,String I_fama_code,String celtd,Vector<E19CongcondGlobalData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,I_celty,famsa,I_fama_code,celtd);
            setTable(function, "T_CONG_RESULT", T_RESULT);
            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * ������ ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
	public String change(String empNo,String I_type,String ainf_seqn,Vector tem) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,ainf_seqn,I_type);

            setInput(function, tem, "T_CONG_RESULT");
            excute(mConnection, function);

            return getField("E_MESSAGE", function);

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
     * @param keycode java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String seqn, String jobcode) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, keycode);

        String fieldName2 = "I_AINF_SEQN";
        setField(function, fieldName2, seqn);

        String fieldName3 = "I_GTYPE";
        setField(function, fieldName3, jobcode);
    }

// Import Parameter �� Vector(Table) �� ���
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @param tableName java.util.Vector
     * @param prev java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo,String I_celty,String famsa,String I_fama_code,String celtd ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);

        String fieldName3 = "I_CELTY";
        setField(function, fieldName3, I_celty);

        String fieldName4 = "I_FAMSA";
        setField(function, fieldName4, famsa);

        String fieldName5 = "I_FAMY_CODE";
        setField(function, fieldName5, I_fama_code);

        String fieldName6 = "I_CELDT";
        setField(function, fieldName6, celtd);
    }


}

