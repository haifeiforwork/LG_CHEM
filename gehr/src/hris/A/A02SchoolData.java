package	hris.A;

/**
 * A02SchoolData.java
 *  �з»��� List �� ��ƿ��� ������
 *   [���� RFC] : ZHRH_RFC_INSA02
 *
 * @author �ڿ���
 * @version 1.0, 2001/12/17
 * @[CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û  2016-01-27
 */
public class A02SchoolData extends com.sns.jdf.EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	BEGDA	;//	DATS	8	������
    public String 	ENDDA	;//	DATS	8	������
    public String 	PERIOD	;//	CHAR	40	�Ⱓ
    public String 	SLART	;//	CHAR	2	�������
    public String 	SLTXT	;//	CHAR	20	�з�
    public String 	SCHCD	;//	CHAR	4	�б��ڵ�
    public String 	SCHTX	;//	CHAR	60	�б���
    public String 	SLTP1	;//	NUMC	 5 	����
    public String 	SLTP1X	;//	CHAR	 40 	������
    public String 	SLTP2	;//	NUMC	 5 	������
    public String 	SLTP2X	;//	CHAR	 40 	��������
    public String 	SLABS	;//	CHAR	 2 	��������
    public String 	SLATX	;//	CHAR	 80 	�������и�
    public String 	SOJAE	;//	CHAR	 100 	������
    public String 	EMARK	;//	CHAR	 4 	�Ի���з�

    //public String SLART_TEXT ; //�б� ����(���п�/���б�/����б�...) [CSR ID:2991671]

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

    public String getENDDA() {
        return ENDDA;
    }

    public void setENDDA(String ENDDA) {
        this.ENDDA = ENDDA;
    }

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }

    public String getSLART() {
        return SLART;
    }

    public void setSLART(String SLART) {
        this.SLART = SLART;
    }

    public String getSLTXT() {
        return SLTXT;
    }

    public void setSLTXT(String SLTXT) {
        this.SLTXT = SLTXT;
    }

    public String getSCHCD() {
        return SCHCD;
    }

    public void setSCHCD(String SCHCD) {
        this.SCHCD = SCHCD;
    }

    public String getSCHTX() {
        return SCHTX;
    }

    public void setSCHTX(String SCHTX) {
        this.SCHTX = SCHTX;
    }

    public String getSLTP1() {
        return SLTP1;
    }

    public void setSLTP1(String SLTP1) {
        this.SLTP1 = SLTP1;
    }

    public String getSLTP1X() {
        return SLTP1X;
    }

    public void setSLTP1X(String SLTP1X) {
        this.SLTP1X = SLTP1X;
    }

    public String getSLTP2() {
        return SLTP2;
    }

    public void setSLTP2(String SLTP2) {
        this.SLTP2 = SLTP2;
    }

    public String getSLTP2X() {
        return SLTP2X;
    }

    public void setSLTP2X(String SLTP2X) {
        this.SLTP2X = SLTP2X;
    }

    public String getSLABS() {
        return SLABS;
    }

    public void setSLABS(String SLABS) {
        this.SLABS = SLABS;
    }

    public String getSLATX() {
        return SLATX;
    }

    public void setSLATX(String SLATX) {
        this.SLATX = SLATX;
    }

    public String getSOJAE() {
        return SOJAE;
    }

    public void setSOJAE(String SOJAE) {
        this.SOJAE = SOJAE;
    }

    public String getEMARK() {
        return EMARK;
    }

    public void setEMARK(String EMARK) {
        this.EMARK = EMARK;
    }
}