package	hris.A.A16Appl;

/**
 * A16ApplListData.java
 *  결재정보 List 를 가져오기 위한 KEY
 *   [관련 RFC] : ZHRA_RFC_GET_APPL_LIST
 * 
 * @author 김성일   
 * @version 1.0, 2001/12/13
 */
 public class A16ApplListKey extends com.sns.jdf.EntityData {

    public String I_BEGDA    ;    //시작일
    public String I_ENDDA    ;    //종료일
    public String I_PERNR    ;    //사번
    public String I_STAT_TYPE;    //결재상태
	public String I_UPMU_TYPE;    //업무형태

}
