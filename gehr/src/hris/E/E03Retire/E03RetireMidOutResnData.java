/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 중도인출                                           */
/*   Program Name : 중도인출 사유 조회                                 */
/*   Program ID   : E03RetireMidOutResnData                                         */
/*   Description  : 중도인출 사유 조회 데이터                    */
/*   Note         : [관련 RFC] : ZSOLRP_GET_TEXT                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireMidOutResnData extends com.sns.jdf.EntityData{
	public String REASON;
	public String REASON_TEXT;	
}
