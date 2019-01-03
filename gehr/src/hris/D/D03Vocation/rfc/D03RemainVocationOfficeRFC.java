package	hris.D.D03Vocation.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03RemainVocationData;

/**
 * D03RemainVocationOfficeRFC.java
 * [WorkTime52]�繫��-������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author ��ȯ��
 * @version 1.0, 2018/05/16
 */
public class D03RemainVocationOfficeRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_NTM_HOLIDAY_TYPE";

    /**
     * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public D03RemainVocationData getRemainVocation(String keycode, String reqdate, String mode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, reqdate, mode);

            excute(mConnection, function);

    		D03RemainVocationData remainVocationData = new D03RemainVocationData();
			remainVocationData = (D03RemainVocationData)getStructor(new D03RemainVocationData(), function, "S_WORK");

			getFields( remainVocationData, function );

            Logger.debug.println(this, remainVocationData.toString());

            return remainVocationData;
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String reqdate, String mode) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;//P_PERNR
        setField(function, fieldName1, keycode);

        String fieldName2 = "I_REQUEST_DATE"   ;//P_REQUEST_DATE
        setField(function, fieldName2, reqdate);

        String fieldName3 = "I_MODE"   ;
        setField(function, fieldName3, mode);
    }
}