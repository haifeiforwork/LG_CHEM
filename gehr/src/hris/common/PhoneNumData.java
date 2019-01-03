package hris.common;

/**
 * PhoneNumData.java
 *  ��ȭ��ȣ ����
 *   [���� RFC] : ZHRW_RFC_GET_PHONE_NUM
 *
 * @author �輺��
 * @version 1.0, 2001/12/13
 * 						C20140416_24713 �����ݽ�û���ֹ��������߰�
 */
public class PhoneNumData extends com.sns.jdf.EntityData {
    public String E_PERNR     ;    //���
    public String E_CELL_PHONE;    //��û�� ��ȭ��ȣ
    public String E_PHONE_NUM ;    //��û�� ��ȭ��ȣ
    public String E_MAIL      ;    //���ͳݸ��� (SMTP) �ּ�
    public String E_ENAME     ;    //�̸�
    public String E_BUKRS     ;    //ȸ���ڵ�
    public String E_TITEL     ;    //��å
    public String E_TITL2     ;    //��å2
    public String E_ORGTX     ;    //�������� �ؽ�Ʈ
    public String E_IS_CHIEF  ;    //���翩��('Y':����, 'N':�񰣻�)
    public String E_STRAS     ;    //�ּ�1
    public String E_LOCAT     ;    //������ �ּ�
    public String E_REGNO     ;    //�ֹε�Ϲ�ȣ( - ����)
    public String E_OVERSEA   ;    //�ؿܱٹ��ڸ� "X" , �����ٹ��ڸ� ""
    public String E_TRFAR     ;    //�޿�����
    public String E_TRFGR     ;    //�޿��׷�
    public String E_TRFST     ;    //�޿�����
    public String E_VGLGR     ;    //�ι�° �޿������ �޿�����/����
    public String E_VGLST     ;    //�ι�°�޿���� ȣ��
    public String E_DAT03     ;    //�Ի���
    public String E_PERSK     ;    //�������׷�

    //  �μ����˻� �޴��� �߰��ϸ鼭 ���� �������� ����� �����ϱ� ���� �߰�
    public String E_DEPTC     ;    //�μ����˻��� ������ ������ ����
    public String E_RETIR     ;    //�����ڸ� ��ȸ ���� ����

    //  �λ����� ����ó �˻��� ���� �ش����� �����
    public String E_GRUP_NUMB ;    //�ش����� ����� ����
    //  ���簳�� �������� üũ�ϴ� �÷���
    public String E_GANSA     ;    //���簡 ���簳�������� �����Ѵ�.(�ش�����)
    // ���� ���� �ʵ� �߰�
    public String E_ORGEH     ;    // �����ڵ�
    public String E_REPRESENTATIVE;  // �븮��û
    public String E_AUTHORIZATION;   // ��������
    public String E_AUTHORIZATION2;   // ��������(ABCD) 20141125 ������D [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����
    public String E_TIMEADMIN;   // �μ����� �븮��û�ڿ��� 09.06.22

    public String E_OBJID     ;    // s-o �����ڵ�
    public String E_OBTXT     ;    // s-o ������
    public String E_WERKS     ;    // �λ翵��(EC00 �̸� �ؿܹ���)
    public String E_RECON     ;    // ��������('D'-���'S'-��ȥ'Y'-����)
    public String E_REDAY     ;    // ��������


    public String E_CFLAG; // C20140416_24713  ���տ� ����
    public String E_PTEXT; // C20140416_24713  ��� ���� �׷� �̸�
    public String E_BTRTL; // C20140416_24713  �λ� ���� ����
    public String E_BTEXT; // C20140416_24713   �λ� ���� ���� �ؽ�Ʈ
    public String E_GBDAT; // [CSR ID:2596828] �������


    public String E_JIKWT;
    public String E_JIKKT;
    public String E_DAT01;
    public String E_MOLGA;

    public String E_PERSG;
    //�ʰ��ٷ�
    public String E_JIKKB;

    public String getE_PERNR() {
        return E_PERNR;
    }

    public void setE_PERNR(String e_PERNR) {
        E_PERNR = e_PERNR;
    }

    public String getE_CELL_PHONE() {
        return E_CELL_PHONE;
    }

    public void setE_CELL_PHONE(String e_CELL_PHONE) {
        E_CELL_PHONE = e_CELL_PHONE;
    }

    public String getE_PHONE_NUM() {
        return E_PHONE_NUM;
    }

    public void setE_PHONE_NUM(String e_PHONE_NUM) {
        E_PHONE_NUM = e_PHONE_NUM;
    }

    public String getE_MAIL() {
        return E_MAIL;
    }

    public void setE_MAIL(String e_MAIL) {
        E_MAIL = e_MAIL;
    }

    public String getE_ENAME() {
        return E_ENAME;
    }

    public void setE_ENAME(String e_ENAME) {
        E_ENAME = e_ENAME;
    }

    public String getE_BUKRS() {
        return E_BUKRS;
    }

    public void setE_BUKRS(String e_BUKRS) {
        E_BUKRS = e_BUKRS;
    }

    public String getE_TITEL() {
        return E_TITEL;
    }

    public void setE_TITEL(String e_TITEL) {
        E_TITEL = e_TITEL;
    }

    public String getE_TITL2() {
        return E_TITL2;
    }

    public void setE_TITL2(String e_TITL2) {
        E_TITL2 = e_TITL2;
    }

    public String getE_ORGTX() {
        return E_ORGTX;
    }

    public void setE_ORGTX(String e_ORGTX) {
        E_ORGTX = e_ORGTX;
    }

    public String getE_IS_CHIEF() {
        return E_IS_CHIEF;
    }

    public void setE_IS_CHIEF(String e_IS_CHIEF) {
        E_IS_CHIEF = e_IS_CHIEF;
    }

    public String getE_STRAS() {
        return E_STRAS;
    }

    public void setE_STRAS(String e_STRAS) {
        E_STRAS = e_STRAS;
    }

    public String getE_LOCAT() {
        return E_LOCAT;
    }

    public void setE_LOCAT(String e_LOCAT) {
        E_LOCAT = e_LOCAT;
    }

    public String getE_REGNO() {
        return E_REGNO;
    }

    public void setE_REGNO(String e_REGNO) {
        E_REGNO = e_REGNO;
    }

    public String getE_OVERSEA() {
        return E_OVERSEA;
    }

    public void setE_OVERSEA(String e_OVERSEA) {
        E_OVERSEA = e_OVERSEA;
    }

    public String getE_TRFAR() {
        return E_TRFAR;
    }

    public void setE_TRFAR(String e_TRFAR) {
        E_TRFAR = e_TRFAR;
    }

    public String getE_TRFGR() {
        return E_TRFGR;
    }

    public void setE_TRFGR(String e_TRFGR) {
        E_TRFGR = e_TRFGR;
    }

    public String getE_TRFST() {
        return E_TRFST;
    }

    public void setE_TRFST(String e_TRFST) {
        E_TRFST = e_TRFST;
    }

    public String getE_VGLGR() {
        return E_VGLGR;
    }

    public void setE_VGLGR(String e_VGLGR) {
        E_VGLGR = e_VGLGR;
    }

    public String getE_VGLST() {
        return E_VGLST;
    }

    public void setE_VGLST(String e_VGLST) {
        E_VGLST = e_VGLST;
    }

    public String getE_DAT03() {
        return E_DAT03;
    }

    public void setE_DAT03(String e_DAT03) {
        E_DAT03 = e_DAT03;
    }

    public String getE_PERSK() {
        return E_PERSK;
    }

    public void setE_PERSK(String e_PERSK) {
        E_PERSK = e_PERSK;
    }

    public String getE_DEPTC() {
        return E_DEPTC;
    }

    public void setE_DEPTC(String e_DEPTC) {
        E_DEPTC = e_DEPTC;
    }

    public String getE_RETIR() {
        return E_RETIR;
    }

    public void setE_RETIR(String e_RETIR) {
        E_RETIR = e_RETIR;
    }

    public String getE_GRUP_NUMB() {
        return E_GRUP_NUMB;
    }

    public void setE_GRUP_NUMB(String e_GRUP_NUMB) {
        E_GRUP_NUMB = e_GRUP_NUMB;
    }

    public String getE_GANSA() {
        return E_GANSA;
    }

    public void setE_GANSA(String e_GANSA) {
        E_GANSA = e_GANSA;
    }

    public String getE_ORGEH() {
        return E_ORGEH;
    }

    public void setE_ORGEH(String e_ORGEH) {
        E_ORGEH = e_ORGEH;
    }

    public String getE_REPRESENTATIVE() {
        return E_REPRESENTATIVE;
    }

    public void setE_REPRESENTATIVE(String e_REPRESENTATIVE) {
        E_REPRESENTATIVE = e_REPRESENTATIVE;
    }

    public String getE_AUTHORIZATION() {
        return E_AUTHORIZATION;
    }

    public void setE_AUTHORIZATION(String e_AUTHORIZATION) {
        E_AUTHORIZATION = e_AUTHORIZATION;
    }

    public String getE_AUTHORIZATION2() {
        return E_AUTHORIZATION2;
    }

    public void setE_AUTHORIZATION2(String e_AUTHORIZATION2) {
        E_AUTHORIZATION2 = e_AUTHORIZATION2;
    }

    public String getE_TIMEADMIN() {
        return E_TIMEADMIN;
    }

    public void setE_TIMEADMIN(String e_TIMEADMIN) {
        E_TIMEADMIN = e_TIMEADMIN;
    }

    public String getE_OBJID() {
        return E_OBJID;
    }

    public void setE_OBJID(String e_OBJID) {
        E_OBJID = e_OBJID;
    }

    public String getE_OBTXT() {
        return E_OBTXT;
    }

    public void setE_OBTXT(String e_OBTXT) {
        E_OBTXT = e_OBTXT;
    }

    public String getE_WERKS() {
        return E_WERKS;
    }

    public void setE_WERKS(String e_WERKS) {
        E_WERKS = e_WERKS;
    }

    public String getE_RECON() {
        return E_RECON;
    }

    public void setE_RECON(String e_RECON) {
        E_RECON = e_RECON;
    }

    public String getE_REDAY() {
        return E_REDAY;
    }

    public void setE_REDAY(String e_REDAY) {
        E_REDAY = e_REDAY;
    }

    public String getE_CFLAG() {
        return E_CFLAG;
    }

    public void setE_CFLAG(String e_CFLAG) {
        E_CFLAG = e_CFLAG;
    }

    public String getE_PTEXT() {
        return E_PTEXT;
    }

    public void setE_PTEXT(String e_PTEXT) {
        E_PTEXT = e_PTEXT;
    }

    public String getE_BTRTL() {
        return E_BTRTL;
    }

    public void setE_BTRTL(String e_BTRTL) {
        E_BTRTL = e_BTRTL;
    }

    public String getE_BTEXT() {
        return E_BTEXT;
    }

    public void setE_BTEXT(String e_BTEXT) {
        E_BTEXT = e_BTEXT;
    }

    public String getE_GBDAT() {
        return E_GBDAT;
    }

    public void setE_GBDAT(String e_GBDAT) {
        E_GBDAT = e_GBDAT;
    }

    public String getE_JIKWT() {
        return E_JIKWT;
    }

    public void setE_JIKWT(String e_JIKWT) {
        E_JIKWT = e_JIKWT;
    }

    public String getE_JIKKT() {
        return E_JIKKT;
    }

    public void setE_JIKKT(String e_JIKKT) {
        E_JIKKT = e_JIKKT;
    }

    public String getE_DAT01() {
        return E_DAT01;
    }

    public void setE_DAT01(String e_DAT01) {
        E_DAT01 = e_DAT01;
    }

    public String getE_MOLGA() {
        return E_MOLGA;
    }

    public void setE_MOLGA(String e_MOLGA) {
        E_MOLGA = e_MOLGA;
    }

    public String getE_PERSG() {
        return E_PERSG;
    }

    public void setE_PERSG(String e_PERSG) {
        E_PERSG = e_PERSG;
    }
}
