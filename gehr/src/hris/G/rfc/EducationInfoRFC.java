/*
 * 작성된 날짜: 2005. 3. 26.
 *
 */
package hris.G.rfc;

import hris.C.C02Curri.C02CurriInfoData;
import hris.G.ApprovalDocumentState;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPWrap;

/**
 * @author 이승희
 * 작성된 날짜: 2005. 3. 26.
 */
public class EducationInfoRFC extends SAPWrap
{
    private String functionName = "ZHRA_RFC_GET_EDUCA_LIST";
    
    public Object getEducationInfo(String I_OBJID ,String I_SOBID) throws GeneralException
    {
        Object  oRet; 
        ApprovalDocumentState ads = new ApprovalDocumentState();
        JCO.Client mConnection = null;
        String E_RETURN;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField(function ,"I_OBJID" ,I_OBJID);
            setField(function ,"I_SOBID" ,I_SOBID);
            excute(mConnection ,function);
            E_RETURN = getField("E_RETURN" ,function);
            if (E_RETURN.equals("S")) {
                oRet = getTable("hris.C.C02Curri.C02CurriInfoData" ,function, "T_EXPORTA").get(0);
                C02CurriInfoData  c02CurriInfoData = (C02CurriInfoData)oRet;
                c02CurriInfoData.IKOST  = String.valueOf(Double.parseDouble(c02CurriInfoData.IKOST) * 100);
            } else {
                throw new GeneralException(getField("E_MESSAGE" ,function));
            } // end if
        } finally {
            close(mConnection);
        } // end try & catch
        return oRet;
    }
}
