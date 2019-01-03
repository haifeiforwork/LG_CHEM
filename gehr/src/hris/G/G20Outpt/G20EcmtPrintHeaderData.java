package hris.G.G20Outpt;

/**
 * 근로소득 원천징수 영수증을 발행하는 정보를 가지는 Header Data
 * [관련 RFC] : ZHRP_RFC_READ_YEA_RESULT_PRIN
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintHeaderData extends com.sns.jdf.EntityData {
   
    public String COMNM;			// 법인명 - COMPANY	
    public String REPRES;			// 대표자(성명) - COMPANY	
    public String STCD2;			// 사업자등록번호 - COMPANY	
    public String STCD1;			// 주민(법인)등록번호 - COMPANY	
    public String ADDRESS_LINE;		// 소재지 - COMPANY	
    public String ENAME;			// 성명 - EMPLOYEE	
    public String REGNO;			// 주민등록번호-EMPLOYEE	
    public String ADDRE;			// 개인주소 - EMPLOYEE	
    public String RT_BEGDA;			// 귀속년도 시작일 - EMPLOYEE	
    public String RT_ENDDA;			// 귀속년도 종료일 - EMPLOYEE	
    public String EX_BEGDA;			// 감면기간 시작일 - EMPLOYEE	
    public String EX_ENDDA;			// 감면기간 종료일 - EMPLOYEE	
    public String RESIDNT;			// 거주구분 - 거주자	
    public String N_RESID;			// 거주구분 - 비거주자	
    public String KOREAN;			// 내/외국인 - 내국인	
    public String FOREIGN;			// 내/외국인 - 외국인	
    public String FLAT_RATE;		// 외국인 단일세율 적용	
    public String N_FLAT_RATE;		// 외국인 단일세율 비적용	
    public String COUNTRY;			// 국가이름	
    public String CURCD;			// 국가코드	
    public String DATUM;			// 영수일	
    public String DUTYM;			// 징수보고의무자	
    
}