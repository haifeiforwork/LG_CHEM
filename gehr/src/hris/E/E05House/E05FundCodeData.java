package hris.E.E05House;

/**
 * E05FundCodeData.java
 *  자금용도를 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_GET_FUND_CODE
 *
 * @author lsa
 * @version 1.0, 2008/09/10
 */
public class E05FundCodeData extends com.sns.jdf.EntityData
{
    public String FUND_CODE; //자금용도 코드
    public String FUND_TEXT; //자금용도 텍스트
    public String DLART;     //대출유형
	public String getFUND_CODE() {
		return FUND_CODE;
	}
	public void setFUND_CODE(String fUND_CODE) {
		FUND_CODE = fUND_CODE;
	}
	public String getFUND_TEXT() {
		return FUND_TEXT;
	}
	public void setFUND_TEXT(String fUND_TEXT) {
		FUND_TEXT = fUND_TEXT;
	}
	public String getDLART() {
		return DLART;
	}
	public void setDLART(String dLART) {
		DLART = dLART;
	}
}
