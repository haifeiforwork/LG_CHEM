package hris.G.G20Outpt;

/**
 * G20EcmtPrintData.java
 * 근로소득 원천징수 영수증을 발행하는 정보를 가지는 Data
 * [관련 RFC] : ZHRH_RFC_DEDUCT_TAXES_DOC
 * 
 * @author  
 * @version 
 */
public class G20EcmtPrintData extends com.sns.jdf.EntityData {
   
    public String MANDT       ;        //클라이언트(회사코드)
    public String PERNR       ;        //사원번호
    public String BEGDA       ;        //신청일
    public String AINF_SEQN   ;        //결재정보 일련번호
    public String GUEN_TYPE   ;        //근로소득및 갑근세 원천징수 구분
    public String PRINT_NUM   ;        //발행부수
    public String SUBMIT_PLACE;        //제출처
    public String USE_PLACE   ;        //사용목적
    public String SPEC_ENTRY1 ;        //특기사항1
    public String SPEC_ENTRY2 ;        //특기사항2
    public String SPEC_ENTRY3 ;        //특기사항3
    public String SPEC_ENTRY4 ;        //특기사항4
    public String SPEC_ENTRY5 ;        //특기사항5
    public String PUBLIC_NUM  ;        //발행번호
    public String PUBLIC_DTE  ;        //발행일
    public String PUBLIC_MAN  ;        //발행인
    public String ZUNAME      ;        //부서서무 이름
    public String AEDTM       ;        //변경일
    public String UNAME       ;        //사용자이름
//  2002.11.22. 갑근세 원천징수 증명서 선택시 선택기간 입력하도록 추가    
    public String EBEGDA      ;        //선택기간 시작일
    public String EENDDA      ;        //선택기간 종료일

}