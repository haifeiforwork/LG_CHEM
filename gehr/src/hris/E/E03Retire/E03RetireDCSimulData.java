/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직금                                             */
/*   2Depth Name  : 퇴직금 조회                                                 */
/*   Program Name : 퇴직금 조회 - DC사용자                                  */
/*   Program ID   : E03RetireDCSimulData                                         */
/*   Description  : 퇴직금 조회  데이터 - DC사용자                          */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_GET_DEDUCTION_WHOLE                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                       */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireDCSimulData extends com.sns.jdf.EntityData{
	public String E_INSU_TEXT; //퇴직연금 사업자
	
	public String ZYEAR;	//년도
	public String BETRG;	//회사납입금액
	public String ADD_BETRG;	//추가납입금액
	public String SUM_BETRG; //합계
}
