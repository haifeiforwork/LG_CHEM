package	hris.E.E25Infojoin;

/**
 * E25InfoSettData.java
 * �����ְ��� ���翡 ���� DATA
 *   [���� RFC] : ZHRH_RFC_INFORMAL_SETT
 *
 * @author ������
 * @version 1.0, 2001/12/26
 */
public class E25InfoSettData extends com.sns.jdf.EntityData {

    public String AINF_SEQN ;   // ���������Ϸù�ȣ
    public String MGART     ;   // ������ ����
    public String STEXT     ;   // ������Ʈ �̸�
    public String PERN_NUMB ;   // ����
    public String ENAME     ;   // �����̸�
    public String ORGEH     ;   // �ҼӺμ�
    public String ORGTX     ;   // ���������ؽ�Ʈ
    public String TITEL     ;   // ��å
    public String APPR_DATE ;   // ������
    public String APPR_STAT ;   // ���λ���
    public String USRID     ;   // ���I/D��ȣ
	public String getAINF_SEQN() {
		return AINF_SEQN;
	}
	public void setAINF_SEQN(String aINF_SEQN) {
		AINF_SEQN = aINF_SEQN;
	}
	public String getMGART() {
		return MGART;
	}
	public void setMGART(String mGART) {
		MGART = mGART;
	}
	public String getSTEXT() {
		return STEXT;
	}
	public void setSTEXT(String sTEXT) {
		STEXT = sTEXT;
	}
	public String getPERN_NUMB() {
		return PERN_NUMB;
	}
	public void setPERN_NUMB(String pERN_NUMB) {
		PERN_NUMB = pERN_NUMB;
	}
	public String getENAME() {
		return ENAME;
	}
	public void setENAME(String eNAME) {
		ENAME = eNAME;
	}
	public String getORGEH() {
		return ORGEH;
	}
	public void setORGEH(String oRGEH) {
		ORGEH = oRGEH;
	}
	public String getORGTX() {
		return ORGTX;
	}
	public void setORGTX(String oRGTX) {
		ORGTX = oRGTX;
	}
	public String getTITEL() {
		return TITEL;
	}
	public void setTITEL(String tITEL) {
		TITEL = tITEL;
	}
	public String getAPPR_DATE() {
		return APPR_DATE;
	}
	public void setAPPR_DATE(String aPPR_DATE) {
		APPR_DATE = aPPR_DATE;
	}
	public String getAPPR_STAT() {
		return APPR_STAT;
	}
	public void setAPPR_STAT(String aPPR_STAT) {
		APPR_STAT = aPPR_STAT;
	}
	public String getUSRID() {
		return USRID;
	}
	public void setUSRID(String uSRID) {
		USRID = uSRID;
	}


}