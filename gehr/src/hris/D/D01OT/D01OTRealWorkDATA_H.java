package hris.D.D01OT;

/********************************************************************************/
/*                                                                              															   */
/*   System Name  : ESS                                                                                                             */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ�                                                    */
/*   Program ID     : D01OTRealWorkDATA_H                                           */
/*   Description     : �Ǳٹ��ð��� ��� ������ (������)               										*/
/*   Note             : [���� RFC] : ZGHR_RFC_NTM_REALWORK_LIST                     */
/*   Creation         : 2018-05-18  ������                                          */
/*   Update           :                                                             */
/*                                                                              															   */
/********************************************************************************/

public class D01OTRealWorkDATA_H extends com.sns.jdf.EntityData {

	public String PERNR;					//�����ȣ
	//������
	public String E_BEGDA;				//�Ⱓ������
	public String E_ENDDA;				//�Ⱓ������

	public String WKLMT;				//�ٹ��ѵ�
	public String NORTM;				//����ٹ��ð�
	public String OVRTM;				//�ʰ��ٹ��ð�
	public String BRKTM;				//�ްԽð�
	public String NWKTM;				//��ٹ��ð�
	public String RWKTM;				//�� �ٷνð�
	public String getPERNR() {
		return PERNR;
	}
	public void setPERNR(String pERNR) {
		PERNR = pERNR;
	}
	public String getE_BEGDA() {
		return E_BEGDA;
	}
	public void setE_BEGDA(String e_BEGDA) {
		E_BEGDA = e_BEGDA;
	}
	public String getE_ENDDA() {
		return E_ENDDA;
	}
	public void setE_ENDDA(String e_ENDDA) {
		E_ENDDA = e_ENDDA;
	}
	public String getWKLMT() {
		return WKLMT;
	}
	public void setWKLMT(String wKLMT) {
		WKLMT = wKLMT;
	}
	public String getNORTM() {
		return NORTM;
	}
	public void setNORTM(String nORTM) {
		NORTM = nORTM;
	}
	public String getOVRTM() {
		return OVRTM;
	}
	public void setOVRTM(String oVRTM) {
		OVRTM = oVRTM;
	}
	public String getBRKTM() {
		return BRKTM;
	}
	public void setBRKTM(String bRKTM) {
		BRKTM = bRKTM;
	}
	public String getNWKTM() {
		return NWKTM;
	}
	public void setNWKTM(String nWKTM) {
		NWKTM = nWKTM;
	}
	public String getRWKTM() {
		return RWKTM;
	}
	public void setRWKTM(String rWKTM) {
		RWKTM = rWKTM;
	}



}