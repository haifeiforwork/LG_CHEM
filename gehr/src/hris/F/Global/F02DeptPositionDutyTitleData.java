/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 소속별/직무별 인원현황                                      */
/*   Program ID   : F02DeptPositionDutyTitleData                               */
/*   Description  : 소속별/직무별 인원현황 조회를 위한 타이틀 DATA 파일         */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-01 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.Global;

/**
 * F02DeptPositionDutyTitleData
 *  소속별/직무별 인원현황 타이틀을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F02DeptPositionDutyTitleData extends com.sns.jdf.EntityData {
    public String PERSG;    //직렬
    public String PERST;    //오브젝트이름
    public String JIKGU;
    public String JIKGT;
}
