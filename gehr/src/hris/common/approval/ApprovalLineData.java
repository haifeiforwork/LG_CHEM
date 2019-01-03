package hris.common.approval;

import com.sns.jdf.EntityData;
import hris.N.AES.AESgenerUtil;
import org.apache.commons.lang.StringUtils;

/**
 * Created by manyjung on 2016-08-23.
 */
public class ApprovalLineData extends EntityData {
    /* 결재 관련 정보 */
    public String AINF_SEQN;//	CHAR	 10 	결재정보 일련번호
    public String APPR_TYPE;//	CHAR	 2 	결재형태
    public String APPU_TYPE;//	NUMC	 2 	결재자 구분
    public String APPR_SEQN;//	 NUMC 	 2 	결재순서
    public String APPU_NAME;//	CHAR	20	결재자 구분 텍스트
    public String APPU_NUMB;//	NUMC	 8 	결재자 사번
    public String APPU_ENC_NUMB;
    public String OTYPE;//	CHAR	 2 	오브젝트 유형	"T'
    public String OBJID;//	NUMC	 8 	태스크 ID
    public String BIGO_TEXT;//	CHAR	 250 	적요	필요시
    public String CMMNT;//	CHAR	 4,096 	의견	필요시
    public String APPR_DATE;//	DATS	 8 	승인일
    public String APPR_TIME;//	TIMS	 6 	시간
    public String APPR_STAT;//	CHAR	 1 	승인상태(도메인)	'A' OR 'R' OR SPACE
    public String APPR_STATX;//	CHAR	 60 	설명 내역

    /* 화면 표시 내용 */
    public String ENAME;//	CHAR	 40 	성명
    public String JIKWE;//	CHAR	 20 	직위
    public String JIKWT;//	CHAR	 40 	직위명
    public String ORGEH;//	NUMC	 8 	조직 단위
    public String ORGTX;//	CHAR	 40 	소속명
    public String PHONE_NUM;//	CHAR	 20 	담당자의 전화번호

    /* RFC에 기타 정보 - 필요시 필요 대상 주석 해제 사용 */

    public String 	PERNR	;//	NUMC	8	사원 번호	결재자 사번
    /*
    public String 	WERKS	;//	CHAR	 4 	인사 영역
    public String 	NAME1	;//	CHAR	 30 	인사 영역 텍스트
    public String 	BTRTL	;//	CHAR	 4 	인사 하위 영역
    public String 	BTEXT	;//	CHAR	 15 	인사 하위 영역 텍스트
    public String 	PERSG	;//	CHAR	 1 	사원 그룹
    public String 	PGTXT	;//	CHAR	 20 	사원 그룹 이름
    public String 	PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String 	PKTXT	;//	CHAR	 20 	사원 하위 그룹 이름
    public String 	STELL	;//	NUMC	 8 	직무
    public String 	STLTX	;//	CHAR	 40 	직무명
    public String 	DAT01	;//	DATS	 8 	그룹입사일
    public String 	DAT02	;//	DATS	 8 	회사입사일
    public String 	DAT03	;//	DATS	 8 	현직위승진일
    public String 	DAT04	;//	DATS	 8 	근속기준일
    public String 	JIKCH	;//	CHAR	 20 	직급
    public String 	JIKCT	;//	CHAR	 40 	직급명

    public String 	MOLGA	;//	CHAR	 2 	국가 그루핑
    */

  //[CSR ID:3456352]
    public String 	JIKKB	;//	CHAR	 20 	직책
    public String 	JIKKT	;//	CHAR	 40 	직책명
    public String 	BUKRS	;//	CHAR	 4 	회사 코드

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

	public String getJIKCH() {
		return JIKCH;
	}

	public void setJIKCH(String jIKCH) {
		JIKCH = jIKCH;
	}

  //[CSR ID:3497059] 사무직 직급체계 변경에 따른 중국지역 직책자 직책으로 표시요청드림 end

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

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

    public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	//[CSR ID:3456352]


    public String getAPPU_ENC_NUMB() {
        return APPU_ENC_NUMB;
    }

    public void setAPPU_ENC_NUMB(String APPU_ENC_NUMB) {
        this.APPU_ENC_NUMB = APPU_ENC_NUMB;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getAPPR_TYPE() {
        return APPR_TYPE;
    }

    public void setAPPR_TYPE(String APPR_TYPE) {
        this.APPR_TYPE = APPR_TYPE;
    }

    public String getAPPU_TYPE() {
        return APPU_TYPE;
    }

    public void setAPPU_TYPE(String APPU_TYPE) {
        this.APPU_TYPE = APPU_TYPE;
    }

    public String getAPPR_SEQN() {
        return APPR_SEQN;
    }

    public void setAPPR_SEQN(String APPR_SEQN) {
        this.APPR_SEQN = APPR_SEQN;
    }

    public String getAPPU_NAME() {
        return APPU_NAME;
    }

    public void setAPPU_NAME(String APPU_NAME) {
        this.APPU_NAME = APPU_NAME;
    }

    public String getAPPU_NUMB() {
        /*모의해킹 결과 - 결재라인 사번 암호화*/
        if(StringUtils.isBlank(APPU_NUMB) && StringUtils.isNotBlank(APPU_ENC_NUMB)) {
            return AESgenerUtil.decryptAES(APPU_ENC_NUMB);
        }
        return APPU_NUMB;
    }

    public void setAPPU_NUMB(String APPU_NUMB) {
        this.APPU_NUMB = APPU_NUMB;
    }

    public String getOTYPE() {
        return OTYPE;
    }

    public void setOTYPE(String OTYPE) {
        this.OTYPE = OTYPE;
    }

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getBIGO_TEXT() {
        return BIGO_TEXT;
    }

    public void setBIGO_TEXT(String BIGO_TEXT) {
        this.BIGO_TEXT = BIGO_TEXT;
    }

    public String getCMMNT() {
        return CMMNT;
    }

    public void setCMMNT(String CMMNT) {
        this.CMMNT = CMMNT;
    }

    public String getAPPR_DATE() {
        return APPR_DATE;
    }

    public void setAPPR_DATE(String APPR_DATE) {
        this.APPR_DATE = APPR_DATE;
    }

    public String getAPPR_TIME() {
        return APPR_TIME;
    }

    public void setAPPR_TIME(String APPR_TIME) {
        this.APPR_TIME = APPR_TIME;
    }

    public String getAPPR_STAT() {
        return APPR_STAT;
    }

    public void setAPPR_STAT(String APPR_STAT) {
        this.APPR_STAT = APPR_STAT;
    }

    public String getAPPR_STATX() {
        return APPR_STATX;
    }

    public void setAPPR_STATX(String APPR_STATX) {
        this.APPR_STATX = APPR_STATX;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
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

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }
}
