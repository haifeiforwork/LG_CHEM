package	hris.A.A16Appl;

/**
 * A16ApplListData.java
 *  결재정보 List 를 담아오는 데이터
 *   [관련 RFC] : ZHRA_RFC_GET_APPL_LIST
 * 
 * @author 김성일    
 * @version 1.0, 2001/12/13
 */
public class A16ApplListData extends com.sns.jdf.EntityData {

    public String BEGDA    ;    //시작일
    public String AINF_SEQN;    //결재정보
    public String UPMU_TYPE;    //업무형태
    public String UPMU_NAME;    //업무이름
	public String STAT_TYPE;    //결재상태

}
