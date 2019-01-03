package	hris.E.E15General;

/**
 * E15GeneralFlagData.java
 * 종합검진 신청여부에 대한 데이터
 *
 * @author 이형석
 * @version 1.0, 2001/12/26
 */
public class E15GeneralFlagData extends com.sns.jdf.EntityData {

    public String ME_FLAG;        //본인 여부
    public String WI_FLAG;       //배우자 여부
    public String ME_CODE;
    public String WI_CODE;

	public String getME_FLAG() {
		return ME_FLAG;
	}
	public void setME_FLAG(String mE_FLAG) {
		ME_FLAG = mE_FLAG;
	}
	public String getWI_FLAG() {
		return WI_FLAG;
	}
	public void setWI_FLAG(String wI_FLAG) {
		WI_FLAG = wI_FLAG;
	}
	public String getME_CODE() {
		return ME_CODE;
	}
	public void setME_CODE(String mE_CODE) {
		ME_CODE = mE_CODE;
	}
	public String getWI_CODE() {
		return WI_CODE;
	}
	public void setWI_CODE(String wI_CODE) {
		WI_CODE = wI_CODE;
	}


}
