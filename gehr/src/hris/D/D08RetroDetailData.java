package hris.D;

/**
 * D08RetroDetailData.java
 * 소급결과내역조회 데이타
 *   [관련 RFC] : ZHRP_RFC_SOGUP_LIST
 * 
 * @author 최영호 
 * @version 1.0, 2002/01/23
 */
public class D08RetroDetailData extends com.sns.jdf.EntityData
{
  
    public String FPPER       ;  // 차압통고 대상기간
    public String PAYDT       ;  // 지급일
    public String OCRSN       ;  // 비정기급여사유
    public String OCRTX       ;  // 비정기급여사유TEXT
    public String LGART       ;  // 임금유형
    public String LGTXT       ;  // 임금유형TEXT
    public String GUBUN       ;  // 일반플래그
    public String ANZHL       ;  // 인사급여관리:수 (소급전)
    public String ANZHL1       ;  // 인사급여관리:수 (소급후)
    public String SOGUP_BEFORE;  // 급여임금유형금액
    public String SOGUP_AFTER ;  // 급여임금유형금액
    public String SOGUP_AMNT  ;  // 급여임금유형금액
                
  
}