package hris.D.D15EmpPayInfo.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.D.D15EmpPayInfo.D15EmpPayData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;


/**
 * D15EmpPayRFC.java
 * 지급/공제 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 정진만
 * @version 1.0, 2016/10/6
 */
public class D15EmpPayRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_PAYMEMT_REQUEST_NJ";

    /**
     * 재직증명서 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<D15EmpPayData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(D15EmpPayData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 재직증명서 신청 RFC 호출하는 Method
     * @exception GeneralException
     */
    public String build(Vector<D15EmpPayData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_YYYYMM", box.get("I_YYYYMM"));
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
     * 재직증명서 삭제 RFC 호출하는 Method
     * @exception GeneralException
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



    public Vector<D15EmpPayData> validateRow(String I_PERNR, String I_YYYYMM, Vector<D15EmpPayData> T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_RQPNR", I_PERNR);
            setField(function, "I_YYYYMM", I_YYYYMM);
            setField(function, "I_GTYPE", "7");

            setTable(function, "T_RESULT", T_RESULT);

            excute(mConnection, function);

            return getTable(D15EmpPayData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}


