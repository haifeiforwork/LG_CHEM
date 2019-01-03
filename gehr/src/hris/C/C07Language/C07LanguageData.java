package	hris.C.C07Language;

/**
 * C07LanguageData.java
 * 어학지원 신청 정보를 담아오는 데이터
 * [관련 RFC] : ZHRE_RFC_LANGUAGE_SUPPORT
 * 
 * @author  김도신   
 * @version 1.0, 2003/04/14
 */
public class C07LanguageData extends com.sns.jdf.EntityData {
 
    public String PERNR     ;			// 사원번호
    public String BEGDA     ;     // 신청일
    public String AINF_SEQN ;     // 사원결재정보 일련번호
    public String SBEG_DATE ;			// 학습시작일
    public String SEND_DATE ;			// 학습종료일
    public String STUD_TYPE ;			// 학습형태
    public String STUD_INST ;			// 학습기관
    public String LECT_SBJT ;			// 수강과목
    public String LECT_TIME ;			// 수강시간
    public String SELT_DATE ;			// 결제일
    public String SETL_WONX ;			// 결제금액
    public String CARD_CMPY ;			// 카드회사
    public String CARD_NUMB ;			// 카드번호
    public String CMPY_WONX ;			// 회사지원금액 - 결제금액의 50%
    public String POST_DATE ;     // 최종결재일

}
