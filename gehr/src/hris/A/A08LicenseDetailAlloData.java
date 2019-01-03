package	hris.A;

/**
 * A08licenseDetailData.java
 *  자격 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_LICENSE_ALLOWANCE
 * 
 * @author 최영호    
 * @version 1.0, 2001/12/19
 */
public class A08LicenseDetailAlloData extends com.sns.jdf.EntityData {

    public String CHAG_RESN;    // 변경사유
    public String CHAG_NAME;    // 변경사유 text
    public String LICN_CODE;    // 자격증
    public String LICN_NAME;    // 자격증 text
	public String LICN_GRAD;    // 자격등급 
    public String GRAD_NAME;    // 자격등급 text
    public String GIVE_RATE1;   // 지급율
    public String LICN_AMNT;    // 금액
    public String WAERS;        // 통화키
    public String ORGEH;        // 조직단위
    public String ORGTX;        // 조직단위 text
    public String EQUI_NAME;    // 설비
    public String ESTA_AREA;    // 위치
    public String PRIZ_TEXT;    // 비고
    public String CERT_DATE;    // 취득일

}                  