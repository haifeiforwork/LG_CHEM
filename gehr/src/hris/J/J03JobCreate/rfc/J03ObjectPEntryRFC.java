package hris.J.J03JobCreate.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

/**
 * J03ObjectPEntryRFC.java
 * Function, Objective, ��з� P/E�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��   
 * @version 1.0, 2003/06/12
 */
public class J03ObjectPEntryRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_PENTRY_LIST";   

    /**
     *  Function, Objective, ��з� P/E�� �������� RFC�� ȣ���ϴ� Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getPEntry(String i_gubun, String i_objid, String i_pernr) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_gubun, i_objid, i_pernr);
            excute(mConnection, function);

            Vector ret = new Vector();
            
            if( i_gubun.equals("1") ) {
                ret = getOutput1(function);
            } else {
                ret = getOutput2(function);
            }

            return ret;
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
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_gubun, String i_objid, String i_pernr) throws GeneralException {
        String fieldName1 = "I_GUBUN";
        setField(function, fieldName1, i_gubun);
        String fieldName2 = "I_OBJID";
        setField(function, fieldName2, i_objid);
        String fieldName3 = "I_PERNR";
        setField(function, fieldName3, i_pernr);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.J.J03JobCreate.J03PEntryListData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String tableName  = "P_RESULT";      // RFC Export ������� ����
        String codeField  = "OBJID_D";
        String valueField = "STEXT_D";
        return getCodeVector( function, tableName, codeField, valueField );
    }
}


