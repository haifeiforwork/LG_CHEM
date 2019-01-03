package hris.A;

/**
 * A01SelfDetailData.java
 * ��������������ȸ ����Ÿ
 * [���� RFC] : ZHRH_RFC_INSA01
 *
 * @author �輺��
 * @version 1.0, 2001/12/17
 * update [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18
 */
public class A01SelfDetailData extends com.sns.jdf.EntityData {
    public String ORGEH;//	NUMC	8	���� ����
    public String CNAME1;//	CHAR	80	����(����)
    public String CNAME2;//	CHAR	80	����(����)
    public String ENAME;//	CHAR	40	����(����)
    public String WERKS;//	CHAR	4	�λ� ����
    public String NAME1;//	CHAR	30	ȸ��
    public String BTRTL;//	CHAR	 4 	�λ� ���� ����
    public String PERSG;//	CHAR	 1 	��� �׷�
    public String PGTXT;//	CHAR	 20 	�źб׷�
    public String PERSK;//	CHAR	 2 	��� ���� �׷�
    public String PKTXT;//	CHAR	 20 	�ź�
    public String STELL;//	NUMC	 8 	����
    public String DAT04;//	DATS	 8 	�ټӱ�����
    public String JIKWE;//	CHAR	 20 	����
    public String JIKWT;//	CHAR	 40 	������
    public String JIKCH;//	CHAR	 20 	����
    public String JIKCT;//	CHAR	 40 	���޸�
    public String JIKKB;//	CHAR	 20 	��å
    public String JIKKT;//	CHAR	 40 	��å��


    public String PERNR;  // �����ȣ
    public String ORGTX;  // ���������ؽ�Ʈ
    public String KNAME;  // �ѱ��̸�
    public String YNAME;  // �����̸�
    public String CNAME;  // �����̸�

    public String TITEL;  // ����
    public String GBDAT;  // �������
    public String REGNO;  // �ѱ���Ϲ�ȣ
    public String DAT02;  // ���������� ���� ����

    public String MGTXT;  // �߷ɻ�����
    public String STLTX;  // ������
    public String DAT03;  // ���������� ���� ����
    public String SLABS;  // �Ի���з�
    public String TITL2;  // ��å2

    public String BEGDA;  // ������
    public String BTEXT;  // �λ��������� �ؽ�Ʈ
    public String VGLST;  // ��ȣ/����
    public String DAT01;  // ���������� ���� ����
    public String LANDX;  // �����̸�

    public String STRAS;  // �ּ�
    public String PSTLZ;  // �����ȣ
    public String STRAS1;  // �ּ�
    public String PSTLZ1;  // �����ȣ
    public String NMF01;  // ��

    public String NMF02;  // ��
    public String NMF06;  // ��
    public String NMF07;  // ��
    public String FLAG;  // �Ϲ��÷���
    public String STEXT;  // ���õ� �ؽ�Ʈ

    public String FLAG1;  // ������ǰ���� �������� ������ ����� ������
    public String HBBY_TEXT;  // ���� 20
    public String FTEXT;  // ��ȥ����
    public String LIVE_TEXT;  // ���� 20
    public String KTEXT;  // ����, ����

    public String HBBY_TEXT1;  // ���� 20
    public String CONTX;  // ���������� kr�ؽ�Ʈ
    public String TRAN_TEXT;  // �������� TEXT
    public String SERTX;  // KR �����ǹ����� �ؽ�Ʈ
    public String IDNUM;  // �����ĺ���ȣ

    public String RTEXT;  // ��������ؽ�Ʈ(�⺻������Ÿ��)
    public String RKTXT;  // ����ؽ�Ʈ KR
    public String PERIOD;  // �Ⱓ
    public String JBTXT;  // �������޺з� �ؽ�Ʈ KR
    public String SERUT;  // �ٹ��δ�

    public String RSEXP;  // �����ǹ� ��������

    public String PHOTO;
    public String AGECN;    //	ZEHRAGE	CHAR	3	0	����

    public String GBORT;  //�����


    public String RACKY;    //		CHAR	 2 	Ethnic group
    public String LTEXT;    //		CHAR	 50 	���� Text
    public String PCODE	;    //	CHAR	 2 	Political status
    public String  PTEXT;    //		CHAR	 40 	��ġ����
    public String  CTEDT;    //		DATS	 8 	��ุ����
    public String  CTEDTX;    //		CHAR	 40 	��ุ����(��ȯ)

    public String BUTXT;
    public String CFNUM;    //�����ȣ

    //[CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
    public String JIKWT_M;  //������_����Ͽ�
    public String JIKKT_M;   //��å��_����Ͽ�
    public String JIK_M;       //����/��å_����Ͽ�
    //[CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end

    public String getCFNUM() {
        return CFNUM;
    }

    public void setCFNUM(String CFNUM) {
        this.CFNUM = CFNUM;
    }

    public String getBUTXT() {
        return BUTXT;
    }

    public void setBUTXT(String BUTXT) {
        this.BUTXT = BUTXT;
    }

    public String getAGECN() {
        return AGECN;
    }

    public void setAGECN(String AGECN) {
        this.AGECN = AGECN;
    }

    public String getORGEH() {
        return ORGEH;
    }

    public void setORGEH(String ORGEH) {
        this.ORGEH = ORGEH;
    }

    public String getCNAME1() {
        return CNAME1;
    }

    public void setCNAME1(String CNAME1) {
        this.CNAME1 = CNAME1;
    }

    public String getCNAME2() {
        return CNAME2;
    }

    public void setCNAME2(String CNAME2) {
        this.CNAME2 = CNAME2;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
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

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getORGTX() {
        return ORGTX;
    }

    public void setORGTX(String ORGTX) {
        this.ORGTX = ORGTX;
    }

    public String getKNAME() {
        return KNAME;
    }

    public void setKNAME(String KNAME) {
        this.KNAME = KNAME;
    }

    public String getYNAME() {
        return YNAME;
    }

    public void setYNAME(String YNAME) {
        this.YNAME = YNAME;
    }

    public String getCNAME() {
        return CNAME;
    }

    public void setCNAME(String CNAME) {
        this.CNAME = CNAME;
    }

    public String getTITEL() {
        return TITEL;
    }

    public void setTITEL(String TITEL) {
        this.TITEL = TITEL;
    }

    public String getGBDAT() {
        return GBDAT;
    }

    public void setGBDAT(String GBDAT) {
        this.GBDAT = GBDAT;
    }

    public String getREGNO() {
        return REGNO;
    }

    public void setREGNO(String REGNO) {
        this.REGNO = REGNO;
    }

    public String getPTEXT() {
        return PTEXT;
    }

    public void setPTEXT(String PTEXT) {
        this.PTEXT = PTEXT;
    }

    public String getDAT02() {
        return DAT02;
    }

    public void setDAT02(String DAT02) {
        this.DAT02 = DAT02;
    }

    public String getMGTXT() {
        return MGTXT;
    }

    public void setMGTXT(String MGTXT) {
        this.MGTXT = MGTXT;
    }

    public String getSTLTX() {
        return STLTX;
    }

    public void setSTLTX(String STLTX) {
        this.STLTX = STLTX;
    }

    public String getDAT03() {
        return DAT03;
    }

    public void setDAT03(String DAT03) {
        this.DAT03 = DAT03;
    }

    public String getSLABS() {
        return SLABS;
    }

    public void setSLABS(String SLABS) {
        this.SLABS = SLABS;
    }

    public String getTITL2() {
        return TITL2;
    }

    public void setTITL2(String TITL2) {
        this.TITL2 = TITL2;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
    }

    public String getBTEXT() {
        return BTEXT;
    }

    public void setBTEXT(String BTEXT) {
        this.BTEXT = BTEXT;
    }

    public String getVGLST() {
        return VGLST;
    }

    public void setVGLST(String VGLST) {
        this.VGLST = VGLST;
    }

    public String getDAT01() {
        return DAT01;
    }

    public void setDAT01(String DAT01) {
        this.DAT01 = DAT01;
    }

    public String getLANDX() {
        return LANDX;
    }

    public void setLANDX(String LANDX) {
        this.LANDX = LANDX;
    }

    public String getSTRAS() {
        return STRAS;
    }

    public void setSTRAS(String STRAS) {
        this.STRAS = STRAS;
    }

    public String getPSTLZ() {
        return PSTLZ;
    }

    public void setPSTLZ(String PSTLZ) {
        this.PSTLZ = PSTLZ;
    }

    public String getSTRAS1() {
        return STRAS1;
    }

    public void setSTRAS1(String STRAS1) {
        this.STRAS1 = STRAS1;
    }

    public String getPSTLZ1() {
        return PSTLZ1;
    }

    public void setPSTLZ1(String PSTLZ1) {
        this.PSTLZ1 = PSTLZ1;
    }

    public String getNMF01() {
        return NMF01;
    }

    public void setNMF01(String NMF01) {
        this.NMF01 = NMF01;
    }

    public String getNMF02() {
        return NMF02;
    }

    public void setNMF02(String NMF02) {
        this.NMF02 = NMF02;
    }

    public String getNMF06() {
        return NMF06;
    }

    public void setNMF06(String NMF06) {
        this.NMF06 = NMF06;
    }

    public String getNMF07() {
        return NMF07;
    }

    public void setNMF07(String NMF07) {
        this.NMF07 = NMF07;
    }

    public String getFLAG() {
        return FLAG;
    }

    public void setFLAG(String FLAG) {
        this.FLAG = FLAG;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getFLAG1() {
        return FLAG1;
    }

    public void setFLAG1(String FLAG1) {
        this.FLAG1 = FLAG1;
    }

    public String getHBBY_TEXT() {
        return HBBY_TEXT;
    }

    public void setHBBY_TEXT(String HBBY_TEXT) {
        this.HBBY_TEXT = HBBY_TEXT;
    }

    public String getFTEXT() {
        return FTEXT;
    }

    public void setFTEXT(String FTEXT) {
        this.FTEXT = FTEXT;
    }

    public String getLIVE_TEXT() {
        return LIVE_TEXT;
    }

    public void setLIVE_TEXT(String LIVE_TEXT) {
        this.LIVE_TEXT = LIVE_TEXT;
    }

    public String getKTEXT() {
        return KTEXT;
    }

    public void setKTEXT(String KTEXT) {
        this.KTEXT = KTEXT;
    }

    public String getHBBY_TEXT1() {
        return HBBY_TEXT1;
    }

    public void setHBBY_TEXT1(String HBBY_TEXT1) {
        this.HBBY_TEXT1 = HBBY_TEXT1;
    }

    public String getCONTX() {
        return CONTX;
    }

    public void setCONTX(String CONTX) {
        this.CONTX = CONTX;
    }

    public String getTRAN_TEXT() {
        return TRAN_TEXT;
    }

    public void setTRAN_TEXT(String TRAN_TEXT) {
        this.TRAN_TEXT = TRAN_TEXT;
    }

    public String getSERTX() {
        return SERTX;
    }

    public void setSERTX(String SERTX) {
        this.SERTX = SERTX;
    }

    public String getIDNUM() {
        return IDNUM;
    }

    public void setIDNUM(String IDNUM) {
        this.IDNUM = IDNUM;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getRKTXT() {
        return RKTXT;
    }

    public void setRKTXT(String RKTXT) {
        this.RKTXT = RKTXT;
    }

    public String getPERIOD() {
        return PERIOD;
    }

    public void setPERIOD(String PERIOD) {
        this.PERIOD = PERIOD;
    }

    public String getJBTXT() {
        return JBTXT;
    }

    public void setJBTXT(String JBTXT) {
        this.JBTXT = JBTXT;
    }

    public String getSERUT() {
        return SERUT;
    }

    public void setSERUT(String SERUT) {
        this.SERUT = SERUT;
    }

    public String getRSEXP() {
        return RSEXP;
    }

    public void setRSEXP(String RSEXP) {
        this.RSEXP = RSEXP;
    }

    public String getPHOTO() {
        return PHOTO;
    }

    public void setPHOTO(String PHOTO) {
        this.PHOTO = PHOTO;
    }


    public String getLTEXT() {
        return LTEXT;
    }

    public void setLTEXT(String LTEXT) {
        this.LTEXT = LTEXT;
    }

    public String getCTEDTX() {
        return CTEDTX;
    }

    public void setCTEDTX(String CTEDTX) {
        this.CTEDTX = CTEDTX;
    }

    public String getGBORT() {
        return GBORT;
    }

    public void setGBORT(String GBORT) {
        this.GBORT = GBORT;
    }

    public String getRACKY() {
        return RACKY;
    }

    public void setRACKY(String RACKY) {
        this.RACKY = RACKY;
    }

    public String getPCODE() {
        return PCODE;
    }

    public void setPCODE(String PCODE) {
        this.PCODE = PCODE;
    }

    public String getCTEDT() {
        return CTEDT;
    }

    public void setCTEDT(String CTEDT) {
        this.CTEDT = CTEDT;
    }

	public String getJIKWT_M() {
		return JIKWT_M;
	}

	public void setJIKWT_M(String jIKWT_M) {
		JIKWT_M = jIKWT_M;
	}

	public String getJIKKT_M() {
		return JIKKT_M;
	}

	public void setJIKKT_M(String jIKKT_M) {
		JIKKT_M = jIKKT_M;
	}

	public String getJIK_M() {
		return JIK_M;
	}

	public void setJIK_M(String jIK_M) {
		JIK_M = jIK_M;
	}
}