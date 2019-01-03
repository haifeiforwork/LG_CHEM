package hris.E.E01Medicare;

/**
 * E01TargetNameData.java
 * 건강보험 피부양자 자격(취득/상실) 신청자 이름을 조회를 하는 데이터
 *   [관련 RFC] : ZHRW_RFC_P_GET_TARGET_NAME
 *
 * @author 박영락
 * @version 1.0, 2002/01/28
 */
public class E01TargetNameData extends com.sns.jdf.EntityData {

    public String SUBTY;      //하부유형
    public String OBJPS;      //오브젝트식별
    public String FNMHG;      //이름
    public String LNMHG;      //성
	public String getSUBTY() {
		return SUBTY;
	}
	public void setSUBTY(String sUBTY) {
		SUBTY = sUBTY;
	}
	public String getOBJPS() {
		return OBJPS;
	}
	public void setOBJPS(String oBJPS) {
		OBJPS = oBJPS;
	}
	public String getFNMHG() {
		return FNMHG;
	}
	public void setFNMHG(String fNMHG) {
		FNMHG = fNMHG;
	}
	public String getLNMHG() {
		return LNMHG;
	}
	public void setLNMHG(String lNMHG) {
		LNMHG = lNMHG;
	}


}