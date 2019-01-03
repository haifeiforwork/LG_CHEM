package hris.D.rfc.Global;

 
import java.util.Vector;

 
import hris.D.D03Vocation.D03RemainVocationData;
import hris.D.D03Vocation.D03VocationData;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D03RemainVocationRFC.java
 * 개인의 잔여휴가일수 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/21
 */
public class D18HolidayCheckRFC extends SAPWrap {

    private String functionName = "ZHRW_RFC_HOLIDAY_CHECK";
    
    /**
     * 개인의 잔여휴가일수 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRemainVocation(String P_PERNR, String AWART,String APPL_FROM,String APPL_TO,String BEGUZ,String ENDUZ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_PERNR, AWART,APPL_FROM,APPL_TO,BEGUZ,ENDUZ);
            
            excute(mConnection, function);
            Vector ret = getOutput(function);
            
          //  D03RemainVocationData ret = (D03RemainVocationData)getRemainOutput(function, (new D03RemainVocationData()));
            
          //  Logger.debug.println(this, ret.toString());
     
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
    private void setInput(JCO.Function function, String P_PERNR, String AWART,String APPL_FROM,String APPL_TO, String BEGUZ , String ENDUZ) throws GeneralException {
        String fieldName1 = "I_PERNR"          ;
        setField(function, fieldName1, P_PERNR);
        String fieldName2 = "I_AWART"          ;
        setField(function, fieldName2, AWART);
        String fieldName3 = "I_BEGDA"          ;
        setField(function, fieldName3, APPL_FROM);
        String fieldName4 = "I_ENDDA"          ;
        setField(function, fieldName4, APPL_TO);
        String fieldName5 = "I_BEGUZ"          ;
        setField(function, fieldName5, BEGUZ);
        String fieldName6 = "I_ENDUZ"          ;
        setField(function, fieldName6, ENDUZ);
 
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
		D03VocationData data = new D03VocationData();
		//Object obj = getStructor(data, function, "ITAB");
		String  E_ABRTG=   getField("E_ABRTG", function);
		String  E_MESSAGE=   getField("E_MESSAGE", function);
		String  I_STDAZ=   getField("I_STDAZ", function);
		String  I_ENDUZ=   getField("I_ENDUZ", function);
		Vector v = new Vector();
		v.addElement(E_ABRTG);
		v.addElement(E_MESSAGE);
		v.addElement(I_STDAZ);
		v.addElement(I_ENDUZ);
		return v;
	}
}