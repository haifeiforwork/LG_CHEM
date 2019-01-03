/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 소속별/직급별 인원현황                                      */
/*   Program ID   : F01DeptPositionClassTitleData                               */
/*   Description  : 소속별/직급별 인원현황 조회를 위한 타이틀 DATA 파일         */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-28 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.F;   

/**
 * F01DeptPositionClassTitleData
 *  소속별/직급별 인원현황 타이틀을 담는 데이터
 *  
 * @author 유용원
 * @version 1.0, 
 */
public class F01DeptPositionClassTitleData extends com.sns.jdf.EntityData {
    public String PERSK;    //사원서브그룹    
    public String PTEXT;    //사원서브그룹이름
    public String TRFGR;    //급여그룹 
}
