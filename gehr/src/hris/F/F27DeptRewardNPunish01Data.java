/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 부서별 포상/징계 내역
*   Program ID   : F27DeptRewardNPunish01Data
*   Description  : 부서별 포상 내역 조회를 위한 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package hris.F;

/**
 * F27DeptRewardNPunish01Data
 *  부서별 포상 내역 내용을 담는 데이터
 * @author
 * @version 1.0,
 */
public class F27DeptRewardNPunish01Data extends com.sns.jdf.EntityData {
    public String PERNR	    ;    //사원번호
    public String ENAME	    ;    //사원 또는 지원자의 포맷된 이름
    public String ORGTX	    ;    //소속명
    public String JIKKT	    ;    //직책명
    public String JIKWT	    ;    //직위명
    public String JIKCT	    ;    //직급명
    public String TRFST	    ;    //호봉 단계
    public String VGLST	    ;    //비교급여범위레벨(연차)
    public String DAT01	    ;    //입사일자
    public String BEGDA;     //포상일
    public String PRZTX;     //포상유형
    public String PRZRN;     //포상사유
    public String COMNT;     //비고
}
