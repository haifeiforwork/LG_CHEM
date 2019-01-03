/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   조직도 검색 시 사원정보								*/
/*   Program ID		: D40OrganInsertData.java								*/
/*   Description		: 조직도 검색 시 사원정보 									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package hris.D.D40TmGroup;
/**
 * D40OrganPersListData.java
 * 조직도 검색 시 사원정보
 * [관련 RFC] :  ZGHR_RFC_TM_GET_ORGEH_PERS
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40OrganPersListData extends com.sns.jdf.EntityData {
    public String PERNR  ;   //사원번호
    public String ENAME  ;   //사원 이름
    public String ORGEH  ;   //소속부서
    public String ORGTX  ;   //소속부서 텍스트
    public String STELL  ;   //직무
    public String STLTX  ;   //직무명
    public String BTRTL  ;   //인사하위영역
    public String BTEXT  ;   //인사하위영역 텍스트
    public String STAT2  ;   //고용상태	  3:현재원, 0:퇴직자, 1,2:휴직자

    public String JIKWE;   //	ZEHRJIKWE	CHAR	20	0	직위
    public String JIKWT;   //	ZEHRJIKWT	CHAR	40	0	직위명
    public String  JIKCH;   //	ZEHRJIKCH	CHAR	20	0	직급
    public String JIKCT;   //	ZEHRJIKCT	CHAR	40	0	직급명
    public String JIKKB	;   //ZEHRJIKKB	CHAR	20	0	직책
    public String  JIKKT;   //	ZEHRJIKKT	CHAR	40	0	직책명
    public String  OBJID;   //	ZEHRJIKKT	CHAR	40	0	직책명
    public String  PGTXT;   //	구분
}

