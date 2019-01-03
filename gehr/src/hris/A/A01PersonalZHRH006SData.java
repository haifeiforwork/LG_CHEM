/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH006SData                                     */
/*   Description  : 포상 정보를 담아오는 데이터                                 */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.A; 

public class A01PersonalZHRH006SData extends com.sns.jdf.EntityData {

    public String POHA     ;  // 포상항목
    public String BEGDA1   ;  // 시작일
    public String BEGDA    ;  // 시작일(수상일자)
    public String GRAD_QNTY;  // 가산점(포상점수)
    public String PRIZ_RESN;  // 포상사유(수상내역)
}