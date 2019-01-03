/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 연금사업자변경                                                 */
/*   Program Name : 연금사업자조회                                   */
/*   Program ID   : E03RetireBusinessInfoData                                         */
/*   Description  : 개인별 연금사업자 데이터                                */
/*   Note         : [관련 RFC] : ZSOLRP_GET_REPEGUBN                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireBusinessInfoData extends com.sns.jdf.EntityData
{
	public String E_INSU_CODE;	//	현재연금사코드 
	
	public String RETEXT;	//	현재연금사변경시 에러메시지 
	
	public String AINF_SEQN;	//	결재번호
    public String PERNR;		//	사번
    public String BEGDA;		//	시작일
    public String INSU_CODE;	//	연금사코드
    public String INSU_NAME;	//	연금사명칭
    public String M_BEGDA;		//	결재 시 시작일
}	
