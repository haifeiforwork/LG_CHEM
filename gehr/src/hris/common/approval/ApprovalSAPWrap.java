package hris.common.approval;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Vector;

/**
 * Created by manyjung on 2016-08-23.
 */
public class ApprovalSAPWrap extends SAPWrap {

    private Vector<ApprovalLineData> approvalLine;

    private ApprovalInput approvalInput;

    private ApprovalHeader approvalHeader;

    /**
     * 기본 조회시 사용
     *
     * @param mConnection
     * @param function
     * @throws GeneralException
     */
    public void excuteDetail(JCO.Client mConnection, JCO.Function function) throws GeneralException {

        if (approvalInput == null) throw new GeneralException("setRequestInput 을 확인 하십시오.");
        approvalInput.setI_GTYPE("1");

        setFields(function, approvalInput);

        super.excute(mConnection, function);

        approvalLine = getTable(ApprovalLineData.class, function, "T_EXPORTA"); //결재자 리스트 조회
        approvalHeader = getStructor(ApprovalHeader.class, function, "S_EXPORTA", "");  //결재자 헤더 조회
    }

    /**
     * 신청시 기본값 셋팅
     * I_UPMU_TYPE		CHAR	 3 	업무구분
     * I_RQPNR		 NUMC 	 8 	신청자 사번(접속자)
     * I_GTYPE   2' : 결재의뢰,     '3' : 수정,     '4' : 삭제
     *
     * @param I_RQPNR     접속자 사번
     * @param I_UPMU_TYPE 업무구분
     */
    public void setRequestInput(String I_RQPNR, String I_UPMU_TYPE) throws GeneralException {
        if (approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_GTYPE("2");
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_UPMU_TYPE(I_UPMU_TYPE);


        /*
        I_UPMU_FLAG		 CHAR 	 1 	업무구분 그룹 지시자*/
    }

    public void setChangeInput(String I_RQPNR, String I_UPMU_TYPE, String I_AINF_SEQN) throws GeneralException {
        if (approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_GTYPE("3");
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_UPMU_TYPE(I_UPMU_TYPE);
        approvalInput.setI_AINF_SEQN(I_AINF_SEQN);



        /*
        I_UPMU_FLAG		 CHAR 	 1 	업무구분 그룹 지시자*/
    }

    public void setDeleteInput(String I_RQPNR, String I_UPMU_TYPE, String I_AINF_SEQN) throws GeneralException {
        if (approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_GTYPE("4");
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_UPMU_TYPE(I_UPMU_TYPE);
        approvalInput.setI_AINF_SEQN(I_AINF_SEQN);
    }

    /**
     * 조회시 기본 입력값
     * I_APGUB		CHAR	 1 	결재메뉴 구분
     I_AINF_SEQN		 CHAR 	 10 	결재정보 일련번호
     * @param I_RQPNR 접속자 사번
     * @param I_APGUB   결재메뉴 구분 :  '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
     * @param I_AINF_SEQN   결재정보 일련번호 - 결재번호
     * @throws GeneralException
     */
    public void setDetailInput(String I_RQPNR, String I_APGUB, String I_AINF_SEQN) throws GeneralException {

        if(approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_APGUB(I_APGUB);
        approvalInput.setI_AINF_SEQN(I_AINF_SEQN);

    }


    /**
     * 신청시 사용
     * @param mConnection
     * @param function
     * @return 신청번호
     * @throws GeneralException
     */
    public String executeRequest(JCO.Client mConnection, JCO.Function function, Box box, HttpServletRequest req) throws GeneralException  {

     /*   setField(function, "I_RQDAT", box.get("I_RQDAT"));  //신청일자
        setField(function, "I_RQTIM", box.get("I_RQTIM"));  //신청시간*/
        if(approvalInput == null) throw new GeneralException("setRequestInput 을 확인 하십시오.");
        Date current = DataUtil.getDate(req);
        approvalInput.setI_RQDAT(current);
        approvalInput.setI_RQTIM(current);

        approvalInput.setI_PERNR(StringUtils.defaultIfEmpty(req.getParameter("PERNR"), approvalInput.getI_RQPNR()));
        setFields(function, approvalInput);

        /**
         * 신청 공통 부분 처리
         */
        //1. 결재라인 등록
        Vector<ApprovalLineData> T_IMPORTA = box.getVector(ApprovalLineData.class, "APPLINE_");
        for(ApprovalLineData row : T_IMPORTA) {
            row.APPU_NUMB = row.getAPPU_NUMB(); /* 사번 암호화 되엇을 경우 decrypt*/
        }

        if(Utils.getSize(T_IMPORTA) > 0)
            setTable(function, "T_IMPORTA", T_IMPORTA);

        super.excute(mConnection, function);

        /**
         * 신청 후 결과 공통 처리
         */
        return getField("E_AINF_SEQN", function);

    }

    /**
     * 변경 부분
     * 신청 부분과 현재로는 동일 함
     * @param mConnection
     * @param function
     * @param box
     * @param req
     * @return
     * @throws GeneralException
     */
    public String executeChange(JCO.Client mConnection, JCO.Function function, Box box, HttpServletRequest req) throws GeneralException  {

        return executeRequest(mConnection, function, box, req);
    }

    public RFCReturnEntity executeDelete(JCO.Client mConnection, JCO.Function function) throws GeneralException  {

        setFields(function, approvalInput);

        super.excute(mConnection, function);

        return getReturn();
    }

    /**
     * 신청내역 조회시 결재 라인 가져오는 부분
     * @return
     */
    public Vector<ApprovalLineData> getApprovalLine() {
        return approvalLine;
    }

    public ApprovalHeader getApprovalHeader() {
        return approvalHeader;
    }

    public ApprovalInput getApprovalInput() {
        return approvalInput;
    }

    public void setApprovalInput(ApprovalInput approvalInput) {
        this.approvalInput = approvalInput;
    }
}
