/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH002SData                                     */
/*   Description  : 학력사항 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A; 

public class A01PersonalZHRH002SData extends com.sns.jdf.EntityData {
    public String PERIOD   ;  // 기간
    public String LART_TEXT;  // 학교 TEXT
    public String FTEXT    ;  // 전공명
    public String FTEXT1   ;  // 전공텍스트
    public String STEXT    ;  // 증명서텍스트(학위)
    public String SOJAE    ;  // 소재지
    public String EMARK    ;  // 최종표시
}