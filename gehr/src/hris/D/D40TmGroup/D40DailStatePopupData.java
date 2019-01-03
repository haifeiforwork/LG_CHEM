/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   �μ�����													*/
/*   2Depth Name		:   ��������													*/
/*   Program Name	:   ��������													*/
/*   Program ID		: D40DailStateData.java								*/
/*   Description		: ��������													*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  ������                                          	*/
/*   Update				: 2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40DailStatePopupData.java
 * ����������-�������� �� �˾�
 * [���� RFC] :  ZGHR_RFC_TM_DAY_DETAIL
 *
 * @author  ������
 * @version 1.0, 2017/12/08
 */
public class D40DailStatePopupData extends com.sns.jdf.EntityData {

	public String WTMCODE;	//��������-�ڵ�
	public String WTMCODE_TX;	//��������-�ؽ�Ʈ
	public String BEGDA;	//������
	public String ENDDA;	//������
	public String BEGUZ;	//���۽ð�
	public String ENDUZ;	//����ð�
	public String PBEG1;	//�޽�1���۽ð�
	public String PEND1;	//�޽�1����ð�
	public String PBEG2;	//�޽�2���۽ð�
	public String PEND2;	//�޽�2����ð�
	public String REASON;	//���»���-�ڵ�
	public String REASON_TX;	//���»���-�ؽ�Ʈ
	public String DETAIL;	//�󼼻���
	public String AEDTM_TX;	//����������
	public String UNAME_TX;	//����������
	public String STDAZ;	//�ٹ��ð� ��

	public String getWTMCODE() {
		return WTMCODE;
	}
	public void setWTMCODE(String wTMCODE) {
		WTMCODE = wTMCODE;
	}
	public String getWTMCODE_TX() {
		return WTMCODE_TX;
	}
	public void setWTMCODE_TX(String wTMCODE_TX) {
		WTMCODE_TX = wTMCODE_TX;
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
	public String getREASON_TX() {
		return REASON_TX;
	}
	public void setREASON_TX(String rEASON_TX) {
		REASON_TX = rEASON_TX;
	}
	public String getDETAIL() {
		return DETAIL;
	}
	public void setDETAIL(String dETAIL) {
		DETAIL = dETAIL;
	}
	public String getAEDTM_TX() {
		return AEDTM_TX;
	}
	public void setAEDTM_TX(String aEDTM_TX) {
		AEDTM_TX = aEDTM_TX;
	}
	public String getUNAME_TX() {
		return UNAME_TX;
	}
	public void setUNAME_TX(String uNAME_TX) {
		UNAME_TX = uNAME_TX;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}



}

