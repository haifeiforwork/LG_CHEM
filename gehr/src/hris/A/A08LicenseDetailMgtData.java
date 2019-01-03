package	hris.A;

/**
 * A08licenseDetailData.java
 *  자격 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRH_RFC_LICENCE_MGT
 * 
 * @author 최영호    
 * @version 1.0, 2001/12/19
 */
public class A08LicenseDetailMgtData extends com.sns.jdf.EntityData {

    public String LICN_TYPE;    // 자격증 구분
    public String GUBN_NAME;    // 자격증 구분 text
    public String FILD_TYPE;    // 분야
    public String FILD_NAME;    // 분야 text
	public String LICN_CODE;    // 자격증 
    public String LICN_NAME;    // 자격증 text
    public String LICN_GRAD;    // 자격등급
    public String GRAD_NAME;    // 자격등급 text
    public String OBN_DATE;     // 취득일
    public String LICN_NUMB;    // 자격증 번호
    public String PUBL_ORGH;    // 발행처
    public String ORGEH;        // 조직단위
    public String ORGTX;        // 자격관리부서 text
    public String CERT_FLAG;    // 증빙
    public String CERT_DATE;    // 취득일
}                  