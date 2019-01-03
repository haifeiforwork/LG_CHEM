/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사원목록 검색                                               */
/*   Program ID   : OrganPersListData.java                                      */
/*   Description  : 조직도 검색 시 사원정보를 보기위한 DATA 파일                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-21 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common;

/**
 * OrganPersListData.java
 * 부서ID로 조회된 사원 정보에 관한 데이터
 * [관련 RFC] :  ZHRA_RFC_GET_ORGEH_PERS_LIST
 *  
 * @author 유용원  
 * @version 1.0, 2005/01/21 
 */ 
public class OrganPersListData extends com.sns.jdf.EntityData {
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
}

