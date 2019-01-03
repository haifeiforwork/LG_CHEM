package	hris.E.E30HealthInsurance;

/**
 * PensionDetailData.java
 * 건강보험 관련 정보를 담아오는 Data
 * [관련 RFC] : ZHRW_RFC_GET_HEALTH_INSURANCE 
 * 
 * @author  김도신
 * @version 1.0, 2003/02/19
 */
public class E30HealthInsuranceData extends com.sns.jdf.EntityData {
    
    public String SUBTY	;	   //하부유형
    public String OBJPS	;	   //오브젝트식별
    public String STEXT	;	   //하부유형이름
    public String LNMHG	;	   //성 (한글)
    public String FNMHG	;	   //이름 (한글)
    public String REGNO	;	   //주민등록번호
    public String GRADE	;	   //등급
    public String BEGDA	;	   //시작일
    
}

