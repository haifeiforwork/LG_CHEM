/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 주택자금 상환신청                                           */
/*   Program Name : 주택자금 상환신청                                           */
/*   Program ID   : E06RehouseData                                              */
/*   Description  : 주택자금신청상환 데이타                                     */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_FUND_REFUND_APP                   */
/*   Creation     : 2001-12-26  이형석                                          */
/*   Update       : 2005-03-04  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E06Rehouse;

public class E06RehouseData extends com.sns.jdf.EntityData
{
    public String MANDT       ;  // 클라이언트
    public String PERNR       ;  // 사원번호
    public String BEGDA       ;  // 신청일
    public String AINF_SEQN   ;  // 결재정보 일련번호
    public String DLART       ;  // 대출유형
    
    public String REPT_DATE   ;  // 상환액 입금일자
    public String BUDAT       ;  // 전표전기일
    public String RPAY_AMNT   ;  // 상환원금
    public String INTR_AMNT   ;  // 주택자금 이자
    public String TOTL_AMNT   ;  // 총액
    public String DARBT       ;  // 승인된 대출금액
    public String DATBW       ;  // 승인일
    public String ALREADY_AMNT;  // 기상환금액
    public String ZZSECU_FLAG ;  // 보증인여부
    public String NEWKO       ;  // 총계정원장계정
    public String SLIP_NUMB   ;  // 회계전표번호
    public String POST_DATE   ;  // POSTING일자
    public String BELNR       ;  // 회계전표번호
    public String ZPERNR      ;  // 대리신청자 사번
    public String ZUNAME      ;  // 부서서무 이름
    public String AEDTM       ;  // 변경일
    public String UNAME       ;  // 사용자이름
    
    public String REMAIN_AMNT   ;  // 사용자이름
    public String E_ALREADY_AMNT;  //기상환액
    public String E_DARBT       ;  //승인된 대출금액
    public String E_DATBW       ;  //승인일
    public String E_INTR_AMNT   ;  //주택이자     
    public String E_REMAIN_AMNT ;  //대출잔액
    public String E_RPAY_AMNT   ;  //상환원금
    public String E_TOTAL_AMNT  ;  //합계     
    public String E_ZZSECU_FLAG ;  //보증여부
    public String E_ZZSECU_TXT  ;  //보증여부
    public String E_REPT_DATE   ;  //날짜
}

