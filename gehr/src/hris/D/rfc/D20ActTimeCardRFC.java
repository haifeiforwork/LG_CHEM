/********************************************************************************/ 
/*	  System Name  	: g-HR 
/*   1Depth Name  	:                                                    											
/*   2Depth Name  	:                                             											
/*   Program Name 	: ActTimeCard                                                 										
/*   Program ID   		: D20ActTimeCardRFC 
/*   Description  		: BOHAI법인 통문 일자/시간 조회  RFC              
/*   Note         		: [관련 RFC] : ZHR_RFC_GET_ACTTIMECARD_DATA                      
/*   Creation			: 2009-12-23 jungin @v1.0 [C20091222_81370] BOHAI법인 통문시간 체크						
/********************************************************************************/

package hris.D.rfc;

import hris.D.*;
import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D20ActTimeCardRFC.java 통문 일자/시간 조회  RFC 를 호출하는 Class
 * 
 * @author jungin
 * @version 1.0, 2009/12/23
 */
public class D20ActTimeCardRFC extends SAPWrap {

	private String functionName = "ZGHR_RFC_GET_ACTTIMECARD_DATA";

	/**
	 * 통문 일자/시간 조회 RFC 호출하는 Method
	 * 
	 * @return java.util.Vector
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getActTimeCard(String I_PERNR, String I_DATE, String I_BEGTIME, String ENDTIME, String I_TYPE)
			throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			
			setInput(function, I_PERNR, I_DATE, I_BEGTIME, ENDTIME, I_TYPE);
			excute(mConnection, function);
			Vector ret = getOutput(function);
			return ret;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 * 
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @param java.lang.String
	 *            사원번호
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param job
	 *            java.lang.String 기능정보
	 * @exception com.sns.jdf.GeneralException
	 */
	private void setInput(JCO.Function function, String I_PERNR, String I_DATE, String I_BEGTIME, String ENDTIME, String I_TYPE) throws GeneralException {
		String fieldName = "I_PERNR";
		setField(function, fieldName, I_PERNR);
		String fieldName1 = "I_DATE";
		setField(function, fieldName1, I_DATE);
		String fieldName2 = "I_BEGTIME";
		setField(function, fieldName2, I_BEGTIME);
		String fieldName3 = "I_ENDTIME";
		setField(function, fieldName3, ENDTIME);
		String fieldName4 = "I_TYPE";
		setField(function, fieldName4, I_TYPE);
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
		String  E_BEGTIME = getField("E_BEGTIME", function);
		String  E_ENDTIME = getField("E_ENDTIME", function);
		String  E_BEGDATE = getField("E_BEGDATE", function);
		String  E_ENDDATE = getField("E_ENDDATE", function);
		
		Vector v = new Vector();
		v.addElement(E_BEGTIME);
		v.addElement(E_ENDTIME);
		v.addElement(E_BEGDATE);
		v.addElement(E_ENDDATE);

		return v;
	}
}
