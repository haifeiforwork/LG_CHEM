/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 제도전환                                       */
/*   Program Name : 퇴직연금 제도전환                        */
/*   Program ID   : E03RetireTransInfoData                                         */
/*   Description  : 퇴직연금  제도전환 신청/조회/변경/삭제   데이터                    */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_PENS_CHANGE_REQ                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireTransInfoData extends com.sns.jdf.EntityData{
	
	public String RETEXT;	//	제도전환시 에러메시지 
	
    public String AINF_SEQN;	//결재정보 일련번호
    public String PERNR;	//사원 번호 
    public String BEGDA;	//신청일
    public String GUBN;	//퇴직연금]제도전환 구분
    public String GUBN_TEXT; //[퇴직연금]제도전환 구분명
    public String M_BEGDA;		//	결재 시 시작일
}
