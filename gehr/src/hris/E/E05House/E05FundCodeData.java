package hris.E.E05House;

/**
 * E05FundCodeData.java
 *  �ڱݿ뵵�� ��� ������
 *   [���� RFC] : ZHRW_RFC_GET_FUND_CODE
 *
 * @author lsa
 * @version 1.0, 2008/09/10
 */
public class E05FundCodeData extends com.sns.jdf.EntityData
{
    public String FUND_CODE; //�ڱݿ뵵 �ڵ�
    public String FUND_TEXT; //�ڱݿ뵵 �ؽ�Ʈ
    public String DLART;     //��������
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
