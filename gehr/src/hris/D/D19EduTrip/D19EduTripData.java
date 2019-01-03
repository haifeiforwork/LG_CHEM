package	hris.D.D19EduTrip;

/**
 * D19EduTripData.java
 * ������ ����, �����û ������ ��ƿ��� ������
 *   [���� RFC] : ZHRW_RFC_HOLIDAY_REQUEST
 *
 * @author lsa
 * @version 1.0, 2006/08/08
 */
public class D19EduTripData extends com.sns.jdf.EntityData {
    public String PERNR       ;     // �����ȣ
    public String AINF_SEQN   ;     // �������� �Ϸù�ȣ
    public String BEGDA       ;	    // ��û��
    public String AWART       ;	    // �ٹ�/�޹� ����
    public String APPL_FROM   ;     // ��û������
    public String APPL_TO     ;	    // ��û������
    public String BEGUZ       ;	    // ���۽ð�
    public String ENDUZ       ;	    // ����ð�
    public String REASON      ;     // ��û ����
    public String AEDTM	      ;     //������
    public String UNAME	      ;     //������̸�
    public String OVTM_CODE   ;     //�����ڵ�
    public String OVTM_CODE2  ;     //�����ڵ�
    public String OVTM_CODE3  ;     //�����ڵ�
    public String OVTM_NAME   ;     //�����
    public String REMAIN_DATE ;	    // �ܿ��ް��ϼ�
    public String ZPERNR ;	    // �븮��û�ڻ��


	public String getPERNR() {
		return PERNR;
	}
	public String getZPERNR() {
		return ZPERNR;
	}
	public void setZPERNR(String zPERNR) {
		ZPERNR = zPERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
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
	public String getAWART() {
		return AWART;
	}
	public void setAWART(String aWART) {
		AWART = aWART;
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
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getAEDTM() {
		return AEDTM;
	}
	public void setAEDTM(String aEDTM) {
		AEDTM = aEDTM;
	}
	public String getUNAME() {
		return UNAME;
	}
	public void setUNAME(String uNAME) {
		UNAME = uNAME;
	}
	public String getOVTM_CODE() {
		return OVTM_CODE;
	}
	public void setOVTM_CODE(String oVTM_CODE) {
		OVTM_CODE = oVTM_CODE;
	}
	public String getOVTM_CODE2() {
		return OVTM_CODE2;
	}
	public void setOVTM_CODE2(String oVTM_CODE2) {
		OVTM_CODE2 = oVTM_CODE2;
	}
	public String getOVTM_CODE3() {
		return OVTM_CODE3;
	}
	public void setOVTM_CODE3(String oVTM_CODE3) {
		OVTM_CODE3 = oVTM_CODE3;
	}
	public String getOVTM_NAME() {
		return OVTM_NAME;
	}
	public void setOVTM_NAME(String oVTM_NAME) {
		OVTM_NAME = oVTM_NAME;
	}
	public String getREMAIN_DATE() {
		return REMAIN_DATE;
	}
	public void setREMAIN_DATE(String rEMAIN_DATE) {
		REMAIN_DATE = rEMAIN_DATE;
	}


}