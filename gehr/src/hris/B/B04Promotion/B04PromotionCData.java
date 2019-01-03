package hris.B.B04Promotion ;

import java.util.Vector;

/**
 * B04PromotionLangData.java
 *  어학기준정보 데이터, 진급누점점수 및 기준점수 데이터
 *   [관련 RFC] : ZHRH_RFC_JINGUP_SIMUL
 *   2015.03.11 이지은D [CSR ID:2724630] 인사정보 화면 일부 수정 건
 *    update [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  20171115 eunha
 * @author 이형석
 * @version 1.0, 2002/01/14
 */
public class B04PromotionCData extends com.sns.jdf.EntityData {
    /*
    public String 	E_RETURN	;//	TYPE	ZGHR0020S	[GEHR] RFC 메세지
    public String 	E_PROM_NAME	;//	TYPE	ZPROM_NAME	진급구분명
    public String 	E_SCPM_AMNT	;//	TYPE	ZSCPM_AMNT	진급누적점수
    public String 	E_GIJUN_AMNT	;//	TYPE	ZSCPM_AMNT	진급기준점수
    public String 	E_EDU_FLAG	;//	TYPE	FLAG	일반표시
    public String 	E_LANG_FLAG	;//	TYPE	FLAG	일반표시
    public String 	E_EXTDT	;//	TYPE	DATS	특별승급일자 날짜           <-- DATUM
    public String 	E_CFLAG	;//	TYPE	CHAR1	경력, 재입사, 직간전화자 flag <-- E_CFLAG
    public String 	E_SFLAG	;//	TYPE	CHAR1	6sigma 인증여부 flag    <-- E_SFLAG


     */

    //fields
    public String E_PROM_NAME;   // 진급구분명
    public String E_SCPM_AMNT;   // 진급누적점수기준
    public String E_GIJUN_AMNT;   // 진급누적점수기준
    public String E_EDU_FLAG;   // 일반플래그
    public String E_LANG_FLAG;   // 일반플래그
	public String E_EXTDT     ;   // 특별승급일자 날짜
	public String E_CFLAG;   // 경력, 재입사, 직간전화자 flag
	public String E_SFLAG;   // 6sigma 인증여부 flag

	//update [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件   start
	public String E_PROM_CODE;   // 진급구분명
	public String E_EDU_YN;   // 진급교육이수여부
	//update [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件   end


    //ZHRS068S 어학정보조회
    public String LANG_TYPE ;      // 어학레코드 유형
    public String LANG_NAME ;      // 하부유형이름
    public String LANG_AMNT ;       // 어학점수/등급
    public String LANG_AMNT1 ;       // 어학점수/등급2번째 조건 CSR ID:2724630


    public Vector<B04PromotionAData> PYUNGA_TAB;    // = getTable(B04PromotionAData.class, function, "ET_PYUNGA");
    public Vector<B04PromotionAData> EDU_TAB;   // = getTable(B04PromotionAData.class, function, "ET_EDU");
    public Vector<B04PromotionBData> PYUNGGA_SCORE_TAB; // = getTable(B04PromotionBData.class, function, "ET_PYUNGA_SCORE");
    public Vector<B04PromotionBData> LANG_TAB;  // = getTable(B04PromotionBData.class, function, "ET_LANG");
    public Vector<B04PromotionCData> LANG_GIJUN_TAB;    // = getTable(B04PromotionCData.class, function, "ET_LANG_GIJUN");

}