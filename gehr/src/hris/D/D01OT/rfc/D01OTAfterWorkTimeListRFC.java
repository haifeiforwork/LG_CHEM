package hris.D.D01OT.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

import hris.D.D01OT.D01OTAfterWorkTimeDATA;
import hris.common.approval.ApprovalSAPWrap;

/**
 * D01OTAfterWorkTimeListRFC.java
 * 초과근무 사후신청시 실근무시간 조회 RFC 를 호출하는 Class
 *
 * @author 강동민
 * @version 1.0, 2018/06/11
 */
public class D01OTAfterWorkTimeListRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_NTM_AFTOT_RWINFO";

    /**
     * 실근무시간 호출하는 Method
     * 
     * @param I_GTYPE
     * @param I_PERNR
     * @param I_RQDAT
     * @param I_VTKEN
     * @param I_AINF_SEQN
     * @param I_DATUM
     * @param I_SPRSL
     * @return
     * @throws GeneralException
     */
    public D01OTAfterWorkTimeDATA getResult(String I_GTYPE, String I_PERNR, String I_RQDAT, String I_VTKEN, String I_AINF_SEQN, String I_DATUM, String I_SPRSL) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_GTYPE", I_GTYPE);
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_RQDAT", I_RQDAT);
            setField(function, "I_VTKEN", I_VTKEN);
            setField(function, "I_AINF_SEQN", I_AINF_SEQN);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_SPRSL", I_SPRSL);

            excute(mConnection, function, null);

            return getStructor(new D01OTAfterWorkTimeDATA(), function, "S_EXPORTA");

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}