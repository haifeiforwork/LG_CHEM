package hris.D.D19Duty.rfc;

import hris.D.D19Duty.D19DutyData;
import hris.D.D19Duty.D19DutyData2;
import hris.D.D19Duty.D19DutyDetailData;
import hris.D.D19Duty.D19DutyTimeData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * D01OTCheckRFC.java 초과근무 해당여부를 첵크하는 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/03/15
 */
public class D19DutyEntryRFC extends SAPWrap {

	//private String functionName = "ZHRA_RFC_GET_DUTY_ENTRY";
	//private String functionName1 = "ZHRW_RFC_DUTY_ACCOUNT";
	private String functionName = "ZGHR_RFC_GET_DUTY_ENTRY";
	private String functionName1 = "ZGHR_RFC_DUTY_ACCOUNT";

	/**
	 * 초과근무 조회 RFC 호출하는 Method
	 *
	 * @return java.util.Vector
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @param java.lang.String
	 *            사원번호
	 * @param java.lang.String
	 *            사원번호
	 * @param java.lang.String
	 *            사원번호
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDutyEntry(String PERNR, String BEGDA) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, PERNR, BEGDA);

			excute(mConnection, function);

			Vector ret = getOutput(function);
			return ret;
		} catch (Exception ex) {
			//Logger.sap.println(this, "SAPException : " + ex.toString());
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
	private void setInput(JCO.Function function, String PERNR, String BEGDA) throws GeneralException {
		String fieldName1 = "I_PERNR";
		setField(function, fieldName1, PERNR);
		String fieldName2 = "I_DATUM";
		setField(function, fieldName2, BEGDA);
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

		// WA_ITAB

		D19DutyData data = new D19DutyData();
		data = (D19DutyData) getStructor(data, function, "S_ITAB");

		data.ZJIKCH = data.JIKCH;

		// E_HOLIDAY
		String E_HOLIDAY = getField("E_HOLIDAY", function);
		data.ZHOLIDAY = E_HOLIDAY;

		// E_HOLIDAY1.	2008-01-14.
		String E_HOLIDAY1 = getField("E_HOLIDAY1", function);
		data.ZHOLIDAY1 = E_HOLIDAY1;


		// T_EXPORTB
		//String entityName = "hris.D.D19Duty.D19DutyTimeData";
		Vector ret = getTable(D19DutyTimeData.class, function, "T_EXPORTB");
		for (int i = 0; ret.size() == 2 && i < ret.size()  ; i++) {
			D19DutyTimeData obj = (D19DutyTimeData) ret.get(i ++);
			data.TPROG1 = obj.TPROG;
			data.TTEXT1 = obj.TTEXT;
			data.BEGUZ1 = obj.BEGUZ.equals("") ? "00:00" : obj.BEGUZ.substring(0, 5);
			data.ENDUZ1 = obj.ENDUZ.equals("") ? "00:00" : obj.ENDUZ.substring(0, 5);

			D19DutyTimeData obj1 = (D19DutyTimeData) ret.get(i);
			data.TPROG2 = obj1.TPROG;
			data.TTEXT2 = obj1.TTEXT;
			data.BEGUZ2 = obj1.BEGUZ.equals("") ? "00:00" : obj1.BEGUZ.substring(0, 5);
			data.ENDUZ2 = obj1.ENDUZ.equals("") ? "00:00" : obj1.ENDUZ.substring(0, 5);
		}

		// T_EXPORTA
		Vector retA = getTable(D19DutyDetailData.class, function, "T_EXPORTA");

		Vector return_vt = new Vector();

		return_vt.addElement(data);
		return_vt.addElement(retA);

		return return_vt;
	}

	//-------------------------------- li hui------------------------
	public Object getMessage(String empNo,String Itype,String today,String JIKCH, String time , String ANZHL) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput2(function, empNo,Itype,today,JIKCH,time,ANZHL);

            excute(mConnection, function);
            D19DutyData2 data2 = new D19DutyData2();
            return  getFields(data2, function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	public Vector vcGetMessage(String empNo,String Itype,String today,String JIKCH, String time , String ANZHL) throws GeneralException{
		JCO.Client mConnection = null;
		Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            ret = new Vector();

            setInput2(function, empNo,Itype,today,JIKCH,time,ANZHL);

            excute(mConnection, function);
            D19DutyData2 data2 = new D19DutyData2();

            //String E_RETURN   = getReturn().MSGTY;

        	String E_ACCOUNT   = getField("E_ACCOUNT", function) ;
        	String E_WAERS   = getField("E_WAERS", function) ;
        	String E_MESSAGE   = getReturn().MSGTX;

        	//getFields(data2, function);

        	Logger.debug.println(this, "=====E_MESSAGE====" + E_MESSAGE);

        	//ret.addElement(getFields(data2, function));
        	ret.addElement(E_ACCOUNT);
        	ret.addElement(E_WAERS);
        	ret.addElement(E_MESSAGE);

            //return  getFields(data2, function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
	}

     private void setInput2(JCO.Function function, String PERNR, String Itype,String today,String JIKCH, String time , String ANZHL) throws GeneralException {
		String fieldName1 = "I_PERNR";
		setField(function, fieldName1, PERNR);
		String fieldName2 = "I_DUTY";
		setField(function, fieldName2, Itype);
		String fieldName3 = "I_DATUM";
		setField(function, fieldName3, today);
		String fieldName4 = "I_JIKCH";
		setField(function, fieldName4, JIKCH);
		String fieldName5 = "I_NDAY";
		setField(function, fieldName5, time);
		String fieldName6 = "I_ANZHL";
		setField(function, fieldName6, ANZHL);
		}
}
