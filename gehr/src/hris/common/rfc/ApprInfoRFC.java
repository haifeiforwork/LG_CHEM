package hris.common.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.common.AppLineData;

import java.util.Vector;

/**
 * ApprInfoRFC.java
 * ���������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��   
 * @version 1.0, 2001/12/13
 */
public class ApprInfoRFC extends SAPWrap {

    private static String functionName = "ZHRA_RFC_GET_APPROVAL_INFO";

    public ApprInfoRFC() {
    }

    public ApprInfoRFC(SAPType sapType) {
        super(sapType);
    }

    /**
     * ���������� �������� RFC�� ȣ���ϴ� Method
     * @param ainfseqn ���� ������ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getApproval( String ainfseqn ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, ainfseqn);
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
            return ret;
        } catch(Exception ex) {
            Logger.error(ex);
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getApprovalA( String ainfseqn ) throws GeneralException {
        
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            
            setInput(function, ainfseqn);
            excute(mConnection, function);
            Vector ret = getOutput1(function);
            
            return ret;
        } catch(Exception ex) {
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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value) throws GeneralException {
        if(getSapType().isLocal())
            setField(function, "I_AINF", value);
        else setField(function, "I_AINF_SEQN", value);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        
        return getTable(hris.common.AppLineData.class, function, "APPLINE", "APPL_");//
    }

    private Vector getOutput1(JCO.Function function) throws GeneralException {
        Vector T_APPLINE = getTable(AppLineData.class, function, "APPLINE", "APPL_");//
        String E_PERNR  = getField("E_PERNR",  function);  // ��û�ڻ��

        Vector ret = new Vector();

        ret.add(T_APPLINE);
        ret.addElement(E_PERNR);
        return ret; 
    }

}

