package hris.D.D01OT;

/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ� ���� ��û- �Ǳٹ� ���� ��ȸ RFC                                        */
/*   Program Name : �ʰ��ٹ� ���� ��û- �Ǳٹ� ���� ��ȸ RFC                                        */
/*   Program ID   : D01OTAfterWorkTimeDATA                                      */
/*   Description  : �ʰ��ٹ� ���� ��û- �Ǳٹ� ���� ��ȸ RFC ( �繫�� )         */
/*   Note         : [���� RFC] : ZGHR_RFC_NTM_AFTOT_RWINFO                      */
/*   Creation     : 2018-06-11  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

@SuppressWarnings("serial")
public class D01OTAfterWorkTimeDATA extends com.sns.jdf.EntityData {

    public String PERNR;            //��� ��ȣ
    public String AINF_SEQN; 		 //�������� �Ϸù�ȣ
    public String BUKRS;            //ȸ�� �ڵ�
    public String EMPGUB;           //��� ����
    public String TPGUB;            //��� �ٹ�����
    public String WKDAT;            //����
    public String BEGUZ;            //���� �ð�
    public String ENDUZ;            //���� �ð�
    public String ABEGUZ01;         //�����簳 �ð�1 ����
    public String AENDUZ01;         //�����簳 �ð�1 ����
    public String AREWK01;          //�����簳 �ð�1
    public String ABEGUZ02;         //�����簳 �ð�2 ����
    public String AENDUZ02;         //�����簳 �ð�2 ����
    public String AREWK02;          //�����簳 �ð�2
    public String BASTM;            //�⺻�ٹ��ð�
    public String MAXTM;            //�ִ�ٹ����ɽð�
    public String PDUNB;            //�ްԽð�
    public String ABSTD;            //��ٹ��ð�(��)
    public String PDABS;            //�ް�/��ٹ��ð�
    public String STDAZ;            //�ٹ� �ð�
    public String AREWK;            //�����簳 �ð� (�հ�)
    public String TOTAL;            //�ٹ� �ð�

    public String NRQPST;           //�����ʰ� ��û���ɽð�
    public String RRQPST;           //�����簳 ��û���ɽð�
    public String RQPST;            //��û���ɽð�
    public String CPDUNB;           //�����޽ıⰣ
    public String CABSTD;           //��ٹ��ð�(��)
    public String CPDABS;           //�ް�/��ٹ��ð�
    public String CSTDAZ;           //�����ð�
    public String CAREWK;           //�����簳�ð�
    public String CTOTAL;           //�հ�
    public String CNRQPST;          //�����ʰ� ��û����
    public String CRRQPST;          //�����簳 ��û����
    public String CRQPST;           //��û���ɽð�
    public String NRFLGG;           //�����ʰ� ��û���� flag
    public String R01FLG;           //�����簳 1 ��û���� flag
    public String R02FLG;           //�����簳 2 ��û���� flag
    public String ZOVTYP;           //����

    public String E_EMPGUB;         //��� ����
    public String E_TPGUB;          //��� �ٹ�����
    public String E_WKDYN;          //���Ͽ���
    public String E_PRECHECK;       //ESS ���ϱٹ� ������ Ȱ��ȭ ����

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
    public String getBUKRS() {
        return BUKRS;
    }
    public void setBUKRS(String bUKRS) {
        BUKRS = bUKRS;
    }
    public String getEMPGUB() {
        return EMPGUB;
    }
    public void setEMPGUB(String eMPGUB) {
        EMPGUB = eMPGUB;
    }
    public String getTPGUB() {
        return TPGUB;
    }
    public void setTPGUB(String tPGUB) {
        TPGUB = tPGUB;
    }
    public String getWKDAT() {
        return WKDAT;
    }
    public void setWKDAT(String wKDAT) {
        WKDAT = wKDAT;
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
    public String getABEGUZ01() {
        return ABEGUZ01;
    }
    public void setABEGUZ01(String aBEGUZ01) {
        ABEGUZ01 = aBEGUZ01;
    }
    public String getAENDUZ01() {
        return AENDUZ01;
    }
    public void setAENDUZ01(String aENDUZ01) {
        AENDUZ01 = aENDUZ01;
    }
    public String getAREWK01() {
        return AREWK01;
    }
    public void setAREWK01(String aREWK01) {
        AREWK01 = aREWK01;
    }
    public String getABEGUZ02() {
        return ABEGUZ02;
    }
    public void setABEGUZ02(String aBEGUZ02) {
        ABEGUZ02 = aBEGUZ02;
    }
    public String getAENDUZ02() {
        return AENDUZ02;
    }
    public void setAENDUZ02(String aENDUZ02) {
        AENDUZ02 = aENDUZ02;
    }
    public String getAREWK02() {
        return AREWK02;
    }
    public void setAREWK02(String aREWK02) {
        AREWK02 = aREWK02;
    }
    public String getBASTM() {
        return BASTM;
    }
    public void setBASTM(String bASTM) {
        BASTM = bASTM;
    }
    public String getMAXTM() {
        return MAXTM;
    }
    public void setMAXTM(String mAXTM) {
        MAXTM = mAXTM;
    }
    public String getPDUNB() {
        return PDUNB;
    }
    public void setPDUNB(String pDUNB) {
        PDUNB = pDUNB;
    }
    public String getABSTD() {
        return ABSTD;
    }
    public void setABSTD(String aBSTD) {
        ABSTD = aBSTD;
    }
    public String getPDABS() {
        return PDABS;
    }
    public void setPDABS(String pDABS) {
        PDABS = pDABS;
    }
    public String getSTDAZ() {
        return STDAZ;
    }
    public void setSTDAZ(String sTDAZ) {
        STDAZ = sTDAZ;
    }
    public String getAREWK() {
        return AREWK;
    }
    public void setAREWK(String aREWK) {
        AREWK = aREWK;
    }
    public String getTOTAL() {
        return TOTAL;
    }
    public void setTOTAL(String tOTAL) {
        TOTAL = tOTAL;
    }
    public String getNRQPST() {
        return NRQPST;
    }
    public void setNRQPST(String nRQPST) {
        NRQPST = nRQPST;
    }
    public String getRRQPST() {
        return RRQPST;
    }
    public void setRRQPST(String rRQPST) {
        RRQPST = rRQPST;
    }
    public String getRQPST() {
        return RQPST;
    }
    public void setRQPST(String rQPST) {
        RQPST = rQPST;
    }
    public String getCPDUNB() {
        return CPDUNB;
    }
    public void setCPDUNB(String cPDUNB) {
        CPDUNB = cPDUNB;
    }
    public String getCABSTD() {
        return CABSTD;
    }
    public void setCABSTD(String cABSTD) {
        CABSTD = cABSTD;
    }
    public String getCPDABS() {
        return CPDABS;
    }
    public void setCPDABS(String cPDABS) {
        CPDABS = cPDABS;
    }
    public String getCSTDAZ() {
        return CSTDAZ;
    }
    public void setCSTDAZ(String cSTDAZ) {
        CSTDAZ = cSTDAZ;
    }
    public String getCAREWK() {
        return CAREWK;
    }
    public void setCAREWK(String cAREWK) {
        CAREWK = cAREWK;
    }
    public String getCTOTAL() {
        return CTOTAL;
    }
    public void setCTOTAL(String cTOTAL) {
        CTOTAL = cTOTAL;
    }
    public String getCNRQPST() {
        return CNRQPST;
    }
    public void setCNRQPST(String cNRQPST) {
        CNRQPST = cNRQPST;
    }
    public String getCRRQPST() {
        return CRRQPST;
    }
    public void setCRRQPST(String cRRQPST) {
        CRRQPST = cRRQPST;
    }
    public String getCRQPST() {
        return CRQPST;
    }
    public void setCRQPST(String cRQPST) {
        CRQPST = cRQPST;
    }
    public String getNRFLGG() {
        return NRFLGG;
    }
    public void setNRFLGG(String nRFLGG) {
        NRFLGG = nRFLGG;
    }
    public String getR01FLG() {
        return R01FLG;
    }
    public void setR01FLG(String r01flg) {
        R01FLG = r01flg;
    }
    public String getR02FLG() {
        return R02FLG;
    }
    public void setR02FLG(String r02flg) {
        R02FLG = r02flg;
    }
    public String getZOVTYP() {
        return ZOVTYP;
    }
    public void setZOVTYP(String zovtyp) {
    	ZOVTYP = zovtyp;
    }
    public String getE_EMPGUB() {
        return E_EMPGUB;
    }
    public void setE_EMPGUB(String e_EMPGUB) {
        E_EMPGUB = e_EMPGUB;
    }
    public String getE_TPGUB() {
        return E_TPGUB;
    }
    public void setE_TPGUB(String e_TPGUB) {
        E_TPGUB = e_TPGUB;
    }
    public String getE_WKDYN() {
        return E_WKDYN;
    }
    public void setE_WKDYN(String e_WKDYN) {
        E_WKDYN = e_WKDYN;
    }
    public String getE_PRECHECK() {
        return E_PRECHECK;
    }
    public void setE_PRECHECK(String e_PRECHECK) {
        E_PRECHECK = e_PRECHECK;
    }

}