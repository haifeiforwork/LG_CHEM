/*
 * �ۼ��� ��¥: 2005. 1. 31.
 *
 */
package hris.G.G001Approval;

import com.sns.jdf.EntityData;

/**
 * @author �̽���
 *
 */
public class ApprovalListKey extends EntityData {
   /* public String GUBUN;        // ����   1 �����ؾ��ҹ��� ,2 ���������� ���� ,3 ����ϷṮ��
    public String PERNR;        // ���
    public String BEGDA;        // ��û�� FROM
    public String ENDDA;        // ��û�� TO
    public String UPMU_TYPE;    // �����׸�
    public String APPL_PERNR;   // ��û�� ���
    public String STAT_TYPE;    // ����   "1 ��û ,2 ���������� ,3 ����Ϸ� ,4 �ݷ�"*/

   /*
   1. ������ ���
   I_AGUBN (����޴� ����)
    '1' : ������ ����
    '2' : ������ ����
    '3' : ����Ϸ� ����

2. I_BEGDA, I_ENDDA,
    I_ITPNR(���� APPL_PERNR - ��û�� ���),
    I_STAT_TYPE ����
    ���� ����� ���ǰ� ������
    */
    public String 	I_AGUBN	;//	CHAR	 1 	����޴� ����
    public String 	I_PERNR	;//	NUMC	 8 	��� ��ȣ(������)
    public String 	I_BEGDA	;//	DATS	 8 	������
    public String 	I_ENDDA	;//	DATS	 8 	������
    public String 	I_UPMU_TYPE	;//	CHAR	 3 	��������
    public String 	I_ITPNR	;//	NUMC	 8 	����� ���
    public String 	I_STAT_TYPE	;//	CHAR	 1 	����(��������)

    public String getI_AGUBN() {
        return I_AGUBN;
    }

    public void setI_AGUBN(String i_AGUBN) {
        I_AGUBN = i_AGUBN;
    }

    public String getI_PERNR() {
        return I_PERNR;
    }

    public void setI_PERNR(String i_PERNR) {
        I_PERNR = i_PERNR;
    }

    public String getI_BEGDA() {
        return I_BEGDA;
    }

    public void setI_BEGDA(String i_BEGDA) {
        I_BEGDA = i_BEGDA;
    }

    public String getI_ENDDA() {
        return I_ENDDA;
    }

    public void setI_ENDDA(String i_ENDDA) {
        I_ENDDA = i_ENDDA;
    }

    public String getI_UPMU_TYPE() {
        return I_UPMU_TYPE;
    }

    public void setI_UPMU_TYPE(String i_UPMU_TYPE) {
        I_UPMU_TYPE = i_UPMU_TYPE;
    }

    public String getI_ITPNR() {
        return I_ITPNR;
    }

    public void setI_ITPNR(String i_ITPNR) {
        I_ITPNR = i_ITPNR;
    }

    public String getI_STAT_TYPE() {
        return I_STAT_TYPE;
    }

    public void setI_STAT_TYPE(String i_STAT_TYPE) {
        I_STAT_TYPE = i_STAT_TYPE;
    }
}
