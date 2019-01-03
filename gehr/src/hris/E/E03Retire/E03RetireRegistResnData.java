/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 신청                                       */
/*   Program Name : 퇴직연금 코드 조회                             */
/*   Program ID   : E03RetireRegistResnData                                         */
/*   Description  : 퇴직연금 코드 조회 데이터                      */
/*   Note         : [관련 RFC] : ZSOLRP_GET_TEXT                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireRegistResnData extends com.sns.jdf.EntityData{
	public String REPE_GUBN;	//퇴직연금]연금 구분
	public String REPE_NAME;	//퇴직연금]연금 구분명

}
