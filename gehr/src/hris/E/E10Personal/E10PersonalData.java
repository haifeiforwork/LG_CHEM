/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금                                                    */
/*   Program ID   : E10PersonalData                                             */
/*   Description  : 개인연금/마이라이프 가입에 대한 데이터                      */
/*   Note         : [관련 RFC] : ZHRW_RFC_PENTION_APPLICATION                   */
/*   Creation     : 2001-12-26  이형석                                          */
/*   Update       : 2005-02-23  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E10Personal;

public class E10PersonalData extends com.sns.jdf.EntityData {

    public String MANDT      ;  // 클라이언트
    public String PERNR      ;  // 사원번호
    public String BEGDA      ;  // 신청일
    public String AINF_SEQN  ;  // 결재정보 일련번호
    public String APPL_TYPE  ;  // 신청구분
    public String PENT_TYPE  ;  // 연금구분
    public String BANK_TYPE  ;  // 금융기관
    public String ENTR_DATE  ;  // 신청일
    public String ENTR_TERM  ;  // 가입기간
    public String MNTH_AMNT  ;  // 월납입액
    public String PERL_AMNT  ;  // 개인납입액
    public String CMPY_AMNT  ;  // 회사납입액
    public String CMPY_FROM  ;  // 회사지원 FROM
    public String CMPY_TOXX  ;  // 회사지원 TO
    public String CMPY_DATE  ;  // 회사지원한도일
    public String ZPENT_TEXT1;  // 개인연금 텍스트
    public String ZPENT_TEXT2;  // 금융기관 텍스트
    public String CLOSE_DATE ;  // 해지시작일
    public String ZPERNR     ;  // 대리신청자 사번
    public String ZUNAME     ;  // 부서서무 이름
    public String AEDTM      ;  // 변경일
    public String UNAME      ;  // 사용자이름
    public String WAERS;     ;  // 통화키
}
