/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 신청                                       */
/*   Program Name : 퇴직연금 신청/조회/변경/삭제                             */
/*   Program ID   : E03RetireRegistInfoData                                         */
/*   Description  : 퇴직연금  신청/조회/변경/삭제 데이터                       */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_PENSION_REQ                                                 */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package hris.E.E03Retire;

public class E03RetireRegistInfoData extends com.sns.jdf.EntityData{
	
	public String RETEXT;	//	퇴직연금 신청시 에러메시지 
	
    public String AINF_SEQN;	//결재정보 일련번호
    public String PERNR;	//사원 번호 
    public String BEGDA;	//신청일
    public String REPE_GUBN;	//퇴직연금]퇴직연금 구분
    public String REPE_NAME; //[퇴직연금]퇴직연금 구분명
    public String INSU_CODE;	//DC인 경우 연금 운용사 코드
    public String INSU_NAME;	//DC인 경우 연금 운용사명    
    public String M_BEGDA;		//	결재 시 시작일
}
