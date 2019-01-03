/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : Global육성POOL                                              */
/*   Program Name : HPI Global육성POOL                                          */
/*   Program ID   : F70GlobalClassTitleData.java                             */
/*   Description  : HPI Global육성POOL 조회를 위한 타이틀 DATA 파일             */
/*   Note         : 없음                                                        */
/*   Creation     : 2006-03-15 LSA                                              */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.F;   

/**
 * F70GlobalClassTitleData
 *  HPI Global육성POOL 타이틀을 담는 데이터
 *  
 * @author 유용원
 * @version 1.0, 
 */
public class F70GlobalClassTitleData extends com.sns.jdf.EntityData {
    public String TITLACD	;    //사원서브그룹    
    public String TITLATXT;    //사원서브그룹이름
    public String TITLBTXT;    //직위            
}
