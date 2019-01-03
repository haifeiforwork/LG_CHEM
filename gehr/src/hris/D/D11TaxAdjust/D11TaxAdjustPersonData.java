package hris.D.D11TaxAdjust ;

/**
 * D11TaxAdjustPersonData.java
 * 연말정산 - 인적공제 데이터
 * [관련 RFC] : ZHRP_RFC_YEAR_PERSON
 *
 * @author 김도신
 * @version 1.0, 2002/11/20
* @version 2.0, 2013/12/10  CSR ID :C20140106_63914
* 2018/01/05 rdcamel [CSR ID:3569665] 2017년 연말정산 웹화면 수정 요청의 건
 */
public class D11TaxAdjustPersonData extends com.sns.jdf.EntityData {

    public String SUBTY  ;  // 관계코드
    public String STEXT  ;  // 관계
    public String ENAME  ;  // 성명
    public String REGNO  ;  // 주민등록번호
    public String BETRG01;  // 기본공제
    public String BETRG02;  // 경로우대
    public String BETRG03;  // 장애자
    public String BETRG04;  // 부녀자
    public String BETRG05;  // 자녀양육비
    public String BETRG06;  // CSR ID:1361257 출산·입양
    public String BETRG07;  // CSR ID:C20140106_63914 한부모가족
    public String CHILD  ;  // 자녀양육
    public String WOMEE  ;  // 부녀자공제
    public String FSTID  ;  // 위탁아동 지시자
    public String HNDEE  ;  // 장애인사원 CSR ID :C20140106_63914
    public String HNDCD  ;  // 장애 코드 CSR ID :C20140106_63914
    public String KDBSL ; //[CSR ID:3569665] 자녀유형 첫째, 둘째, 셋째 이상
}
