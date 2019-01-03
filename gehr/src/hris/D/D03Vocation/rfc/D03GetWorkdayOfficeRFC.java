package	hris.D.D03Vocation.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03GetWorkdayData;

/**
 * D03GetWorkdayOfficeRFC.java
 * [WorkTime52]�繫��-������ �ް���û ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author ��ȯ��
 * @version 1.0, 2018/05/16
 */
public class D03GetWorkdayOfficeRFC extends SAPWrap {

	private String functionName = "ZGHR_NTM_GET_NO_OF_WORKDAY";
    
	/**
     * ������ �ް���û ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Object getWorkday(String pernr, String currDate, String mode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, pernr, currDate, "", mode);
            excute(mConnection, function);
            Object ret = getOutput(function, ( new D03GetWorkdayData() ));
            return ret;

        }catch(Exception ex){
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
    private void setInput(JCO.Function function, String pernr, String date, String flag, String mode) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, pernr);

        String fieldName2 = "I_DATE"          ;
        setField(function, fieldName2, date)  ;

        String fieldName3 = "I_FLAG"      ;
        setField(function, fieldName3, flag);
        
        String fieldName4 = "I_MODE"      ;
        setField(function, fieldName4, mode);
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	 private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        String structureName = "S_WORK";      // RFC
        return getStructor( data, function, structureName);
    }
}
