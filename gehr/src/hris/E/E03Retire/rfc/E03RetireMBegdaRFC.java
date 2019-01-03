/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금                                           */
/*   Program Name : 퇴직연금 관련 문서 결재 시 시작일 입력란 유/무  조회                              */
/*   Program ID   : E03RetireMBegdaRFC                                         */
/*   Description  : 퇴직연금 관련 문서 결재 시 시작일 입력란 유/무  조회                      */
/*   Note         : [관련 RFC] : ZSOLRP_GET_SETTING                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetireMBegdaData;


import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;


public class E03RetireMBegdaRFC extends SAPWrap {
	
	private String functionName = "ZSOLRP_GET_SETTING";
	
	public String  getRetireMBegdaInfo(String i_upmu) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            String nowdate = DateTime.getShortDateString();

            setInput(function, i_upmu);
            excute(mConnection, function);
           
            E03RetireMBegdaData data = (E03RetireMBegdaData)getOutput(function, (new E03RetireMBegdaData()));
            
            String E_ZCHECK = data.E_ZCHECK;
                       
            if(E_ZCHECK == null) E_ZCHECK = "";	//E_ZCHECK 가 X 이면 결재자가 시작일을 입력할 수 있는 input을 화면에 출력
            return E_ZCHECK;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.getMessage());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
	
	/*
	 * 날짜 계산
	 */
	private String getDateFormat(String date1, String format){
		try{
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("yyyy-MM-dd", java.util.Locale.KOREA);
			java.util.Date date = null;
	
			date = formatter.parse(date1);
			
			formatter = new java.text.SimpleDateFormat (format, java.util.Locale.KOREA);
        
			return formatter.format(date);
		}catch(Exception e){
			return "";
		}
	}

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_upmu) throws GeneralException {
        String fieldName1 = "I_UPMU";
        String fieldName2 = "I_ZOBJEC";

        setField( function, fieldName1, i_upmu );
        setField( function, fieldName2, "ESS_BEGDA" );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetireMBegdaData data) throws GeneralException {
    	return getFields(data, function);
    }

}
