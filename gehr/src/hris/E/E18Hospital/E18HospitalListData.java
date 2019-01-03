package hris.E.E18Hospital ;

/**
 * E18HospitalListData.java
 *  사원의 의료비 내역을 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_MEDIC
 * 
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18HospitalListData extends com.sns.jdf.EntityData {
    public String CTRL_NUMB  ;      // 관리번호
    public String SICK_NAME  ;      // 상병명
    public String SICK_DESC1 ;      // 구체적 증상 1
    public String SICK_DESC2 ;      // 구체적 증상 2
    public String SICK_DESC3 ;      // 구체적 증상 3
    public String EMPL_WONX  ;      // 본인납부액
    public String COMP_WONX  ;      // 회사지원액
    public String YTAX_WONX  ;      // 연말정산반영액
    public String BEGDA      ;      // 신청일
    public String POST_DATE  ;      // 최종 결제일
    public String BIGO_TEXT1 ;      // 비고1      
    public String BIGO_TEXT2 ;      // 비고2
    public String WAERS      ;      // 통화키
    public String GUEN_CODE  ;      // 본인, 배우자 구분
    public String PROOF      ;      // 배우자 연말정산반영여부
// 2005년 임단협 결과 반영(2005.05.31)
    public String ENAME      ;      // 배우자, 자녀 이름
    public String OBJPS_21   ;      // 자녀 구분자
    public String REGNO      ;      // 자녀 주민번호
//  2003.01.10. - 의료비 반납정보 추가    
    public String RFUN_DATE  ;      // 반납일자
    public String RFUN_RESN  ;      // 반납사유
    public String RFUN_AMNT  ;      // 반납액
    public String TREA_CODE  ;      // 진료과코드   06.02.23추가
    public String TREA_TEXT  ;      // 진료과코드명 06.02.23추가
    public String AINF_SEQN  ;      // 결재정보 일련번호 13.09.04 add
    
}
