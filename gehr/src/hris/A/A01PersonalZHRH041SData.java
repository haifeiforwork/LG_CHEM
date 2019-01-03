/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH041SData                                     */
/*   Description  : 핵심인재 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2012-09-05  lsa                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;

public class A01PersonalZHRH041SData extends com.sns.jdf.EntityData {
 
    public String STEXT   ;  // 하위 유형 이름
    public String ENDDA  ;  // 종료일
    public String BEGDA  ;  // 시작일
    public String RES_DEVE;  // 육성결과
    public String LANDX;  // 국가 이름  
    
}