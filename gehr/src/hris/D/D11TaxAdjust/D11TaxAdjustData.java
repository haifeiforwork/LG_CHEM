package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustData.java
 *  연말정산공제신청/수정, 소득공제신고서출력용 데이터
 *   [관련 RFC] : ZHRP_RFC_COLLECT_YEA_DATA
 *   table name : ESS 인적공제분[1 ZHRPI01S], ESS 연말정산 특별공제분 & ESS 연말정산 기타/세액공제분[2 ZHRPI02S]
 * @author 김성일
 * @version 1.0, 2002/01/22
 */
public class D11TaxAdjustData extends com.sns.jdf.EntityData {

    public String RELA      ;   // 관계         [1,2]
    public String ENAME     ;   // 성명         [1,2]
    public String REGNO     ;   // 주민등록번호 [1,2]

    public String BASIC_RED ;   // 기본공제     [1  ]
    public String OLD_RED   ;   // 경로우대     [1  ]
    public String HANDY_RED ;   // 장애자       [1  ]
    public String WOMEN_RED ;   // 부녀자       [1  ]
    public String CHILD_RED ;   // 자녀양육비   [1  ]    
                                                
    public String GUBUN     ;   // 공제구분     [  2]
    public String FASAR     ;   // 가족구성원의 학력[  2]
    public String STEXT     ;   // 학교유형텍스트[  2]
    public String ADD_AMT   ;   // 개인추가분   [  2]
    public String AUTO_AMT  ;   // 자동반영분   [  2]
    public String AUTO_TEXT ;   // 자동분내역   [  2]     
}                                              
