package hris.J.J03JobCreate.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.common.*;

import hris.J.J01JobMatrix.*;

/**
 * J03OrgehPersListRFC.java
 * ������ �ش��ϴ� ��� List�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��   
 * @version 1.0, 2003/06/13
 */
public class J03OrgehPersListRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_ORGEH_PERS_LIST";   

    /**
     *  ���� List�� �������� RFC�� ȣ���ϴ� Method
     *  @return java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getDetail(String i_pernr, String i_objid) throws GeneralException {
        
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr, i_objid);
            excute(mConnection, function);
            Vector ret = getOutput(function);

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
    private void setInput(JCO.Function function, String i_pernr, String i_objid) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
        String fieldName2 = "I_OBJID";
        setField(function, fieldName2, i_objid);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.J.J01JobMatrix.J01PersonsData";
        String tableName  = "PER_INFO";
        return getTable(entityName, function, tableName);
    }
}

