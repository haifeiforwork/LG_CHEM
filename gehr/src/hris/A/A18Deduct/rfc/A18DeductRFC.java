package hris.A.A18Deduct.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.A.A18Deduct.A18DeductData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;


/**
 * A18DeductRFC.java
 * �ٷμҵ� ��õ¡�� ������, ���ټ� ��õ¡�� ������ ��û/����/���� RFC �� ȣ���ϴ� Class                        
 *
 * @author  �赵��
 * @version 1.0, 2002/10/22
 */
public class A18DeductRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_DEDUCT_TAXES_DOC_REQ";

    /**
     * �������� ��ȸ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A18DeductData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(A18DeductData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �������� ��û RFC ȣ���ϴ� Method
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<A18DeductData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * �������� ���� RFC ȣ���ϴ� Method
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
     * �������� ���ι��� �Ϸ��� Flag ���� RFC ȣ���ϴ� Method
     * @exception com.sns.jdf.GeneralException
     */
    public void updateFlag( String I_PERNR, String I_AINF_SEQN  ) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_AINF_SEQN", I_AINF_SEQN);
            setField(function, "I_GTYPE", "5");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


