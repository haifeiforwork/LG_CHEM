/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 검색                                                 */
/*   Program ID   : OrganInfoData.java                                          */
/*   Description  : 조직도 검색을 위한 DATA 파일                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package	hris.common;

/**
 * OrganInfoData.java
 * 사번(권한)으로 조회된 조직 정보에 관한 데이터
 * [관련 RFC] :  ZHRA_RFC_GET_ORGEH_LIST 
 *  
 * @author 유용원  
 * @version 1.0, 2005/01/19 
 */
public class OrganInfoData extends com.sns.jdf.EntityData {
	
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

