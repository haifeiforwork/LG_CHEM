package	hris.D.D20Flextime.rfc;

import hris.D.D20Flextime.D20FlextimeData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

/**
 * D20FlextimeRFC.java
 * Flextime RFC�� ȣ���ϴ� Class
 * 2017-08-01  eunha    [CSR ID:3438118] flexible time �ý��� ��û
 * 2018-05-10  ��ȯ��   [WorkTime52] �κ�/�������� �ٹ��� ����
 * @author eunha
 * @version 1.0, 2017/08/02
 */
public class D20FlextimeRFC extends ApprovalSAPWrap {

//    private String functionName = "ZGHR_RFC_FLEXTIME_REQUEST";
    private String functionName = "ZGHR_RFC_NTM_FLEXTIME_REQUEST";

    /**
     * ������Flextime ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<D20FlextimeData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(D20FlextimeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * Flextime �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<D20FlextimeData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * Flextime ���� RFC ȣ���ϴ� Method
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
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}