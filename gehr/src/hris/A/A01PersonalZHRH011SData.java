/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH011SData                                     */
/*   Description  : 가족사항 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.A;

public class A01PersonalZHRH011SData extends com.sns.jdf.EntityData {

    public String STEXT ;  // 하부유형이름(관계)
    public String KNAME ;  // 한글이름(성명)
    public String FGBDT ;  // 생년월일
    public String STEXT1;  // 하부유형이름(학력)
    public String FAJOB ;  // 가족구성원의 직무(직업)
}  