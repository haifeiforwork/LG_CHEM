/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 3. 7.
 *
 */
package hris.G.rfc;

import hris.G.ApprovalDocumentState;
import hris.G.MealChargeData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPWrap;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class MealChargeRFC extends SAPWrap
{
    private String functionName = "ZHRA_RFC_GET_MEALCHARGE_APP";
    //private String functionName = "ZGHR_RFC_GET_MEALCHARGE_APP";

    public Vector getMealChargeData(String AINF_SEQN) throws GeneralException
    {
        Vector vcRet;
        ApprovalDocumentState ads = new ApprovalDocumentState();
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField(function ,"I_AINF" ,AINF_SEQN);
            setField(function ,"I_CONF_TYPE" ,"1");
            excute(mConnection ,function);
            vcRet =  getTable(MealChargeData.class, function , "T_EXPORTA" );
            for (int i = 0; i < vcRet.size(); i++) {
                MealChargeData mlc = (MealChargeData) vcRet.get(i);
                mlc.TKCT_WONX = String.valueOf(Double.parseDouble(mlc.TKCT_WONX) * 100);
                mlc.CASH_WONX = String.valueOf(Double.parseDouble(mlc.CASH_WONX) * 100);
            } // end for
        } finally {
            close(mConnection);
        } // end try & catch
        return vcRet;
    }

}
