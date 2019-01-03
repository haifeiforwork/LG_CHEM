package hris.D;

/**
 * D16OTHDDupCheckData2.java
 *  �ް� ��û�� �ߺ� üũ�� ���� ZHRA024T ������ ��ƿ��� ������ ����
 *   [���� RFC] : ZHRW_RFC_OTHD_DUP_CHECK
 * 
 * @author ��α�
 * @version 1.0, 2003/10/17
 */
public class D16OTHDDupCheckData2 extends com.sns.jdf.EntityData {
	public String AINF_SEQN	;		//�������� �Ϸù�ȣ
    public String BEGDA     ;		//��û��
	public String APPL_FROM ;		//�ް�������(upmu_type 18)
	public String APPL_TO   ;		//�ް�������(upmu_type 18)
	public String AWART		;		//�ް�����(upmu_type 18)
    public String BEGUZ     ;		//���۽ð�
	public String ENDUZ		;		//����ð�
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
	public String getAPPL_FROM() {
		return APPL_FROM;
	}
	public void setAPPL_FROM(String aPPL_FROM) {
		APPL_FROM = aPPL_FROM;
	}
	public String getAPPL_TO() {
		return APPL_TO;
	}
	public void setAPPL_TO(String aPPL_TO) {
		APPL_TO = aPPL_TO;
	}
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
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
	
}
