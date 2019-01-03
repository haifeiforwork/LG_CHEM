package	hris.G;

/**
 * G004CongraReasonData.java
 * 경조금 결재시 사유  데이터
 *   [관련 RFC] : ZHRA_RFC_GET_DOMAIN_NAME
 *
 * @author lsa
 * @version 1.0, 2013/09/04
 */
public class G004CongraReasonData extends com.sns.jdf.EntityData {
    public String DOMVALUE   ;     // 코드
    public String DDTEXT   ;     // 텍스트
	public String getDOMVALUE() {
		return DOMVALUE;
	}
	public void setDOMVALUE(String dOMVALUE) {
		DOMVALUE = dOMVALUE;
	}
	public String getDDTEXT() {
		return DDTEXT;
	}
	public void setDDTEXT(String dDTEXT) {
		DDTEXT = dDTEXT;
	}
}