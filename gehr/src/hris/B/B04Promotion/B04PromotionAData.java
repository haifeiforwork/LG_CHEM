package hris.B.B04Promotion;

/**
 * B04PromotionData.java
 *  평가기준정보 및 진급필수교육이수현황데이터
 *   [관련 RFC] : ZHRH_RFC_JINGUP_SIMUL
 * 
 * @author 이형석
 * @version 1.0, 2002/02/15
 */
public class B04PromotionAData extends com.sns.jdf.EntityData {

    //ZHRS064S 평가조회 
    public String PROM_YEAR ;   // 오브젝트이름
    public String EVAL_LEVL ;   // 시작일
    public String EVAL_AMNT ;   // 종료일
    
     //ZHRS065S 진급필수교육이수현황 
    public String EDU_NAME  ;   // 오브젝트이름
    public String EDU_FLAG  ;   // 일반플래그  
    
}

