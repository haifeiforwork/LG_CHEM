/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 1. 31.
 *
 */
package hris.G.G001Approval.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;

import java.util.Vector;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class G001ApprovalDocListRFC extends SAPWrap
{
    private String functionName = "ZGHR_RFC_WF_DOCU_LIST";
    
    public Vector<ApprovalDocList> getApprovalDocList(ApprovalListKey inputData)throws GeneralException
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setFields(function ,inputData);

            excute(mConnection ,function);

            return getTable(ApprovalDocList.class,function ,"T_EXPORTA");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
           // throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch

        return new Vector<ApprovalDocList>();
    }
    
        
}
