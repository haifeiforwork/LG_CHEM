package	hris.D.D03Vocation.rfc;

import java.util.Vector;


import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D03RemainVocationRFC.java
 * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/01/21
 */
public class D03HolidayAbsenceRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_HOLIDAY_ABSENCE"; //ZHR_RFC_GET_HOLIDAY_ABSENCE

    /**
     * ������ �ܿ��ް��ϼ� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getHolidayAbsence(String P_PERNR,String AWART) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_PERNR,AWART);

            excute(mConnection, function);
            Vector ret = getOutput(function);
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
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode,String AWART) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, keycode);
        String fieldName2 = "I_AWART"          ;
        setField(function, fieldName2, AWART);
    }

    /**
	 * RFC �������� Import ���� setting �Ѵ�. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @param entityVector
	 *            java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */

	private Vector getOutput(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D03Vocation.D03HolidayAbsenceData";
        String tableName  = "T_ITAB";
        return getTable(entityName, function, tableName);
	}
}