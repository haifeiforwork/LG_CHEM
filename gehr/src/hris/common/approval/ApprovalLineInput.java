package hris.common.approval;

import com.sns.jdf.EntityData;
import com.sns.jdf.util.DataUtil;

/**
 * Created by manyjung on 2016-09-29.
 */
public class ApprovalLineInput extends EntityData {

    public String 	I_UPMU_FLAG	 ;// 	 CHAR 	 1 	업무구분 그룹 지시자
    public String 	I_UPMU_TYPE	 ;// 	CHAR	 3 	업무구분
    public String 	I_APPR_TYPE	 ;// 	 CHAR 	 2 	결재형태(사용안함)
    public String 	I_PERNR	 ;// 	NUMC	 8 	사원 번호
    public String 	I_AINF_SEQN	 ;// 	CHAR	 10 	결재정보 일련번호
    public String 	I_APPR_SEQN	 ;// 	NUMC	 2 	결재순서
    public String 	I_LOAN_CODE	 ;// 	CHAR	 4 	대출유형
    public String 	I_ANZHL	 ;// 	DEC	7.2	시간
    public String 	I_DAYS	 ;// 	DEC	6.2	일수
    public String 	I_AWART	 ;// 	CHAR	 4 	휴무(근무)유형
    public String 	I_DATUM = DataUtil.getCurrentDate()	 ;// 	CHAR	 4 	휴무(근무)유형

    public ApprovalLineInput() {
    }

    public ApprovalLineInput(String i_AINF_SEQN) {
        I_AINF_SEQN = i_AINF_SEQN;
    }

    public ApprovalLineInput(String i_AINF_SEQN, String I_PERNR) {
        I_AINF_SEQN = i_AINF_SEQN;
        I_PERNR = I_PERNR;
    }

    public String getI_UPMU_FLAG() {
        return I_UPMU_FLAG;
    }

	public void setI_UPMU_FLAG(String i_UPMU_FLAG) {
        I_UPMU_FLAG = i_UPMU_FLAG;
    }

    public String getI_UPMU_TYPE() {
        return I_UPMU_TYPE;
    }

    public void setI_UPMU_TYPE(String i_UPMU_TYPE) {
        I_UPMU_TYPE = i_UPMU_TYPE;
    }

    public String getI_APPR_TYPE() {
        return I_APPR_TYPE;
    }

    public void setI_APPR_TYPE(String i_APPR_TYPE) {
        I_APPR_TYPE = i_APPR_TYPE;
    }

    public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_AINF_SEQN() {
        return I_AINF_SEQN;
    }

    public void setI_AINF_SEQN(String i_AINF_SEQN) {
        I_AINF_SEQN = i_AINF_SEQN;
    }

    public String getI_APPR_SEQN() {
        return I_APPR_SEQN;
    }

    public void setI_APPR_SEQN(String i_APPR_SEQN) {
        I_APPR_SEQN = i_APPR_SEQN;
    }

    public String getI_LOAN_CODE() {
        return I_LOAN_CODE;
    }

    public void setI_LOAN_CODE(String i_LOAN_CODE) {
        I_LOAN_CODE = i_LOAN_CODE;
    }

    public String getI_ANZHL() {
        return I_ANZHL;
    }

    public void setI_ANZHL(String i_ANZHL) {
        I_ANZHL = i_ANZHL;
    }

    public String getI_DAYS() {
        return I_DAYS;
    }

    public void setI_DAYS(String i_DAYS) {
        I_DAYS = i_DAYS;
    }

    public String getI_AWART() {
        return I_AWART;
    }

    public void setI_AWART(String i_AWART) {
        I_AWART = i_AWART;
    }

    public String getI_DATUM() {
		return I_DATUM;
	}

	public void setI_DATUM(String i_DATUM) {
		I_DATUM = i_DATUM;
	}
}
