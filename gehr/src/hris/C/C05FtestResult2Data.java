package	hris.C;

/**
 * C05FtestResult2Data.java
 * 개인의 어학능력 정보를 담아오는 데이터
 *   [관련 RFC] : ZHRE_RFC_LANGUAGE_ABILITY
 * 
 * @author 김도신    
 * @version 1.0, 2002/01/14
 */
public class C05FtestResult2Data extends com.sns.jdf.EntityData {

    public String SUBTY   ;   // 하부유형
    public String COMP_AVG;   // 전사평균
    public String TITL_AVG;   // 직급평균
    public String RANGE1  ;   // 분포율1
    public String RANGE2  ;   // 분포율2

}
