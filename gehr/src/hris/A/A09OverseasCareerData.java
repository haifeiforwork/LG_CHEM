package	hris.A;

/**
 * A09OverseasCareerData.java
 * 해외근무경력 정보를 담아오는 데이터
 *  [관련 RFC] : ZHRA_RFC_TRIP_LIST
 * 
 * @author 윤정현      
 * @version 1.0, 2005/01/07
 */
public class A09OverseasCareerData extends com.sns.jdf.EntityData {

    public String PERNR	    ;  //   사원번호
    public String BEGDA	    ;  //   시작일  
    public String ENDDA	    ;  //   종료일  
    public String RESN_FLAG	;  //   사유구분
    public String RESN_TEXT	;  //   내역    
    public String RESN_DESC1;  //	사유1   
    public String RESN_DESC2;  //	사유2   
    public String DEST_ZONE	;  //   목적지  
    public String WAY1_ZONE	;  //   경유지  
    public String WAY2_ZONE	;  //   경유지2 
    public String CRCL_UNIT	;  //   단체    
    public String EDUC_WONX	;  //   소요비용
}
