package hris.E.E17Hospital.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.E.E17Hospital.E17ChildData;
import hris.common.PersonData;

import org.apache.commons.collections.map.HashedMap;

import java.util.Map;
import java.util.Vector;

/**
 * E17GuenCodeRFC.java
 * ����,����� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/09/16
 * update:		2018-04-20 cykim [CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� ��
 */
public class E17GuenCodeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_P_GUEN_CODE";

    /**
     * ����,����� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Map<String, Vector> getGuenCode(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", I_PERNR);

            excute(mConnection, function);


            Map<String, Vector> resultMap = new HashedMap();

            resultMap.put("T_RESULT", getCodeVector(function, "T_RESULT", "VALPOS", "DDTEXT"));
            resultMap.put("T_CHILD", getTable(E17ChildData.class, function, "T_CHILD"));
            //[CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� �� start. @��ȥ�����, �Ի����� �޾ƿ�
            resultMap.put("T_DATE", getTable(E17ChildData.class, function, "T_DATE"));
            //[CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� �� end

            return resultMap;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * �ڳ� ����Ʈ�� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getChildList(String empNo) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            Vector ret = getOutput2(function);

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
     * @param keycode java.lang.String �������� �Ϸù�ȣ
     * @param job java.lang.String �������
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName = "PERNR";
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
        String tableName = "P_RESULT";      // RFC Export ������� ����
        return getCodeVector( function,tableName, "VALPOS", "DDTEXT");
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E17Hospital.E17ChildData";
        String tableName  = "P_CHILD";
        return getTable(entityName, function, tableName);
    }
}

