package hris.D.D15EmpPayInfo;

import com.sns.jdf.EntityData;

public class D15EmpPayTypeData extends EntityData {
	public String LGART;	//�ӱ� ����
	public String LGTXT;	//�ӱ� ���� ����
	public String ABTYZ;	//��� ���� �׷� �׷����� 1�� �ӱ� ���� �� �ӱ� ��������
	public String WKTYZ;	//�ֿ��ӱ����� �� �ӱ����������� ���� �λ���������
	public String KOMBI;	//��ȿ�� �Է�����

	/*�ؿ�*/
	public String INFTY;	//		CHAR	4	Infotype

	public String getINFTY() {
		return INFTY;
	}

	public void setINFTY(String INFTY) {
		this.INFTY = INFTY;
	}

	public String getLGART() {
		return LGART;
	}

	public void setLGART(String LGART) {
		this.LGART = LGART;
	}

	public String getLGTXT() {
		return LGTXT;
	}

	public void setLGTXT(String LGTXT) {
		this.LGTXT = LGTXT;
	}

	public String getABTYZ() {
		return ABTYZ;
	}

	public void setABTYZ(String ABTYZ) {
		this.ABTYZ = ABTYZ;
	}

	public String getWKTYZ() {
		return WKTYZ;
	}

	public void setWKTYZ(String WKTYZ) {
		this.WKTYZ = WKTYZ;
	}

	public String getKOMBI() {
		return KOMBI;
	}

	public void setKOMBI(String KOMBI) {
		this.KOMBI = KOMBI;
	}
}
