package	hris.E.E26InfoState.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;

import hris.E.E25Infojoin.E25InfoJoinData;
import hris.E.E26InfoState.*;
import hris.common.approval.ApprovalSAPWrap;


/**
 * E26InfosecessionRFC.java
 * ������ ��û�� �����ֿ� ���� Ż�� ��û�� �� ���ִ� RFC�� �������� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class E26InfosecessionRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRH_RFC_INFORMAL_SECEDE ";
	private String functionName = "ZGHR_RFC_INFORMAL_SECEDE ";

    /**
     * Ż�� ��û ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInfosecession(String empNo, String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "1");

            excute(mConnection, function);

            Vector ret = getOutput(function);

            for ( int i = 0 ; i < ret.size() ; i++ ){
                E26InfoStateData data = (E26InfoStateData)ret.get(i);
                data.BETRG = Double.toString(Double.parseDouble(data.BETRG) * 100.0 );
            }
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector<E26InfoStateData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);
            Vector<E26InfoStateData> vE26InfoStateData = getTable(E26InfoStateData.class, function, "T_RESULT");

            for ( int i = 0 ; i < vE26InfoStateData.size() ; i++ ){
                E26InfoStateData data = (E26InfoStateData)vE26InfoStateData.get(i);
                data.BETRG =DataUtil.changeLocalAmount(data.BETRG, "KRW") ;
            }
            return vE26InfoStateData;

        } catch(Exception ex){
            Logger.error(ex);
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

    public String build(Vector<E26InfoStateData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            for ( int i = 0 ; i < T_RESULT.size() ; i++ ){
                E26InfoStateData data = (E26InfoStateData)T_RESULT.get(i);
                data.BETRG =DataUtil.changeGlobalAmount(data.BETRG,  "KRW")  ;
            }

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
     * Ż�� ��û insert�ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ  java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public void build(String empNo, String p_ainf_seqn, Vector Infosecession_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "2");

            for ( int i = 0 ; i < Infosecession_vt.size() ; i++ ){
                E26InfoStateData data = (E26InfoStateData)Infosecession_vt.get(i);
                data.BETRG = Double.toString(Double.parseDouble(data.BETRG) / 100.0 );
            }

            setInput(function, Infosecession_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
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
    public void delete(String empNo, String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "4");

            excute(mConnection, function);

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
     * @param value java.lang.String ��� java.lang.String �����Ϸù�ȣ java.lang.String �۾�����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String p_ainf_seqn, String jobcode) throws GeneralException {
        String fieldName1 = "P_CONT_TYPE"      ;
        setField(function, fieldName1, jobcode);

        String fieldName2 = "P_AINF_SEQN"          ;
        setField(function, fieldName2, p_ainf_seqn)  ;

        String fieldName3 = "P_PERNR"          ;
        setField(function, fieldName3, empNo);

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
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E26InfoState.E26InfoStateData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}
