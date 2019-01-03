package	hris.E.E25Infojoin;

/**
 * InformalListData.java
 * 인포멀리스트를 가져오는 데이터
 *   [관련 RFC] : ZHRH_RFC_P_INFORMAL_LIST
 *
 * @author 이형석
 * @version 1.0, 2001/12/26
 */
public class InfoListData extends com.sns.jdf.EntityData {

    public String MGART     ;   //구성원 유형
    public String STEXT     ;   // 하부유형이름
    public String PERN_NUMB ;   // 간사
    public String ENAME     ;   // 사원또는 지원자의 포맷 이름
    public String TITEL     ;   // 직책
    public String MEMBER    ;   // 회원여부(0:비회원, 1:회원)
    public String USRID     ;   // 간사 연락처
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
