package hris.D.D01OT;

/**
 * D01OTReasonData.java
 *   [ RFC] : ZHRW_RFC_OVERTIME_REASON
 * 
 * @author pang xiaolin
 * @version 1.0, 2016/04/26
 */
public class D01OTReasonData extends com.sns.jdf.EntityData {
    public String WERKS ;
    public String ZRCODE;
    public String REASON;
    
	public String getWERKS() {
		return WERKS;
	}
	public void setWERKS(String wERKS) {
		WERKS = wERKS;
	}
	public String getZRCODE() {
		return ZRCODE;
	}
	public void setZRCODE(String zRCODE) {
		ZRCODE = zRCODE;
	}
	public String getREASON() {
		return REASON;
	}
	public void setREASON(String rEASON) {
		REASON = rEASON;
	}

}
