package hris.E.E13CyGeneral.rfc;

import hris.E.E13CyGeneral.E13CyStmcCodeData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * E13SeltCodeRFC.java
 * ���� �̿����������ð˻� possible entry RFC �� ȣ���ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2013/02/25
 */
public class E13CySeltCodeRFC extends SAPWrap {

    //private static String functionName = "ZHRH_RFC_SELT_CODE_DF";
    private static String functionName = "ZGHR_RFC_SELT_CODE_DF";

    /**
     * �̿����������ð˻� possible entry RFC ȣ���ϴ� Method
     * @param empNo java.lang.String �����ȣ
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getSeltCode(String empNo, String hospCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,hospCode);
            excute(mConnection, function);
            Vector ret = getTable(E13CyStmcCodeData.class, function, "T_RESULT");//getOutput(function);

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
    private void setInput(JCO.Function function, String empNo, String hospCode) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_HOSP_CODE";
        setField(function, fieldName2, hospCode);
    }

}


