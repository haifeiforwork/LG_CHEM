/*
 * 작성된 날짜: 2005. 1. 31.
 *
 */
package hris.G.G001Approval;

import com.sns.jdf.EntityData;

/**
 * @author 이승희
 *
 */
public class ApprovalListKey extends EntityData {
   /* public String GUBUN;        // 구분   1 결재해야할문서 ,2 결재진행중 문서 ,3 결재완료문서
    public String PERNR;        // 사번
    public String BEGDA;        // 신청일 FROM
    public String ENDDA;        // 신청일 TO
    public String UPMU_TYPE;    // 업무항목
    public String APPL_PERNR;   // 신청자 사번
    public String STAT_TYPE;    // 상태   "1 신청 ,2 결재진행중 ,3 결재완료 ,4 반려"*/

   /*
   1. 결재함 펑션
   I_AGUBN (결재메뉴 구분)
    '1' : 결재할 문서
    '2' : 결재중 문서
    '3' : 결재완료 문서

2. I_BEGDA, I_ENDDA,
    I_ITPNR(기존 APPL_PERNR - 신청자 사번),
    I_STAT_TYPE 등은
    기존 펑션의 조건과 동일함
    */
    public String 	I_AGUBN	;//	CHAR	 1 	결재메뉴 구분
    public String 	I_PERNR	;//	NUMC	 8 	사원 번호(접속자)
    public String 	I_BEGDA	;//	DATS	 8 	시작일
    public String 	I_ENDDA	;//	DATS	 8 	종료일
    public String 	I_UPMU_TYPE	;//	CHAR	 3 	업무구분
    public String 	I_ITPNR	;//	NUMC	 8 	대상자 사번
    public String 	I_STAT_TYPE	;//	CHAR	 1 	상태(기존로직)

    public String getI_AGUBN() {
        return I_AGUBN;
    }

    public void setI_AGUBN(String i_AGUBN) {
        I_AGUBN = i_AGUBN;
    }

    public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_BEGDA() {
        return I_BEGDA;
    }

    public void setI_BEGDA(String i_BEGDA) {
        I_BEGDA = i_BEGDA;
    }

    public String getI_ENDDA() {
        return I_ENDDA;
    }

    public void setI_ENDDA(String i_ENDDA) {
        I_ENDDA = i_ENDDA;
    }

    public String getI_UPMU_TYPE() {
        return I_UPMU_TYPE;
    }

    public void setI_UPMU_TYPE(String i_UPMU_TYPE) {
        I_UPMU_TYPE = i_UPMU_TYPE;
    }

    public String getI_ITPNR() {
        return I_ITPNR;
    }

    public void setI_ITPNR(String i_ITPNR) {
        I_ITPNR = i_ITPNR;
    }

    public String getI_STAT_TYPE() {
        return I_STAT_TYPE;
    }

    public void setI_STAT_TYPE(String i_STAT_TYPE) {
        I_STAT_TYPE = i_STAT_TYPE;
    }
}
