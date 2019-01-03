/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 제도전환                                       */
/*   Program Name : 퇴직연금 제도전환 종류 조회                         */
/*   Program ID   : E03RetireTransResnData                                         */
/*   Description  : 퇴직연금 제도전환 종류 조회 데이터                     */
/*   Note         : [관련 RFC] : ZSOLRP_GET_TEXT                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireTransResnData extends com.sns.jdf.EntityData{
	public String GUBN;	//퇴직연금]제도전환 구분
	public String GUBN_TEXT;	//퇴직연금]제도전환 구분명
	public String PERIOD;		//퇴직연금]제도전환 주기
	public String CHANCE;		//퇴직연금]제도전환 시기	
	public String GUBN_RESN;	//퇴직연금]제도전환 비고
}
