/*
 * 작성된 날짜: 2005. 2. 4.
 *
 * Update	: 2018-05-24 성환희 [WorkTime52] I_NTM 필드 Import 분기처리
 */
package hris.G.rfc;

import java.util.Iterator;
import java.util.Map;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;

import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.G.ApprovalReturnState;
import hris.common.approval.ApprovalImport;

/**
 * @author 이승희
 *
 */
public class G001ApprovalProcessRFC extends SAPWrap
{
    private String functionName = "ZGHR_RFC_MAIN_PROCESS";
    private String approvalTableName = "T_APPRNR";
    private String returnTableName = "T_RESULT";

    private ApprovalImport approvalImport;

    public ApprovalImport getApprovalImport() {
        return approvalImport;
    }

    public void setApprovalImport(ApprovalImport approvalImport) {
        this.approvalImport = approvalImport;
    }

    public ApprovalReturnState setApproval (Vector vcAppLineData) throws GeneralException {
        return setApproval(vcAppLineData, null, null);
    }

    public ApprovalReturnState setApproval (Vector vcAppLineData , String szAppTableName , Vector vcAppTableData) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            String I_NTM = Utils.getFieldValue(vcAppTableData.get(0), "I_NTM", "");// "X" 의 경우 유연근무제 관련 체크 적용
            setField(function, "I_NTM", I_NTM);
            
            setTable(function, "T_APPRNR", vcAppLineData ,"APPL_");

            if(StringUtils.isNotBlank(szAppTableName))
                setTable(function, szAppTableName, vcAppTableData);

            if(approvalImport != null) {
                Iterator<Map.Entry<String, Vector>> iter = approvalImport.entrySet().iterator();
                while(iter.hasNext()) {
                    Map.Entry<String, Vector> importTable = iter.next();
                    setTable(function, importTable.getKey(), importTable.getValue());
                }
            }

            excute(mConnection ,function);

            Vector<ApprovalReturnState> resultList = getTable(ApprovalReturnState.class, function, "T_RESULT");

            return Utils.indexOf(resultList, 0);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } // end try & catch
    }

    public Vector setApprovalStatutsList (Vector vcAppLineData)throws GeneralException
    {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_NTM", "X");// 일괄 승인시 "X" 셋팅
            
            setTable(function, "T_APPRNR", vcAppLineData ,"APPL_");

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
            
            setTable(function ,szAppTableName       ,vcAppTableData);
            
            setTable(function ,exAppTableName       ,exAppTableData);
            
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
