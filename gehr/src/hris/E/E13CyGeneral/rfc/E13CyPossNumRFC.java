package hris.E.E13CyGeneral.rfc;

import java.util.Vector;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E13CyGeneral.*;

/**
 * E13CyPossNumRFC.java
 * ���������� ����� ���డ���ο� �� �����ο����� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author Lsa
 * @version 1.0, 2008/01/30
 */
public class E13CyPossNumRFC extends SAPWrap {

    //private String functionName = "ZHRH_RFC_REQU_POSS_NUM_DF";
    private String functionName = "ZGHR_RFC_REQU_POSS_NUM_DF";

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
            Vector ret = getTable(E13CyPossNumData.class, function, "T_CARE");//getOutput(function);
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


}

