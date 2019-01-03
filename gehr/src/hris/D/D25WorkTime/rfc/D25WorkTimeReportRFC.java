package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D25WorkTime.D25WorkTimeHeaderData;

/**
 * D25WorkTimeReportRFC.java
 * 실 근로시간 레포트를 조회하는 RFC
 * 2018-05-24  성환희    [WorkTime52] 실 근로시간 레포트
 * @author 성환희
 * @version 1.0, 2018/05/24
 */
public class D25WorkTimeReportRFC extends SAPWrap {
	
	private String functionName = "";
	
	private final String S_WORKTIME_WEEK_REPORT = "ZGHR_RFC_NTM_RW_REP_S_WEEK";
	private final String H_WORKTIME_WEEK_REPORT = "ZGHR_RFC_NTM_RW_REP_H_WEEK2";
	private final String S_WORKTIME_MONTH_REPORT = "ZGHR_RFC_NTM_RW_REP_S_MONTH";
	private final String H_WORKTIME_MONTH_REPORT = "ZGHR_RFC_NTM_RW_REP_H_MONTH2";
	
	public Vector getSWeekReport(String pernr, String datum) throws GeneralException {

		String functionName = S_WORKTIME_WEEK_REPORT;
		
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_PERNR", pernr);
            setField(function, "I_DATUM", datum);

            excute(mConnection, function);
            
            Vector ret = getOutputSWeek(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	public Vector getHWeekReport(String pernr, String datum) throws GeneralException {
		
		String functionName = H_WORKTIME_WEEK_REPORT;
		
		JCO.Client mConnection = null;
		try{
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			
			setField(function, "I_PERNR", pernr);
			setField(function, "I_DATUM", datum);
			
			excute(mConnection, function);
			
			Vector ret = getOutputHWeek(function);
			
			return ret;
		} catch(Exception ex){
			Logger.sap.println(this, "SAPException : "+ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
	
	public Vector getSMonthReport(String pernr, String yyyymm) throws GeneralException {

		String functionName = S_WORKTIME_MONTH_REPORT;
		
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", pernr);
            setField(function, "I_YYYYMM", yyyymm);

            excute(mConnection, function);
            
            Vector ret = getOutputSMonth(function);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	public Vector getHMonthReport(String pernr, String datum) throws GeneralException {
		
		String functionName = H_WORKTIME_MONTH_REPORT;
		
		JCO.Client mConnection = null;
		try{
			mConnection = getClient();
			JCO.Function function = createFunction(functionName) ;
			
			setField(function, "I_PERNR", pernr);
			setField(function, "I_DATUM", datum);
			
			excute(mConnection, function);
			
			Vector ret = getOutputHMonth(function);
			
			return ret;
		} catch(Exception ex){
			Logger.sap.println(this, "SAPException : "+ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
	
	/**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputSWeek(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	// Field 결과 조회
    	String E_NAME = getField("E_NAME", function);

    	// Table 결과 조회
    	Vector T_BODY = getTable(hris.D.D25WorkTime.D25WorkTimeBodyData.class,  function, "T_BODY");
    	Vector T_NWKTYP = getTable(hris.D.D25WorkTime.D25WorkTimeNwktypData.class,  function, "T_NWKTYP");
    	Vector T_AWART = getTable(hris.D.D25WorkTime.D25WorkTimeAwartData.class,  function, "T_AWART");
    	Vector T_HEADER = getTable(hris.D.D25WorkTime.D25WorkTimeHeaderData.class,  function, "T_HEADER");

    	ret.addElement(E_NAME);
    	ret.addElement(T_BODY);
    	ret.addElement(T_NWKTYP);
    	ret.addElement(T_AWART);
    	ret.addElement(T_HEADER);
    	
    	return ret;
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputHWeek(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	// Field 결과 조회
    	String E_NAME = getField("E_NAME", function);
    	String E_WTCATTX = getField("E_WTCATTX", function);
    	String E_BEGDA = getField("E_BEGDA", function);
    	String E_ENDDA = getField("E_ENDDA", function);
    	String E_WKAVR = getField("E_WKAVR", function);
    	
    	// Table 결과 조회
    	Vector T_BODY = getTable(hris.D.D25WorkTime.D25WorkTimeBodyData.class,  function, "T_BODY");
    	Vector T_NWKTYP = getTable(hris.D.D25WorkTime.D25WorkTimeNwktypData.class,  function, "T_NWKTYP");
    	Vector T_HEADER = getTable(hris.D.D25WorkTime.D25WorkTimeHeaderData.class,  function, "T_HEADER");
    	
    	ret.addElement(E_NAME);
    	ret.addElement(E_WTCATTX);
    	ret.addElement(E_BEGDA);
    	ret.addElement(E_ENDDA);
    	ret.addElement(E_WKAVR);
    	ret.addElement(T_BODY);
    	ret.addElement(T_NWKTYP);
    	ret.addElement(T_HEADER);
    	
    	return ret;
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputSMonth(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	// Field 결과 조회
    	String E_NAME = getField("E_NAME", function);
    	String E_BEGDA = getField("E_BEGDA", function);
    	String E_ENDDA = getField("E_ENDDA", function);
    	
    	// Structure 결과 조회
    	D25WorkTimeHeaderData ES_HEADER = getStructor(new D25WorkTimeHeaderData(), function, "ES_HEADER");
    	
    	// Table 결과 조회
    	Vector T_BODY = getTable(hris.D.D25WorkTime.D25WorkTimeBodyData.class,  function, "T_BODY");
    	Vector T_NWKTYP = getTable(hris.D.D25WorkTime.D25WorkTimeNwktypData.class,  function, "T_NWKTYP");
    	Vector T_AWART = getTable(hris.D.D25WorkTime.D25WorkTimeAwartData.class,  function, "T_AWART");
    	Vector T_HEADER = getTable(hris.D.D25WorkTime.D25WorkTimeHeaderData.class,  function, "T_HEADER");
    	
    	ret.addElement(E_NAME);
    	ret.addElement(E_BEGDA);
    	ret.addElement(E_ENDDA);
    	ret.addElement(ES_HEADER);
    	ret.addElement(T_BODY);
    	ret.addElement(T_NWKTYP);
    	ret.addElement(T_AWART);
    	ret.addElement(T_HEADER);
    	
    	return ret;
    }

    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputHMonth(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	// Field 결과 조회
    	String E_NAME = getField("E_NAME", function);
    	String E_WTCATTX = getField("E_WTCATTX", function);
    	String E_BEGDA = getField("E_BEGDA", function);
    	String E_ENDDA = getField("E_ENDDA", function);
    	
    	// Table 결과 조회
    	Vector T_BODY = getTable(hris.D.D25WorkTime.D25WorkTimeBodyData.class,  function, "T_BODY");
    	Vector T_NWKTYP = getTable(hris.D.D25WorkTime.D25WorkTimeNwktypData.class,  function, "T_NWKTYP");
    	Vector T_HEADER = getTable(hris.D.D25WorkTime.D25WorkTimeHeaderData.class,  function, "T_HEADER");
    	
    	ret.addElement(E_NAME);
    	ret.addElement(E_WTCATTX);
    	ret.addElement(E_BEGDA);
    	ret.addElement(E_ENDDA);
    	ret.addElement(T_BODY);
    	ret.addElement(T_NWKTYP);
    	ret.addElement(T_HEADER);
    	
    	return ret;
    }

}
