package	hris.E.E15General.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;

import hris.E.E05House.E05HouseData;
import hris.E.E15General.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E15GeneralListRFC.java
 * ������ ��û�� ���հ�����û ������ �������� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class E15GeneralListRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRH_RFC_BANK_HOSP_AREA_LIST";
    private String functionName = "ZGHR_RFC_BANK_HOSP_AREA_LIST";

    /**
     * ������ ���հ��� ��û ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGeneralList(String empNo, String ainfseqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn, "1");

            excuteDetail(mConnection, function);

            Vector ret = getTable(E15GeneralData.class, function, "T_ENTR_RESULT");//getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getGeneralListAinf(String empNo, String ainfseqn, String rqpnr) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn, "1");
            setField(function, "I_RQPNR", rqpnr);
            excute(mConnection, function);

            Vector ret = getTable(E15GeneralData.class, function, "T_ENTR_RESULT");//getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���հ���  ��� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E15GeneralData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
            setTable(function, "T_ENTR_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���дɷ°�����û�� insert�ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build(String empNo, String ainfseqn, Vector General_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn,"2");

            setInput(function, General_vt, "T_ENTR_RESULT");


            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * ��û�� �����͸� �����ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String empNo, String ainfseqn, Vector General_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn ,"3");

            setInput(function, General_vt, "T_ENTR_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
     /**
     * ��û�� �����͸� �����ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void delete(String empNo, String ainfseqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, ainfseqn, "4");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ��û�� �����͸� �����ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ java.lang.String �۾�����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String ainfseqn, String jobcode) throws GeneralException {
        String fieldName1 = "I_ITPNR";
        setField(function, fieldName1, empNo);

        String fieldName2 = "I_AINF_SEQN" ;
        setField(function, fieldName2, ainfseqn)  ;

        String fieldName3 = "I_GTYPE";
        setField(function, fieldName3, jobcode);
    }

    private void setInput(JCO.Function function, String ainf_seqn, String conf_type ) throws GeneralException {
        String fieldName  = "I_AINF_SEQN"; // I_AINF_SEQN
        setField( function, fieldName, ainf_seqn );
        String fieldName2 = "I_GTYPE";//"I_CONF_TYPE";
        setField( function, fieldName2, conf_type );
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

}

