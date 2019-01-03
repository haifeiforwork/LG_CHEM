/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ�                                                    */
/*   Program ID   : D01OTData                                                   */
/*   Description  : �ʰ� �ٹ������� �Է� ���� ������ ��� ������                */
/*   Note         : [���� RFC] : ZHRP_RFC_OVERTIME_WORK                         */
/*   Creation     : 2002-01-21  �ڿ���                                          */
/*   Update       : 2005-03-02  ������                                          */
/*                  2015-06-18  [CSR ID:2803878] �ʰ��ٹ� ��û Process ���� ��û */
/*                  2017-12-06  ������                                          */
/*                              [CSR ID:3544114] [LGCTW]Request of Global HR Portal system Compensatory Leave(����ʣ) function increasing  */
/*                  2018-06-14  [WorkTime52] I_NTM ���� �߰�                    */
/********************************************************************************/

package hris.D.D01OT;

@SuppressWarnings("serial")
public class D01OTData extends com.sns.jdf.EntityData {

	public String PERNR;      //�����ȣ
    public String AINF_SEQN;  //�������� �Ϸù�ȣ

    public String BEGDA;      //��û��
    public String WORK_DATE;  //������
    public String VTKEN;      //����������
    
    public String BEGUZ;      //���۽ð�
    public String ENDUZ;      //����ð�
    public String STDAZ;      //�ʰ��ٹ��ð�

    public String PBEG1;      //�޽Ľ���1
    public String PEND1;      //�޽�����1
    public String PUNB1;      //�����޽Ľð�1
    public String PBEZ1;      //�����޽Ľð�1

    public String PBEG2;      //�޽Ľ���2
    public String PEND2;      //�޽�����2
    public String PUNB2;      //�����޽Ľð�2
    public String PBEZ2;      //�����޽Ľð�2
    
    public String PBEG3;      //�޽Ľ���3
    public String PEND3;      //�޽�����3
    public String PUNB3;      //�����޽Ľð�3
    public String PBEZ3;      //�����޽Ľð�3

    public String PBEG4;      //�޽Ľ���4
    public String PEND4;      //�޽�����4
    public String PUNB4;      //�����޽Ľð�4
    public String PBEZ4;      //�����޽Ľð�4

    public String OVTM_CODE;   //�����ڵ� CSR ID:1546748
    public String OVTM_NAME;   //���ٹ���,�����   CSR ID:1546748
    public String REASON;      //��û����
    public String ZPERNR;      //�븮��û�ڻ��
    public String ZUNAME;      //�μ����� �̸�
    public String AEDTM;       //������
    public String UNAME;       //������̸�
    public String OVTM_DESC1;  //[CSR ID:2803878] �ʰ��ٹ� ȭ�� �׸� �߰� �� ����
    public String OVTM_DESC2;  //[CSR ID:2803878] �ʰ��ٹ� ȭ�� �׸� �߰� �� ����
    public String OVTM_DESC3;  //[CSR ID:2803878] �ʰ��ٹ� ȭ�� �׸� �߰� �� ����
    public String OVTM_DESC4;  //[CSR ID:2803878] �ʰ��ٹ� ȭ�� �׸� �߰� �� ����
    public String OVTM12YN;    //[CSR ID:2803878] 12�ð� �ʰ��̳� �׷��� �� ��û�Ұž�! N
    public String YN_FLAG;     //[CSR ID:2803878] 'Y'�� ��û ������ ���, 'N'�� ��û�� �����ϳ� �ʰ��ٹ������� �Ѿ. (������ : �ִ� 22�ð�, �繫�� : ���� 36�ð�)
    public String SUM;         //[CSR ID:2803878] ��û�ϰ� �ִ� ������ �ð��� �����Ͽ� �������� ��� �ִ�(��~��) �ʰ��ٹ� �ð�, �繫���� ��� ����(���� 21���� �̹� �� 20�� ����) �ʰ��ٹ� �ð� ��û�� �� ���� ���
    public String PERSON_FLAG; //[CSR ID:2803878]  ��û�ڰ� �繫������ ���������� �����ϴ� flag(������ : P, �繫�� : O)
    public String VERSL;       //[CSR ID:3544114] �ʰ��ٹ� ���� �� ����(G220���θ�) [��ü�ް� : 3, �ݾ׺��� : 0]  
    public String I_NTM;       //[WorkTime52]
    public String ZOVTYP;      //[WorkTime52]

    //Global
    public String ZREASON;
    public String ZRCODE;
    public String PERNR_D;

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
    public String getWORK_DATE() {
        return WORK_DATE;
    }
    public void setWORK_DATE(String wORK_DATE) {
        WORK_DATE = wORK_DATE;
    }
    public String getVTKEN() {
        return VTKEN;
    }
    public void setVTKEN(String vTKEN) {
        VTKEN = vTKEN;
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
    public String getSTDAZ() {
        return STDAZ;
    }
    public void setSTDAZ(String sTDAZ) {
        STDAZ = sTDAZ;
    }
    public String getPBEG1() {
        return PBEG1;
    }
    public void setPBEG1(String pBEG1) {
        PBEG1 = pBEG1;
    }
    public String getPEND1() {
        return PEND1;
    }
    public void setPEND1(String pEND1) {
        PEND1 = pEND1;
    }
    public String getPUNB1() {
        return PUNB1;
    }
    public void setPUNB1(String pUNB1) {
        PUNB1 = pUNB1;
    }
    public String getPBEZ1() {
        return PBEZ1;
    }
    public void setPBEZ1(String pBEZ1) {
        PBEZ1 = pBEZ1;
    }
    public String getPBEG2() {
        return PBEG2;
    }
    public void setPBEG2(String pBEG2) {
        PBEG2 = pBEG2;
    }
    public String getPEND2() {
        return PEND2;
    }
    public void setPEND2(String pEND2) {
        PEND2 = pEND2;
    }
    public String getPUNB2() {
        return PUNB2;
    }
    public void setPUNB2(String pUNB2) {
        PUNB2 = pUNB2;
    }
    public String getPBEZ2() {
        return PBEZ2;
    }
    public void setPBEZ2(String pBEZ2) {
        PBEZ2 = pBEZ2;
    }
    public String getPBEG3() {
        return PBEG3;
    }
    public void setPBEG3(String pBEG3) {
        PBEG3 = pBEG3;
    }
    public String getPEND3() {
        return PEND3;
    }
    public void setPEND3(String pEND3) {
        PEND3 = pEND3;
    }
    public String getPUNB3() {
        return PUNB3;
    }
    public void setPUNB3(String pUNB3) {
        PUNB3 = pUNB3;
    }
    public String getPBEZ3() {
        return PBEZ3;
    }
    public void setPBEZ3(String pBEZ3) {
        PBEZ3 = pBEZ3;
    }
    public String getPBEG4() {
        return PBEG4;
    }
    public void setPBEG4(String pBEG4) {
        PBEG4 = pBEG4;
    }
    public String getPEND4() {
        return PEND4;
    }
    public void setPEND4(String pEND4) {
        PEND4 = pEND4;
    }
    public String getPUNB4() {
        return PUNB4;
    }
    public void setPUNB4(String pUNB4) {
        PUNB4 = pUNB4;
    }
    public String getPBEZ4() {
        return PBEZ4;
    }
    public void setPBEZ4(String pBEZ4) {
        PBEZ4 = pBEZ4;
    }
    public String getREASON() {
        return REASON;
    }
    public void setREASON(String rEASON) {
        REASON = rEASON;
    }
    public String getZPERNR() {
        return ZPERNR;
    }
    public void setZPERNR(String zPERNR) {
        ZPERNR = zPERNR;
    }
    public String getZUNAME() {
        return ZUNAME;
    }
    public void setZUNAME(String zUNAME) {
        ZUNAME = zUNAME;
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
    public String getOVTM_NAME() {
        return OVTM_NAME;
    }
    public void setOVTM_NAME(String oVTM_NAME) {
        OVTM_NAME = oVTM_NAME;
    }
    public String getOVTM_DESC1() {
        return OVTM_DESC1;
    }
    public void setOVTM_DESC1(String oVTM_DESC1) {
        OVTM_DESC1 = oVTM_DESC1;
    }
    public String getOVTM_DESC2() {
        return OVTM_DESC2;
    }
    public void setOVTM_DESC2(String oVTM_DESC2) {
        OVTM_DESC2 = oVTM_DESC2;
    }
    public String getOVTM_DESC3() {
        return OVTM_DESC3;
    }
    public void setOVTM_DESC3(String oVTM_DESC3) {
        OVTM_DESC3 = oVTM_DESC3;
    }
    public String getOVTM_DESC4() {
        return OVTM_DESC4;
    }
    public void setOVTM_DESC4(String oVTM_DESC4) {
        OVTM_DESC4 = oVTM_DESC4;
    }
    public String getOVTM12YN() {
        return OVTM12YN;
    }
    public void setOVTM12YN(String oVTM12YN) {
        OVTM12YN = oVTM12YN;
    }
    public String getYN_FLAG() {
        return YN_FLAG;
    }
    public void setYN_FLAG(String yN_FLAG) {
        YN_FLAG = yN_FLAG;
    }
    public String getSUM() {
        return SUM;
    }
    public void setSUM(String sUM) {
        SUM = sUM;
    }
    public String getPERSON_FLAG() {
        return PERSON_FLAG;
    }
    public void setPERSON_FLAG(String pERSON_FLAG) {
        PERSON_FLAG = pERSON_FLAG;
    }
    public String getVERSL() {
        return VERSL;
    }
    public void setVERSL(String vERSL) {
        VERSL = vERSL;
    }
    public String getI_NTM() {
        return I_NTM;
    }
    public void setI_NTM(String i_NTM) {
        I_NTM = i_NTM;
    }
    public String getZOVTYP() {
        return ZOVTYP;
    }
    public void setZOVTYP(String zOVTYP) {
        ZOVTYP = zOVTYP;
    }
    public String getZREASON() {
        return ZREASON;
    }
    public void setZREASON(String zREASON) {
        ZREASON = zREASON;
    }
    public String getZRCODE() {
        return ZRCODE;
    }
    public void setZRCODE(String zRCODE) {
        ZRCODE = zRCODE;
    }
    public String getPERNR_D() {
        return PERNR_D;
    }
    public void setPERNR_D(String pERNR_D) {
        PERNR_D = pERNR_D;
    }
    
}