package hris.D.D01OT;

/**
 * D01OTCheckDataAdd.java
 *  한계결정한 시간 정보를 담아오는 데이터 구조
 *   [관련 RFC] : ZGHR_RFC_NTM_OT_AVAL_CHK_ADD
 *
 * @author 강동민
 * @version 1.0, 2018/05/23
 */
public class D01OTCheckDataAdd extends com.sns.jdf.EntityData {
    public String	PERNR			;		//사원 번호
    public String	AINF_SEQN		;		//결재정보 일련번호
    public String	BEGDA			;		//신청일
    public String	WORK_DATE	;		//시작일
    public String	VTKEN			;		//전일 지시자
    public String	BEGUZ			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	ENDUZ			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	STDAZ			;		//초과근무시간
    public String	PBEG1			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PEND1			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PUNB1			;		//무급휴식기간
    public String	PBEZ1			;		//유급휴식기간
    public String	PBEG2			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PEND2			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PUNB2			;		//무급휴식기간
    public String	PBEZ2			;		//유급휴식기간
    public String	PBEG3			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PEND3			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PUNB3			;		//무급휴식기간
    public String	PBEZ3			;		//유급휴식기간
    public String	PBEG4			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PEND4			;		//시간 데이타 엘리먼트(CHAR 6)
    public String	PUNB4			;		//무급휴식기간
    public String	PBEZ4			;		//유급휴식기간
    public String	REASON			;		//신청 이유
    public String	ZPERNR			;		//대리신청자사번
    public String	ZUNAME			;		//부서서무 이름
    public String	AEDTM			;		//변경일
    public String	UNAME			;		//사용자이름
    public String	OVTM_CODE	;		//사유코드
    public String	OVTM_CODE2	;		//사유코드
    public String	OVTM_CODE3	;		//사유코드
    public String	OVTM_NAME	;		//대근자
    public String	OVTM12YN		;		//12시간 초과 여부(초과이면 N)
    public String	OVTM_DESC1	;		//초과근무 상세일정
    public String	OVTM_DESC2	;		//초과근무 상세일정
    public String	OVTM_DESC3	;		//초과근무 상세일정
    public String	OVTM_DESC4	;		//초과근무 상세일정

}
