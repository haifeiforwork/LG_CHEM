/*
 * �ۼ��� ��¥: 20013. 9. 23.
 *
 */
package hris.G;

/**
 * @author ������
 */
@SuppressWarnings("serial")
public class ApprovalCancelData extends com.sns.jdf.EntityData {

    public String PERNR;         // �����ȣ
    public String AINF_SEQN;     // ���������Ϸù�ȣ
    public String BEGDA;         // ��û��
    public String CANC_REASON;   // ������� ����
    public String ORG_AINF_SEQN; // �������� �Ϸù�ȣ
    public String ORG_BEGDA;     // ��û��
    public String ORG_UPMU_TYPE; // �� ���� ����
    public String ZPERNR;        // �븮��û�� ���
    public String AEDTM;         // ������
    public String UNAME;         // ������̸�
    public String APPL_FROM;     // ��û������
    public String APPL_TO;		 // ��û������
    public String APPL_REAS;     // ��û ����
    public String I_NTM;         // [WorkTime52] 

    public String getPERNR() {
        return PERNR;
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
    public String getCANC_REASON() {
        return CANC_REASON;
    }
    public void setCANC_REASON(String cANC_REASON) {
        CANC_REASON = cANC_REASON;
    }
    public String getORG_AINF_SEQN() {
        return ORG_AINF_SEQN;
    }
    public void setORG_AINF_SEQN(String oRG_AINF_SEQN) {
        ORG_AINF_SEQN = oRG_AINF_SEQN;
    }
    public String getORG_BEGDA() {
        return ORG_BEGDA;
    }
    public void setORG_BEGDA(String oRG_BEGDA) {
        ORG_BEGDA = oRG_BEGDA;
    }
    public String getORG_UPMU_TYPE() {
        return ORG_UPMU_TYPE;
    }
    public void setORG_UPMU_TYPE(String oRG_UPMU_TYPE) {
        ORG_UPMU_TYPE = oRG_UPMU_TYPE;
    }
    public String getZPERNR() {
        return ZPERNR;
    }
    public void setZPERNR(String zPERNR) {
        ZPERNR = zPERNR;
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
    public String getAPPL_REAS() {
        return APPL_REAS;
    }
    public void setAPPL_REAS(String aPPL_REAS) {
        APPL_REAS = aPPL_REAS;
    }
    public String getI_NTM() {
        return I_NTM;
    }
    public void setI_NTM(String i_NTM) {
        I_NTM = i_NTM;
    }

}