package hris.E.E17Hospital ;

/**
 * E17ChildData.java
 *  ����� �ڳ� ����Ʈ�� ��� ������
 *   [���� RFC] : ZHRW_RFC_P_GUEN_CODE
 *
 * @author �赵��
 * @version 1.0, 2005/05/31
 * update: 	2018-04-23 cykim [CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� ��
 */
public class E17ChildData extends com.sns.jdf.EntityData {

    public String SUBTY    ;      // ��������
    public String OBJPS_21 ;      // �ڳ� ����
    public String REGNO    ;      // �ڳ� �ֹι�ȣ
    public String ENAME    ;      // �ڳ� �̸�
    public String DATUM_20 ;      // �Ƿ�� ������ �Ұ����� ���� ����
    // [CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� �� @�����/����/�ڳ� �Ƿ�� ��û�� ��� ���� ��ȥ�����, �Ի����� �ʵ� �߰�. start
    public String BEGDA;			//�Ի�����
    public String FAMDT;			//��ȥ�����

    public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String BEGDA) {
		this.BEGDA = BEGDA;
	}

	public String getFAMDT() {
		return FAMDT;
	}

	public void setFAMDT(String FAMDT) {
		this.FAMDT = FAMDT;
	}
	// [CSR ID:3658652] �Ƿ������ ��û �޴� ���� ��û�� �� @�����/����/�ڳ� �Ƿ�� ��û�� ��� ���� ��ȥ�����, �Ի����� �ʵ� �߰�. end

	public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getOBJPS_21() {
        return OBJPS_21;
    }

    public void setOBJPS_21(String OBJPS_21) {
        this.OBJPS_21 = OBJPS_21;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getDATUM_20() {
        return DATUM_20;
    }

    public void setDATUM_20(String DATUM_20) {
        this.DATUM_20 = DATUM_20;
    }
}
