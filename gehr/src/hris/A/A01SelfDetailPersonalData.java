package hris.A;

import com.sns.jdf.EntityData;

/**
 * A01SelfDetailPersonalData.java
 * ���νŻ� ����Ÿ
 *   [���� RFC] : ZGHR_RFC_PERSONEL_EXTRA
 * 
 * @author ������
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailPersonalData extends EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	STRAS	;//	CHAR	200	�ּ�(����)
    public String 	PSTLZ	;//	CHAR	10	�����ȣ(����)
    public String 	STRAS1	;//	CHAR	200	�ּ�(���ּ�)
    public String 	PSTLZ1	;//	CHAR	10	�����ȣ(���ּ�)
    public String 	ZHEIGHT	;//	DEC	5	����
    public String 	ZWEIGHT	;//	DEC	5	ü��
    public String 	LSIGHT	;//	DEC	4	�÷�(��)
    public String 	RSIGHT	;//	DEC	 4 	�÷�(��)
    public String 	CBLIND	;//	CHAR	 1 	���Ϳ���
    public String 	BLDTYP	;//	CHAR	 25 	������
    public String 	HNDCD	;//	CHAR	 1 	��ֿ���
    public String 	ZTALEN	;//	CHAR	 20 	Ư��
    public String 	FATXT	;//	CHAR	 6 	��ȥ ����
    public String 	LIVETP	;//	CHAR	 20 	�ְ�����
    public String 	CONTX	;//	CHAR	 40 	���� ����-����
    public String 	ZHOBBY	;//	CHAR	 20 	���

    public String KTEXT;

    public String getKTEXT() {
        return KTEXT;
    }

    public void setKTEXT(String KTEXT) {
        this.KTEXT = KTEXT;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
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

    public String getZHEIGHT() {
        return ZHEIGHT;
    }

    public void setZHEIGHT(String ZHEIGHT) {
        this.ZHEIGHT = ZHEIGHT;
    }

    public String getZWEIGHT() {
        return ZWEIGHT;
    }

    public void setZWEIGHT(String ZWEIGHT) {
        this.ZWEIGHT = ZWEIGHT;
    }

    public String getLSIGHT() {
        return LSIGHT;
    }

    public void setLSIGHT(String LSIGHT) {
        this.LSIGHT = LSIGHT;
    }

    public String getRSIGHT() {
        return RSIGHT;
    }

    public void setRSIGHT(String RSIGHT) {
        this.RSIGHT = RSIGHT;
    }

    public String getCBLIND() {
        return CBLIND;
    }

    public void setCBLIND(String CBLIND) {
        this.CBLIND = CBLIND;
    }

    public String getBLDTYP() {
        return BLDTYP;
    }

    public void setBLDTYP(String BLDTYP) {
        this.BLDTYP = BLDTYP;
    }

    public String getHNDCD() {
        return HNDCD;
    }

    public void setHNDCD(String HNDCD) {
        this.HNDCD = HNDCD;
    }

    public String getZTALEN() {
        return ZTALEN;
    }

    public void setZTALEN(String ZTALEN) {
        this.ZTALEN = ZTALEN;
    }

    public String getFATXT() {
        return FATXT;
    }

    public void setFATXT(String FATXT) {
        this.FATXT = FATXT;
    }

    public String getLIVETP() {
        return LIVETP;
    }

    public void setLIVETP(String LIVETP) {
        this.LIVETP = LIVETP;
    }

    public String getCONTX() {
        return CONTX;
    }

    public void setCONTX(String CONTX) {
        this.CONTX = CONTX;
    }

    public String getZHOBBY() {
        return ZHOBBY;
    }

    public void setZHOBBY(String ZHOBBY) {
        this.ZHOBBY = ZHOBBY;
    }


}