/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH012SData                                     */
/*   Description  : 병역 정보를 담아오는 데이터                                 */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A; 

public class A01PersonalZHRH012SData extends com.sns.jdf.EntityData {

    public String TRAN_TEXT;  // 전역구분 TEXT(실역구분)
    public String SERTX    ;  // 병역의무유형 텍스트 KR(군별)
    public String IDNUM    ;  // 병역군번
    public String RTEXT    ;  // 변경사유텍스트(전역사유)
    public String RKTXT    ;  // 계급
    public String PERIOD   ;  // 기간(복무기간)
    public String JBTXT    ;  // 병역보직분류 텍스트 KR
    public String SERUT    ;  // 근무부대
    public String RSEXP    ;  // 병역의무 면제사유
}
