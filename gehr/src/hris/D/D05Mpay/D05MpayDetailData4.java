package	hris.D.D05Mpay;

/**
 * D05MpayDetailData4.java
 * export1������ ��ƿ��� ������
 *   [���� RFC] : ZGHR_GET_PAY_INFO
 *   
 *   UPDATE : [CSR ID:2575929] �����ް��� �߰�(SAP������ �ؿ��ް��������ް���� ����
 * 
 * @author �ֿ�ȣ    
 * @version 1.0, 2002/01/28
 * @update [CSR ID:2591949] �ؿ������ �޿����� ������û 
 */
public class D05MpayDetailData4 extends com.sns.jdf.EntityData {

    public String PERNR ;   // �����ȣ
    public String ENAME ;   // �����
    public String BUKRS ;   // ȸ���ڵ�
    public String ORGEH ;   // �ҼӺμ��ڵ�
    public String ORGTX ;   // ���������ؽ�Ʈ
    public String BET01 ;   // �����޾�
    public String BET02 ;   // �����Ѿ�
    public String BET03 ;   // �������޾�
    public String BET04 ;   // ���������
    public String BET05 ;   // �������ú�
    public String BET06 ;   // �����Ѿ�
    public String BET07 ;   // �������ټ�
    public String BET08 ;   // �����ֹμ�
    public String BET09 ;   // �����Ѿ�
    public String BET10 ;   // �ؿܼ���
    public String BET11 ;   // ��������
    public String BET12 ;   // ����net
    public String BET13 ;   // �����Աݾ�
    public String BET14 ;   // �ؿܼ۱ݾ�
    public String BET15 ;   // �ؿܼ۱ݾ�(����ȭ)
    public String BET18 ;   // ����� �ϱޱݾ�
    public String BET19 ;   //  
    public String BET20 ;   // �������ټ�(ȸ��δ�)
    public String BET21 ;   // �����ֹμ�(ȸ��δ�)
    public String WRK01 ;   // �����ϼ�
    public String WRK02 ;   // ����ް��ϼ�
    public String WRK03 ;   // �ܿ��ް��ϼ�
    public String ZRATE ;   // ȯ��
    public String ZCURR ;   // �����ȭ
    public String TRFNM;    //��ȣ  [CSR ID:1438060]
    public String DYBET;    //	������ �ӱ� ���� �ݾ�   [CSR ID:1438060]
    public String ZRATE1;    //USD ȯ�� [CSR ID:2575929]
    public String ZCURR1;    //	USD [CSR ID:2575929]
    public String ABROAD;    //�ؿܱ޿��ڿ���(B,C�� ��� ���޿����� �߰� ����)  [CSR ID:2591949]
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getBUKRS() {
		return BUKRS;
	}
	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}
	public String getBET01() {
		return BET01;
	}
	public void setBET01(String bET01) {
		BET01 = bET01;
	}
	public String getBET02() {
		return BET02;
	}
	public void setBET02(String bET02) {
		BET02 = bET02;
	}
	public String getBET03() {
		return BET03;
	}
	public void setBET03(String bET03) {
		BET03 = bET03;
	}
	public String getBET04() {
		return BET04;
	}
	public void setBET04(String bET04) {
		BET04 = bET04;
	}
	public String getBET05() {
		return BET05;
	}
	public void setBET05(String bET05) {
		BET05 = bET05;
	}
	public String getBET06() {
		return BET06;
	}
	public void setBET06(String bET06) {
		BET06 = bET06;
	}
	public String getBET07() {
		return BET07;
	}
	public void setBET07(String bET07) {
		BET07 = bET07;
	}
	public String getBET08() {
		return BET08;
	}
	public void setBET08(String bET08) {
		BET08 = bET08;
	}
	public String getBET09() {
		return BET09;
	}
	public void setBET09(String bET09) {
		BET09 = bET09;
	}
	public String getBET10() {
		return BET10;
	}
	public void setBET10(String bET10) {
		BET10 = bET10;
	}
	public String getBET11() {
		return BET11;
	}
	public void setBET11(String bET11) {
		BET11 = bET11;
	}
	public String getBET12() {
		return BET12;
	}
	public void setBET12(String bET12) {
		BET12 = bET12;
	}
	public String getBET13() {
		return BET13;
	}
	public void setBET13(String bET13) {
		BET13 = bET13;
	}
	public String getBET14() {
		return BET14;
	}
	public void setBET14(String bET14) {
		BET14 = bET14;
	}
	public String getBET15() {
		return BET15;
	}
	public void setBET15(String bET15) {
		BET15 = bET15;
	}
	public String getBET18() {
		return BET18;
	}
	public void setBET18(String bET18) {
		BET18 = bET18;
	}
	public String getBET19() {
		return BET19;
	}
	public void setBET19(String bET19) {
		BET19 = bET19;
	}
	public String getBET20() {
		return BET20;
	}
	public void setBET20(String bET20) {
		BET20 = bET20;
	}
	public String getBET21() {
		return BET21;
	}
	public void setBET21(String bET21) {
		BET21 = bET21;
	}
	public String getWRK01() {
		return WRK01;
	}
	public void setWRK01(String wRK01) {
		WRK01 = wRK01;
	}
	public String getWRK02() {
		return WRK02;
	}
	public void setWRK02(String wRK02) {
		WRK02 = wRK02;
	}
	public String getWRK03() {
		return WRK03;
	}
	public void setWRK03(String wRK03) {
		WRK03 = wRK03;
	}
	public String getZRATE() {
		return ZRATE;
	}
	public void setZRATE(String zRATE) {
		ZRATE = zRATE;
	}
	public String getZCURR() {
		return ZCURR;
	}
	public void setZCURR(String zCURR) {
		ZCURR = zCURR;
	}
	public String getTRFNM() {
		return TRFNM;
	}
	public void setTRFNM(String tRFNM) {
		TRFNM = tRFNM;
	}
	public String getDYBET() {
		return DYBET;
	}
	public void setDYBET(String dYBET) {
		DYBET = dYBET;
	}
	public String getZRATE1() {
		return ZRATE1;
	}
	public void setZRATE1(String zRATE1) {
		ZRATE1 = zRATE1;
	}
	public String getZCURR1() {
		return ZCURR1;
	}
	public void setZCURR1(String zCURR1) {
		ZCURR1 = zCURR1;
	}
	public String getABROAD() {
		return ABROAD;
	}
	public void setABROAD(String aBROAD) {
		ABROAD = aBROAD;
	}
    

}