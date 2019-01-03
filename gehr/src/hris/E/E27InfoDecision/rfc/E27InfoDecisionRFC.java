package	hris.E.E27InfoDecision.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.E.E27InfoDecision.*;

/**
 * E27InfoDecisionRFC.java
 * �������� List �� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��   
 * @version 1.0, 2001/12/13
 */
public class E27InfoDecisionRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_INFORMAL_APPROVAL";

    /**
     * �������� List �� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.Object hris.E.E27InfoDecision.E27InfoDecisionKey Object.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInfoDecision( Object key ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, key);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            return ret;
        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public void build(Object key, Vector InfoDecision_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, key);

            setInput(function, InfoDecision_vt, "P_RESULT");
            
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

  
    public void infobuild(Object key, Vector InfoDecision_vt) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, key);
            
            setInput(function, InfoDecision_vt, "P_RESULT");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
   
    public void delete(Object key) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
                        
            setInput(function, key);

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param entity java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Object key) throws GeneralException{
        setFields(function, key);
    }

    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E27InfoDecision.E27InfoDecisionData";
        String tableName = "P_RESULT";
        return getTable(entityName, function, tableName);
    }
}
