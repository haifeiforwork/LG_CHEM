package hris.J.J01JobMatrix.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.J.J01JobMatrix.*;

/**
 * J01FuncObjListRFC.java
 * Function, Objective P/E�� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class                        
 *
 * @author �赵��
 * @version 1.0, 2003/02/11
 */
public class J01FuncObjListRFC extends SAPWrap {

    private String functionName = "ZHRH_RFC_GET_FUNC_OBJ_LIST";

    public Vector getDetail(String i_pernr) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_pernr);
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_pernr ) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, i_pernr);
    }
    
    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.J.J01JobMatrix.J01JobMatrixData";
        String tableName  = "P_RESULT";
        return getTable(entityName, function, tableName);
    }

}

