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

package hris.D.D12Rotation;

/**
 * D12RotationSearchData
 * 사번(권한)으로 조회된 부서명,성명 정보에 관한 데이터
 *
 * @author lsa
 * @version 1.0,
 */
public class D12RotationSearchData extends com.sns.jdf.EntityData {

    public String SPERNR    ;    //사원 번호
    public String OBJID     ;    //오브젝트 ID
    public String STEXT     ;    //오브젝트 이름
    public String EPERNR    ;    //사원 번호
    public String ENAME     ;    //조직ID
    public String OBJTXT    ;    //사원 또는 지원자의 포맷된 이름

}

