/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 개인연금                                                    */
/*   Program Name : 개인연금/마이라이프 해약신청                                */
/*   Program ID   : E11AnnulmentBuildSV                                         */
/*   Description  : 개인연금/마이라이프 조회/신청/삭제                          */
/*   Note         : [관련 RFC] : ZHRW_RFC_PENTION_APPLICATION [1],              */
/*                               ZHRW_RFC_PENTION_DISPLAY [2]                   */
/*   Creation     : 2002-02-04  박영락                                          */
/*   Update       : 2005-02-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E11Personal;

public class E11PersonalData extends com.sns.jdf.EntityData {

    public String MANDT      ;  // 클라이언트
    public String PERNR      ;  // 사원번호
    public String BEGDA      ;  // 시작일
    public String ENDDA      ;  // 종료일
    public String AINF_SEQN  ;  // 결재정보 일련번호
    public String APPL_TYPE  ;  // 신청구분(1:신청, 2:해약)[1]
    public String PENT_TYPE  ;  // 연금구분
    public String BANK_TYPE  ;  // 금융기관
    public String ENTR_DATE  ;  // 신청일
    public String ENTR_TERM  ;  // 가입기간
    public String MNTH_AMNT  ;  // 월납입액
    public String PERL_AMNT  ;  // 개인납입액
    public String CMPY_AMNT  ;  // 회사납입액
    public String CMPY_FROM  ;  // 가입일
    public String CMPY_TOXX  ;  // 가입종료일(만기일)

    public String CMPY_DATE  ;  // 회사지원한도일
    public String ZPENT_TEXT1;  // 개인연금 텍스트
    public String ZPENT_TEXT2;  // 금융기관 텍스트
    public String CLOSE_DATE ;  // 해지시작일
    public String ZPERNR     ;  // 대리신청자 사번
    public String ZUNAME     ;  // 부서서무 이름
    public String AEDTM      ;  // 변경일
    public String UNAME      ;  // 사용자이름

    public String SUMM_AMNT  ;  // 불입누계
    public String RESM_TERM  ;  // 잔여월//계산
    public String LAST_MNTH  ;  // 납입월
    
    //추가
    public String ABDN_DATE  ;  //해약일
    public String PENT_TEXT  ;  //연금구분 텍스트
    public String BANK_TEXT  ;  //금융기간 텍스트
    public String STATUS     ;  //계약상태를 나타냄 해지, 진행중, 만기완료
}
