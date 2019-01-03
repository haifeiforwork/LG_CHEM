package hris.E.Global.E18Hospital ;

/**
 * E18HospitalDetailData.java
 *  사원의 의료비 상세 내역을 담는 데이터
 *   [관련 RFC] : ZHRW_RFC_MEDIC_DETAIL
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18HospitalDetailData extends com.sns.jdf.EntityData {
    public String MEDI_NAME ;      // 의료기관
    public String TELX_NUMB ;      // 전화번호
    public String EXAM_DATE ;      // 진료일
    public String MEDI_CODE ;      // 입원/외래
    public String MEDI_TEXT ;      // 입원/외래
    public String RCPT_CODE ;      // 영수증 구분
    public String RCPT_TEXT ;      // 영수증 구분
    public String RCPT_NUMB ;      // No.
    public String EMPL_WONX ;      // 본인 실납부액
    public String WAERS     ;      // 통화키
//  2004년 연말정산 이후 사업자등록번호 필드 추가 (3.7)
    public String MEDI_NUMB ;      // 의료기관 사업자등록번호
    public String MEDI_MTHD ;      // 05.12.26 add 결재수단 (1:현금, 2:신용카드)
    public String MEDI_YEAR ;      // 05.12.26 add 연말정산제외
    public String YTAX_WONX ;      // 06.01.17 add 연말정산반영액
}
