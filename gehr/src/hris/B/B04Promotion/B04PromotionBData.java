package hris.B.B04Promotion ;

/**
 * B04PromotionLangData.java
 *  평가등급별 점수 정보 및 어학정보 데이터
 *   [관련 RFC] : ZHRH_RFC_JINGUP_SIMUL
 * 
 * @author 이형석
 * @version 1.0, 2002/02/15
 */
public class B04PromotionBData extends com.sns.jdf.EntityData {
 
    //ZHRS066S 평가등급별 점수 정보
    public String EVAL_LEVL ;   // 개발계획상태텍스트
    public String EVAL_AMNT ;   // 오브젝트유형텍스트

    //ZHRS067S 어학정보조회   
    public String LANG_TYPE ;   // 어학레코드 유형
    public String LANG_NAME ;   // 하부유형이름
    public String LANG_AMNT ;   // 어학점수/등급
    public String GIJUN_AMNT;   // 어학점수/등급 
    
}

