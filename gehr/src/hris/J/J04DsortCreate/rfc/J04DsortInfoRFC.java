package hris.J.J04DsortCreate.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J01JobMatrix.*;

/**
 * J04DsortInfoRFC.java
 * ��з� �󼼳��� ���� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author  �赵��
 * @version 1.0, 2003/06/25
 */
public class J04DsortInfoRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_DSORT_INFO";

    public Vector getDetail( String i_objid, String i_begda ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_objid, i_begda);
            excute(mConnection, function);

            return getOutput(function);
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_objid, String i_begda) throws GeneralException {
        String fieldName1 = "I_OBJID";
        setField(function, fieldName1, i_objid);

        String fieldName2 = "I_BEGDA";
        setField(function, fieldName2, i_begda);        
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
//      Table ��� ��ȸ
        String entityName1 = "hris.J.J01JobMatrix.J01JobMatrixData";
        Vector P_RESULT    = getTable(entityName1, function, "P_RESULT");
        
        return P_RESULT;
    }
}

