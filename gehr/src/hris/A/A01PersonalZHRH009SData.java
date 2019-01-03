/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH009SData                                     */
/*   Description  : 해외경험 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;

public class A01PersonalZHRH009SData extends com.sns.jdf.EntityData {

    public String BEGDA1    ;  // 시작일
    public String PERIOD    ;  // 기간(체류기간)
    public String DEST_ZONE ;  // 목적지(지역)
    public String RESN_DESC ;  // 사유(활동분야)
    public String RESN_DESC1;  // 사유1(특기사항)
} 