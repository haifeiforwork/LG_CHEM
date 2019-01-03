package hris.D.D13ScheduleChange;

import com.sns.jdf.EntityData;

public class D13DayScheduleData extends EntityData {
	public String PERNR;	 	//��� ��ȣ
	public String ENAME;	 //��� �Ǵ� �������� ���˵� �̸�
	public String BEGDA;	 //������(���������� ������)
	public String  KURZT;	 //Start Date 
	public String TPROG;	 //���� �ٹ� ����
	public String VARIA;	 	//�ϰ��ٹ����� ����
	public String TTEXT;	 //���ϱٹ����� �ؽ�Ʈ
	public String  SOBEG ;	 //Start of planned working time	
	public String  SOEND ;	 //End of planned working time	
	public String  STDAZ;	 //Start of planned working time	
	public String  ZMODN;	 //End of planned working time	
	public String  ZTEXT;	 //Planned working hours	
	public String  MOFID;	 //comments	
	public String  RTEXT ;	 //Text for Work Schedule Rule (Planned Working Time Infotype) 
	
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
	public String getKURZT() {
		return KURZT;
	}
	public void setKURZT(String kURZT) {
		KURZT = kURZT;
	}
	public String getTPROG() {
		return TPROG;
	}
	public void setTPROG(String tPROG) {
		TPROG = tPROG;
	}
	public String getVARIA() {
		return VARIA;
	}
	public void setVARIA(String vARIA) {
		VARIA = vARIA;
	}
	public String getTTEXT() {
		return TTEXT;
	}
	public void setTTEXT(String tTEXT) {
		TTEXT = tTEXT;
	}
	public String getSOBEG() {
		return SOBEG;
	}
	public void setSOBEG(String sOBEG) {
		SOBEG = sOBEG;
	}
	public String getSOEND() {
		return SOEND;
	}
	public void setSOEND(String sOEND) {
		SOEND = sOEND;
	}
	public String getSTDAZ() {
		return STDAZ;
	}
	public void setSTDAZ(String sTDAZ) {
		STDAZ = sTDAZ;
	}
	public String getZMODN() {
		return ZMODN;
	}
	public void setZMODN(String zMODN) {
		ZMODN = zMODN;
	}
	public String getZTEXT() {
		return ZTEXT;
	}
	public void setZTEXT(String zTEXT) {
		ZTEXT = zTEXT;
	}
	public String getMOFID() {
		return MOFID;
	}
	public void setMOFID(String mOFID) {
		MOFID = mOFID;
	}
	public String getRTEXT() {
		return RTEXT;
	}
	public void setRTEXT(String rTEXT) {
		RTEXT = rTEXT;
	}
	
	
}
