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
     * �⺻ ��ȸ�� ���
     *
     * @param mConnection
     * @param function
     * @throws GeneralException
     */
    public void excuteDetail(JCO.Client mConnection, JCO.Function function) throws GeneralException {

        if (approvalInput == null) throw new GeneralException("setRequestInput �� Ȯ�� �Ͻʽÿ�.");
        approvalInput.setI_GTYPE("1");

        setFields(function, approvalInput);

        super.excute(mConnection, function);

        approvalLine = getTable(ApprovalLineData.class, function, "T_EXPORTA"); //������ ����Ʈ ��ȸ
        approvalHeader = getStructor(ApprovalHeader.class, function, "S_EXPORTA", "");  //������ ��� ��ȸ
    }

    /**
     * ��û�� �⺻�� ����
     * I_UPMU_TYPE		CHAR	 3 	��������
     * I_RQPNR		 NUMC 	 8 	��û�� ���(������)
     * I_GTYPE   2' : �����Ƿ�,     '3' : ����,     '4' : ����
     *
     * @param I_RQPNR     ������ ���
     * @param I_UPMU_TYPE ��������
     */
    public void setRequestInput(String I_RQPNR, String I_UPMU_TYPE) throws GeneralException {
        if (approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_GTYPE("2");
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_UPMU_TYPE(I_UPMU_TYPE);


        /*
        I_UPMU_FLAG		 CHAR 	 1 	�������� �׷� ������*/
    }

    public void setChangeInput(String I_RQPNR, String I_UPMU_TYPE, String I_AINF_SEQN) throws GeneralException {
        if (approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_GTYPE("3");
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_UPMU_TYPE(I_UPMU_TYPE);
        approvalInput.setI_AINF_SEQN(I_AINF_SEQN);



        /*
        I_UPMU_FLAG		 CHAR 	 1 	�������� �׷� ������*/
    }

    public void setDeleteInput(String I_RQPNR, String I_UPMU_TYPE, String I_AINF_SEQN) throws GeneralException {
        if (approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_GTYPE("4");
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_UPMU_TYPE(I_UPMU_TYPE);
        approvalInput.setI_AINF_SEQN(I_AINF_SEQN);
    }

    /**
     * ��ȸ�� �⺻ �Է°�
     * I_APGUB		CHAR	 1 	����޴� ����
     I_AINF_SEQN		 CHAR 	 10 	�������� �Ϸù�ȣ
     * @param I_RQPNR ������ ���
     * @param I_APGUB   ����޴� ���� :  '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����
     * @param I_AINF_SEQN   �������� �Ϸù�ȣ - �����ȣ
     * @throws GeneralException
     */
    public void setDetailInput(String I_RQPNR, String I_APGUB, String I_AINF_SEQN) throws GeneralException {

        if(approvalInput == null) approvalInput = new ApprovalInput();
        approvalInput.setI_RQPNR(I_RQPNR);
        approvalInput.setI_APGUB(I_APGUB);
        approvalInput.setI_AINF_SEQN(I_AINF_SEQN);

    }


    /**
     * ��û�� ���
     * @param mConnection
     * @param function
     * @return ��û��ȣ
     * @throws GeneralException
     */
    public String executeRequest(JCO.Client mConnection, JCO.Function function, Box box, HttpServletRequest req) throws GeneralException  {

     /*   setField(function, "I_RQDAT", box.get("I_RQDAT"));  //��û����
        setField(function, "I_RQTIM", box.get("I_RQTIM"));  //��û�ð�*/
        if(approvalInput == null) throw new GeneralException("setRequestInput �� Ȯ�� �Ͻʽÿ�.");
        Date current = DataUtil.getDate(req);
        approvalInput.setI_RQDAT(current);
        approvalInput.setI_RQTIM(current);

        approvalInput.setI_PERNR(StringUtils.defaultIfEmpty(req.getParameter("PERNR"), approvalInput.getI_RQPNR()));
        setFields(function, approvalInput);

        /**
         * ��û ���� �κ� ó��
         */
        //1. ������� ���
        Vector<ApprovalLineData> T_IMPORTA = box.getVector(ApprovalLineData.class, "APPLINE_");
        for(ApprovalLineData row : T_IMPORTA) {
            row.APPU_NUMB = row.getAPPU_NUMB(); /* ��� ��ȣȭ �Ǿ��� ��� decrypt*/
        }

        if(Utils.getSize(T_IMPORTA) > 0)
            setTable(function, "T_IMPORTA", T_IMPORTA);

        super.excute(mConnection, function);

        /**
         * ��û �� ��� ���� ó��
         */
        return getField("E_AINF_SEQN", function);

    }

    /**
     * ���� �κ�
     * ��û �κа� ����δ� ���� ��
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
     * ��û���� ��ȸ�� ���� ���� �������� �κ�
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
