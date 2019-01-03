/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금                                           */
/*   Program Name : 퇴직연금 관련 신청기간 조회                              */
/*   Program ID   : E03RetirePeriodData                                         */
/*   Description  : 퇴직연금 관련 신청기간 조회 데이터                      */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_REQUSET_PERIOD                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetirePeriodData extends com.sns.jdf.EntityData{
	public String E_MASK;
	public String E_BEGDA;
	public String E_ENDDA;
}
