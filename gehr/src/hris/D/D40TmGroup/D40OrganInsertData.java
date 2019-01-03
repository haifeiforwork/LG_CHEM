/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   조직도 하부조직 검색 									*/
/*   Program ID		: D40OrganInsertData.java								*/
/*   Description		: 조직도 하부조직 검색 									*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package	hris.D.D40TmGroup;

/**
 * D40OrganInsertData.java
 * 조직도 하부조직 정보에 관한 데이터
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40OrganInsertData extends com.sns.jdf.EntityData {

    public String OBJID     ;    //조직ID
    public String E_CHECK ;


    public String getE_CHECK() {
		return E_CHECK;
	}

	public void setE_CHECK(String E_CHECK) {
		this.E_CHECK = E_CHECK;
	}

	public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }
}

