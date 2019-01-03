package hris.A;

/**
 * A10RaiseResultData.java
 * 육성결과조회
 *   [관련 RFC] : ZHRA_RFC_CORE_TALENTED_PERSON2
 *
 * @author 이지은
 * @version 1.0, 2016/01/27
 * @[CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
 */
public class A10RaiseResultData extends com.sns.jdf.EntityData
{
    public String STEXT     ;       // 하위 유형 이름
    public String ENDDA     ;       // 종료일
    public String BEGDA		;       // 시작일
    public String RES_DEVE ;       // 육성결과
    public String LANDX     ;       // 국가 이름
}
