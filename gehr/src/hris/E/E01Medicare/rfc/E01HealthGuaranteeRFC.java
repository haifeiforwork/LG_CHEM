package	hris.E.E01Medicare.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;

import hris.A.A17Licence.A17LicenceData;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.E.E01Medicare.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E01HealthGuaranteeRFC.java
 * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/29
 */
public class E01HealthGuaranteeRFC extends ApprovalSAPWrap {

   // private String functionName = "ZHRW_RFC_HEALTH_GUARANTEE";
	 private String functionName = "ZGHR_RFC_HEALTH_GUARANTEE";

    /**
     * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û�ϴ� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	    public Vector<E01HealthGuaranteeData> getDetail() throws GeneralException {

	        JCO.Client mConnection = null;

	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;

	            excuteDetail(mConnection, function);

	            return getTable(E01HealthGuaranteeData.class, function, "T_RESULT");

	        } catch(Exception ex){
	            Logger.error(ex);
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	    }



    /**
     * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E01HealthGuaranteeData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String empNo, String seqn, Vector healthVector) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, seqn, "3");

            setInput(function, healthVector, "T_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ǰ����� �Ǻξ��� �ڰ�(���/���) ��û ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo, String seqn, String gubun) throws GeneralException {

        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);

        String fieldName2 = "I_AINF_SEQN";
        setField(function, fieldName2, seqn);

        String fieldName3 = "I_CONF_TYPE";
        setField(function, fieldName3, gubun);

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

        return getTable(hris.E.E01Medicare.E01HealthGuaranteeData.class, function, "T_RESULT");
    }
}