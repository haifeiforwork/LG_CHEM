/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH007SData                                     */
/*   Description  : 징계 정보를 담아오는 데이터                                 */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A; 

public class A01PersonalZHRH007SData extends com.sns.jdf.EntityData {

    public String PUNTX ;  // 징계처분 텍스트(징계유형)
    public String BEGDA ;  // 시작일(징계일자)
    public String PERIOD;  // 기간
    public String PUNRS ;  // 처분방법 발행사유(징계내역)
    public String ZDISC_DAYS ;  // 징계기간 C20130611_47348
}