package hris.E.E19Congra;

/**
 * E19CongraDupCheckData.java
 * 경조금 중복신청 check
 * [관련 RFC] : ZHRW_RFC_CONGRA_DUP_CHECK
 *
 * @author  김도신
 * @version 1.0, 2003/03/04
 */
public class E19CongraDupCheckData extends com.sns.jdf.EntityData {

    public String CONG_CODE;        // 경조내역
    public String RELA_CODE;        // 경조대상자관계코드
    public String EREL_NAME;        // 경조대상성명
    public String INFO_FLAG;        // Infotype Data이면 'I', Temp Table Data이면 'T'
    public String AINF_SEQN;        // Temp Table을 Check할때 결재번호가 같은지도 Check한다.(수정시 필요)
	public String getCONG_CODE() {
		return CONG_CODE;
	}
	public void setCONG_CODE(String cONG_CODE) {
		CONG_CODE = cONG_CODE;
	}
	public String getRELA_CODE() {
		return RELA_CODE;
	}
	public void setRELA_CODE(String rELA_CODE) {
		RELA_CODE = rELA_CODE;
	}
	public String getEREL_NAME() {
		return EREL_NAME;
	}
	public void setEREL_NAME(String eREL_NAME) {
		EREL_NAME = eREL_NAME;
	}
	public String getINFO_FLAG() {
		return INFO_FLAG;
	}
	public void setINFO_FLAG(String iNFO_FLAG) {
		INFO_FLAG = iNFO_FLAG;
	}
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}



}