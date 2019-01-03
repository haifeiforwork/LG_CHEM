package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * PersInfoWithNameRFC.java
 * ��� �̸����� ���������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 */
public class PersInfoWithNameRFC extends SAPWrap {

    //private static String functionName = "ZHRA_RFC_GET_ENAME_INFORMATION";
	private static String functionName = "ZGHR_RFC_GET_ENAME_TASK"; //[CSR ID:3525213] Flextime �ý��� ���� ��û

    /**
     * ��� �̸����� ���������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ����̸�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getApproval( String ename, String objid , String pernr ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, ename, objid, pernr);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.error(ex);
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
    private void setInput(JCO.Function function, String ename, String objid , String pernr) throws GeneralException {
        String fieldName  = "I_ENAME";
        setField(function, fieldName,  ename);
        String fieldName1 = "I_OBJID";
        setField(function, fieldName1, objid);
        String fieldName2 = "I_PERNR";
        setField(function, fieldName2, pernr);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        /*String entityName = "hris.common.PersInfoData";
        String tableName = "PER_INFO";
        return getTable(entityName, function, tableName);*/
        return getTable(PersonData.class, function, "T_RESULT","E_");
    }
}


