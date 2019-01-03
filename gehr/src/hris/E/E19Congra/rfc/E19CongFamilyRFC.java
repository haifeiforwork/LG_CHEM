package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongFamilyData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * A04FamilyDetailRFC.java
 * ��������(��������) ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author ebksong
 * @version 1.0, 2006/06/14
 */
public class E19CongFamilyRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_P_CONGCOND_FAMILY";
	 private String functionName = "ZGHR_RFC_P_CONGCOND_FAMILY";

    /**
     * �������� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getCongFamily( String empNo , String cong , String rela) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo , cong, rela);
            excute(mConnection, function);
            Vector ret = getTable(E19CongFamilyData.class, function, "T_RESULT");

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value , String value2 , String value3 ) throws GeneralException {
        String fieldName = "I_PERNR";
        setField(function, fieldName, value);
        fieldName = "I_CONG_CODE";
        setField(function, fieldName, value2);
        fieldName = "I_RELA_CODE";
        setField(function, fieldName, value3);

    }


}