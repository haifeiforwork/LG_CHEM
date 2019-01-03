package hris.D.D03Vocation;

/**
 * D03CondolHolidaysData.java
 * 경조내역 조회
 * [관련 RFC] : ZHRW_RFC_GET_CONDOL_HOLIDAYS
 * @author 이선아
 * @version 1.0, 2008/03/11
 */
public class D03CondolHolidaysData extends com.sns.jdf.EntityData
{
    public String PERNR    ;       // 사원번호            
    public String AINF_SEQN;       // 결재정보 일련번호   
    public String BEGDA    ;       // 신청일              
    public String CONG_CODE;       // 경조내역            
    public String CONG_NAME;       // 경조내역코드명      
    public String RELA_CODE;       // 경조대상자관계코드  
    public String RELA_NAME;       // 경조대상자관계코드명
    public String CONG_DATE;       // 경조발생일          
    public String HOLI_CONT;       // 경조휴가  
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
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getCONG_NAME() {
		return CONG_NAME;
	}
	public void setCONG_NAME(String cONG_NAME) {
		CONG_NAME = cONG_NAME;
	}
	public String getRELA_CODE() {
		return RELA_CODE;
	}
	public void setRELA_CODE(String rELA_CODE) {
		RELA_CODE = rELA_CODE;
	}
	public String getRELA_NAME() {
		return RELA_NAME;
	}
	public void setRELA_NAME(String rELA_NAME) {
		RELA_NAME = rELA_NAME;
	}
	public String getCONG_DATE() {
		return CONG_DATE;
	}
	public void setCONG_DATE(String cONG_DATE) {
		CONG_DATE = cONG_DATE;
	}
	public String getHOLI_CONT() {
		return HOLI_CONT;
	}
	public void setHOLI_CONT(String hOLI_CONT) {
		HOLI_CONT = hOLI_CONT;
	}
    
}