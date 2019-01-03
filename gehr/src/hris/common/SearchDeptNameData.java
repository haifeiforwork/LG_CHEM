/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 부서명 검색                                                 */
/*   Program ID   : SearchDeptNameData                                          */
/*   Description  : 부서명 검색을 위한 DATA 파일                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.common; 

/**
 * SearchDeptNameData
 * 사번(권한)으로 조회된 부서명 정보에 관한 데이터
 *  
 * @author 유용원  
 * @version 1.0, 
 */
public class SearchDeptNameData extends com.sns.jdf.EntityData {
	
    public String OBJID     ;    //조직ID 
    public String OBJTXT    ;    //조직명
}

