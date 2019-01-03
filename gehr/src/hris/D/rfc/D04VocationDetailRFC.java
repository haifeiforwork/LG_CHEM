/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                		*/
/*   Program Name : 휴가실적정보                                                		*/
/*   Program ID   : D04VocationDetailRFC.java                                   */
/*   Description  : 개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Class            	*/
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/********************************************************************************/
package	hris.D.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D04VocationDetailRFC.java
 * 개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/21
 */
public class D04VocationDetailRFC extends SAPWrap {

   // private String functionName = "ZHRW_RFC_HOLIDAY_DISPLAY";
	 private String functionName = "ZGHR_RFC_HOLIDAY_DISPLAY";
	 
	 public Vector getExport(String empNo, String year) throws GeneralException {
		JCO.Client mConnection = null;

		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);

			setInput(function, empNo, year);
			excute(mConnection, function);

			Vector ret = getAllExport(function);

			return ret;

		} catch (Exception ex) {
			Logger.sap.println(this, " SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	 }

    /**
     * 개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocationDetail( String empNo, String year, String gubun ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);

            Vector ret = null;

            if( gubun == "1" ) {            // 휴가발생내역
              ret = getOutput1(function);
            } else if( gubun == "2" ) {     // 휴가사용내역
              ret = getOutput2(function);
            } else if( gubun == "3" ) {     // 사전부여휴가내역
		      ret = getOutput5(function);
			} else if( gubun == "4" ) {     // 선택적보상휴가내역
		      ret = getOutput6(function);
			}

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    public Vector getAllExport(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	String eNonAbsence = getField("E_NON_ABSENCE", function);		//개근연차계 0
    	String eLongService = getField("E_LONG_SERVICE", function);		//근속년차계	1
    	String eFlexible = getField("E_FLEXIBLE", function);			//유연휴가계 2
    	Vector tOccurResult = getTable(hris.D.D04VocationDetail3Data.class,  function, "T_OCCUR_RESULT");	//휴가발생 3
    	Vector tUsedResult = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT");		//휴가사용 4
    	Vector tUsedResult1 = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT1");	//휴가사용-사전부여 5
    	Vector tOccurResult1 = getTable(hris.D.D04VocationDetail3Data.class,  function, "T_OCCUR_RESULT1");	//휴가발생-사전부여 6
    	Vector tOccurResult2 = getTable(hris.D.D04VocationDetail4Data.class,  function, "T_OCCUR_RESULT2");	//휴가발생-선택적보상휴가 7
    	
    	ret.addElement(eNonAbsence);
    	ret.addElement(eLongService);
    	ret.addElement(eFlexible);
    	ret.addElement(tOccurResult);
    	ret.addElement(tUsedResult);
    	ret.addElement(tUsedResult1);
    	ret.addElement(tOccurResult1);
    	ret.addElement(tOccurResult2);
    	
    	return ret;
    }

    public String getNON_ABSENCE(String empNo, String year) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);

            String NON_ABSENCE = null;

            NON_ABSENCE = getOutput3(function);

            return NON_ABSENCE;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String getLONG_SERVICE(String empNo, String year) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);

            String LONG_SERVICE = null;

            LONG_SERVICE = getOutput4(function);

            return LONG_SERVICE;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    //@rdcamel 2016.12.15 유연휴가제 추가
    public String getFLEXIBLE(String empNo, String year) throws GeneralException {
        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);

            String E_FLEXIBLE = null;

            E_FLEXIBLE = getOutput7(function);

            return E_FLEXIBLE;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
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
    private void setInput(JCO.Function function, String value, String value1) throws GeneralException {
        String fieldName  = "I_PERNR";
        String fieldName1 = "I_YEAR";
        setField(function, fieldName, value);
        setField(function, fieldName1, value1);

    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput1(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D04VocationDetail1Data";
        String tableName  = "T_OCCUR_RESULT";
        return getTable(entityName, function, tableName);
    }

    private Vector getOutput2(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D04VocationDetail2Data";
        String tableName  = "T_USED_RESULT";
        return getTable(entityName, function, tableName);
    }

    private String getOutput3(JCO.Function function) throws GeneralException {
        String fieldName = "E_NON_ABSENCE";			// 개근연차계
        return getField(fieldName, function);
    }

    private String getOutput4(JCO.Function function) throws GeneralException {
        String fieldName = "E_LONG_SERVICE";		// 근속연차계
        return getField(fieldName, function);
    }

    private Vector getOutput5(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D04VocationDetail3Data";
        String tableName  = "T_OCCUR_RESULT1";		// 사전부여휴가
        return getTable(entityName, function, tableName);
    }

	private Vector getOutput6(JCO.Function function) throws GeneralException {
        String entityName = "hris.D.D04VocationDetail4Data";
        String tableName  = "T_OCCUR_RESULT2";		// 선택적보상휴가
        return getTable(entityName, function, tableName);
    }

	//@rdcamel 2016.12.15 유연휴가 detail 조회
    private String getOutput7(JCO.Function function) throws GeneralException {
        String fieldName = "E_FLEXIBLE";		// 유연휴가
        return getField(fieldName, function);
    }
}