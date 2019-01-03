/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH013SData                                     */
/*   Description  : 어학능력 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;
 
public class A01PersonalZHRH013SData extends com.sns.jdf.EntityData {

    public String LANG_TYPE;  // 어학레코드 유형
    public String STEXT    ;  // 하부유형이름(검정구분)
    public String BEGDA    ;  // 시작일(검정일)
    public String TOTL_SCOR;  // TOTAL
    public String LANG_LEVL;  //
    public String LISN_SCOR;  // L/C
    public String HEAR_SCOR;  // 청력
    public String WRIT_SCOR;  // WRITING
    public String EXPR_SCOR;  // 어법
    public String READ_SCOR;  // R/C
    public String UNDR_SCOR;  // 독해
    public String SUMM_SCOR;  // 종합
    public String COMP_SCOR;  // 작문
    public String ORAL_SCOR;  // 구술
    public String STRU_SCOR;  // STRUCTURE
    public String SEPT_TEXT;  // 텍스트 문자열 22 문자
    public String LGAX_TEXT;  // 텍스트 문자열 22 문자
    public String LAPX_TEXT;  // 텍스트 문자열 22 문자
    public String SEPT_SCOR;  // WEIGHTED SCORE
    public String LGAX_SCOR;  // ORAL SCORE
    public String LAPX_SCOR;  // WRITTEN SCORE
    public String SEPT_LEVL;  // SEPT LEVEL
    public String SORT_ORDR;  // 문자필드길이 1
}