package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongGrupData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

/**
 * E19CongraGrubNumbRFC.java
 * �λ��������� �λ�׷���  Code�� �������� RFC�� ȣ���ϴ� Class
 *
 * @author lsa
 * @version 1.0, 2014/04/18
 */
public class E19CongraGrubNumbRFC extends SAPWrap {

   // private String functionName = "ZHRA_RFC_GET_GRUP_NUMB";
	private String functionName = "ZGHR_RFC_GET_GRUP_NUMB";

    /**
     * �λ��������� �λ�׷��� Code�� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getGrupCode(String companyCode,String gubn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode,gubn);
            excute(mConnection, function);
            Vector ret = getTable(E19CongGrupData.class, function, "T_ITAB");
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
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode,String gubn) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
        String fieldName1 = "I_UPMU_FLAG";
        setField( function, fieldName1, "B" );
        String fieldName2 = "I_UPMU_TYPE";
        setField( function, fieldName2, gubn );
    }



}


