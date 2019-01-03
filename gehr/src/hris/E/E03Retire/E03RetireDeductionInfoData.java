/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금추가납입                                                 */
/*   Program Name : 연금추가납입 조회                                  */
/*   Program ID   : E03RetireDeductionInfoData                                         */
/*   Description  : 연금추가납입조회 데이터                           */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_CHECK_REQ_OR_DEL                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                       */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireDeductionInfoData extends com.sns.jdf.EntityData{
	public String BETRG_0014;
	public String BETRG_0015;
	public String DATE_0014;
	public String DATE_0015;
	public String CHECK_CODE_0014;
	public String CHECK_CODE_0015;
	
	public String RETCODE;
	public String RETTEXT;	
}
