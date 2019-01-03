package hris.common.approval;

import org.apache.commons.lang.StringUtils;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-08-23.
 */
public class ApprovalHeader extends EntityData {

    public String 	UPMU_NAME	;//	CHAR	 30 	�������� �ؽ�Ʈ
    public String 	MODFL	;//	CHAR	 1 	�������� FLAG	X OR SPACE
    public String 	ACCPFL	;//	CHAR	 1 	����/�ݷ����� FLAG	X OR SPACE
    public String 	FINAL	;//	CHAR	 1 	���������� FLAG	X OR SPACE
    public String 	CANCFL	;//	CHAR	 1 	��Ұ��� FLAG	X OR SPACE
    public String   DISPFL  ;   //��ȸ ���� �÷���

    public String 	AINF_SEQN	;//	CHAR	 10 	�������� �Ϸù�ȣ
    public String 	UPMU_FLAG	;//	 CHAR 	 1 	�������� �׷� ������
    public String 	UPMU_TYPE	;//	CHAR	 3 	��������
    public String 	RQPNR	;//	NUMC	8	��û�� ���(����/�븮)
    public String 	ITPNR	;//	NUMC	 8 	����� ���

    public String 	PERNR	;//	NUMC	8	��� ��ȣ
    public String 	ORGTX	;//	CHAR	 40 	�ҼӸ�
    public String 	ENAME	;//	CHAR	 40 	����
    public String 	JIKCT	;//	CHAR	 40 	���޸�
    public String 	PHONE_NUM	;//	CHAR	 20 	������� ��ȭ��ȣ
    public String 	MOLGA	;//	CHAR	 2 	���� �׷���

    public String 	JIKWE	;//	CHAR	 20 	����
    public String 	JIKWT	;//	CHAR	 40 	������


   /*
    //�ʿ�� ���� ���
    public String 	ORGEH	;//	NUMC	 8 	���� ����

    public String 	WERKS	;//	CHAR	 4 	�λ� ����
    public String 	NAME1	;//	CHAR	 30 	�λ� ���� �ؽ�Ʈ
    public String 	BTRTL	;//	CHAR	 4 	�λ� ���� ����
    public String 	BTEXT	;//	CHAR	 15 	�λ� ���� ���� �ؽ�Ʈ
    public String 	PERSG	;//	CHAR	 1 	��� �׷�
    public String 	PGTXT	;//	CHAR	 20 	��� �׷� �̸�	����� ���
    public String 	PERSK	;//	CHAR	 2 	��� ���� �׷�
    public String 	PKTXT	;//	CHAR	 20 	��� ���� �׷� �̸�
    public String 	STELL	;//	NUMC	 8 	����
    public String 	STLTX	;//	CHAR	 40 	������
    public String 	DAT01	;//	DATS	 8 	�׷��Ի���
    public String 	DAT02	;//	DATS	 8 	ȸ���Ի���
    public String 	DAT03	;//	DATS	 8 	������������
    public String 	DAT04	;//	DATS	 8 	�ټӱ�����

    public String 	JIKCH	;//	CHAR	 20 	����

*/
    //[CSR ID:3456352]
    public String 	BUKRS	;//	CHAR	 4 	ȸ�� �ڵ�
	public String 	JIKKB	;//	CHAR	 20 	��å
    public String 	JIKKT	;//	CHAR	 40 	��å��

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

	public String getBUKRS() {
		return BUKRS;
	}

	public void setBUKRS(String bUKRS) {
		BUKRS = bUKRS;
	}

	public String getJIKCH() {
		return JIKCH;
	}

	public void setJIKCH(String jIKCH) {
		JIKCH = jIKCH;
	}
	 //[CSR ID:3497059] �繫�� ����ü�� ���濡 ���� �߱����� ��å�� ��å���� ǥ�ÿ�û�帲 end
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

    //[CSR ID:3456352]

    public String 	RQDAT	;//	DATS	 8 	��û����
    public String 	RQTIM	;//	TIMS	 6 	��û�ð�
    public String 	AFDAT	;//	DATS	 8 	���� ��������
    public String 	AFTIM	;//	TIMS	 6 	���� ����ð�
    public String 	AFSTAT	;//	CHAR	 2 	���� ������� (03����Ϸ� 04�ݷ�)
    public String 	AFSTATX	;//	CHAR	 60 	����������¸�

    public String PMANFL;   //		CHAR	 1 	��û�μ��� FLAG	X OR SPACE
    public String DMANFL;   //		CHAR	 2 	�����, ���μ���	'01', '02'	01 : ����� , 02 : ���μ���


    public boolean isFinish() {
        return "03".equals(AFSTAT) || "04".equals(AFSTAT);
    }

    /**
     * �����ڰ� �߰� ����Ÿ ��� �� ��ȸ ����
     * ���簡 1ȸ �̻� �Ǿ��ų� ���簡�� ����
     * @return
     */
    public boolean isShowManagerArea() {
        return !"01".equals(AFSTAT) ||  "X".equals(ACCPFL);
    }

    /**
     * �μ����� ���� ���� ����
     * �μ��� ����� �߰� �Է½� ���
     * @return
     */
    public boolean isDepartManager() { return "X".equals(ACCPFL) && "X".equals(PMANFL); }

    /**
     * ��� �μ����� ���� ���� ����
     * ��� �μ��� ����� �߰� �Է½� ���
     * @return
     */
    public boolean isChargeArea() { return "X".equals(ACCPFL) && !StringUtils.isEmpty(DMANFL); }
    /**
     * ��� �μ����� ���� ���� ����
     * ��� �μ��� ����� �߰� �Է½� ���
     * @return
     */
    public boolean isChargeManager() { return "X".equals(ACCPFL) &&( "02".equals(DMANFL) || "03".equals(DMANFL)) ; }

    /**
     * ����� ���� ���� ����
     * ����� ����� �߰� �Է½� ���
     * @return
     */
    public boolean isCharger() { return "X".equals(ACCPFL) && "01".equals(DMANFL); }

    /**
     * ���� �����ڰ� ����Ÿ�� ���� �� �� �ִ��� ����
     * @return
     */
    public boolean isEditManagerArea() {
        return "01".equals(AFSTAT);
    }

    public String getManagerReadonly() {
        return !"01".equals(AFSTAT) ? "readonly" : "";
    }


    public String getUPMU_NAME() {
        return UPMU_NAME;
    }

    public void setUPMU_NAME(String UPMU_NAME) {
        this.UPMU_NAME = UPMU_NAME;
    }

    public String getMODFL() {
        return MODFL;
    }

    public void setMODFL(String MODFL) {
        this.MODFL = MODFL;
    }

    public String getACCPFL() {
        return ACCPFL;
    }

    public void setACCPFL(String ACCPFL) {
        this.ACCPFL = ACCPFL;
    }

    public String getFINAL() {
        return FINAL;
    }

    public void setFINAL(String FINAL) {
        this.FINAL = FINAL;
    }

    public String getCANCFL() {
        return CANCFL;
    }

    public void setCANCFL(String CANCFL) {
        this.CANCFL = CANCFL;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getUPMU_FLAG() {
        return UPMU_FLAG;
    }

    public void setUPMU_FLAG(String UPMU_FLAG) {
        this.UPMU_FLAG = UPMU_FLAG;
    }

    public String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    public void setUPMU_TYPE(String UPMU_TYPE) {
        this.UPMU_TYPE = UPMU_TYPE;
    }

    public String getRQPNR() {
        return RQPNR;
    }

    public void setRQPNR(String RQPNR) {
        this.RQPNR = RQPNR;
    }

    public String getITPNR() {
        return ITPNR;
    }

    public void setITPNR(String ITPNR) {
        this.ITPNR = ITPNR;
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

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getJIKCT() {
        return JIKCT;
    }

    public void setJIKCT(String JIKCT) {
        this.JIKCT = JIKCT;
    }

    public String getPHONE_NUM() {
        return PHONE_NUM;
    }

    public void setPHONE_NUM(String PHONE_NUM) {
        this.PHONE_NUM = PHONE_NUM;
    }

    public String getMOLGA() {
        return MOLGA;
    }

    public void setMOLGA(String MOLGA) {
        this.MOLGA = MOLGA;
    }

    public String getRQDAT() {
        return RQDAT;
    }

    public void setRQDAT(String RQDAT) {
        this.RQDAT = RQDAT;
    }

    public String getRQTIM() {
        return RQTIM;
    }

    public void setRQTIM(String RQTIM) {
        this.RQTIM = RQTIM;
    }

    public String getAFDAT() {
        return AFDAT;
    }

    public void setAFDAT(String AFDAT) {
        this.AFDAT = AFDAT;
    }

    public String getAFTIM() {
        return AFTIM;
    }

    public void setAFTIM(String AFTIM) {
        this.AFTIM = AFTIM;
    }

    public String getAFSTAT() {
        return AFSTAT;
    }

    public void setAFSTAT(String AFSTAT) {
        this.AFSTAT = AFSTAT;
    }

    public String getAFSTATX() {
        return AFSTATX;
    }

    public void setAFSTATX(String AFSTATX) {
        this.AFSTATX = AFSTATX;
    }

    public String getDISPFL() {
        return DISPFL;
    }

    public void setDISPFL(String DISPFL) {
        this.DISPFL = DISPFL;
    }

    public String getPMANFL() {
        return PMANFL;
    }

    public void setPMANFL(String PMANFL) {
        this.PMANFL = PMANFL;
    }

    public String getDMANFL() {
        return DMANFL;
    }

    public void setDMANFL(String DMANFL) {
        this.DMANFL = DMANFL;
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
}
