/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 2. 15.
 *
 */
package hris.G.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.common.approval.ApprovalHeader;
import org.apache.commons.lang.StringUtils;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class ApprovalHeaderRFC extends SAPWrap
{
    private String functionName = "ZGHR_RFC_WF_HEADER";

    public ApprovalHeaderRFC() {
    }

    public ApprovalHeaderRFC(SAPType sapType) {
        super(sapType);
    }

    public ApprovalHeader getApprovalHeader(String I_AINF_SEQN, String I_PERNR) throws GeneralException {
        JCO.Client mConnection = null;

        try {
            mConnection = getClient();

            JCO.Function function = createFunction(functionName);

            setField(function, "I_AINF_SEQN", I_AINF_SEQN);
            if (StringUtils.isNotBlank(I_PERNR))
                setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            return getStructor(new ApprovalHeader(), function, "S_EXPORTA");
        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
            close(mConnection);
        } // end try & catch
    }

    public ApprovalHeader getApprovalHeader(String I_AINF_SEQN, String I_PERNR, String I_APGUB) throws GeneralException {
        JCO.Client mConnection = null;

        try {
            mConnection = getClient();

            JCO.Function function = createFunction(functionName);

            setField(function, "I_AINF_SEQN", I_AINF_SEQN);
            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_APGUB", I_APGUB);

            excute(mConnection, function);

            return getStructor(new ApprovalHeader(), function, "S_EXPORTA");
        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {
            close(mConnection);
        } // end try & catch
    }

}
