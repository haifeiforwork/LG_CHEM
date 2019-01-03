/*
 * 작성된 날짜: 2005. 3. 7.
 *
 */
package hris.G;

import com.sns.jdf.EntityData;

/**
 * @author 이승희
 *
 */
public class MealChargeData extends EntityData
{
    public String  PERNR        ; // 사번(13자리 식대관리)
    public String  BEGDA        ; // 신청일
    public String  AINF_SEQN    ; // 결재정보 일련번호
    public String  APLY_FLAG    ; // 신청구분
    public String  APLY_MNTH    ; // 분석기간 - 월
    public String  ORGEH        ; // 소속부서
    public String  ENAME        ; // 사원 또는 지원자의 포맷이름
    public String  TKCT_CONT    ; // 현물지급일수
    public String  TKCT_WONX    ; // 현물지급액
    public String  CASH_CONT    ; // 현금보상일수
    public String  CASH_WONX    ; // 현금보상액
    public String  BANKS        ; // 은행국가키
    public String  BANKL        ; // 은행 키
    public String  BANKN        ; // 은행계좌번호
    public String  BKONT        ; // 은행관리키
    public String  BVTYP        ; // 거래처은행유형
    public String  POST_DATE    ; // POSTING일자
    public String  BELNR        ; // 회계전표번호
    public String  ZPERNR       ; // 대리신청자 사번
    public String  ZUNAME       ; // 부서서무 이름
    public String  BIGO_TXT     ; // 구체적증상
    public String  STEXT        ; // 부서명
    public String  BANKTXT      ; // 은행명
    public String  AEDTM        ; // 변경일
    public String  UNAME        ; // 사용자이름
}
