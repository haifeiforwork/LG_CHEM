package	hris.A.A12Family;

/**
 * A12FamilyBuyangData.java
 * �ξ簡�� ��û ������
 *   [���� RFC] : ZHRH_RFC_FAMILY_BUYANG
 * 
 * @author �赵��    
 * @version 1.0, 2002/01/30
 */
public class A12FamilyBuyangData extends com.sns.jdf.EntityData {

    public String PERNR    ;    // �����ȣ
    public String BEGDA    ;    // ��û��
    public String AINF_SEQN;    // �������� �Ϸù�ȣ
    public String GUBUN    ;    // �ξ簡�� 'X' �������� ' '
    public String SUBTY    ;    // �Ϻ�����
    public String STEXT    ;    // �Ϻ������̸�
    public String OBJPS    ;    // ������Ʈ�ĺ�
    public String FNMHG    ;    // �̸�(�ѱ�)
    public String LNMHG    ;    // ��(�ѱ�)
    public String REGNO    ;    // �ֹε�Ϲ�ȣ
    public String FAJOB    ;    // ������������ ����
    public String DPTID    ;    // �ξ簡�� �������� ���� ������
    public String LIVID    ;    // ������ �Բ� �����ϴ� ������
    public String HNDID    ;    // ����ο� ���� ������
    public String CHDID    ;    // �ڳຸȣ����� ���� ����������
    public String HELID    ;    // �ǰ�����������
    public String FAMID    ;    // �������� ������
    
//  2002.10.31 ���������� ����
    public String APPL_DATE;    // �������� ���� ����
    public String LOSS_DATE;    // �������� ��� ����
    
    public String ZUNAME   ;    // �μ����� �̸�
    public String AEDTM    ;    // ������
    public String UNAME    ;    // ������̸�

//  2003.02.24 �ξ簡�� �������� �߰�����
    public String CANC_DATE;    // ��������
    public String CANC_CODE;    // �����ڵ�
    public String CANC_ETCD;    // �����ڵ� ��Ÿ ���ý� ��Ÿ�����Է�
    
// ���� ���� �߰� 
    public String ZPERNR;        // �븮 ��û�� ���
    public String DPTYP;         // �ξ� ���� ����
    public String BALID ;   // ���� ������ �ξ簡�� ������

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getGUBUN() {
        return GUBUN;
    }

    public void setGUBUN(String GUBUN) {
        this.GUBUN = GUBUN;
    }

    public String getSUBTY() {
        return SUBTY;
    }

    public void setSUBTY(String SUBTY) {
        this.SUBTY = SUBTY;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getOBJPS() {
        return OBJPS;
    }

    public void setOBJPS(String OBJPS) {
        this.OBJPS = OBJPS;
    }

    public String getFNMHG() {
        return FNMHG;
    }

    public void setFNMHG(String FNMHG) {
        this.FNMHG = FNMHG;
    }

    public String getLNMHG() {
        return LNMHG;
    }

    public void setLNMHG(String LNMHG) {
        this.LNMHG = LNMHG;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getFAJOB() {
        return FAJOB;
    }

    public void setFAJOB(String FAJOB) {
        this.FAJOB = FAJOB;
    }

    public String getDPTID() {
        return DPTID;
    }

    public void setDPTID(String DPTID) {
        this.DPTID = DPTID;
    }

    public String getLIVID() {
        return LIVID;
    }

    public void setLIVID(String LIVID) {
        this.LIVID = LIVID;
    }

    public String getHNDID() {
        return HNDID;
    }

    public void setHNDID(String HNDID) {
        this.HNDID = HNDID;
    }

    public String getCHDID() {
        return CHDID;
    }

    public void setCHDID(String CHDID) {
        this.CHDID = CHDID;
    }

    public String getHELID() {
        return HELID;
    }

    public void setHELID(String HELID) {
        this.HELID = HELID;
    }

    public String getFAMID() {
        return FAMID;
    }

    public void setFAMID(String FAMID) {
        this.FAMID = FAMID;
    }

    public String getAPPL_DATE() {
        return APPL_DATE;
    }

    public void setAPPL_DATE(String APPL_DATE) {
        this.APPL_DATE = APPL_DATE;
    }

    public String getLOSS_DATE() {
        return LOSS_DATE;
    }

    public void setLOSS_DATE(String LOSS_DATE) {
        this.LOSS_DATE = LOSS_DATE;
    }

    public String getZUNAME() {
        return ZUNAME;
    }

    public void setZUNAME(String ZUNAME) {
        this.ZUNAME = ZUNAME;
    }

    public String getAEDTM() {
        return AEDTM;
    }

    public void setAEDTM(String AEDTM) {
        this.AEDTM = AEDTM;
    }

    public String getUNAME() {
        return UNAME;
    }

    public void setUNAME(String UNAME) {
        this.UNAME = UNAME;
    }

    public String getCANC_DATE() {
        return CANC_DATE;
    }

    public void setCANC_DATE(String CANC_DATE) {
        this.CANC_DATE = CANC_DATE;
    }

    public String getCANC_CODE() {
        return CANC_CODE;
    }

    public void setCANC_CODE(String CANC_CODE) {
        this.CANC_CODE = CANC_CODE;
    }

    public String getCANC_ETCD() {
        return CANC_ETCD;
    }

    public void setCANC_ETCD(String CANC_ETCD) {
        this.CANC_ETCD = CANC_ETCD;
    }

    public String getZPERNR() {
        return ZPERNR;
    }

    public void setZPERNR(String ZPERNR) {
        this.ZPERNR = ZPERNR;
    }

    public String getDPTYP() {
        return DPTYP;
    }

    public void setDPTYP(String DPTYP) {
        this.DPTYP = DPTYP;
    }

    public String getBALID() {
        return BALID;
    }

    public void setBALID(String BALID) {
        this.BALID = BALID;
    }
}

