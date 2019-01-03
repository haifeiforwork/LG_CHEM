package	hris.E.E25Infojoin.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E25Infojoin.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E25InfoSettRFC.java
 * ��û�� �����ֿ� ���� ���縦 ��û�ϴ� rfc�� ȣ���ϴ� class
 *
 * @author ������
 * @version 1.0, 2002/01/04
 */
public class E25InfoSettRFC extends ApprovalSAPWrap {

    //private String functionName = "ZHRH_RFC_INFORMAL_SETT ";
	private String functionName = "ZGHR_RFC_INFORMAL_SETT ";

    /**
     * ��û�� �����ֿ� ���� ���� ��û ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����ڵ� java.lang.String �����Ϸù�ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
  /*  public Vector getInfoSett(String empNo, String p_ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "1");

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
*/
    public Vector<E25InfoSettData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(E25InfoSettData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    public String build(Vector<E25InfoSettData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * ��û�� �����ֿ� ���� ���� ��û�� insert�ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����ڵ� java.lang.String �����Ϸù�ȣ java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
  /*  public void build(String empNo, String p_ainf_seqn, Vector InfoSett_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, p_ainf_seqn, "2");

            setInput(function, InfoSett_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

*/



     /**
     * ��û�� �����͸� �����ϴ� Method
     * @param java.lang.String �����ȣ java.lang.String �����Ϸù�ȣ
     * @exception com.sns.jdf.GeneralException
     */
  /*
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
*/

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
     * @param value java.lang.String ��� java.lang.String �����Ϸù�ȣ  java.lang.String �۾�����
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String p_ainf_seqn, String jobcode) throws GeneralException {
        String fieldName1 = "P_AINF_SEQN"          ;
        setField(function, fieldName1, p_ainf_seqn)  ;

        String fieldName2 = "P_CONT_TYPE"      ;
        setField(function, fieldName2, jobcode);

        String fieldName3 = "P_PERNR"          ;
        setField(function, fieldName3, empNo);



    }

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
        String entityName = "hris.E.E25Infojoin.E25InfoSettData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}

