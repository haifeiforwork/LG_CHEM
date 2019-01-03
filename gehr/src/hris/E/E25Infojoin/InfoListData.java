package	hris.E.E25Infojoin;

/**
 * InformalListData.java
 * �����ָ���Ʈ�� �������� ������
 *   [���� RFC] : ZHRH_RFC_P_INFORMAL_LIST
 *
 * @author ������
 * @version 1.0, 2001/12/26
 */
public class InfoListData extends com.sns.jdf.EntityData {

    public String MGART     ;   //������ ����
    public String STEXT     ;   // �Ϻ������̸�
    public String PERN_NUMB ;   // ����
    public String ENAME     ;   // ����Ǵ� �������� ���� �̸�
    public String TITEL     ;   // ��å
    public String MEMBER    ;   // ȸ������(0:��ȸ��, 1:ȸ��)
    public String USRID     ;   // ���� ����ó
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
	public String getTITEL() {
		return TITEL;
	}
	public void setTITEL(String tITEL) {
		TITEL = tITEL;
	}
	public String getMEMBER() {
		return MEMBER;
	}
	public void setMEMBER(String mEMBER) {
		MEMBER = mEMBER;
	}
	public String getUSRID() {
		return USRID;
	}
	public void setUSRID(String uSRID) {
		USRID = uSRID;
	}

}
