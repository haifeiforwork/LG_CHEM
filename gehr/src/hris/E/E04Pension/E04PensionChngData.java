/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 국민연금 자격변경                                           */
/*   Program Name : 국민연금 자격변경                                           */
/*   Program ID   : E04PensionChngData                                          */
/*   Description  : 국민연금 자격변경 정보를 담아오는 데이터                    */
/*   Note         : [관련 RFC] : ZHRW_RFC_NATIONAL_PENSION                      */
/*   Creation     : 2002-01-25  최영호                                          */
/*   Update       : 2005-03-01  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package hris.E.E04Pension;

public class E04PensionChngData extends com.sns.jdf.EntityData {

    public String MANDT      ;   // 클라이언트
    public String BEGDA      ;   // 시작일
    public String AINF_SEQN  ;   // 결재정보 일련번호
    public String PERNR      ;   // 사원번호
    public String CHNG_TYPE  ;   // 국민연금 자격변경사항 항목 코드
    public String CHNG_BEFORE;   // 변경전 데이타
    public String CHNG_AFTER ;   // 변경후 데이타
    public String PUBLIC_DTE ;   // 발행일
    public String ZPERNR     ;   // 대리신청자 사번
    public String ZUNAME     ;   // 부서서무 이름
    public String AEDTM      ;   // 변경일
    public String UNAME      ;   // 사용자이름
    public String CHNG_TEXT  ;   // 국민연금 자격변경사항 항목코드 TEXT
}
