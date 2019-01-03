/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인사정보조회                                                */
/*   Program Name : 인사기록부 조회 및 출력                                     */
/*   Program ID   : A01PersonalZHRH010SData                                     */
/*   Description  : 인적사항(2) 정보를 담아오는 데이터                          */
/*   Note         : [관련 RFC] : ZHRA_RFC_GET_PERSONAL_CARD                     */
/*   Creation     : 2005-01-13  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A; 

public class A01PersonalZHRH010SData extends com.sns.jdf.EntityData {

    public String BEGDA1    ;  // 시작일
    public String STRAS     ;  // 상세 주소/번지(본적)
    public String PSTLZ     ;  // 우편번호
    public String STRAS1    ;  // 상세 주소/번지(현주소)
    public String PSTLZ1    ;  // 우편번호
    public String NMF01     ;  // 값(신장)
    public String NMF02     ;  // 값(체중)
    public String NMF06     ;  // 값(시력_좌)
    public String NMF07     ;  // 값(시력_우)
    public String FLAG1     ;  // 일반플래그(장애여부)
    public String FLAG      ;  // 일반플래그(색맹여부)
    public String STEXT     ;  // 숙련도 텍스트(혈액형)
    public String CHATX     ;  // KR 장애유형 텍스트
    public String CONTX     ;  // 국가유공자 KR 텍스트
    public String FTEXT     ;  // 결혼여부
    public String LIVE_TEXT ;  // 문자 20(주거형태)
    public String HBBY_TEXT ;  // 문자 20(취미)
    public String HBBY_TEXT1;  // 문자 20(특기)
    public String KTEXT     ;  // 종파(종교)
    public String TELNR     ;  // 전화번호
    public String MOBILE    ;  // 통신 ID/번호
    
}