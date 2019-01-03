package hris.E.E21Expense.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.E.E21Expense.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E21ExpenseRFC.java
 * ���ڱ�/���б� ��û,��ȸ,���� RFC �� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/03
 */
public class E21ExpenseRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRW_RFC_SCHOOL_FEE_LIST";
    private String functionName = "ZGHR_RFC_SCHOOL_FEE_LIST";

    /**
     * ���ڱ�/���б� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String �������� �Ϸù�ȣ
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String P_AINF_SEQN, String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_AINF_SEQN, empNo, "1");
            excuteDetail(mConnection, function); //excute(mConnection, function);
            Vector ret = getTable(E21ExpenseData.class, function, "T_SCHOOL_RESULT");// getOutput(function);

//          2002.06.12. ��ȭŰ�� ���� �Ҽ��� ���� RFC�� �о� ó��������
//                      ���� R3�� KRW�� ������ ������ ��ȭŰ�� 2�ڸ��� �����Ͽ� �����ϹǷ�
//                      ESS������ �Ҽ��� ���� RFC�� ���� �ʵ��� �Ѵ�.
//          2002.06.12. KRW�� ������ ������ ��ȭŰ�� �о�� �״�� �����ش�. KRW�� 100�� ���Ѵ�.
            for( int i = 0 ; i < ret.size() ; i++ ) {
                E21ExpenseData data = (E21ExpenseData)ret.get(i);

//              ��û��
                if( data.WAERS.equals("KRW") ) {
                    if(data.PROP_AMNT.equals("")){ data.PROP_AMNT=""; }else{ data.PROP_AMNT=Double.toString(Double.parseDouble(data.PROP_AMNT) * 100.0 ) ; }
                }

//              ȸ�����޾�
                if( data.WAERS1.equals("KRW") ) {
                    if(data.PAID_AMNT.equals("")){ data.PAID_AMNT=""; }else{ data.PAID_AMNT=Double.toString(Double.parseDouble(data.PAID_AMNT) * 100.0 ) ; }
                }

//              ��������ݿ��� - �׻� KRW
                    if(data.YTAX_WONX.equals("")){ data.YTAX_WONX=""; }else{ data.YTAX_WONX=Double.toString(Double.parseDouble(data.YTAX_WONX) * 100.0 ) ; }
            }
//          2002.06.12. KRW�� ������ ������ ��ȭŰ�� �о�� �״�� �����ش�. KRW�� 100�� ���Ѵ�.
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���ڱ�/���б�  ��û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String �������� �Ϸù�ȣ
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String P_AINF_SEQN , String empNo, Object school_obj ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            E21ExpenseData school_data = (E21ExpenseData)school_obj;

//          2002.06.12. ��ȭŰ�� ���� �Ҽ��� ���� RFC�� �о� ó��������
//                      ���� R3�� KRW�� ������ ������ ��ȭŰ�� 2�ڸ��� �����Ͽ� �����ϹǷ�
//                      ESS������ �Ҽ��� ���� RFC�� ���� �ʵ��� �Ѵ�.
//          2002.06.12. KRW�� ������ ������ ��ȭŰ�� �״�� �������ش�. KRW�� 100�� ������.
            if( school_data.WAERS.equals("KRW") ) {
                school_data.PROP_AMNT = Double.toString(Double.parseDouble(school_data.PROP_AMNT) / 100 ) ;  // ��û��
            }
//          2002.06.12. KRW�� ������ ������ ��ȭŰ�� �о�� �״�� �����ش�. KRW�� 100�� ���Ѵ�.

            Vector schoolVector = new Vector();

            schoolVector.addElement(school_data);

            setInput(function, P_AINF_SEQN, empNo, "2");
            setInput(function, schoolVector, "T_SCHOOL_RESULT");
            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ���ڱ�/���б�  ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String �������� �Ϸù�ȣ
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String P_AINF_SEQN , String empNo, Object school_obj ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E21ExpenseData school_data = (E21ExpenseData)school_obj;

//          2002.06.12. ��ȭŰ�� ���� �Ҽ��� ���� RFC�� �о� ó��������
//                      ���� R3�� KRW�� ������ ������ ��ȭŰ�� 2�ڸ��� �����Ͽ� �����ϹǷ�
//                      ESS������ �Ҽ��� ���� RFC�� ���� �ʵ��� �Ѵ�.
//          2002.06.12. KRW�� ������ ������ ��ȭŰ�� �״�� �������ش�. KRW�� 100�� ������.
            if( school_data.WAERS.equals("KRW") ) {
                school_data.PROP_AMNT = Double.toString(Double.parseDouble(school_data.PROP_AMNT) / 100 ) ;  // ��û��
            }
//          2002.06.12. KRW�� ������ ������ ��ȭŰ�� �о�� �״�� �����ش�. KRW�� 100�� ���Ѵ�.

            Vector schoolVector = new Vector();

            schoolVector.addElement(school_data);

            setInput(function, P_AINF_SEQN, empNo, "3");
            setInput(function, schoolVector, "T_SCHOOL_RESULT");
            excute(mConnection, function);

         } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * ���ڱ�/���б�  ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param P_AINF_SEQN java.lang.String �������� �Ϸù�ȣ
     * @param empNo java.lang.String �����ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void delete(  String P_AINF_SEQN, String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, empNo, "4");
            excute(mConnection, function);

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
     * @param P_AINF_SEQN java.lang.String �������� �Ϸù�ȣ
     * @param empNo java.lang.String �����ȣ
     * @param job java.lang.String ���ʽſ��� ����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_AINF_SEQN, String empNo, String job) throws GeneralException {
        String fieldName = "I_AINF_SEQN";
        setField( function, fieldName, P_AINF_SEQN );
        String fieldName2 = "I_ITPNR";
        setField( function, fieldName2, empNo );
        //String fieldName3 = "P_CONT_TYPE";
        String fieldName3 = "I_GTYPE";
        setField( function, fieldName3, job );
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
     * ���ڱ�/���б�  ��� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E21ExpenseData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, empNo, I_INSUR, ainf_seqn, type, cdate, waers);

            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
            setTable(function, "T_SCHOOL_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ڱ�/���б�  ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
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


}


