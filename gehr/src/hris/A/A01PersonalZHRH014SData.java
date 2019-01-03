/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH014SData                                     */
/*   Description  : 평가사항 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;

public class A01PersonalZHRH014SData extends com.sns.jdf.EntityData {
 
    public String YEAR   ;  // 년도
    public String ORGTX  ;  // 조직단위텍스트(근무부서)
    public String ACHIV  ;  // 업적
    public String RATING1;  // 능력
    public String RATING2;  // 태도
    public String RATING3;  // 부하육성
    public String TOTL   ;  // 종합
    public String RTEXT1 ;  // 고과요소평가(상대화)
    public String APPRAISER; // 평가자이름
}