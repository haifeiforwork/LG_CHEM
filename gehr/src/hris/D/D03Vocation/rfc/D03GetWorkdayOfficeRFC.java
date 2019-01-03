package	hris.D.D03Vocation.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03GetWorkdayData;

/**
 * D03GetWorkdayOfficeRFC.java
 * [WorkTime52]사무직-개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 성환희
 * @version 1.0, 2018/05/16
 */
public class D03GetWorkdayOfficeRFC extends SAPWrap {

	private String functionName = "ZGHR_NTM_GET_NO_OF_WORKDAY";
    
	/**
     * 개인의 휴가신청 정보를 가져오는 RFC를 호출하는 Method
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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
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
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
	 private Object getOutput(JCO.Function function, Object data) throws GeneralException {
        String structureName = "S_WORK";      // RFC
        return getStructor( data, function, structureName);
    }
}
