package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustPensionData.java
 * 연말정산 -  연금/저축공제 데이터
 * [관련 RFC] : ZSOLYR_RFC_YEAR_PENSION_SAVING
 *
 * @author lsa
 * @version 1.0, 1.0, 2010/12/08
 */
public class D11TaxAdjustPensionData extends com.sns.jdf.EntityData {

	public String GUBUN;
    public String MANDT	 ;   //클라이언트
    public String WORK_YEAR; //카운트 매개변수
    public String ENDDA	 ;   //종료일
    public String BEGDA	 ;   //시작일
    public String PERNR	 ;   //사원 번호
    public String SUBTY	 ;   //하위 유형
    public String PNSTY	 ;   //구분
    public String SEQNR	 ;   //동일한 키를 가진 인포타입 레코드 번호
    public String EXPTY	 ;   //비용 유형
    public String NAM01	 ;   //NTS로부터의 비용 금액 정보
    public String CUR01	 ;   //비용 통화 키
    public String FINCO	 ;   //금융기관코드
    public String INSNM	 ;   //연금저축 금융사명
    public String ACCNO	 ;   //계좌번호
    public String PREIN	 ;   //종(전)근무지
    public String REQ_H	 ;   //세대주필수 체크
    public String PREIN_FLAG	 ;   //종(전)근무지필수 체크
    public String FINCO_FLAG	 ;   //금융기관코드필수 체크
    public String ACCNO_FLAG	 ;   //계좌번호필수 체크
    public String PDF_FLAG	 ;   //PDF 파일여부
    public String OMIT_FLAG;	//삭제 플래그
    public String RCBEG ; //가입일 @2015 연말정산 청약저축일 경우 필수항목
}
