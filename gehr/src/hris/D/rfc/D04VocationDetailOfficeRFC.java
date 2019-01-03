/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 휴가실적정보                                                		*/
/*   Program Name : 휴가실적정보                                                		*/
/*   Program ID   : D04VocationDetailOfficeRFC.java                             */
/*   Description  : 사무직-개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Class       */
/*   Note         :                                                             */
/*   Creation     : 2018-05-18 성환희 [WorkTime52] 보상휴가 추가 건 				*/
/*   Update       :  															*/
/********************************************************************************/
package	hris.D.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D04VocationDetailOfficeRFC.java
 * [WorkTime52] 사무직-개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 성환희
 * @version 1.0, 2018/05/18
 */
public class D04VocationDetailOfficeRFC extends SAPWrap {

	 private String functionName = "ZGHR_RFC_NTM_HOLIDAY_DISPLAY";

    /**
     * 사무직-개인의 휴가현황 정보를 가져오는 RFC를 호출하는 Method<br/>
     * <br/>
     * 0 : E_NON_ABSENCE(개근연차계)<br/>
     * 1 : E_LONG_SERVICE(근속년차계)<br/>
     * 2 : E_FLEXIBLE(유연휴가계)<br/>
     * 3 : T_OCCUR_RESULT(휴가발생)<br/>
     * 4 : T_USED_RESULT(휴가사용)<br/>
     * 5 : T_USED_RESULT1(휴가사용-사전부여)<br/>
     * 6 : T_OCCUR_RESULT1(휴가발생-사전부여)<br/>
     * 7 : T_OCCUR_RESULT2(휴가발생-선택적보상휴가)<br/>
     * 8 : E_COMPTIME(보상휴가계)<br/>
     * 9 : T_OCCUR_RESULT3(휴가발생-보상휴가)<br/>
     * 10: T_USED_RESULT3(휴가사용-보상휴가)
     * 
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getVocationDetail(String empNo, String year) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year);
            excute(mConnection, function);

            Vector ret = getExport(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    
    /**
     * @param function
     * @return
     * @throws GeneralException
     */
    public Vector getExport(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();
    	
    	String eNonAbsence = getField("E_NON_ABSENCE", function);		//개근연차계
    	String eLongService = getField("E_LONG_SERVICE", function);		//근속년차계
    	String eFlexible = getField("E_FLEXIBLE", function);			//유연휴가계
    	String eComptime = getField("E_COMPTIME", function);			//보상휴가계
    	Vector tOccurResult = getTable(hris.D.D04VocationDetail3Data.class,  function, "T_OCCUR_RESULT");	//휴가발생
    	Vector tUsedResult = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT");		//휴가사용
    	Vector tUsedResult1 = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT1");	//휴가사용-사전부여
    	Vector tOccurResult1 = getTable(hris.D.D04VocationDetail3Data.class,  function, "T_OCCUR_RESULT1");	//휴가발생-사전부여
    	Vector tOccurResult2 = getTable(hris.D.D04VocationDetail4Data.class,  function, "T_OCCUR_RESULT2");	//휴가발생-선택적보상휴가
    	Vector tOccurResult3 = getTable(hris.D.D04VocationDetail4Data.class,  function, "T_OCCUR_RESULT3");	//휴가발생-보상휴가
    	Vector tUsedResult3 = getTable(hris.D.D04VocationDetail2Data.class,  function, "T_USED_RESULT3");	//휴가사용-보상휴가
    	
    	ret.addElement(eNonAbsence);
    	ret.addElement(eLongService);
    	ret.addElement(eFlexible);
    	ret.addElement(tOccurResult);
    	ret.addElement(tUsedResult);
    	ret.addElement(tUsedResult1);
    	ret.addElement(tOccurResult1);
    	ret.addElement(tOccurResult2);
    	ret.addElement(eComptime);
    	ret.addElement(tOccurResult3);
    	ret.addElement(tUsedResult3);
    	
    	return ret;
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

}