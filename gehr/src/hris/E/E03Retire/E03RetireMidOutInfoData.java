/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 중도인출                                           */
/*   Program Name : 중도인출 신청/조회/변경/삭제                              */
/*   Program ID   : E03RetireMidOutInfoData                                         */
/*   Description  : 중도인출 신청/조회/변경/삭제 데이터                      */
/*   Note         : [관련 RFC] : ZSOLRP_RFC_MID_SEP_REQ                                                  */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/
package hris.E.E03Retire;

public class E03RetireMidOutInfoData extends com.sns.jdf.EntityData{
	
	public String RETEXT;	//	중도인출시 에러메시지 
	
    public String AINF_SEQN;	//결재정보 일련번호
    public String PERNR;	//사원 번호 
    public String BEGDA;	//신청일
    public String REASON;	//퇴직연금]중도인출사유코드
    public String REASON_TEXT; //[퇴직연금]중도인출사유코드명
    public String M_BEGDA;		//	결재 시 시작일
}
