package hris.D.D03Vocation.rfc;
/**
 * 독일용 반차시간대
 */

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class D03HolidayTimeRFC extends SAPWrap {

//    private String functionName = "ZHR_PERSON_READ_WORK_SCHEDULE1";
    private String functionName = "ZGHR_PERSON_READ_WORK_SCHEDUL1";


    public Vector getHolidayTime(String P_PERNR, String AWART,String BEGDA,String ENDDA) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_PERNR, AWART, BEGDA, ENDDA);

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
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode,String AWART, String BEGDA, String ENDDA) throws GeneralException {
        String fieldName1 = "I_PERNR";
        String fieldName2 = "I_AWART";
        String fieldName3 = "I_BEGDA";
        String fieldName4 = "I_ENDDA";
        setField(function, fieldName1, keycode);
        setField(function, fieldName2, AWART);
        setField(function, fieldName3, BEGDA);
        setField(function, fieldName4, ENDDA);
    }

    /**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @param entityVector
	 *            java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */

	private Vector getOutput(JCO.Function function) throws GeneralException {
        String  E_BEGZT=   getField("E_BEGZT", function);
		String  E_ENDZT=   getField("E_ENDZT", function);
 		String  E_PABEG=   getField("E_PABEG", function);
 		String  E_PAEND=   getField("E_PAEND", function);
 		String  E_MESSAGE="";
 		if (functionName.equals("ZHR_PERSON_READ_WORK_SCHEDULE1"))
 			E_MESSAGE=   getField("E_MESSAGE", function);
 		else
 	    	E_MESSAGE=   getReturn().MSGTX;

	    Vector v1 = getTable(hris.D.D03Vocation.D03ScheduleData.class, function, (functionName.equals("ZHR_PERSON_READ_WORK_SCHEDULE1"))? "ITAB":"T_ITAB");

	    Logger.debug("v1++++++++++++++++++" + v1);
	    Logger.debug("E_MESSAGE++++++++++++++++++" + E_MESSAGE);

		Vector v = new Vector();
		v.addElement(E_BEGZT);
		v.addElement(E_ENDZT);
 		v.addElement(E_PABEG);
 		v.addElement(E_PAEND);
		v.addElement(v1);
		v.addElement(E_MESSAGE);

		return v;
	}
}