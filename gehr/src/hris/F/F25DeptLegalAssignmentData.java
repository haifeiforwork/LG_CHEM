/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 법정선임 내역
*   Program ID   : F25DeptLegalAssignmentData
*   Description  : 부서별 법정선임 내역 조회를 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F;

/**
 * F25DeptLegalAssignmentData
 *  부서별 법정선임 내역 내용을 담는 데이터
 * @author
 * @version 1.0,
 */
public class F25DeptLegalAssignmentData extends com.sns.jdf.EntityData {
    public String PERNR	    ;    //사원번호
    public String ENAME	    ;    //사원 또는 지원자의 포맷된 이름
    public String ORGTX	    ;    //소속명
    public String JIKKT	    ;    //직책명
    public String JIKWT	    ;    //직위명
    public String JIKCT	    ;    //직급명
    public String TRFST	    ;    //호봉 단계
    public String VGLST	    ;    //비교급여범위레벨(연차)
    public String DAT01	    ;    //입사일자
    public String LICNNM	;  	 //자격면허명
    public String OBNDAT	; 	 //취득일
    public String LGRDNM	;  	 //자격등급명
    public String PBORGH	;  	 //발행기관
    public String LAW		;	 //법정선임사유
}
