/*
 * 작성된 날짜: 2005. 2. 15.
 *
 */
package hris.G.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.G.ApprovalDocumentState;
import hris.G.DocInfoEntityData;
import hris.common.AppLineData;

import java.util.Vector;

/**
 * @author 이승희
 *
 */
public class ApprovalDocumentStateRFC extends SAPWrap
{
    private String functionName = "ZHRA_RFC_GET_DOCU_STATUS";
    
    public Vector getDocumetState(String AINF_SEQN) throws GeneralException
    {
        Vector vcRet = new Vector(); 
        ApprovalDocumentState ads = new ApprovalDocumentState();
        JCO.Client mConnection = null;
        String E_RETURN;
        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);
            setField(function, "I_AINF", AINF_SEQN);
            excute(mConnection, function);
            getStructor(ads, function, "E_ZHR0021S");
            E_RETURN = getField("E_RETURN", function);

            if (E_RETURN.equals("S")) {
                vcRet.add(ads); //  0
                // 결재자  정보 리스트
                vcRet.add(getTable(AppLineData.class, function, "T_EXPORTA", "APPL_")); //1
                // 현재 결재자 리스트
                vcRet.add(getTable(DocInfoEntityData.class, function, "T_EXPORTB"));        //2
                // 이전 결재자 리스트
                vcRet.add(getTable(DocInfoEntityData.class, function, "T_EXPORTC"));        //3
                // 업무 담당자 리스트
                vcRet.add(getTable(DocInfoEntityData.class, function, "T_EXPORTD"));        //4
            } else {
                Logger.err.println(this, AINF_SEQN + getField("E_MESSAGE", function));

                throw new GeneralException(getField("E_MESSAGE", function));
            } // end if
        } catch (Exception e) {
            Logger.error(e);
        } finally {
            close(mConnection);
        } // end try & catch
        return vcRet;
    }

}
