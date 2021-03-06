/********************************************************************************
*
*   System Name  : MSS
*   1Depth Name  : Manager's Desk
*   2Depth Name  : 인원현황
*   Program Name : 소속별/직급별 평균연령
*   Program ID   : F07DeptPositionClassAgeTitleData
*   Description  : 소속별/직급별 평균연령 조회를 위한 타이틀 DATA 파일
*   Note         : 없음
*   Creation     :
*   Update       :
*
********************************************************************************/

package hris.F;

/**
 * F07DeptPositionClassAgeTitleData
 *  소속별/직급별 평균연령 타이틀을 담는 데이터
 * @author
 * @version 1.0,
 */
public class F07DeptPositionClassAgeTitleData extends com.sns.jdf.EntityData {
    public String PERSK;    //사원서브그룹
    public String PTEXT;    //사원서브그룹이름
    public String TRFGR;    //급여그룹
}
