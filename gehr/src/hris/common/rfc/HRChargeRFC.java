package hris.common.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

import hris.common.*;

/**
 * HRChargeRFC.java
 * ����庰 �λ����� ����ó ��ȸ
 *
 * @author �赵��
 * @version 1.0, 2002/09/24
 */
public class HRChargeRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_HR_CHARGE_1";
    private String functionName = "ZGHR_RFC_GET_HR_CHARGE";


    /**
     * ��� �̸����� ���������� �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String ����̸�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
//    public Vector getCharge( String i_pernr ) throws GeneralException {
    public Vector getCharge( String i_bukrs, String i_grup_numb, String i_upmu_code ) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

//            setInput(function, i_pernr);
            setInput(function, i_bukrs, i_grup_numb, i_upmu_code);
            excute(mConnection, function);
            Vector ret = getTable(HRChargeData.class, function, "P_RESULT");//getOutput(function);

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
     * @exception com.sns.jdf.GeneralException
     */
//    private void setInput(JCO.Function function, String i_pernr) throws GeneralException {
//        String fieldName  = "I_PERNR";
//        setField(function, fieldName, i_pernr);
//    }

    private void setInput(JCO.Function function, String i_bukrs, String i_grup_numb, String i_upmu_code) throws GeneralException {
        String fieldName  = "I_BUKRS";
        setField(function, fieldName, i_bukrs);

        String fieldName1 = "I_GRUP_NUMB";
        setField(function, fieldName1, i_grup_numb);

        String fieldName2 = "I_UPMU_CODE";
        setField(function, fieldName2, i_upmu_code);
    }


}
