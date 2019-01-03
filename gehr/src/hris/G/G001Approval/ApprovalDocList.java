/*
 * �ۼ��� ��¥: 2005. 1. 28.
 *2017-04-03  eunha [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ����
 *2017-04-19  eunha [CSR ID:3359686]   ���� ���� 5������
 */
package hris.G.G001Approval;

import com.sns.jdf.EntityData;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.D01OTData;
import hris.D.D19Duty.D19DutyData;
import hris.common.PersonData;
import org.apache.commons.lang.StringUtils;

/**
 * @author �̽���
 *
 */
public class ApprovalDocList extends EntityData {

    /* �ؿ� */
    public String IFlag;
    public String E_ANZHL;
    public String SHIFT ;
    public PersonData personData;
    public D01OTData d01OTData;
    public D19DutyData d19DutyData;
    public String no;
    public String actTime;

    public String DUTY_TXT;

    public String APPL_TO;  //	ZAPPL_TO	DATS	8	0	App. End Date
    public String ABRTG;    //	ABRTG	DEC	6	2	Payroll days
    /***************************************************
     *    �� ����ȭ�� ����Ʈ �ʵ� �߰�.
     *    2008-04-02	jungin		@v1.0 [C20080401_43345]
     ***************************************************/
    public String APPL_DATE  ;  	// �ش� ���� ��û��.
    public String BEGUZ  ;  		// �򰡵� �ð�.
    public String ENDUZ  ;  		// �򰡵� �ð�.


    /***************************************************
     *    BOHAI���� �빮�ð� üũ.
     *    2009-12-23	jungin		@v1.1 [C20091222_81370]
     ***************************************************/
    public String I_BEGTIME  ;  	// �빮 ���۽ð�
    public String I_ENDTIME  ;  	// �빮 ����ð�
    public String I_BEGDATE	;	// �빮 ������
    public String I_ENDDATE	;	// �빮 ������
    public String ZREASON;

    public String E_46OVER_NOT_APPROVAL  ;   //2017-04-03   [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ����
    public String E_7OVER_NOT_APPROVAL  ;		//2017-04-19    [CSR ID:3359686]   ���� ���� 5������
    /* ���� */

	public String BUKRS      ;  //  ȸ���ڵ�
    public String STEXT      ;  //  �μ���
    public String PERNR      ;  //  �����ȣ
    public String ENAME      ;  //  ����̸�
    public String BEGDA      ;  //  ��û��
    public String AINF_SEQN  ;  //  �������� �Ϸù�ȣ
    public String UPMU_FLAG  ;  //  �������� �׷� ������
    public String UPMU_TYPE  ;  //  ��������
    public String UPMU_NAME  ;  //  �������� �ؽ�Ʈ
    public String APPR_TYPE  ;  //  ��������(������� ���ܷ� ��������... 01 ���� , 02 ���_������...)
    public String APPU_TYPE  ;  //  ������ ����(01: ��û�μ� ����, 02: ���μ� ����)
    public String APPR_SEQN  ;  //  �������(1�� 2�� 3�� ���� ����)
    public String OTYPE      ;  //  ������Ʈ����
    public String OBJID      ;  //  ������Ʈ ID
    public String APPU_NUMB  ;  //  ������ ���
    public String APPR_DATE  ;  //  ������
    public String APPR_STAT  ;  //  ���λ���    A:���� R:�ݷ� ' ':�̰���(�������) -����ó����
    public String STAT_TYPE  ;  //  �������    1 ��û ,2 ���������� ,3 ����Ϸ� ,4 �ݷ�
    public String DETERMINANT;  //  ����������̸�
    public String AFSTAT;   //	���� �������	CHAR	2	0	ZEHRAFSTAT
    public String AFSTATX;  //	����������¸�	CHAR	60	0	ZEHRAFSTATX


    public String getBUKRS() {
        return BUKRS;
    }

    public void setBUKRS(String BUKRS) {
        this.BUKRS = BUKRS;
    }

    public String getSTEXT() {
        return STEXT;
    }

    public void setSTEXT(String STEXT) {
        this.STEXT = STEXT;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }

    public String getENAME() {
        return ENAME;
    }

    public void setENAME(String ENAME) {
        this.ENAME = ENAME;
    }

    public String getBEGDA() {
        return BEGDA;
    }

    public void setBEGDA(String BEGDA) {
        this.BEGDA = BEGDA;
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

    public String getUPMU_NAME() {
        return UPMU_NAME;
    }

    public void setUPMU_NAME(String UPMU_NAME) {
        this.UPMU_NAME = UPMU_NAME;
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

    public String getAPPU_NUMB() {
        return APPU_NUMB;
    }

    public void setAPPU_NUMB(String APPU_NUMB) {
        this.APPU_NUMB = APPU_NUMB;
    }

    public String getAPPR_DATE() {
        return APPR_DATE;
    }

    public void setAPPR_DATE(String APPR_DATE) {
        this.APPR_DATE = APPR_DATE;
    }

    public String getAPPR_STAT() {
        return APPR_STAT;
    }

    public void setAPPR_STAT(String APPR_STAT) {
        this.APPR_STAT = APPR_STAT;
    }

    public String getSTAT_TYPE() {
        return STAT_TYPE;
    }

    public void setSTAT_TYPE(String STAT_TYPE) {
        this.STAT_TYPE = STAT_TYPE;
    }

    public String getDETERMINANT() {
        return DETERMINANT;
    }

    public void setDETERMINANT(String DETERMINANT) {
        this.DETERMINANT = DETERMINANT;
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

    public String getAPPL_DATE() {
        return APPL_DATE;
    }

    public void setAPPL_DATE(String APPL_DATE) {
        this.APPL_DATE = APPL_DATE;
    }

    public String getBEGUZ() {
        return BEGUZ;
    }

    public void setBEGUZ(String BEGUZ) {
        this.BEGUZ = BEGUZ;
    }

    public String getENDUZ() {
        return ENDUZ;
    }

    public void setENDUZ(String ENDUZ) {
        this.ENDUZ = ENDUZ;
    }

    public String getI_BEGTIME() {
        return I_BEGTIME;
    }

    public void setI_BEGTIME(String i_BEGTIME) {
        I_BEGTIME = i_BEGTIME;
    }

    public String getI_ENDTIME() {
        return I_ENDTIME;
    }

    public void setI_ENDTIME(String i_ENDTIME) {
        I_ENDTIME = i_ENDTIME;
    }

    public String getI_BEGDATE() {
        return I_BEGDATE;
    }

    public void setI_BEGDATE(String i_BEGDATE) {
        I_BEGDATE = i_BEGDATE;
    }

    public String getI_ENDDATE() {
        return I_ENDDATE;
    }

    public void setI_ENDDATE(String i_ENDDATE) {
        I_ENDDATE = i_ENDDATE;
    }

    public String getIFlag() {
        return IFlag;
    }

    public void setIFlag(String IFlag) {
        this.IFlag = IFlag;
    }

    public String getE_ANZHL() {
        return E_ANZHL;
    }

    public void setE_ANZHL(String e_ANZHL) {
        E_ANZHL = e_ANZHL;
    }

    public String getSHIFT() {
        return SHIFT;
    }

    public void setSHIFT(String SHIFT) {
        this.SHIFT = SHIFT;
    }

    public PersonData getPersonData() {
        return personData;
    }

    public void setPersonData(PersonData personData) {
        this.personData = personData;
    }

    public D01OTData getD01OTData() {
        return d01OTData;
    }

    public void setD01OTData(D01OTData d01OTData) {
        this.d01OTData = d01OTData;
    }

    public D19DutyData getD19DutyData() {
        return d19DutyData;
    }

    public void setD19DutyData(D19DutyData d19DutyData) {
        this.d19DutyData = d19DutyData;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getActTime() {
        String result = WebUtil.printDate(I_BEGDATE) + " " + WebUtil.printTime(I_BEGTIME) + " ~" + " " + WebUtil.printDate(I_ENDDATE) + " " + WebUtil.printTime(I_ENDTIME);

        if(StringUtils.length(StringUtils.trim(result)) < 3) return "";

        return result;
    }

    public void setActTime(String actTime) {
        this.actTime = actTime;
    }

    public String getZREASON() {
        return ZREASON;
    }

    public void setZREASON(String ZREASON) {
        this.ZREASON = ZREASON;
    }

    public String getDUTY_TXT() {
        return DUTY_TXT;
    }

    public void setDUTY_TXT(String DUTY_TXT) {
        this.DUTY_TXT = DUTY_TXT;
    }

    public String getAPPL_TO() {
        return APPL_TO;
    }

    public void setAPPL_TO(String APPL_TO) {
        this.APPL_TO = APPL_TO;
    }

    public String getABRTG() {
        return ABRTG;
    }

    public void setABRTG(String ABRTG) {
        this.ABRTG = ABRTG;
    }

    //[CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� START
    public String getE_46OVER_NOT_APPROVAL() {
		return E_46OVER_NOT_APPROVAL;
	}

	public void setE_46OVER_NOT_APPROVAL(String e_46over_NOT_APPROVAL) {
		E_46OVER_NOT_APPROVAL = e_46over_NOT_APPROVAL;
	}
	//[CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� END
	//[CSR ID:3359686]   ���� ���� 5������ START
	public String getE_7OVER_NOT_APPROVAL() {
		return E_7OVER_NOT_APPROVAL;
	}

	public void setE_7OVER_NOT_APPROVAL(String e_7over_NOT_APPROVAL) {
		E_7OVER_NOT_APPROVAL = e_7over_NOT_APPROVAL;
	}
	//[CSR ID:3359686]   ���� ���� 5������ END
}
