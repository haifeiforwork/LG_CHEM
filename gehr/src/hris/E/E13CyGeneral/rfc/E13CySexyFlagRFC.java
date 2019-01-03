package	hris.E.E13CyGeneral.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;

import hris.E.E15General.E15GeneralData;

/**
 * E15SexyFlagRFC.java
 * ����, ����ڿ� ���� �̿� ��������� ���� �����͸� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2013/02/26
 */
public class E13CySexyFlagRFC extends SAPWrap {

    //private static String functionName = "ZHRW_RFC_GET_HOSP_SEXY_FLAG_DF";
    private static String functionName = "ZGHR_RFC_GET_HOSP_SEXY_FLAG_DF";

    /**
     * �����ڱ� ��û�� ���� �����͸� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �����ȣ , java.lang.String ������󿬵�
     * @return hris.E.E15General.E15GeneralData
     * @exception com.sns.jdf.GeneralException
     */
    public E15GeneralData getSexyFlag(String empNo, String p_exam_year) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo, p_exam_year);
            excute(mConnection, function);
            E15GeneralData ret = (E15GeneralData)getOutput(function,  new E15GeneralData()  );
            return ret;

        }catch(Exception ex){
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
     * @param @param java.lang.String �����ȣ , java.lang.String ������󿬵�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function,String empNo, String p_exam_year ) throws GeneralException {
        String fieldName = "I_PERNR"          ;
        setField(function, fieldName, empNo);

        String fieldName1= "I_EXAM_YEAR" ;
        setField(function, fieldName1, p_exam_year);
    }

    /**
     * RFC ������ Export ���� Object �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param data java.lang.Object
     * @return java.lang.Object
     * @exception com.sns.jdf.GeneralException
     */
    private Object getOutput(JCO.Function function, E15GeneralData data) throws GeneralException {
          return getFields( data, function );
    }
}

