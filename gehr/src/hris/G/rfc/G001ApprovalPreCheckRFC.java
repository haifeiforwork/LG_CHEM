/*
 * 작성된 날짜: 2012. 7. 2.
 * 결재전 미리 체크:
 */
package hris.G.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.G.ApprovalReturnState;

import java.util.Vector;

/**
 * @author lsa
 *
 */
public class G001ApprovalPreCheckRFC extends SAPWrap
{
    //private String functionName = "ZHRA_RFC_MAIN_PROCESS_PRECHECK";
    private String functionName = "ZGHR_RFC_MAIN_PROCESS_PRECHECK";
    private String approvalTableName = "T_ZHRA003T";
    private String returnTableName = "T_ZHR0900S";

    public Vector setApprovalStatutsList (Vector vcAppLineData)throws GeneralException
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setTable(function ,approvalTableName ,vcAppLineData ,"APPL_");
            excute(mConnection ,function);

            Vector ret = getTable("hris.G.ApprovalReturnState" ,function ,returnTableName);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch
    }

    public Vector setApprovalStatutsList (Vector vcAppLineData ,String szAppTableName ,Vector vcAppTableData)throws GeneralException
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);


            setTable(function ,approvalTableName    ,vcAppLineData ,"APPL_");

            setTable(function ,szAppTableName       ,vcAppTableData);

            excute(mConnection ,function);

            Vector ret = getTable("hris.G.ApprovalReturnState" ,function ,returnTableName);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch
    }

    public Vector setApprovalStatutsList (Vector vcAppLineData ,String szAppTableName ,Vector vcAppTableData ,String exAppTableName ,Vector exAppTableData)throws GeneralException
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);


            setTable(function ,approvalTableName    ,vcAppLineData ,"APPL_");

            //setTable(function ,szAppTableName       ,vcAppTableData);

            //setTable(function ,exAppTableName       ,exAppTableData);

            excute(mConnection ,function);

            Vector ret = getTable("hris.G.ApprovalReturnState" ,function ,returnTableName);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch
    }

    public Vector<ApprovalReturnState> setApprovalStatutsList (String AINF_SEQN)throws GeneralException
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            // set  parameter   결재 번호

            setField( function,  "I_AINF_SEQN", AINF_SEQN );
            excute(mConnection ,function);

            Vector ret = getTable("hris.G.ApprovalReturnState" ,function ,returnTableName);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch
    }

}
