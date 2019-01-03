/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 해외경험                                                    */
/*   Program Name : 해외경험 조회                                               */
/*   Program ID   : A19OverseasCareerData                                       */
/*   Description  : 해외경험 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_TRIP_LIST                             */
/*   Creation     : 2005-01-10  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package	hris.A;

public class A19OverseasCareerData extends com.sns.jdf.EntityData {

    public String PERNR     ;  // 사원번호
    public String BEGDA     ;  // 시작일
    public String ENDDA     ;  // 종료일
    public String RESN_FLAG ;  // 사유구분
    public String RESN_TEXT ;  // 내역(활동분야)
    public String RESN_DESC1;  // 사유1(특기사항1)
    public String RESN_DESC2;  // 사유2(특기사항2)
    public String DEST_ZONE ;  // 목적지(지역)
    public String WAY1_ZONE ;  // 경유지
    public String WAY2_ZONE ;  // 경유지2
    public String CRCL_UNIT ;  // 단체
    public String EDUC_WONX ;  // 소요비용
}
