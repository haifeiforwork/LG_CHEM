/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 코스트센터                                                  */
/*   Program Name : 부서별 코스트센터 조회                                      */
/*   Program ID   : F61DeptCostCenterData                                       */
/*   Description  : 부서별 코스트센터 조회를 위한 DATA 파일                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F;  

/**
 * F61DeptCostCenterData
 *  부서별 코스트센터 조회 내용을 담는 데이터
 * 
 * @author 유용원
 * @version 1.0, 
 */
public class F61DeptCostCenterData extends com.sns.jdf.EntityData {
    public String STEXT;    //조직단위 텍스
    public String KTEXT;    //코스트센터명
    public String KOSTL;    //코스트센터ID
    public String BEGDA;    //시작일자   
    public String ENDDA;    //효력만료일 

}
