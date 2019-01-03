/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ���ϱٹ�����												*/
/*   Program Name	:   ���ϱٹ�����												*/
/*   Program ID		: D40DailScheFrameData.java							*/
/*   Description		: ���ϱٹ�����												*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40DefaultSettingRFC.java
 * ����������-�⺻������
 * [���� RFC] :  ZGHR_RFC_TM_SELECT_OPTION
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40DefaultSettingData extends com.sns.jdf.EntityData {

	public String PKEY; 		//���� Key
	public String CODE; 		//�ڵ�
	public String TEXT; 		//�ؽ�Ʈ
	public String ENDDA; 	//������
	public String BEGUZ; 	//���۽ð�
	public String ENDUZ; 	//����ð�
	public String PBEG1; 	//�޽Ľ��۽ð�1
	public String PEND1; 	//�޽�����ð�1
	public String PBEG2; 	//�޽Ľ��۽ð�2
	public String PEND2; 	//�޽�����ð�2
	public String REASON; 	//����
	public String DETAIL; 	//�󼼻���
	public String REASON_YN; //�����ڵ� �ʼ�����
	public String DETAIL_YN; 	//�󼼻��� �ʼ�����
	public String TIME_YN; 	//�ð��Է� �ʼ�����
	public String STDAZ_YN ; 	//�� �Է� ���ɿ���
	public String PTIME_YN ; 	//�޽Ľð� �Է� ���ɿ���

	public String getPKEY() {
		return PKEY;
	}
	public void setPKEY(String pKEY) {
		PKEY = pKEY;
	}
	public String getCODE() {
		return CODE;
	}
	public void setCODE(String cODE) {
		CODE = cODE;
	}
	public String getTEXT() {
		return TEXT;
	}
	public void setTEXT(String tEXT) {
		TEXT = tEXT;
	}
	public String getENDDA() {
		return ENDDA;
	}
	public void setENDDA(String eNDDA) {
		ENDDA = eNDDA;
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
	public String getPBEG1() {
		return PBEG1;
	}
	public void setPBEG1(String pBEG1) {
		PBEG1 = pBEG1;
	}
	public String getPEND1() {
		return PEND1;
	}
	public void setPEND1(String pEND1) {
		PEND1 = pEND1;
	}
	public String getPBEG2() {
		return PBEG2;
	}
	public void setPBEG2(String pBEG2) {
		PBEG2 = pBEG2;
	}
	public String getPEND2() {
		return PEND2;
	}
	public void setPEND2(String pEND2) {
		PEND2 = pEND2;
	}
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}
	public String getDETAIL() {
		return DETAIL;
	}
	public void setDETAIL(String dETAIL) {
		DETAIL = dETAIL;
	}
	public String getREASON_YN() {
		return REASON_YN;
	}
	public void setREASON_YN(String rEASON_YN) {
		REASON_YN = rEASON_YN;
	}
	public String getDETAIL_YN() {
		return DETAIL_YN;
	}
	public void setDETAIL_YN(String dETAIL_YN) {
		DETAIL_YN = dETAIL_YN;
	}
	public String getTIME_YN() {
		return TIME_YN;
	}
	public void setTIME_YN(String tIME_YN) {
		TIME_YN = tIME_YN;
	}
	public String getSTDAZ_YN() {
		return STDAZ_YN;
	}
	public void setSTDAZ_YN(String sTDAZ_YN) {
		STDAZ_YN = sTDAZ_YN;
	}
	public String getPTIME_YN() {
		return PTIME_YN;
	}
	public void setPTIME_YN(String pTIME_YN) {
		PTIME_YN = pTIME_YN;
	}



}

