package hris.E.E05House;

/**
 * E05PersLoanData.java
 * 주택융자에 관한 사원정보 데이타
 *   [관련 RFC] : ZHRW_RFC_GET_INFTY_0045
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 */
public class E05PersLoanData extends com.sns.jdf.EntityData
{
    public String PERNR;       // 사번
    public String BEGDA;       // 시작일
    public String ENDDA;       // 종료일
    public String DLART;       // 대출유형
    public String DARBT;       // 승인된 대출금액
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}
	public String getDLART() {
		return DLART;
	}
	public void setDLART(String dLART) {
		DLART = dLART;
	}
	public String getDARBT() {
		return DARBT;
	}
	public void setDARBT(String dARBT) {
		DARBT = dARBT;
	}



}
