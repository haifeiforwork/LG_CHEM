package	hris.D.D03Vocation;

/**
 * D03WorkPeriodData.java
 * ���� �Ⱓ �۾� ������ ��� ������
 *   [���� RFC] : ZHRP_RFC_GET_WORK_PERIOD
 *
 * @author �赵��
 * @version 1.0, 2002/01/24
 */
public class D03VocationReasonData extends com.sns.jdf.EntityData {
    public String SCODE   ;     // �ڵ�
    public String STEXT   ;     // �ؽ�Ʈ
	public String getSCODE() {
		return SCODE;
	}
	public void setSCODE(String sCODE) {
		SCODE = sCODE;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}

}