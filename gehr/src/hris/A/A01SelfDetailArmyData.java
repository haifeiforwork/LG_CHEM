package hris.A;

import com.sns.jdf.EntityData;

/**
 * A01SelfDetailArmyData.java
 * ���� ����Ÿ
 *   [���� RFC] :  ZGHR_RFC_MILITARY_LIST_KR
 *
 * @author ������
 * @version 1.0, 2016/08/08
 */
public class A01SelfDetailArmyData extends EntityData {

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	BEGDA	;//	DATS	8	������
    public String 	ENDDA	;//	DATS	8	������
    public String 	PERIOD	;//	CHAR	40	�����Ⱓ
    public String 	SERUT	;//	CHAR	30	�ٹ��δ�
    public String 	TRAN_TYPE	;//	CHAR	4	��������
    public String 	TRAN_TEXT	;//	CHAR	10	�ǿ�����
    public String 	SERTY	;//	CHAR	2	��������
    public String 	SERTX	;//	CHAR	 20 	����
    public String 	MRANK	;//	CHAR	 2 	���
    public String 	RKTXT	;//	CHAR	 30 	��޸�
    public String 	PREAS	;//	CHAR	 2 	������ ������ ���� ����
    public String 	RTEXT	;//	CHAR	 30 	��������
    public String 	IDNUM	;//	CHAR	 15 	��������
    public String 	JOBCL	;//	CHAR	 4 	���� �з�
    public String 	JBTXT	;//	CHAR	 30 	��Ư��
    public String 	RSEXP	;//	CHAR	 40 	�����ǹ� ��������

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

    public String getSERUT() {
        return SERUT;
    }

    public void setSERUT(String SERUT) {
        this.SERUT = SERUT;
    }

    public String getTRAN_TYPE() {
        return TRAN_TYPE;
    }

    public void setTRAN_TYPE(String TRAN_TYPE) {
        this.TRAN_TYPE = TRAN_TYPE;
    }

    public String getTRAN_TEXT() {
        return TRAN_TEXT;
    }

    public void setTRAN_TEXT(String TRAN_TEXT) {
        this.TRAN_TEXT = TRAN_TEXT;
    }

    public String getSERTY() {
        return SERTY;
    }

    public void setSERTY(String SERTY) {
        this.SERTY = SERTY;
    }

    public String getSERTX() {
        return SERTX;
    }

    public void setSERTX(String SERTX) {
        this.SERTX = SERTX;
    }

    public String getMRANK() {
        return MRANK;
    }

    public void setMRANK(String MRANK) {
        this.MRANK = MRANK;
    }

    public String getRKTXT() {
        return RKTXT;
    }

    public void setRKTXT(String RKTXT) {
        this.RKTXT = RKTXT;
    }

    public String getPREAS() {
        return PREAS;
    }

    public void setPREAS(String PREAS) {
        this.PREAS = PREAS;
    }

    public String getRTEXT() {
        return RTEXT;
    }

    public void setRTEXT(String RTEXT) {
        this.RTEXT = RTEXT;
    }

    public String getIDNUM() {
        return IDNUM;
    }

    public void setIDNUM(String IDNUM) {
        this.IDNUM = IDNUM;
    }

    public String getJOBCL() {
        return JOBCL;
    }

    public void setJOBCL(String JOBCL) {
        this.JOBCL = JOBCL;
    }

    public String getJBTXT() {
        return JBTXT;
    }

    public void setJBTXT(String JBTXT) {
        this.JBTXT = JBTXT;
    }

    public String getRSEXP() {
        return RSEXP;
    }

    public void setRSEXP(String RSEXP) {
        this.RSEXP = RSEXP;
    }
}