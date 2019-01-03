/********************************************************************************/
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Time Management
/*   Program Name 	: Time Sheet
/*   Program ID   		: D07TimeSheetRFCUsa.java
/*   Description  		: Time Sheet 조회, 입력, 수정, 취소  RFC (USA - LG CPI(G400))
/*   Note         		: [관련 RFC] : ZHRE_RFC_TIME_SHEET
/*   Creation     		: 2010-10-12 jungin @v1.0 LGCPI법인 Time Sheet 신규 개발
/*   Update				: 2011-02-11 jungin @v1.1 [C20110124_13389] 결재요청 취소(Cancle Application) 추가. (결재진행중일 경우에만 한함.)
/********************************************************************************/

package hris.D.D07TimeSheet.rfc;

import hris.A.A17Licence.A17LicenceData;
import hris.D.D07TimeSheet.D07TimeSheetAinfDataUsa;
import hris.D.D07TimeSheet.D07TimeSheetApproverDataUsa;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.D.D07TimeSheet.D07TimeSheetSummaryDataUsa;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalInput;
import hris.common.approval.ApprovalLineData;
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
 * D07TimeSheetRFCUsa.java
 * Time Sheet 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author jungin
 * @version 1.0, 2010/10/12
 */
public class D07TimeSheetRFCUsa extends ApprovalSAPWrap {

	private String functionName = "ZGHR_RFC_TIME_SHEET";


    public String build(Vector<D07TimeSheetDetailDataUsa> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput3(function, T_RESULT, "T_DETAIL");
            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	public Vector getTimeSheetDetail(String I_PERNR, String I_PAYDR, String I_LCLDT, String I_APPR_STAT)
		throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, I_PERNR, I_PAYDR, I_LCLDT, "1", I_APPR_STAT);
			excuteDetail(mConnection, function);
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
	 * Time Sheet 조회 RFC 호출하는 Method
	 */
	public Vector getTimeSheet(String I_PERNR, String I_PAYDR, String I_LCLDT,  String I_APPR_STAT)
		throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput(function, I_PERNR, I_PAYDR, I_LCLDT, "1", I_APPR_STAT);
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
	 * Time Sheet 신청 RFC 호출하는 Method
	 */
	public String save(String I_PERNR, String I_PAYDR, String I_LCLDT,
								String I_AINF_SEQN, String I_APPR_STAT, Vector createVector)
		throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput1(function, I_PERNR, I_PAYDR, I_LCLDT, "3", I_AINF_SEQN, I_APPR_STAT);
			setInput3(function, createVector, "T_DETAIL");
			excute(mConnection, function);
			Logger.debug.println(this,getReturn().MSGTY );
			Logger.debug.println(this,getReturn().MSGTX );
			return getReturn().MSGTY;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

	/**
	 * Time Sheet 삭제 RFC 호출하는 Method
	 */
	public String cancle(String I_PERNR, String I_AINF_SEQN) throws GeneralException {

		JCO.Client mConnection = null;
		try {
			mConnection = getClient();
			JCO.Function function = createFunction(functionName);
			setInput2(function, I_PERNR, "4", I_AINF_SEQN);
			excute(mConnection, function);
			return getReturn().MSGTY;
		} catch (Exception ex) {
			Logger.sap.println(this, "SAPException : " + ex.toString());
			throw new GeneralException(ex);
		} finally {
			close(mConnection);
		}
	}

    /**
     * Time Sheet 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드

	 */
	private void setInput(JCO.Function function, String I_PERNR, String I_PAYDR, String I_LCLDT,
																  String I_GTYPE, String I_APPR_STAT)
		throws GeneralException {

		setField(function, "I_PERNR", I_PERNR);
		setField(function, "I_PAYDR", I_PAYDR);
		setField(function, "I_LCLDT", I_LCLDT);
		setField(function, "I_GTYPE", I_GTYPE);
		setField(function, "I_APPR_STAT", I_APPR_STAT);
	}

	private void setInput1(JCO.Function function, String I_PERNR, String I_PAYDR, String I_LCLDT,
																	String I_GTYPE, String I_AINF_SEQN, String I_APPR_STAT)
		throws GeneralException {

		setField(function, "I_PERNR", I_PERNR);
		setField(function, "I_PAYDR", I_PAYDR);
		setField(function, "I_LCLDT", I_LCLDT);
		setField(function, "I_GTYPE", I_GTYPE);
		setField(function, "I_AINF_SEQN", I_AINF_SEQN);
		setField(function, "I_APPR_STAT", I_APPR_STAT);
	}

	private void setInput2(JCO.Function function, String I_PERNR, String I_GTYPE, String I_AINF_SEQN)
		throws GeneralException {

		setField(function, "I_PERNR", I_PERNR);
		setField(function, "I_GTYPE", I_GTYPE);
		setField(function, "I_AINF_SEQN", I_AINF_SEQN);
	}

	private void setInput3(JCO.Function function, Vector entityVector, String tableName)
		throws GeneralException {
	        setTable(function, tableName, entityVector);
	}

	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 *
	 */
	private Vector getOutput(JCO.Function function) throws GeneralException {

		Vector ts_detail = new Vector();
		Vector ts_summa = new Vector();

        ts_detail = getTable(D07TimeSheetDetailDataUsa.class, function, "T_DETAIL");
        ts_summa = getTable(D07TimeSheetSummaryDataUsa.class, function, "T_SUMMA");


    	String E_MESSAGE   = getReturn().MSGTX;
        String E_BEGDA = getField("E_BEGDA", function);
		String E_ENDDA = getField("E_ENDDA", function);
		String E_PAYDRX = getField("E_PAYDRX", function);
		Logger.debug.println(this,"E_BEGDA====="+E_BEGDA);
		Logger.debug.println(this,"E_ENDDA====="+E_ENDDA);

		D07TimeSheetApproverDataUsa E_APPROVER = new D07TimeSheetApproverDataUsa();
		E_APPROVER = (D07TimeSheetApproverDataUsa)getStructor(E_APPROVER, function, "S_APPROVER");

		Vector ret = new Vector();

		ret.addElement(ts_detail);
		ret.addElement(ts_summa);
		ret.addElement(E_MESSAGE);
		ret.addElement(E_BEGDA);
		ret.addElement(E_ENDDA);
		ret.addElement(E_PAYDRX);
		ret.addElement(E_APPROVER);

		return ret;
	}

}
