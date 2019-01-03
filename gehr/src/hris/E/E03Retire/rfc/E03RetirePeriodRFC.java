/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금                                           */
/*   Program Name : 퇴직연금 관련 신청기간 조회                              */
/*   Program ID   : E03RetirePeriodRFC                                         */
/*   Description  : 퇴직연금 관련 신청기간 조회                       */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_REQUSET_PERIOD                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire.rfc;

import hris.E.E03Retire.E03RetirePeriodData;


import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;


public class E03RetirePeriodRFC extends SAPWrap {
	
	private String functionName = "ZSOLRP_RFC_REQUSET_PERIOD";
	
	public boolean getRetirePeriodInfo(String i_bukrs, String i_upmu_type, String i_subtype) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            String nowdate = DateTime.getShortDateString();

            setInput(function, i_bukrs, i_upmu_type, i_subtype);
            excute(mConnection, function);
           
            E03RetirePeriodData data = (E03RetirePeriodData)getOutput(function, (new E03RetirePeriodData()));
            
            String E_mask = data.E_MASK;
            String nowDt = "";
            String begda = "";
            String endda = "";
            
            if(E_mask.equals("YYYYMMDD")){
            	nowDt = DateTime.getFormatString("yyyyMMdd");
            	begda = getDateFormat(data.E_BEGDA, "yyyyMMdd");
            	endda = getDateFormat(data.E_ENDDA, "yyyyMMdd");
            }else if(E_mask.equals("YYYY")){
            	nowDt = DateTime.getFormatString("yyyy");
            	begda = getDateFormat(data.E_BEGDA, "yyyy");
            	endda = getDateFormat(data.E_ENDDA, "yyyy");            	
            }else if(E_mask.equals("MMDD")){
            	nowDt = DateTime.getFormatString("MMdd");
            	begda = getDateFormat(data.E_BEGDA, "MMdd");
            	endda = getDateFormat(data.E_ENDDA, "MMdd");            	
            }else if(E_mask.equals("MM")){
            	nowDt = DateTime.getFormatString("MM");
            	begda = getDateFormat(data.E_BEGDA, "MM");
            	endda = getDateFormat(data.E_ENDDA, "MM");            	
            }else if(E_mask.equals("DD")){
            	nowDt = DateTime.getFormatString("dd");
            	begda = getDateFormat(data.E_BEGDA, "dd");
            	endda = getDateFormat(data.E_ENDDA, "dd");            	
            }else{//입력안된 건 전기간
            	nowDt = DateTime.getFormatString("MM");
            	begda = getDateFormat("1111-01-11", "MM");
            	endda = getDateFormat("1111-12-11", "MM");              	
            }
            
            int i_nowDt = Integer.parseInt(nowDt);
            int i_begda = Integer.parseInt(begda);
            int i_endda = Integer.parseInt(endda);
            
            if(i_nowDt >= i_begda && i_nowDt <= i_endda)
            	return true;
            else 
            	return false;
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
    private void setInput(JCO.Function function, String i_bukrs, String i_upmu_type, String i_subtype) throws GeneralException {
        String fieldName1 = "I_BUKRS";
        String fieldName2 = "I_UPMU_TYPE";
        String fieldName3 = "I_SUBTYPE";

        setField( function, fieldName1, i_bukrs );
        setField( function, fieldName2, i_upmu_type );
        setField( function, fieldName3, i_subtype );
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
        
    private Object getOutput(JCO.Function function, E03RetirePeriodData data) throws GeneralException {
    	return getFields(data, function);
    }

}
