package hris.D.D25WorkTime.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D25WorkTimeLeaderReportRFC.java
 * 리더 실근무 관리 레포트를 조회하는 RFC
 * 2018-05-24  성환희    [WorkTime52] 실근무 실적현황
 * @author 성환희
 * @version 1.0, 2018/05/28
 */
public class D25WorkTimeLeaderReportRFC extends SAPWrap {
	
	private String functionName = "";
	
	private final String LEADER_S_WORKTIME_WEEK_REPORT = "ZGHR_RFC_NTM_RW_REP_S_WEEK_LD";
	private final String LEADER_S_WORKTIME_MONTH_REPORT = "ZGHR_RFC_NTM_RW_REP_S_MONTH_LD";
	private final String LEADER_H_WORKTIME_REPORT = "ZGHR_RFC_NTM_RW_REP_H_LEADER";
	
	/**
	 * @param SEARCH_EMPGUBUN
	 * @param LOGPER
	 * @param SEARCH_DATE
	 * @param DEPTID
	 * @param includeSubOrg
	 * @param PERNR
	 * @return
	 * @throws GeneralException
	 */
	public Vector getSWeekReport(	String LOGPER, 
									String SEARCH_DATE, 
									String DEPTID, 
									String includeSubOrg, 
									String PERNR) throws GeneralException {

		String functionName = LEADER_S_WORKTIME_WEEK_REPORT;
		
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_LOGPER", LOGPER);
            setField(function, "I_REQDT", SEARCH_DATE);
            if(DEPTID != null && !DEPTID.equals("")) setField(function, "I_ORGEH", DEPTID);
            if(includeSubOrg != null && includeSubOrg.equals("Y")) setField(function, "I_LOWERYN", includeSubOrg);
            if(PERNR != null && !PERNR.equals("")) setField(function, "I_PERNR", PERNR);

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
	
	/**
	 * @param SEARCH_EMPGUBUN
	 * @param LOGPER
	 * @param SEARCH_DATE
	 * @param DEPTID
	 * @param includeSubOrg
	 * @param PERNR
	 * @return
	 * @throws GeneralException
	 */
	public Vector getSMonthReport(	String LOGPER, 
									String SEARCH_DATE, 
									String DEPTID, 
									String includeSubOrg, 
									String PERNR) throws GeneralException {

		String functionName = LEADER_S_WORKTIME_MONTH_REPORT;
		
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_LOGPER", LOGPER);
            
            String searchYear = SEARCH_DATE.substring(0, 4);
        	String searchMonth = SEARCH_DATE.substring(4, 6);
            String curDay = SEARCH_DATE.substring(6, 8);
            String I_YYYYMM = SEARCH_DATE.substring(0, 6);
            
        	setField(function, "I_YYYYMM", I_YYYYMM);
            if(DEPTID != null && !DEPTID.equals("")) setField(function, "I_ORGEH", DEPTID);
            if(includeSubOrg != null && includeSubOrg.equals("Y")) setField(function, "I_LOWERYN", includeSubOrg);
            if(PERNR != null && !PERNR.equals("")) setField(function, "I_PERNR", PERNR);

            excute(mConnection, function);
            
            Vector ret = getOutputSMonth(function);
            
            ret.addElement(I_YYYYMM);
            
            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
	/**
	 * @param LOGPER
	 * @param SEARCH_DATE
	 * @param DEPTID
	 * @param includeSubOrg
	 * @param PERNR
	 * @return
	 * @throws GeneralException
	 */
	public Vector getHReport(	String LOGPER, 
								String SEARCH_DATE, 
								String DEPTID, 
								String includeSubOrg, 
								String PERNR) throws GeneralException {

		String functionName = LEADER_H_WORKTIME_REPORT;

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setField(function, "I_LOGPER", LOGPER);
			setField(function, "I_DATUM", SEARCH_DATE);
			if (DEPTID != null && !DEPTID.equals(""))
				setField(function, "I_ORGEH", DEPTID);
			if (includeSubOrg != null && includeSubOrg.equals("Y"))
				setField(function, "I_LOWERYN", includeSubOrg);
			if (PERNR != null && !PERNR.equals(""))
				setField(function, "I_PERNR", PERNR);

			excute(mConnection, function);

			Vector ret = getOutputHReport(function);

			return ret;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}
	
	/**
	 * @param LOGPER
	 * @param SEARCH_DATE
	 * @param I_SELTAB
	 * @param OBJID
	 * @return
	 * @throws GeneralException
	 */
	public Vector getHReportByObjectTable(	String LOGPER, 
											String SEARCH_DATE, 
											String I_SELTAB, 
											Vector OBJID) throws GeneralException {
		
		String functionName = LEADER_H_WORKTIME_REPORT;
		
		JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_LOGPER", LOGPER);
            setField(function, "I_DATUM", SEARCH_DATE);
            setField(function, "I_MANAG", "X");
           
            if("A".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTA", OBJID);
            }else if("B".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTB", OBJID);
            }else if("C".equals(I_SELTAB)){
            	setTable(function, "T_IMPORTC", OBJID);
            }

            excute(mConnection, function);
            
            Vector ret = getOutputHReport(function);
            
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

    	// Table 결과 조회
    	Vector T_LIST = getTable(hris.D.D25WorkTime.D25WorkTimeListData.class,  function, "T_LIST");
    	Vector T_TWEEKS = getTable(hris.D.D25WorkTime.D25WorkTimeTweeksData.class,  function, "T_TWEEKS");

    	ret.addElement(T_LIST);
    	ret.addElement(T_TWEEKS);
    	
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
    	
    	// Table 결과 조회
    	Vector T_LIST = getTable(hris.D.D25WorkTime.D25WorkTimeListData.class,  function, "T_LIST");
    	
    	ret.addElement(T_LIST);
    	
    	return ret;
    }
    
    /**
     * RFC 실행후 Export 값을 String 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutputHReport(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	// Table 결과 조회
    	Vector T_RESULT = getTable(hris.D.D25WorkTime.D25WorkTimeResultData.class,  function, "T_RESULT");
    	
    	ret.addElement(T_RESULT);
    	
    	return ret;
    }

}
