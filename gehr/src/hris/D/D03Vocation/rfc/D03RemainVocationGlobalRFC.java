package	hris.D.D03Vocation.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D03Vocation.D03RemainVocationData;

/**
 * D03RemainVocationRFC.java
 * 개인의 잔여휴가일수 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/21
 */
public class D03RemainVocationGlobalRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_GET_REMAIN_HOLIDAY";//ZHRW_RFC_GET_REMAIN_HOLIDAY

    /**
     * 개인의 잔여휴가일수 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @return hris.D.D03Vocation.D03RemainVocationData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getRemainVocation(String P_PERNR, String reqdate, String I_AWART) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, P_PERNR, reqdate, I_AWART);
            excute(mConnection, function);
            D03RemainVocationData data = new D03RemainVocationData();
    		Object obj = getStructor(data, function, "S_ITAB");//ITAB
    		Vector ret = new Vector();
    		ret.addElement(obj);
        	
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
    private void setInput(JCO.Function function, String keycode, String reqdate, String I_AWART) throws GeneralException {
        
        setField(function, "I_PERNR", keycode);
        if (!reqdate.equals("")){
	        setField(function, "I_BEGDA" , reqdate);
        }
        setField(function,  "I_AWART"  , I_AWART);
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Object getRemainOutput(JCO.Function function, Object data) throws GeneralException {
        return getFields( data, function );
    }
	
}