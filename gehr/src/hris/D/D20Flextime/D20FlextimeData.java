package hris.D.D20Flextime;

/**
 * D20FlextimeData.java 개인의 Flextime 신청 정보를 담아오는 데이터 [관련 RFC] :
 * ZGHR_RFC_FLEXTIME_REQUEST 2017-08-01 eunha [CSR ID:3438118] flexible time 시스템
 * Update 	: 2018-05-09 성환희 [WorkTime52] 부분/완전선택 근무제 변경
 * 
 * @author eunha
 * @version 1.0, 2017/08/02
 */
public class D20FlextimeData extends com.sns.jdf.EntityData {

	public String PERNR; // 사원 번호
	public String AINF_SEQN; // 결재정보 일련번호
	public String BEGDA; // 신청일
	public String FLEX_BEG; // 길이 6의 문자필드
	public String FLEX_END; // 길이 6의 문자필드
	public String SCHKZ; // 근무 일정 규칙
	public String ZEDESCR; // Description
	public String ZPERNR;
	public String AEDTM;
	public String UNAME;

	// [CSR ID:3525213] Flextime 시스템 변경 요청 start
	public String FLEX_BEGDA; // 시작일
	public String FLEX_ENDDA; // 종료일

	// [WorkTime52] 부분/완전선택 근무제 변경
	public String FLEX_BEGTM; // 근무시작시각
	public String FLEX_ENDTM; // 근무종료시각
	public String CR_UNAME; // 생성자
	public String CR_DATE; // 생성일
	public String CR_TIME; // 생성시간

	public String I_NTM;

	public String getI_NTM() {
		return I_NTM;
	}

	public void setI_NTM(String i_NTM) {
		I_NTM = i_NTM;
	}

	public String getFLEX_BEGTM() {
		return FLEX_BEGTM;
	}

	public void setFLEX_BEGTM(String fLEX_BEGTM) {
		FLEX_BEGTM = fLEX_BEGTM;
	}

	public String getFLEX_ENDTM() {
		return FLEX_ENDTM;
	}

	public void setFLEX_ENDTM(String fLEX_ENDTM) {
		FLEX_ENDTM = fLEX_ENDTM;
	}

	public String getCR_UNAME() {
		return CR_UNAME;
	}

	public void setCR_UNAME(String cR_UNAME) {
		CR_UNAME = cR_UNAME;
	}

	public String getCR_DATE() {
		return CR_DATE;
	}

	public void setCR_DATE(String cR_DATE) {
		CR_DATE = cR_DATE;
	}

	public String getCR_TIME() {
		return CR_TIME;
	}

	public void setCR_TIME(String cR_TIME) {
		CR_TIME = cR_TIME;
	}

	public String getFLEX_BEGDA() {
		return FLEX_BEGDA;
	}

	public void setFLEX_BEGDA(String fLEX_BEGDA) {
		FLEX_BEGDA = fLEX_BEGDA;
	}

	public String getFLEX_ENDDA() {
		return FLEX_ENDDA;
	}

	public void setFLEX_ENDDA(String fLEX_ENDDA) {
		FLEX_ENDDA = fLEX_ENDDA;
	}

	// [CSR ID:3525213] Flextime 시스템 변경 요청 end
	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getAINF_SEQN() {
		return AINF_SEQN;
	}

	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}

	public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}

	public String getFLEX_BEG() {
		return FLEX_BEG;
	}

	public void setFLEX_BEG(String fLEX_BEG) {
		FLEX_BEG = fLEX_BEG;
	}

	public String getFLEX_END() {
		return FLEX_END;
	}

	public void setFLEX_END(String fLEX_END) {
		FLEX_END = fLEX_END;
	}

	public String getSCHKZ() {
		return SCHKZ;
	}

	public void setSCHKZ(String sCHKZ) {
		SCHKZ = sCHKZ;
	}

	public String getZEDESCR() {
		return ZEDESCR;
	}

	public void setZEDESCR(String zEDESCR) {
		ZEDESCR = zEDESCR;
	}

	public String getZPERNR() {
		return ZPERNR;
	}

	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}

	public String getAEDTM() {
		return AEDTM;
	}

	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}

	public String getUNAME() {
		return UNAME;
	}

	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}

}