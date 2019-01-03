package hris.E.E17Hospital ;

/**
 * E17HospitalData.java
 *  ����� �Ƿ�� �� ������ ��� ������
 *   [���� RFC] : ZHRW_RFC_MEDIC_LIST
 * 
 * @author �輺��
 * @version 1.0, 2002/01/08
 */
public class E17HospitalData extends com.sns.jdf.EntityData {
    public String BEGDA     ;      // ������
    public String MANDT     ;      // Ŭ���̾�Ʈ           
    public String PERNR     ;      // �����ȣ
    public String CTRL_NUMB ;      // ������ȣ
    public String AINF_SEQN ;      // �������� �Ϸù�ȣ
    public String MEDI_NAME ;      // �Ƿ���
    public String TELX_NUMB ;      // ��ȭ��ȣ
    public String EXAM_DATE ;      // ������
    public String MEDI_CODE ;      // �Կ�/�ܷ�
    public String MEDI_TEXT ;      // �Կ�/�ܷ�
    public String RCPT_CODE ;      // ������ ����
    public String RCPT_TEXT ;      // ������ ����
    public String RCPT_NUMB ;      // No. ��������ȣ
    public String EMPL_WONX ;      // ���� �ǳ��ξ�
    public String WAERS     ;      // ��ȭŰ
    public String COMP_WONX ;      // ȸ��������
//  2004�� �������� ���� ����ڵ�Ϲ�ȣ �ʵ� �߰� (3.7)
    public String MEDI_NUMB ;      // �Ƿ��� ����ڵ�Ϲ�ȣ
    public String MEDI_MTHD ;      // 05.12.26 add ������� (1:����, 2:�ſ�ī��)
    public String MEDI_YEAR ;      // 05.12.26 add ������������
    public String YTAX_WONX ;      // 06.01.17 add ��������ݿ���

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getMANDT() {
        return MANDT;
    }

    public void setMANDT(String MANDT) {
        this.MANDT = MANDT;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getCTRL_NUMB() {
        return CTRL_NUMB;
    }

    public void setCTRL_NUMB(String CTRL_NUMB) {
        this.CTRL_NUMB = CTRL_NUMB;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getMEDI_NAME() {
        return MEDI_NAME;
    }

    public void setMEDI_NAME(String MEDI_NAME) {
        this.MEDI_NAME = MEDI_NAME;
    }

    public String getTELX_NUMB() {
        return TELX_NUMB;
    }

    public void setTELX_NUMB(String TELX_NUMB) {
        this.TELX_NUMB = TELX_NUMB;
    }

    public String getEXAM_DATE() {
        return EXAM_DATE;
    }

    public void setEXAM_DATE(String EXAM_DATE) {
        this.EXAM_DATE = EXAM_DATE;
    }

    public String getMEDI_CODE() {
        return MEDI_CODE;
    }

    public void setMEDI_CODE(String MEDI_CODE) {
        this.MEDI_CODE = MEDI_CODE;
    }

    public String getMEDI_TEXT() {
        return MEDI_TEXT;
    }

    public void setMEDI_TEXT(String MEDI_TEXT) {
        this.MEDI_TEXT = MEDI_TEXT;
    }

    public String getRCPT_CODE() {
        return RCPT_CODE;
    }

    public void setRCPT_CODE(String RCPT_CODE) {
        this.RCPT_CODE = RCPT_CODE;
    }

    public String getRCPT_TEXT() {
        return RCPT_TEXT;
    }

    public void setRCPT_TEXT(String RCPT_TEXT) {
        this.RCPT_TEXT = RCPT_TEXT;
    }

    public String getRCPT_NUMB() {
        return RCPT_NUMB;
    }

    public void setRCPT_NUMB(String RCPT_NUMB) {
        this.RCPT_NUMB = RCPT_NUMB;
    }

    public String getEMPL_WONX() {
        return EMPL_WONX;
    }

    public void setEMPL_WONX(String EMPL_WONX) {
        this.EMPL_WONX = EMPL_WONX;
    }

    public String getWAERS() {
        return WAERS;
    }

    public void setWAERS(String WAERS) {
        this.WAERS = WAERS;
    }

    public String getCOMP_WONX() {
        return COMP_WONX;
    }

    public void setCOMP_WONX(String COMP_WONX) {
        this.COMP_WONX = COMP_WONX;
    }

    public String getMEDI_NUMB() {
        return MEDI_NUMB;
    }

    public void setMEDI_NUMB(String MEDI_NUMB) {
        this.MEDI_NUMB = MEDI_NUMB;
    }

    public String getMEDI_MTHD() {
        return MEDI_MTHD;
    }

    public void setMEDI_MTHD(String MEDI_MTHD) {
        this.MEDI_MTHD = MEDI_MTHD;
    }

    public String getMEDI_YEAR() {
        return MEDI_YEAR;
    }

    public void setMEDI_YEAR(String MEDI_YEAR) {
        this.MEDI_YEAR = MEDI_YEAR;
    }

    public String getYTAX_WONX() {
        return YTAX_WONX;
    }

    public void setYTAX_WONX(String YTAX_WONX) {
        this.YTAX_WONX = YTAX_WONX;
    }
}
