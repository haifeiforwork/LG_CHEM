package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustHouseLoanData.java * @2015 연말정산 -  주택자금상환 데이터 * [관련 RFC] : ZSOLYR_RFC_HOUSE_LOAN * * @author 이지은 * @version 1.0, 1.0, 2015/12/29
 */
public class D11TaxAdjustHouseLoanData extends com.sns.jdf.EntityData {

    public String MANDT	 ;   //클라이언트    public String WORK_YEAR; //카운트 매개변수    public String ENDDA	 ;   //종료일    public String BEGDA	 ;   //시작일    public String PERNR	 ;   //사원 번호	public String GUBUN;  //회사지원분 1,  eHR신청 2, PDF 9    public String SUBTY	 ;   //하위 유형    public String SEQNR	 ;   //동일한 키를 가진 인포타입 레코드 번호    public String NAM01	 ;   //NTS로부터의 비용 금액 정보    public String FIXRT	 ;   //고정금리    public String NODEF	 ;   //비거치    public String LSREG	 ;   //주민등록번호 (한국)    public String INRAT	 ;   //이자율    public String INTRS	 ;   //이자    public String OMIT_FLAG;	//삭제 플래그    public String RCBEG ; //가입일    public String RCEND ; //종료일    public String PDF_FLAG ; //pdf 여부    public String LNPRD ; //@2016연말정산 대출기간(년)

}
