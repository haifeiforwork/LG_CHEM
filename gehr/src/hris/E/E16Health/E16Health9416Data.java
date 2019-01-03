package	hris.E.E16Health;

/**
 * E16Health9416Data.java
 * 임직원건강관리카드에 검진이력에   대한 데이터
 *   [관련 RFC] : ZHRW_RFC_HEALTH_CARD_DISPLAY
 * 
 * @author lsa   
 * @version 1.0, 2010/05/31
 */
public class E16Health9416Data extends com.sns.jdf.EntityData {

    public String SUBT_TYPE;     //신청일
    public String MEDI_RSLT ;     // 유소견 코드 
    public String MEDI_DISE1;      // 질환유형
    public String MEDI_DISE2;      // 질환유형
    public String MEDI_DISE3;      // 질환유형
    public String MEDI_DISE4;      // 질환유형
    public String MEDI_DISE5;      // 질환유형
    public String MEDI_DISE6;      // 질환유형
    public String MEDI_DESC1;    // 상세결과 
    public String MEDI_DESC2;    // 상세결과
    public String MEDI_DESC3;    // 상세결과
    public String BEGDA;            // 상세결과    
    public String Z_YEAR;          // 검진년도
    public String SUBT_TEXT;     // 검사유형 텍스트
    public String DDTEXT1;          //고정 값 내역   
    public String DDTEXT2;          //고정 값 내역   
    public String DDTEXT3;          //고정 값 내역   
    public String DDTEXT4;          //고정 값 내역   
    public String DDTEXT5;          //고정 값 내역   
    public String DDTEXT6;          //고정 값 내역   
    
}
