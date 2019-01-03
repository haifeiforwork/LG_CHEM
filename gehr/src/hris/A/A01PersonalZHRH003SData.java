/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH003SData                                     */
/*   Description  : 자격면허 정보를 담아오는 데이터                             */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A;
 
public class A01PersonalZHRH003SData extends com.sns.jdf.EntityData {

    public String LICN_NAME;  // 자격증명
    public String OBN_DATE ;  // 취득일
    public String GRAD_NAME;  // 자격등급명
    public String PUBL_ORGH;  // 발행처
    public String FLAG     ;  // FLAG(기표=SPACE,역기표='X')(법정선임여부)
}