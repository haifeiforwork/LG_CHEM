package	hris.A;

/**
 * A08licenseDetailData.java
 *  자격 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_LICENCE
 * 
 * @author 최영호    
 * @version 1.0, 2001/12/19
 */
public class A08LicenseDetailData extends com.sns.jdf.EntityData {

    public String LICN_CODE;    // 자격증 
    public String LICN_NAME;    // 자격증 text
    public String LICN_GRAD;    // 자격등급
    public String GRAD_NAME;    // 자격등급 text
	public String OBN_DATE;     // 취득일 
    public String PUBL_ORGH;    // 발행처
    public String ORGEH;        // 법정선임부서
    public String ORGTX;        // 법정선임부서 text
    public String FLAG;         // 법정선임 구분 플래그
    public String ESTA_AREA;    // 위치
}                  