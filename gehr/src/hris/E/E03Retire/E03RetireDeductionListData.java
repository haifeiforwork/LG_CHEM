/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금추가납입                                                 */
/*   Program Name : 연금추가납입 실적                                  */
/*   Program ID   : E03RetireDeductionListData                                         */
/*   Description  : 연금추가납입 실적 데이터                           */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_GET_DEDUCTION                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                       */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireDeductionListData extends com.sns.jdf.EntityData{
	public String ZYEAR;
	public String MONTH;
	public String BETRG;
	public String BETRG2;
	public String E_TOTAL_AMT;
}
