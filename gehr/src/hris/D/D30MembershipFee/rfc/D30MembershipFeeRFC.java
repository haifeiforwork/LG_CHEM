package hris.D.D30MembershipFee.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;


/**
 * D30MembershipFeeRFC.java
 * 회비 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 정진만
 * @version 1.0, 2016/10/6
 */
public class D30MembershipFeeRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_MEMBER_FEE_REQUEST_NJ";

    /**
     * 회비 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<D30MembershipFeeData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(D30MembershipFeeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 회비 신청 RFC 호출하는 Method
     * @exception GeneralException
     */
    public String build(Vector<D30MembershipFeeData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * 회비 삭제 RFC 호출하는 Method
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



    public Vector<D30MembershipFeeData> validateRow(String I_PERNR, String I_YYYYMM, Vector<D30MembershipFeeData> T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_RQPNR", I_PERNR);
            setField(function, "I_YYYYMM", I_YYYYMM);
            setField(function, "I_GTYPE", "7");

            setTable(function, "T_RESULT", T_RESULT);

            excute(mConnection, function);

            return getTable(D30MembershipFeeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}


