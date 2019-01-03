package	hris.A.A13Address;

/**
 * A13AddressNationData.java
 * ���� �ڵ�, ���� ��ƿ��� ������
 *   [���� RFC] : ZHRE_RFC_P_ADDRESS_NATION
 * 
 * @author �赵��    
 * @version 1.0, 2001/12/26
 */
public class A13AddressNationData extends com.sns.jdf.EntityData {

    public String LAND1;   // �����ڵ�
    public String LANDX;   // ������       - BIRTH ���
    public String NATIO;  //	NATIO	CHAR	15	0	����
    public String CNATIO; //	NATIO50	CHAR	50	0	���� (�ִ� 50����)    - �������� ���

    public String getLAND1() {
        return LAND1;
    }

    public void setLAND1(String LAND1) {
        this.LAND1 = LAND1;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getNATIO() {
        return NATIO;
    }

    public void setNATIO(String NATIO) {
        this.NATIO = NATIO;
    }

    public String getCNATIO() {
        return CNATIO;
    }

    public void setCNATIO(String CNATIO) {
        this.CNATIO = CNATIO;
    }
}
