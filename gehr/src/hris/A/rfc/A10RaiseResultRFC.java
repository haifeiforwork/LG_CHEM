package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.A.*;

/**
 * A10RaiseResultRFC.java
 * ���������� �������� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2016/01/27
 * @[CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û
 */
public class A10RaiseResultRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_CORE_TALENTED_PERSON2";

    /**
     * ���������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String empNo
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRaise( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
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
     * @param empNo java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empNo );
    }


    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.A.A10RaiseResultData";
        String tableName  = "T_ZHRS041T";
        return getTable(entityName, function, tableName);
    }
}


