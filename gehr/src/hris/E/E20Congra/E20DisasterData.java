package hris.E.E20Congra;

/**
 * E20DisasterData.java
 * 재해피해신고서조회
 *   [관련 RFC] :  ZHRW_RFC_DISASTER_DISPLAY
 *
 * @author 박영락
 * @version 1.0, 2001/12/20
 */
public class E20DisasterData extends com.sns.jdf.EntityData
{
    public String CONG_DATE ;   // 발생일자
    public String DISA_CODE ;   // 재해구분코드
    public String DISA_DESC1;   // 재해내용1
    public String DISA_DESC2;   // 재해내용2
    public String DISA_DESC3;   // 재해내용3
    public String DISA_DESC4;   // 재해내용4
    public String DISA_DESC5;   // 재해내용5
    public String DISA_RATE ;   // 지급율
    public String DREL_CODE ;   // 재해대상자 관계코드
    public String EREL_NAME ;   // 경조대상자명
    public String INDX_NUMB ;   // 순번
    public String PERNR     ;   // 사원번호
    public String REGNO     ;   // 주민등록번호
    public String STRAS     ;   // 주소
    public String CONG_NAME ;   // 경조내역명
    public String RELA_NAME ;   // 본인과의관계
}
