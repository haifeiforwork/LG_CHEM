package hris.F.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import hris.F.F46OverTimeData;

/**
 * F46OverTimeRFC
 * �μ��ڵ忡 ���� ����ٷν��� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  ������
 * @version 1.0
 */
public class F46OverTimeRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_WORK_OVERTIME";
    private String functionName = "ZGHR_RFC_GET_WORK_OVERTIME";

    /**
     * �μ��ڵ忡 ���� ����ٷν��� ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getOverTime(F46OverTimeData data) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,data);
            excute(mConnection, function);
			ret = getOutput(function);
			Logger.debug.println(this, " ret = " + ret);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, F46OverTimeData data) throws GeneralException {
        String fieldName1  = "I_ORGEH";
        setField(function, fieldName1, data.I_ORGEH);
        String fieldName2 = "I_TODAY";
        setField(function, fieldName2, data.I_TODAY);
        String fieldName3  = "I_GUBUN";
        setField(function, fieldName3, data.I_GUBUN);
        String fieldName4 = "I_LOWERYN";
        setField(function, fieldName4, data.I_LOWERYN);
        String fieldName5  = "I_OVERYN";
        setField(function, fieldName5, data.I_OVERYN);
    }

    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	Vector retVt = new Vector();
    	String fieldName1 = "E_YYYYMON";      // ��ȸ���
    	String E_YYYYMON  = getField(fieldName1, function) ;
    	retVt.addElement(E_YYYYMON);
        String tableName  = "T_EXPORT";
        Vector tableT = new Vector();
        tableT = getTable(hris.F.F46OverTimeData.class, function, tableName);
        retVt.addElement(tableT);
        return retVt;
    }

}


