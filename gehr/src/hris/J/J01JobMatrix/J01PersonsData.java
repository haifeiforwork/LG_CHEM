package hris.J.J01JobMatrix;

/**
 * J01PersonsData.java
 * 팀장의 사원리스트를 조회한다. 해당하는 Objective에 해당하는 사원만 조회한다.
 * [관련 RFC] : ZHRH_RFC_GET_PERSONS
 * 
 * @author  김도신
 * @version 1.0, 2003/04/23
 */
public class J01PersonsData extends com.sns.jdf.EntityData {

//  P_RESULT_D(ZHRH038S)
    public String PERNR      ;     // 사번
    public String ENAME      ;     // 성명
    public String ORGEH      ;     // 조직코드
    public String ORGTX      ;     // 조직명
    public String TITEL      ;     // 직위
    public String OBJID      ;     // Objective ID
//  WEB에서만 사용하는 변수
    public String CHK_HOLDER ;     // 생성시 Job Holder 선택 여부
    public String BEGDA      ;     // 생성시 Job Holder 선택 여부

}
