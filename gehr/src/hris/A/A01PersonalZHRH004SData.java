/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH004SData                                     */
/*   Description  : 경력사항 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;
 
public class A01PersonalZHRH004SData extends com.sns.jdf.EntityData {

    public String PERIOD   ;  // 기간
    public String ARBGB    ;  // 회사이름
    public String TITL_TEXT;  // 직위
    public String JOBB_TEXT;  // 직무
}