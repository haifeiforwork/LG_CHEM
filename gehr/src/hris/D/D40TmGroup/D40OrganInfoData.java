/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:   부서근태													*/
/*   2Depth Name		:   공통														*/
/*   Program Name	:   조직도													*/
/*   Program ID		: D40OrganInfoData.java								*/
/*   Description		: 조직도														*/
/*   Note				:             													*/
/*   Creation			: 2017-12-08  정준현                                          	*/
/*   Update				: 2017-12-08  정준현                                          	*/
/*                                                                              			*/
/********************************************************************************/

package	hris.D.D40TmGroup;

/**
 * D40OrganInfoData.java
 * 조직도 정보에 관한 데이터
 * [관련 RFC] :  ZHRA_RFC_GET_ORGEH_LIST
 *
 * @author  정준현
 * @version 1.0, 2017/12/08
 */
public class D40OrganInfoData extends com.sns.jdf.EntityData {

    public String   OBJID;        //조직ID
    public String   OBJTXT;       //조직명
    public String   UPOBJID;      //상위조직
    public String   LOWERYN ;     //하위여부.
    public String   STOPHERE;     //선택된위치.
    public boolean  isOpen = false; //노드의 open/close 상태.

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getOBJTXT() {
        return OBJTXT;
    }

    public void setOBJTXT(String OBJTXT) {
        this.OBJTXT = OBJTXT;
    }

    public String getUPOBJID() {
        return UPOBJID;
    }

    public void setUPOBJID(String UPOBJID) {
        this.UPOBJID = UPOBJID;
    }

    public String getLOWERYN() {
        return LOWERYN;
    }

    public void setLOWERYN(String LOWERYN) {
        this.LOWERYN = LOWERYN;
    }

    public String getSTOPHERE() {
        return STOPHERE;
    }

    public void setSTOPHERE(String STOPHERE) {
        this.STOPHERE = STOPHERE;
    }

    public boolean isOpen() {
        return isOpen;
    }

    public void setOpen(boolean open) {
        isOpen = open;
    }
}

