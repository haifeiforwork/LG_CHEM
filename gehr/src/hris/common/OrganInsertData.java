/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 하부조직 검색                                        */
/*   Program ID   : OrganInsertData                                             */
/*   Description  : 조직도 하부조직 검색을 위한 DATA 파일                       */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package	hris.common;

/**
 * OrganInsertData
 * 사번(권한)으로 조회된 하부조직 정보에 관한 데이터
 *  
 * @author 유용원  
 * @version 1.0, 
 */
public class OrganInsertData extends com.sns.jdf.EntityData {
	
    public String OBJID     ;    //조직ID

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }
}

