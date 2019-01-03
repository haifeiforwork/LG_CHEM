package	hris.common.mail;

import java.util.Vector;

import hris.common.*;
import hris.E.E27InfoDecision.*;
/**
 * MailData.java
 * 메일전송에 관한 데이터
 *
 * @author 이형석
 * @version 1.0, 2001/12/13
 */

public class MailData extends com.sns.jdf.EntityData {

    public WebUserData user      ;
    public Vector AppLineData_vt ;
    public String upmuname       ;
    public double mailNumber     ;
    public String gempNo;
    public E27InfoDecisionData data;
    public String stext;     // 인포멀 TEXT
}