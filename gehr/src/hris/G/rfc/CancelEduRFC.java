/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 3. 31.
 *
 */
package hris.G.rfc;

import hris.G.ApprovalReturnState;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class CancelEduRFC extends SAPWrap
{
    private String functionName = "ZHRA_RFC_CANCEL_EDU";
    
    public Object cancelEdu(String AINF_SEQN)throws GeneralException 
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setField(function ,"I_AINF_SEQN",AINF_SEQN);
            excute(mConnection ,function);
            ApprovalReturnState oApprovalReturnState = new ApprovalReturnState();
            
            getFields(oApprovalReturnState ,function);
            
            return oApprovalReturnState;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch
    }
    

}
