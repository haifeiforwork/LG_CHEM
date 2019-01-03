package hris.D.D01OT.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

import hris.D.D01OT.D01OTRealWorkDATA;	//사무직
import hris.D.D01OT.D01OTRealWorkDATA_H;	//현장직
import hris.common.approval.ApprovalSAPWrap;

/**
 * D01OTRealWrokListRFC.java
 * 초과근무 신청시 실근무시간 조회 RFC 를 호출하는 Class
 *
 * @author 강동민
 * @version 1.0, 2018/05/18
 */
public class D01OTRealWrokListRFC extends ApprovalSAPWrap {

    // private String functionName = "ZGHR_RFC_NTM_REALWORK_LIST";
    private String functionName = "ZGHR_RFC_NTM_OT_REQ_RW_LIST";

    /**
     * 실근무시간 조회 RFC 호출하는 Method
     *
     * @param I_EMPGUB
     * @param I_PERNR
     * @param I_DATUM
     * @param I_VTKEN
     * @param I_MODE
     * @return
     * @throws GeneralException
     */
    public D01OTRealWorkDATA getResult(String I_EMPGUB, String I_PERNR, String I_DATUM, String I_VTKEN, String I_AINF_SEQN, String I_MODE) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_EMPGUB", I_EMPGUB);
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_VTKEN", I_VTKEN);
            setField(function, "I_AINF_SEQN", I_AINF_SEQN);
            setField(function, "I_MODE", I_MODE);

            excute(mConnection, function, null);

            D01OTRealWorkDATA d01OTRealWorkDATA = new D01OTRealWorkDATA();
            // d01OTRealWorkDATA = (D01OTRealWorkDATA) getStructor(new D01OTRealWorkDATA(), function, "E_SDATA");ES_EMPGUB_S
            d01OTRealWorkDATA = (D01OTRealWorkDATA) getStructor(new D01OTRealWorkDATA(), function, "ES_EMPGUB_S");

            return d01OTRealWorkDATA;

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public D01OTRealWorkDATA_H getResult_H(String I_PERNR, String I_DATUM, String I_EMPGUB, String I_MODE) throws GeneralException {

        JCO.Client mConnection = null;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_DATUM", I_DATUM);
            setField(function, "I_EMPGUB", I_EMPGUB);
            setField(function, "I_MODE", I_MODE);

            excute(mConnection, function, null);

            D01OTRealWorkDATA_H d01OTRealWorkDATA = new D01OTRealWorkDATA_H();

            d01OTRealWorkDATA = (D01OTRealWorkDATA_H) getStructor(d01OTRealWorkDATA, function, "T_HDATA");

            String e_Begda = getField("E_BEGDA", function);
            String e_Endda = getField("E_ENDDA", function);
            d01OTRealWorkDATA.setPERNR(I_PERNR);
            d01OTRealWorkDATA.setE_BEGDA(e_Begda);
            d01OTRealWorkDATA.setE_ENDDA(e_Endda);

            return d01OTRealWorkDATA;

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}