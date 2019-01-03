package hris.D.D12Rotation.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;

import hris.D.D12Rotation.D12RotationBuildCnData;
import hris.D.D12Rotation.D12RotationBuildCnExcelData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;


/**
 * D12RoataionBuildCnRFC.java
 * 초과근무등록 RFC 를 호출하는 Class
 *
 * @author
 * @version
 */
public class D12RoataionBuildCnRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_OT_REQUEST_NJ";

    /**
     * 초과근무등록 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception GeneralException
     */
    public Vector<D12RotationBuildCnData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(D12RotationBuildCnData.class, function, "T_RESULT");

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
    public String build(Vector<D12RotationBuildCnData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_YYYYMM", box.get("applyYear") + box.get("applyMonth"));
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



    public Vector<D12RotationBuildCnData> validateRow(String I_PERNR, String I_YYYYMM, Vector<D12RotationBuildCnExcelData> T_RESULT) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_GTYPE", "2");
            setField(function, "I_PERNR", I_PERNR);

            setTable(function, "T_RESULT", T_RESULT);

            excute(mConnection, function);

            return getTable(D12RotationBuildCnData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}


