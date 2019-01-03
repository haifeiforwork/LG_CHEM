/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   근태그룹인원 지정										*/
/*   Program Name	:   근태그룹인원 지정										*/
/*   Program ID		: D40TmGroupPersData.java							*/
/*   Description		: 근태그룹인원 지정											*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/


package hris.D.D40TmGroup;
/**
 * D40TmGroupPersData.java
 * 근태그룹인원 지정/조회 RFC
 * [관련 RFC] :  ZGHR_RFC_TM_TIME_GRUP_PERS
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40TmGroupPersData extends com.sns.jdf.EntityData {

	public String I_PERNR; //사원 번호
	public String I_DATUM; //일자
	public String I_SPRSL; //언어 키
	public String I_GTYPE; //처리구분
	public String I_PABRJ; //연도
	public String I_PABRP; //월
	public String I_SEQNO; //근태그룹 Key

	public String SPERNR; //사원 번호
	public String SPERNR_TX; //사원 이름
	public String OBEGDA; //그룹원생성일
	public String SORGEH; //	생성시 소속부서 코드
	public String SORGEH_TX; //생성시 소속부서 명
	public String ORGEH; //	현부서코드
	public String ORGEH_TX; //현부서명
	public String ORGEH_DT; //	현부서일자
	public String PERSG; //	구분코드
	public String PERSG_TX; //구분텍스트
	public String PERSG_DT; //구분일자
	public String AEDTM	; //변경일
	public String AEZET; //	최종변경시간
	public String UNAME; //사용자이름

}

