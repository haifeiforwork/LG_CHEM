package	hris.D.D03Vocation;

/**
 * D03WorkPeriodData.java
 * ���� �Ⱓ �۾� ������ ��� ������
 *   [���� RFC] : ZHRP_RFC_GET_WORK_PERIOD
 *   Global ��ġ
 * 
 * @author �赵��    
 * @version 1.0, 2002/01/24
 */
public class D03WorkPeriodData extends com.sns.jdf.EntityData {
    public String BEGDA   ;     // ������
    public String BEGUZ   ;     // �ð� ������ ������Ʈ
    public String ENDUZ   ;			// �ð� ������ ������Ʈ
    public String FLAG    ;			// '01' : �ʰ��ٹ�, '02' : �ϰ�������
    public String CHK_0340;     // ���Ϻ�ٹ� ��û�������� üũ
    public String DAY;     // @csr1 ������ 1, ȭ���� 2, ������ 3, ..��:6  �Ͽ��� 7
	public String getBEGDA() {
		return BEGDA;
	}
	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
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
	public String getFLAG() {
		return FLAG;
	}
	public void setFLAG(String fLAG) {
		FLAG = fLAG;
	}
	public String getCHK_0340() {
		return CHK_0340;
	}
	public void setCHK_0340(String cHK_0340) {
		CHK_0340 = cHK_0340;
	}
	public String getDAY() {
		return DAY;
	}
	public void setDAY(String dAY) {
		DAY = dAY;
	}

}