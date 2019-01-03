package hris.E.E38Cancer.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E38Cancer.*;

/**
 * E38CancerPossNumRFC.java
 * ���������� ����� ���డ���ο� �� �����ο����� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author Lsa
 * @version 1.0, 2013/06/21 C20130620_53407
 */
public class E38CancerPossNumRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_REQU_POSS_NUM_N";
    private String functionName = "ZGHR_RFC_REQU_POSS_NUM_N";

    /**
     * ���������� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInwonCnt(String empNo,String yyMm,String hospCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput( function, empNo, yyMm, hospCode);
            excute(mConnection, function);
            Vector ret = getTable(E38CancerPossNumData.class, function, "T_CARE");//getOutput(function);
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String empNo,String yyMm,String hospCode) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_YYMM";
        setField(function, fieldName2, yyMm);
        String fieldName3 = "I_HOSP_CODE";
        setField(function, fieldName3, hospCode);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.E.E38Cancer.E38CancerPossNumData";
        String tableName  = "T_CARE";
        return getTable(E38CancerPossNumData.class, function, "T_CARE");
    }
}

