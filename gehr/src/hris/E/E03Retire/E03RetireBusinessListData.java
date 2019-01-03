/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금사업자변경                                                 */
/*   Program Name : 연금사업자조회                                   */
/*   Program ID   : E03RetireBusinessListData                                         */
/*   Description  : 연금사업자리스트 데이터                                   */
/*   Note         : [관련 RFC] : ZSOLRP_GET_TEXT                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                         */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireBusinessListData extends com.sns.jdf.EntityData
{
    public String REPE_GUBN        ;   // 연금 구분 코드
    public String INSU_CODE         ;   // 연금사 코드
    public String INSU_NAME         ;   // 연금사 텍스트
}
