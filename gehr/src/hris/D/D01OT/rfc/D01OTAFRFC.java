package hris.D.D01OT.rfc;

import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang.StringUtils;
import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.D.D01OT.D01OTData;
import hris.common.approval.ApprovalSAPWrap;


/**
 * D01OTAFRFC.java
 * 초과근무 사후신청 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 강동민
 * @version 1.0, 2018/06/25
 */
@SuppressWarnings("rawtypes")
public class D01OTAFRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_NTM_AFTOT_REQ";

    public D01OTAFRFC() {}

    public D01OTAFRFC(String empNo, String I_APGUB, String AINF_SEQN) throws GeneralException {

        setDetailInput(empNo, I_APGUB, AINF_SEQN);
    }

    /**
     * 초과근무 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<D01OTData> getDetail(String P_AINF_SEQN, String P_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            excuteDetail(mConnection, function);

            Vector ret = new Vector();
            if (g.getSapType().isLocal())
            	ret= getTable(hris.D.D01OT.D01OTData.class, function, "T_RESULT");
            else
            	ret= getOutput(function);

            D01OTData data = (D01OTData) Utils.indexOf(ret,0);

            Vector ret_vt = new Vector();
            if (data!=null){
	            // 공백으로 처리
			    if(data.PBEG1.equals(data.PEND1) && data.PEND1.equals("00:00:00")){
				    data.PBEG1 = "";
				    data.PEND1 = "";
			    }
		    	if (data.PBEG2.equals(data.PEND2) && data.PBEG2.equals("00:00:00")){
				    data.PBEG2 = "";
				    data.PEND2 = "";
			    }
		    	ret_vt.addElement(data);
            }
			return ret_vt;

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 초과근무 신청 RFC 호출하는 Method
  	 * @param P_PERNR 결재정보 일련번호
     * @exception com.sns.jdf.GeneralException
     */
    public String build( String P_PERNR, Vector createVector , Box box, HttpServletRequest req)
    		throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, null, P_PERNR, "2", createVector);

             /* 모바일에서 결재라인 관련 처리 */
            if(box.getObject("T_IMPORTA") != null)
                setTable(function, "T_IMPORTA", (Vector) box.getObject("T_IMPORTA"));

            return executeRequest(mConnection, function, box, req);
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 초과근무 수정 RFC 호출하는 Method
     * @param P_AINF_SEQN 결재정보 일련번호
     * @param P_PERNR 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public String change( String P_AINF_SEQN, String P_PERNR, Vector createVector ,Box box,  HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "3", createVector);
//            excute(mConnection, function);
            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 초과근무 삭제 RFC 호출하는 Method
     * @param P_AINF_SEQN 결재정보 일련번호
     * @param P_PERNR 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete( String P_AINF_SEQN, String P_PERNR )  throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, P_AINF_SEQN, P_PERNR, "4");
           return  executeDelete(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String key1, String key2, String job) throws GeneralException {
        setField( function, "I_AINF_SEQN", key1 );//"P_AINF_SEQN";
        setField( function, "I_ITPNR", key2 );;// "P_PERNR";
        setField( function, "I_GTYPE", job );//"P_CONT_TYPE";
    }


    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param job java.lang.String 기능정보
     * @param job java.util.Vector entityVector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String P_AINF_SEQN, String P_PERNR,
    		String job, Vector entityVector) throws GeneralException {

        setField( function, "I_AINF_SEQN", P_AINF_SEQN ); //"P_AINF_SEQN";
        setField( function, "I_GTYPE", job );//"P_CONT_TYPE";
        if(StringUtils.isNotEmpty(P_PERNR)) setField( function,  "I_ITPNR", P_PERNR );// "P_PERNR";
//        setField( function,  "I_PERNR", P_PERNR );// "P_PERNR";

        if (g.getSapType().isLocal()){
        	setTable(function, "T_RESULT", entityVector); // "P_RESULT";
        }else{
        	// Global:
        	setStructor(function, "S_RESULT", entityVector.get(0));
        }
    }


	/**
	 * RFC 실행전에 Import 값을 setting 한다. com.sns.jdf.SAPWrap.excute(JCO.Client
	 * mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
	 *
	 * @param function
	 *            com.sap.mw.jco.JCO.Function
	 *            java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */

	private Vector getOutput(JCO.Function function) throws GeneralException {
		D01OTData data = new D01OTData();
		D01OTData obj = (D01OTData)getStructor(data, function, "S_RESULT");//WA_ITAB

		if(obj.REASON.equals("")){	// QA에 zreason 저장부분 미반영으로 임시조치*ksc
			obj.REASON = data.ZREASON;
		}

		Vector v = new Vector();
		v.addElement(obj);
		return v;
	}

}


