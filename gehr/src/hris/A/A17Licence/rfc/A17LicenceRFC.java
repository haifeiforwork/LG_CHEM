package	hris.A.A17Licence.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.A.A17Licence.A17LicenceData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;

/**
 * A17LicenceBuildRFC.java
 * ������ �ڰ��� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �ֿ�ȣ
 * @version 1.0, 2002/01/11
 */
public class A17LicenceRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_LICN_REQ";

    /**
     * ������ �ڰ��� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A17LicenceData> getLicence() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(A17LicenceData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �ڰݸ��� �Է� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */ 
    public String build(Vector<A17LicenceData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setTable(function, "T_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * �ڰݸ��� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException

    public String change(Vector<A17LicenceData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            A17LicenceData data = (A17LicenceData)licence;

            Vector licenceVector = new Vector();
            licenceVector.addElement(data);

            setInput(function, seqn, "3");

            setInput(function, licenceVector, "TAB");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }*/
    
    /**
     * �ڰݸ��� ���� RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    

}