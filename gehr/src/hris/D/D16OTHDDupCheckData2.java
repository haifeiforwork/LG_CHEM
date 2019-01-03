package hris.D;

/**
 * D16OTHDDupCheckData2.java
 *  휴가 신청시 중복 체크를 위해 ZHRA024T 정보를 담아오는 데이터 구조
 *   [관련 RFC] : ZHRW_RFC_OTHD_DUP_CHECK
 * 
 * @author 배민규
 * @version 1.0, 2003/10/17
 */
public class D16OTHDDupCheckData2 extends com.sns.jdf.EntityData {
	public String AINF_SEQN	;		//결재정보 일련번호
    public String BEGDA     ;		//신청일
	public String APPL_FROM ;		//휴가시작일(upmu_type 18)
	public String APPL_TO   ;		//휴가종료일(upmu_type 18)
	public String AWART		;		//휴가유형(upmu_type 18)
    public String BEGUZ     ;		//시작시간
	public String ENDUZ		;		//종료시간
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
	public String getAPPL_FROM() {
		return APPL_FROM;
	}
	public void setAPPL_FROM(String aPPL_FROM) {
		APPL_FROM = aPPL_FROM;
	}
	public String getAPPL_TO() {
		return APPL_TO;
	}
	public void setAPPL_TO(String aPPL_TO) {
		APPL_TO = aPPL_TO;
	}
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
	}
	public String getBEGUZ() {
		return BEGUZ;
	}
	public void setBEGUZ(String bEGUZ) {
		BEGUZ = bEGUZ;
	}
	public String getENDUZ() {
		return ENDUZ;
	}
	public void setENDUZ(String eNDUZ) {
		ENDUZ = eNDUZ;
	}
	
}
