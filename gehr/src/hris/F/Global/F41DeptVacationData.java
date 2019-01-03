/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 부서별 휴가 사용 현황                                       */
/*   Program ID   : F41DeptVacationData                                         */
/*   Description  : 부서별 휴가 사용 현황 조회를 위한 DATA 파일                 */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.Global;

/**
 * F41DeptVacationData
 *  부서별 휴가 사용 현황 내용을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F41DeptVacationData extends com.sns.jdf.EntityData {
    public String PERNR;    //사원번호
    public String ENAME;    //한글이름
    public String STEXT;    //조직단위텍스트
    public String JIKTX;    //직책
    public String JIWTX;    //직위
    public String JICTX;    //급여그룹(직급)
    public String ANNUL;    //급여레벨(호봉)
    public String HDATE;    //비교급여범위레벨(연차)
    public String CSDAT;    //입사일자
    public String GENERATED;    //발생일수
    public String USED;    //사용일수
    public String BALANCE;    //잔여일수
    public String USERATE;    //휴가사용율
    public String TATIT;
    public String ORUNI;
}
