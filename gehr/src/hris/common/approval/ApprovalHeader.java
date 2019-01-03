package hris.common.approval;

import org.apache.commons.lang.StringUtils;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-08-23.
 */
public class ApprovalHeader extends EntityData {

    public String 	UPMU_NAME	;//	CHAR	 30 	업무구분 텍스트
    public String 	MODFL	;//	CHAR	 1 	수정가능 FLAG	X OR SPACE
    public String 	ACCPFL	;//	CHAR	 1 	승인/반려가능 FLAG	X OR SPACE
    public String 	FINAL	;//	CHAR	 1 	최종결재자 FLAG	X OR SPACE
    public String 	CANCFL	;//	CHAR	 1 	취소가능 FLAG	X OR SPACE
    public String   DISPFL  ;   //조회 가능 플래그

    public String 	AINF_SEQN	;//	CHAR	 10 	결재정보 일련번호
    public String 	UPMU_FLAG	;//	 CHAR 	 1 	업무구분 그룹 지시자
    public String 	UPMU_TYPE	;//	CHAR	 3 	업무구분
    public String 	RQPNR	;//	NUMC	8	신청자 사번(본인/대리)
    public String 	ITPNR	;//	NUMC	 8 	대상자 사번

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	ORGTX	;//	CHAR	 40 	소속명
    public String 	ENAME	;//	CHAR	 40 	성명
    public String 	JIKCT	;//	CHAR	 40 	직급명
    public String 	PHONE_NUM	;//	CHAR	 20 	담당자의 전화번호
    public String 	MOLGA	;//	CHAR	 2 	국가 그루핑

    public String 	JIKWE	;//	CHAR	 20 	직위
    public String 	JIKWT	;//	CHAR	 40 	직위명


   /*
    //필요시 해제 사용
    public String 	ORGEH	;//	NUMC	 8 	조직 단위

    public String 	WERKS	;//	CHAR	 4 	인사 영역
    public String 	NAME1	;//	CHAR	 30 	인사 영역 텍스트
    public String 	BTRTL	;//	CHAR	 4 	인사 하위 영역
    public String 	BTEXT	;//	CHAR	 15 	인사 하위 영역 텍스트
    public String 	PERSG	;//	CHAR	 1 	사원 그룹
    public String 	PGTXT	;//	CHAR	 20 	사원 그룹 이름	대상자 사번
    public String 	PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String 	PKTXT	;//	CHAR	 20 	사원 하위 그룹 이름
    public String 	STELL	;//	NUMC	 8 	직무
    public String 	STLTX	;//	CHAR	 40 	직무명
    public String 	DAT01	;//	DATS	 8 	그룹입사일
    public String 	DAT02	;//	DATS	 8 	회사입사일
    public String 	DAT03	;//	DATS	 8 	현직위승진일
    public String 	DAT04	;//	DATS	 8 	근속기준일

    public String 	JIKCH	;//	CHAR	 20 	직급

*/
    //[CSR ID:3456352]
    public String 	BUKRS	;//	CHAR	 4 	회사 코드
	public String 	JIKKB	;//	CHAR	 20 	직책
    public String 	JIKKT	;//	CHAR	 40 	직책명

    //[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 start
    public String 	PERSG	;//	CHAR	 1 	사원 그룹
    public String 	PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String 	JIKCH	;//	CHAR	 20 	직급


    public String getPERSG() {
		return PERSG;
	}

	public void setPERSG(String pERSG) {
		PERSG = pERSG;
	}

	public String getPERSK() {
		return PERSK;
	}

	public void setPERSK(String pERSK) {
		PERSK = pERSK;
	}

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getJIKCH() {
		return JIKCH;
	}

	public void setJIKCH(String jIKCH) {
		JIKCH = jIKCH;
	}
	 //[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end
	public String getJIKKB() {
		return JIKKB;
	}

	public void setJIKKB(String jIKKB) {
		JIKKB = jIKKB;
	}

	public String getJIKKT() {
		return JIKKT;
	}

	public void setJIKKT(String jIKKT) {
		JIKKT = jIKKT;
	}

    //[CSR ID:3456352]

    public String 	RQDAT	;//	DATS	 8 	신청일자
    public String 	RQTIM	;//	TIMS	 6 	신청시간
    public String 	AFDAT	;//	DATS	 8 	최종 결재일자
    public String 	AFTIM	;//	TIMS	 6 	최종 결재시간
    public String 	AFSTAT	;//	CHAR	 2 	최종 결재상태 (03결재완료 04반려)
    public String 	AFSTATX	;//	CHAR	 60 	최종결재상태명

    public String PMANFL;   //		CHAR	 1 	신청부서장 FLAG	X OR SPACE
    public String DMANFL;   //		CHAR	 2 	담당자, 담당부서장	'01', '02'	01 : 담당자 , 02 : 담당부서장


    public boolean isFinish() {
        return "03".equals(AFSTAT) || "04".equals(AFSTAT);
    }

    /**
     * 결재자가 추가 데이타 등록 후 조회 여부
     * 결재가 1회 이상 되었거나 결재가능 여부
     * @return
     */
    public boolean isShowManagerArea() {
        return !"01".equals(AFSTAT) ||  "X".equals(ACCPFL);
    }

    /**
     * 부서장이 결재 가능 여부
     * 부서장 결재시 추가 입력시 사용
     * @return
     */
    public boolean isDepartManager() { return "X".equals(ACCPFL) && "X".equals(PMANFL); }

    /**
     * 담당 부서장이 결재 가능 여부
     * 담당 부서장 결재시 추가 입력시 사용
     * @return
     */
    public boolean isChargeArea() { return "X".equals(ACCPFL) && !StringUtils.isEmpty(DMANFL); }
    /**
     * 담당 부서장이 결재 가능 여부
     * 담당 부서장 결재시 추가 입력시 사용
     * @return
     */
    public boolean isChargeManager() { return "X".equals(ACCPFL) &&( "02".equals(DMANFL) || "03".equals(DMANFL)) ; }

    /**
     * 담당자 결재 가능 여부
     * 담당자 결재시 추가 입력시 사용
     * @return
     */
    public boolean isCharger() { return "X".equals(ACCPFL) && "01".equals(DMANFL); }

    /**
     * 최초 결재자가 데이타를 수정 할 수 있는지 여부
     * @return
     */
    public boolean isEditManagerArea() {
        return "01".equals(AFSTAT);
    }

    public String getManagerReadonly() {
        return !"01".equals(AFSTAT) ? "readonly" : "";
    }


    public String getUPMU_NAME() {
        return UPMU_NAME;
    }

    public void setUPMU_NAME(String UPMU_NAME) {
        this.UPMU_NAME = UPMU_NAME;
    }

    public String getMODFL() {
        return MODFL;
    }

    public void setMODFL(String MODFL) {
        this.MODFL = MODFL;
    }

    public String getACCPFL() {
        return ACCPFL;
    }

    public void setACCPFL(String ACCPFL) {
        this.ACCPFL = ACCPFL;
    }

    public String getFINAL() {
        return FINAL;
    }

    public void setFINAL(String FINAL) {
        this.FINAL = FINAL;
    }

    public String getCANCFL() {
        return CANCFL;
    }

    public void setCANCFL(String CANCFL) {
        this.CANCFL = CANCFL;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getUPMU_FLAG() {
        return UPMU_FLAG;
    }

    public void setUPMU_FLAG(String UPMU_FLAG) {
        this.UPMU_FLAG = UPMU_FLAG;
    }

    public String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    public void setUPMU_TYPE(String UPMU_TYPE) {
        this.UPMU_TYPE = UPMU_TYPE;
    }

    public String getRQPNR() {
        return RQPNR;
    }

    public void setRQPNR(String RQPNR) {
        this.RQPNR = RQPNR;
    }

    public String getITPNR() {
        return ITPNR;
    }

    public void setITPNR(String ITPNR) {
        this.ITPNR = ITPNR;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getJIKCT() {
        return JIKCT;
    }

    public void setJIKCT(String JIKCT) {
        this.JIKCT = JIKCT;
    }

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }

    public String getMOLGA() {
        return MOLGA;
    }

    public void setMOLGA(String MOLGA) {
        this.MOLGA = MOLGA;
    }

    public String getRQDAT() {
        return RQDAT;
    }

    public void setRQDAT(String RQDAT) {
        this.RQDAT = RQDAT;
    }

    public String getRQTIM() {
        return RQTIM;
    }

    public void setRQTIM(String RQTIM) {
        this.RQTIM = RQTIM;
    }

    public String getAFDAT() {
        return AFDAT;
    }

    public void setAFDAT(String AFDAT) {
        this.AFDAT = AFDAT;
    }

    public String getAFTIM() {
        return AFTIM;
    }

    public void setAFTIM(String AFTIM) {
        this.AFTIM = AFTIM;
    }

    public String getAFSTAT() {
        return AFSTAT;
    }

    public void setAFSTAT(String AFSTAT) {
        this.AFSTAT = AFSTAT;
    }

    public String getAFSTATX() {
        return AFSTATX;
    }

    public void setAFSTATX(String AFSTATX) {
        this.AFSTATX = AFSTATX;
    }

    public String getDISPFL() {
        return DISPFL;
    }

    public void setDISPFL(String DISPFL) {
        this.DISPFL = DISPFL;
    }

    public String getPMANFL() {
        return PMANFL;
    }

    public void setPMANFL(String PMANFL) {
        this.PMANFL = PMANFL;
    }

    public String getDMANFL() {
        return DMANFL;
    }

    public void setDMANFL(String DMANFL) {
        this.DMANFL = DMANFL;
    }

    public String getJIKWE() {
        return JIKWE;
    }

    public void setJIKWE(String JIKWE) {
        this.JIKWE = JIKWE;
    }

    public String getJIKWT() {
        return JIKWT;
    }

    public void setJIKWT(String JIKWT) {
        this.JIKWT = JIKWT;
    }
}
