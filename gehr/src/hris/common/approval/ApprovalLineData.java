package hris.common.approval;

import com.sns.jdf.EntityData;
import hris.N.AES.AESgenerUtil;
import org.apache.commons.lang.StringUtils;

/**
 * Created by manyjung on 2016-08-23.
 */
public class ApprovalLineData extends EntityData {
    /* ���� ���� ���� */
    public String AINF_SEQN;//	CHAR	 10 	�������� �Ϸù�ȣ
    public String APPR_TYPE;//	CHAR	 2 	��������
    public String APPU_TYPE;//	NUMC	 2 	������ ����
    public String APPR_SEQN;//	 NUMC 	 2 	�������
    public String APPU_NAME;//	CHAR	20	������ ���� �ؽ�Ʈ
    public String APPU_NUMB;//	NUMC	 8 	������ ���
    public String APPU_ENC_NUMB;
    public String OTYPE;//	CHAR	 2 	������Ʈ ����	"T'
    public String OBJID;//	NUMC	 8 	�½�ũ ID
    public String BIGO_TEXT;//	CHAR	 250 	����	�ʿ��
    public String CMMNT;//	CHAR	 4,096 	�ǰ�	�ʿ��
    public String APPR_DATE;//	DATS	 8 	������
    public String APPR_TIME;//	TIMS	 6 	�ð�
    public String APPR_STAT;//	CHAR	 1 	���λ���(������)	'A' OR 'R' OR SPACE
    public String APPR_STATX;//	CHAR	 60 	���� ����

    /* ȭ�� ǥ�� ���� */
    public String ENAME;//	CHAR	 40 	����
    public String JIKWE;//	CHAR	 20 	����
    public String JIKWT;//	CHAR	 40 	������
    public String ORGEH;//	NUMC	 8 	���� ����
    public String ORGTX;//	CHAR	 40 	�ҼӸ�
    public String PHONE_NUM;//	CHAR	 20 	������� ��ȭ��ȣ

    /* RFC�� ��Ÿ ���� - �ʿ�� �ʿ� ��� �ּ� ���� ��� */

    public String 	PERNR	;//	NUMC	8	��� ��ȣ	������ ���
    /*
    public String 	WERKS	;//	CHAR	 4 	�λ� ����
    public String 	NAME1	;//	CHAR	 30 	�λ� ���� �ؽ�Ʈ
    public String 	BTRTL	;//	CHAR	 4 	�λ� ���� ����
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
    public String 	JIKCH	;//	CHAR	 20 	����
    public String 	JIKCT	;//	CHAR	 40 	���޸�

    public String 	MOLGA	;//	CHAR	 2 	���� �׷���
    */

  //[CSR ID:3456352]
    public String 	JIKKB	;//	CHAR	 20 	��å
    public String 	JIKKT	;//	CHAR	 40 	��å��
    public String 	BUKRS	;//	CHAR	 4 	ȸ�� �ڵ�

  //[CSR ID:3497059] �繫�� ����ü�� ���濡 ���� �߱����� ��å�� ��å���� ǥ�ÿ�û�帲 start
    public String 	PERSG	;//	CHAR	 1 	��� �׷�
    public String 	PERSK	;//	CHAR	 2 	��� ���� �׷�
    public String 	JIKCH	;//	CHAR	 20 	����

	public String getPERSG() {
		return PERSG;
	}

	public void setPERSG(String pERSG) {
		PERSG = pERSG;
	}

	public String getPERSK() {
		return PERSK;
	}

	public void setPERSK(String pERSK) {
		PERSK = pERSK;
	}

	public String getJIKCH() {
		return JIKCH;
	}

	public void setJIKCH(String jIKCH) {
		JIKCH = jIKCH;
	}

  //[CSR ID:3497059] �繫�� ����ü�� ���濡 ���� �߱����� ��å�� ��å���� ǥ�ÿ�û�帲 end

	public String getPERNR() {
		return PERNR;
	}

	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}

	public String getJIKKB() {
		return JIKKB;
	}

	public void setJIKKB(String jIKKB) {
		JIKKB = jIKKB;
	}

	public String getJIKKT() {
		return JIKKT;
	}

	public void setJIKKT(String jIKKT) {
		JIKKT = jIKKT;
	}

    public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}
	//[CSR ID:3456352]


    public String getAPPU_ENC_NUMB() {
        return APPU_ENC_NUMB;
    }

    public void setAPPU_ENC_NUMB(String APPU_ENC_NUMB) {
        this.APPU_ENC_NUMB = APPU_ENC_NUMB;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getAPPR_TYPE() {
        return APPR_TYPE;
    }

    public void setAPPR_TYPE(String APPR_TYPE) {
        this.APPR_TYPE = APPR_TYPE;
    }

    public String getAPPU_TYPE() {
        return APPU_TYPE;
    }

    public void setAPPU_TYPE(String APPU_TYPE) {
        this.APPU_TYPE = APPU_TYPE;
    }

    public String getAPPR_SEQN() {
        return APPR_SEQN;
    }

    public void setAPPR_SEQN(String APPR_SEQN) {
        this.APPR_SEQN = APPR_SEQN;
    }

    public String getAPPU_NAME() {
        return APPU_NAME;
    }

    public void setAPPU_NAME(String APPU_NAME) {
        this.APPU_NAME = APPU_NAME;
    }

    public String getAPPU_NUMB() {
        /*������ŷ ��� - ������� ��� ��ȣȭ*/
        if(StringUtils.isBlank(APPU_NUMB) && StringUtils.isNotBlank(APPU_ENC_NUMB)) {
            return AESgenerUtil.decryptAES(APPU_ENC_NUMB);
        }
        return APPU_NUMB;
    }

    public void setAPPU_NUMB(String APPU_NUMB) {
        this.APPU_NUMB = APPU_NUMB;
    }

    public String getOTYPE() {
        return OTYPE;
    }

    public void setOTYPE(String OTYPE) {
        this.OTYPE = OTYPE;
    }

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getBIGO_TEXT() {
        return BIGO_TEXT;
    }

    public void setBIGO_TEXT(String BIGO_TEXT) {
        this.BIGO_TEXT = BIGO_TEXT;
    }

    public String getCMMNT() {
        return CMMNT;
    }

    public void setCMMNT(String CMMNT) {
        this.CMMNT = CMMNT;
    }

    public String getAPPR_DATE() {
        return APPR_DATE;
    }

    public void setAPPR_DATE(String APPR_DATE) {
        this.APPR_DATE = APPR_DATE;
    }

    public String getAPPR_TIME() {
        return APPR_TIME;
    }

    public void setAPPR_TIME(String APPR_TIME) {
        this.APPR_TIME = APPR_TIME;
    }

    public String getAPPR_STAT() {
        return APPR_STAT;
    }

    public void setAPPR_STAT(String APPR_STAT) {
        this.APPR_STAT = APPR_STAT;
    }

    public String getAPPR_STATX() {
        return APPR_STATX;
    }

    public void setAPPR_STATX(String APPR_STATX) {
        this.APPR_STATX = APPR_STATX;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
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

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }
}
