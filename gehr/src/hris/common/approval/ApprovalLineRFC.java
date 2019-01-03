package hris.common.approval;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;

import java.util.Vector;

/**
 * Created by manyjung on 2016-08-24.
 */
public class ApprovalLineRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_FIND_DECISIONER";

    public ApprovalLineRFC() {
    }

    public ApprovalLineRFC(SAPType sapType) {
        super(sapType);
    }

    public Vector<ApprovalLineData> getApprovalLine(String I_UPMU_TYPE, String I_PERNR) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_UPMU_TYPE", I_UPMU_TYPE);
            setField(function, "I_PERNR", I_PERNR);
            /*I_LOAN_CODE : 국내 특화(대출신청시??) */

            excute(mConnection, function);

            return getTable(ApprovalLineData.class, function, "T_APPRLINE");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector<ApprovalLineData> getApprovalLine(ApprovalLineInput inputData) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setFields(function, inputData);

            excute(mConnection, function);

            return getTable(ApprovalLineData.class, function, "T_APPRLINE");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}
