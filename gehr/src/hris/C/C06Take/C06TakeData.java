package	hris.C.C06Take;

/**
 * C06TakeData.java
 * 수강신청현황정보데이터
 *   [관련 RFC] : ZHRE_RFC_LANGUAGE_FIRST
 * 
 * @author 이형석   
 * @version 1.0, 2001/12/26
 */
public class C06TakeData extends com.sns.jdf.EntityData {

    public String GWAJUNG ;   // 과정명
    public String GWAID   ;   // 과정ID
    public String CHASU   ;   // 차수명
    public String CHAID   ;   // 차수ID
    public String GBEGDA  ;   // 시작일
    public String GENDDA  ;   // 종료일
    public String ZSTAT_ID;   // 신청사유
    
}

