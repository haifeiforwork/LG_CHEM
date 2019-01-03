/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� 4���� ���ȭ ��                                    */
/*   Program ID   : F31Dept4YearValuationData                                   */
/*   Description  : �μ��� 4���� ���ȭ �� ��ȸ�� ���� DATA ����              */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-01 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F31Dept4YearValuationData
 *  �μ��� 4���� ���ȭ �� ������ ��� ������
 * 
 * @author �����
 * @version 1.0, 
 */
public class F31Dept4YearValuationData extends com.sns.jdf.EntityData {

    /* �ؿ� */
    public String 	ANNUL	;//	CHAR	 2 	Level Years

    /* ���� */
    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	ORGEH	;//	NUMC	8	���� ����
    public String 	ORGTX	;//	CHAR	40	�ҼӸ�
    public String 	ENAME	;//	CHAR	40	��� �Ǵ� �������� ���˵� �̸�
    public String 	BUKRS	;//	CHAR	4	ȸ�� �ڵ�
    public String 	WERKS	;//	CHAR	4	�λ� ����
    public String 	NAME1	;//	CHAR	30	�λ� ���� �ؽ�Ʈ
    public String 	BTRTL	;//	CHAR	4	�λ� ���� ����
    public String 	BTEXT	;//	CHAR	 15 	�λ� ���� ���� �ؽ�Ʈ
    public String 	PERSG	;//	CHAR	 1 	��� �׷�
    public String 	PGTXT	;//	CHAR	 20 	��� �׷� �̸�
    public String 	PERSK	;//	CHAR	 2 	��� ���� �׷�
    public String 	PKTXT	;//	CHAR	 20 	��� ���� �׷� �̸�
    public String 	STELL	;//	NUMC	 8 	����
    public String 	STLTX	;//	CHAR	 40 	������
    public String 	DAT01	;//	DATS	 8 	�׷��Ի���
    public String 	DAT02	;//	DATS	 8 	ȸ���Ի���
    public String 	DAT03	;//	DATS	 8 	������������
    public String 	DAT04	;//	DATS	 8 	�ټӱ�����
    public String 	JIKWE	;//	CHAR	 20 	����
    public String 	JIKWT	;//	CHAR	 40 	������
    public String 	JIKCH	;//	CHAR	 20 	����
    public String 	JIKCT	;//	CHAR	 40 	���޸�
    public String 	JIKKB	;//	CHAR	 20 	��å
    public String 	JIKKT	;//	CHAR	 40 	��å��
    public String 	MOLGA	;//	CHAR	 2 	���� �׷���
    public String 	PHONE_NUM	;//	CHAR	 20 	������� ��ȭ��ȣ
    public String 	TRFGR	;//	CHAR	 8 	ȣ�� �׷�
    public String 	TRFST	;//	CHAR	 2 	ȣ�� �ܰ�
    public String 	VGLST	;//	CHAR	 2 	�񱳱޿���������
    public String 	SHORT	;//	CHAR	 12 	������Ʈ ���
    public String 	D1	;//	CHAR	 40 	P-1
    public String 	D2	;//	CHAR	 40 	P-2
    public String 	D3	;//	CHAR	 40 	P-3
    public String 	D4	;//	CHAR	 40 	P-4

    public String getANNUL() {
        return ANNUL;
    }

    public void setANNUL(String ANNUL) {
        this.ANNUL = ANNUL;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getBUKRS() {
        return BUKRS;
    }

    public void setBUKRS(String BUKRS) {
        this.BUKRS = BUKRS;
    }

    public String getWERKS() {
        return WERKS;
    }

    public void setWERKS(String WERKS) {
        this.WERKS = WERKS;
    }

    public String getNAME1() {
        return NAME1;
    }

    public void setNAME1(String NAME1) {
        this.NAME1 = NAME1;
    }

    public String getBTRTL() {
        return BTRTL;
    }

    public void setBTRTL(String BTRTL) {
        this.BTRTL = BTRTL;
    }

    public String getBTEXT() {
        return BTEXT;
    }

    public void setBTEXT(String BTEXT) {
        this.BTEXT = BTEXT;
    }

    public String getPERSG() {
        return PERSG;
    }

    public void setPERSG(String PERSG) {
        this.PERSG = PERSG;
    }

    public String getPGTXT() {
        return PGTXT;
    }

    public void setPGTXT(String PGTXT) {
        this.PGTXT = PGTXT;
    }

    public String getPERSK() {
        return PERSK;
    }

    public void setPERSK(String PERSK) {
        this.PERSK = PERSK;
    }

    public String getPKTXT() {
        return PKTXT;
    }

    public void setPKTXT(String PKTXT) {
        this.PKTXT = PKTXT;
    }

    public String getSTELL() {
        return STELL;
    }

    public void setSTELL(String STELL) {
        this.STELL = STELL;
    }

    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }

    public String getDAT01() {
        return DAT01;
    }

    public void setDAT01(String DAT01) {
        this.DAT01 = DAT01;
    }

    public String getDAT02() {
        return DAT02;
    }

    public void setDAT02(String DAT02) {
        this.DAT02 = DAT02;
    }

    public String getDAT03() {
        return DAT03;
    }

    public void setDAT03(String DAT03) {
        this.DAT03 = DAT03;
    }

    public String getDAT04() {
        return DAT04;
    }

    public void setDAT04(String DAT04) {
        this.DAT04 = DAT04;
    }

    public String getJIKWE() {
        return JIKWE;
    }

    public void setJIKWE(String JIKWE) {
        this.JIKWE = JIKWE;
    }

    public String getJIKWT() {
        return JIKWT;
    }

    public void setJIKWT(String JIKWT) {
        this.JIKWT = JIKWT;
    }

    public String getJIKCH() {
        return JIKCH;
    }

    public void setJIKCH(String JIKCH) {
        this.JIKCH = JIKCH;
    }

    public String getJIKCT() {
        return JIKCT;
    }

    public void setJIKCT(String JIKCT) {
        this.JIKCT = JIKCT;
    }

    public String getJIKKB() {
        return JIKKB;
    }

    public void setJIKKB(String JIKKB) {
        this.JIKKB = JIKKB;
    }

    public String getJIKKT() {
        return JIKKT;
    }

    public void setJIKKT(String JIKKT) {
        this.JIKKT = JIKKT;
    }

    public String getMOLGA() {
        return MOLGA;
    }

    public void setMOLGA(String MOLGA) {
        this.MOLGA = MOLGA;
    }

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }

    public String getTRFGR() {
        return TRFGR;
    }

    public void setTRFGR(String TRFGR) {
        this.TRFGR = TRFGR;
    }

    public String getTRFST() {
        return TRFST;
    }

    public void setTRFST(String TRFST) {
        this.TRFST = TRFST;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getSHORT() {
        return SHORT;
    }

    public void setSHORT(String SHORT) {
        this.SHORT = SHORT;
    }

    public String getD1() {
        return D1;
    }

    public void setD1(String d1) {
        D1 = d1;
    }

    public String getD2() {
        return D2;
    }

    public void setD2(String d2) {
        D2 = d2;
    }

    public String getD3() {
        return D3;
    }

    public void setD3(String d3) {
        D3 = d3;
    }

    public String getD4() {
        return D4;
    }

    public void setD4(String d4) {
        D4 = d4;
    }
}
