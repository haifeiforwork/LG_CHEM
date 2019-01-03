/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ڱ� �űԽ�û                                           */
/*   Program Name : �����ڱ� �űԽ�û                                           */
/*   Program ID   : E05HouseRFC                                                 */
/*   Description  : ������ �����ڱ� ��û, ��ȸ, ����, ������ �� �� �ִ� Class   */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_FUND_NEW_APP                      */
/*   Creation     : 2005-03-04  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E05House.rfc;

import hris.E.E05House.E05HouseData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;

public class E05HouseRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRA_RFC_GET_FUND_NEW_APP";
    private String functionName = "ZGHR_RFC_GET_FUND_NEW_APP";

    /**
     * ������ �����ڱ� ��û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "1");
            excuteDetail(mConnection, function); //excute(mConnection, function);
            Vector ret = getTable(E05HouseData.class, function, "T_RESULT"); //getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * ������ �����ڱ�  ��� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E05HouseData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, ainf_seqn, "2");

            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
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
     * �����ڱ� �űԽ�û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void build( String ainf_seqn, Vector house_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setInput(function, ainf_seqn, "2");

            //setInput(function, house_vt, "T_EXPORTA");
            setInput(function, house_vt, "T_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �����ڱ� �űԽ�û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void change(  String ainf_seqn, Vector house_vt ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "3");
            //setInput(function, house_vt, "T_EXPORTA");
            setInput(function, house_vt, "T_RESULT");

            excute(mConnection, function);

         } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �����ڱ� �űԽ�û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
    public void delete( String ainf_seqn ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ainf_seqn, "4");

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
     * @param ainf_seqn java.lang.String �������� �Ϸù�ȣ
     * @param conf_type java.lang.String ���ʽſ��� ����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String ainf_seqn, String conf_type ) throws GeneralException {
        String fieldName  = "I_AINF_SEQN"; // I_AINF_SEQN
        setField( function, fieldName, ainf_seqn );
        String fieldName2 = "I_GTYPE";//"I_CONF_TYPE";
        setField( function, fieldName2, conf_type );
    }

    // Import Parameter �� Vector(Table) �� ���
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
     * �����ڱ�  ���� RFC ȣ���ϴ� Method
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
