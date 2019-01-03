package hris.B ;

/**
 * B03DevelopData2.java
 *  인재개발협의결과를 담는 데이터
 *   [관련 RFC] : ZHRE_RFC_DEVELOP_LIST
 * 
 * @author 배민규
 * @version 1.0, 2003/06/09
 * @author 최영호
 * @version 2.0, 2003/07/01
 */
public class B03DevelopData2 extends com.sns.jdf.EntityData {
    public String PERNR      ;  // 사번
    public String BEGDA      ;	// 시작일
    public String SEQNR      ;	// 동일한 키를 가진 정보유형 레코드번호
    public String ITEM_INDX  ;	// 경력/교육개발 일련번호
    public String DEVP_TYPE  ;	// 구분
    public String DEVP_YEAR  ;  // 년도
    public String DEVP_MNTH  ;  // 시기  
    public String DEVP_TEXT  ;  // 직무/교육명
    public String DEVP_STAT  ;  // 상태
    public String RMRK_TEXT  ;  // 비고
}