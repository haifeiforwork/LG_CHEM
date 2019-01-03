package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongFlowerInfoData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * E19CongraFlowerInfoRFC.java
 * �ֹ���ü������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2014/04/18
 */
public class E19CongraFlowerInfoRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_FLOWER_INFO";
	private String functionName = "ZGHR_RFC_GET_FLOWER_INFO";

    /**
     * �λ��������� �λ�׷��� Code�� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    public Vector getFlowerInfoCode(String CONG_CODE) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function,CONG_CODE);
            excute(mConnection, function);
            Vector ret = getTable(E19CongFlowerInfoData.class, function, "T_ITAB");
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
//////////////////////////////


    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode,String gubn) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_UPMU_TYPE";
        setField( function, fieldName1, gubn );
    }


    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    //[CSR ID:3051290] ��ȭȯ ���� ��û ���� �ý��� ����  2016.07.13 �����S
    private void setInput(JCO.Function function, String CONG_CODE) throws GeneralException {
        String fieldName = "I_CODE";
        setField( function, fieldName, CONG_CODE );

    }
/////////////////////

}


