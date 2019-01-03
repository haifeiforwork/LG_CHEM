/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 채권 압류자
*   Program ID   : F28DeptCreditSeizorData
*   Description  : 부서별 채권 압류자 조회를 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F;

/**
 * F28DeptCreditSeizorData
 *  부서별 채권 압류자 내용을 담는 데이터
 * @author
 * @version 1.0,
 */
public class F28DeptCreditSeizorData extends com.sns.jdf.EntityData {
    public String PERNR	    ;    //사원번호
    public String ENAME	    ;    //사원 또는 지원자의 포맷된 이름
    public String ORGTX	    ;    //소속명
    public String JIKKT	    ;    //직책명
    public String JIKWT	    ;    //직위명
    public String JIKCT	    ;    //직급명
    public String TRFST	    ;    //호봉 단계
    public String VGLST	    ;    //비교급여범위레벨(연차)
    public String DAT01	    ;    //입사일자
	public String BEGDA    ;     //압류일
	public String CRED_AMNT;     //압류금액
	public String CRED_TEXT;     //사유
}