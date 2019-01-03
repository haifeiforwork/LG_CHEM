package hris.D.D19Duty.rfc;

import hris.D.D19Duty.D19DutyData;
import hris.E.E38Cancer.E38CancerData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;

/**
 * D01OTRFC.java 초과근무 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 박영락
 * @version 1.0, 2002/01/24
 */
public class D19DutyRFC extends ApprovalSAPWrap {

	//private String functionName = "ZHRW_RFC_DUTY_REQUEST";
	private String functionName = "ZGHR_RFC_DUTY_REQUEST";

	/**
	 * 초과근무 조회 RFC 호출하는 Method
	 *
	 * @return java.util.Vector
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @exception com.sns.jdf.GeneralException
	 */
	public Vector getDetail(String P_AINF_SEQN, String P_PERNR)	throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, P_AINF_SEQN, P_PERNR, "1");
			excuteDetail(mConnection, function); //excute(mConnection, function);
			Vector ret = getOutput(function);

			//D19DutyData data = new D19DutyData();
			//Object obj = getStructor(data, function, "S_ITAB");
			//ret.addElement(obj);

			return ret;
		} catch (Exception ex) {
			//Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	public Vector<D19DutyData> getDetail1(String P_AINF_SEQN, String P_PERNR,String I_AINF_NO	) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput1(function, P_AINF_SEQN, P_PERNR, "1",I_AINF_NO);
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

	public Vector getDetail2(String P_AINF_SEQN, String P_PERNR,String I_AINF_NO	) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput1(function, P_AINF_SEQN, P_PERNR, "1",I_AINF_NO);
			excuteDetail(mConnection, function); //excute(mConnection, function);
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
	 * 초과근무 신청 RFC 호출하는 Method
	 *
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @param java.util.Vector
	 *            초과근무신청신청 Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public String build(String P_AINF_SEQN, String P_PERNR, Vector createVector) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, P_AINF_SEQN, P_PERNR, "2", createVector);
			excute(mConnection, function);
			String MESSAGE = getField("E_MESSAGE", function);
			return MESSAGE;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * 직반 신청 RFC 호출하는 Method
	 *
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @param java.util.Vector
	 *            초과근무신청신청 Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	public String build(D19DutyData T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

    		setField(function, "I_ITPNR", box.get("PERNR"));
    		setField(function, "I_GTYPE", box.get("I_GTYPE"));
            //setTable(function, "S_ITAB", T_RESULT);
    		setStructor(function, "S_ITAB", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            //Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	/**
	 * 초과근무 수정 RFC 호출하는 Method
	 *
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @exception com.sns.jdf.GeneralException
	 */
	public void change(String P_AINF_SEQN, String P_PERNR, Vector createVector)	throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, P_AINF_SEQN, P_PERNR, "3", createVector);
			excute(mConnection, function);
			String MESSAGE = getField("E_MESSAGE", function);

		} catch (Exception ex) {
			//Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
     * 신청한 데이터를 삭제하는 Method
     * @return java.util.Vector
     * @param ainf_seqn java.lang.String 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
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
	private void setInput(JCO.Function function, String key1, String key2,	String job) throws GeneralException {
		String fieldName = "I_AINF_SEQN";
		setField(function, fieldName, key1);
		String fieldName1 = "I_ITPNR";// "I_PERNR";
		setField(function, fieldName1, key2);
		String fieldName2 = "I_GTYPE";
		setField(function, fieldName2, job);

	}
	private void setInput1(JCO.Function function, String key1, String key2,String job,String I_AINF_NO) throws GeneralException {
		String fieldName = "I_AINF_SEQN";
		setField(function, fieldName, key1);
		String fieldName1 = "I_ITPNR";// "I_PERNR";
		setField(function, fieldName1, key2);
		String fieldName2 = "I_GTYPE";
		setField(function, fieldName2, job);
		String fieldName3 = "I_AINF_NO";
		setField(function, fieldName3, I_AINF_NO);

	}

	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 * @param java.lang.String
	 *            결재정보 일련번호
	 * @param java.lang.String
	 *            사원번호
	 * @param job
	 *            java.lang.String 기능정보
	 * @param job
	 *            java.util.Vector entityVector
	 * @exception com.sns.jdf.GeneralException
	 */
	private void setInput(JCO.Function function, String P_AINF_SEQN,String P_PERNR, String job, Vector entityVector)	throws GeneralException {
		String fieldName = "I_AINF_SEQN";
		setField(function, fieldName, P_AINF_SEQN);
		String fieldName2 = "I_PERNR";
		setField(function, fieldName2, P_PERNR);
		String fieldName3 = "I_GTYPE";
		setField(function, fieldName3, job);
		String tableName = "S_ITAB";
		setStructor(function, tableName, entityVector.get(0));
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
		D19DutyData data = new D19DutyData();
		Object obj = getStructor(data, function, "S_ITAB");
		Vector v = new Vector();
		v.addElement(obj);
		return v;
	}

}
