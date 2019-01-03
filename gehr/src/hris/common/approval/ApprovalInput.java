package hris.common.approval;

import java.util.Date;

/**
 * Created by manyjung on 2016-08-25.
 */
public class ApprovalInput {

    public String 	I_GTYPE	 ;// 	 CHAR 	 1 	처리구분
    public String 	I_APGUB	 ;// 	CHAR	 1 	결재메뉴 구분
    public String 	I_AINF_SEQN	 ;// 	 CHAR 	 10 	결재정보 일련번호
    public String 	I_UPMU_TYPE	 ;// 	CHAR	 3 	업무구분
    public String 	I_RQPNR	 ;// 	 NUMC 	 8 	신청자 사번(접속자)
    public Date     I_RQDAT	 ;// 	DATS	 8 	신청일자
    public Date 	I_RQTIM	 ;// 	TIME	 6 	신청시간

    public String I_PERNR;  //대상자 사번

    public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_GTYPE() {
        return I_GTYPE;
    }

    public void setI_GTYPE(String i_GTYPE) {
        I_GTYPE = i_GTYPE;
    }

    public String getI_APGUB() {
        return I_APGUB;
    }

    public void setI_APGUB(String i_APGUB) {
        I_APGUB = i_APGUB;
    }

    public String getI_AINF_SEQN() {
        return I_AINF_SEQN;
    }

    public void setI_AINF_SEQN(String i_AINF_SEQN) {
        I_AINF_SEQN = i_AINF_SEQN;
    }

    public String getI_UPMU_TYPE() {
        return I_UPMU_TYPE;
    }

    public void setI_UPMU_TYPE(String i_UPMU_TYPE) {
        I_UPMU_TYPE = i_UPMU_TYPE;
    }

    public String getI_RQPNR() {
        return I_RQPNR;
    }

    public void setI_RQPNR(String i_RQPNR) {
        I_RQPNR = i_RQPNR;
    }

    public Date getI_RQDAT() {
        return I_RQDAT;
    }

    public void setI_RQDAT(Date i_RQDAT) {
        I_RQDAT = i_RQDAT;
    }

    public Date getI_RQTIM() {
        return I_RQTIM;
    }

    public void setI_RQTIM(Date i_RQTIM) {
        I_RQTIM = i_RQTIM;
    }
}
