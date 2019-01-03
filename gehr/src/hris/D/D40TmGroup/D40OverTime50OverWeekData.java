/********************************************************************************/
/*																				*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  �μ�����												*/
/*   2Depth Name		:  �ʰ��ٹ�												*/
/*   Program Name	:  �ʰ��ٹ�													*/
/*   Program ID		:  D40OverTime50OverWeekData.java							*/
/*   Description		:  �ʰ��ٹ� 												*/
/*   Note				:             											*/
/*   Creation			:  2018-06-18  ��ȯ�� [Worktime52]                       */
/*   Update				:  											         	*/
/*                                                                              */
/********************************************************************************/

package hris.D.D40TmGroup;

/**
 * D40OverTime50OverWeekData.java ����������-�ʰ��ٹ� [���� RFC] : ZGHR_RFC_TM_OVERTIME
 *
 * @author ��ȯ��
 * @version 1.0, 2018/06/18
 */
public class D40OverTime50OverWeekData extends com.sns.jdf.EntityData {

	public String PERNR; // ��� ��ȣ
	public String ENAME; // ��� �Ǵ� �������� ���˵� �̸�
	public String BEGDA; // ������
	public String ENDDA; // ������
	public String WWKTM; // ��

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

	public String getBEGDA() {
		return BEGDA;
	}

	public void setBEGDA(String bEGDA) {
		BEGDA = bEGDA;
	}

	public String getENDDA() {
		return ENDDA;
	}

	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
	}

	public String getWWKTM() {
		return WWKTM;
	}

	public void setWWKTM(String wWKTM) {
		WWKTM = wWKTM;
	}

}
