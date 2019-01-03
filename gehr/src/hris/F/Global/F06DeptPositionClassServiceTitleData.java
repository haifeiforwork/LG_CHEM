/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 소속별/직급별 평균근속                                      */
/*   Program ID   : F06DeptPositionClassServiceTitleData                        */
/*   Description  : 소속별/직급별 평균근속 조회를 위한 타이틀 DATA 파일         */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-03 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.Global;

/**
 * F06DeptPositionClassServiceTitleData
 *  소속별/직급별 평균근속 타이틀을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F06DeptPositionClassServiceTitleData extends com.sns.jdf.EntityData {
    public String PERSK;    //사원서브그룹
    public String PTEXT;    //사원서브그룹이름
    public String TRFGR;    //급여그룹

    public String ZLEVEL;
    public String OBJID;
    public String STEXT;
    public String JIKGU;
    public String JIKGT;
    public String F1;
    public String F2;
    public String F3;
    public String F4;
    public String F5;
    public String F6;
    public String F7;
    public String F8;
    public String F9;

}
