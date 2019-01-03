/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                */
/*   2Depth Name  :                                                 */
/*   Program Name :                                      */
/*   Program ID   : AdminLoginGQSSV.java                                    */
/*   Description  :                          */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/
package servlet.hris;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminLoginGQSSV extends EHRBaseServlet 
{
    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection conn = null;
        boolean isCommit = false;    
        try{
            Box box = WebUtil.getBox(req);
            WebUserData user = new WebUserData();
            box.copyToEntity(user);
            user.empNo = DataUtil.fixEndZero( user.empNo ,8);
            
            PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
            PersonData personData   = new PersonData();
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정

            String webUserId = box.getString("webUserId");
            if(webUserId == null){
                webUserId = "";
            }
            String webUserPwd = box.getString("webUserPwd");
            if(webUserPwd == null){
                webUserPwd = "";
            }
            String remoteIP = box.getString("remoteIP");
            if(remoteIP == null){
                remoteIP = "";
            }

            // 사번에 대한 비밀번호를 가져온다.
            String upperID = webUserId.toUpperCase();
	//		Vector getUD = getPassword(upperID);
        //    String originPwd = getUD.get(0).toString();
	//		String userIP = getUD.get(1).toString();
			
	//		Vector getUD = getPassword(upperID);
            String originPwd = "GQS";
			String userIP = "165.243.32.213";
Logger.debug.println(this,"webUserPwd:webUserPwd======>"+webUserPwd+"originPwd:"+originPwd);
            //if (webUserPwd.trim().equalsIgnoreCase(originPwd.trim())) {
            if (webUserPwd.trim().equals(originPwd.trim())) {
Logger.debug.println(this,"=======GQS TEST 1 ======>");
                HttpSession session = req.getSession(false);
                if (session != null){ session.invalidate(); }
                try{
                    personData = (PersonData)personInfoRFC.getPersonInfo(user.empNo, "X");
Logger.debug.println(this,"=======GQS TEST 2 ======>");

                }catch(Exception ex){      
Logger.debug.println(this,"=======GQS TEST 3 ======>");
                   
                    user.login_stat       = "Y";
                    user.companyCode      = "C100" ;
                    Config conf           = new Configuration();
                    user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    user.ename            = "임규용" ;
                    user.e_titel          = "과장" ;
                    user.e_titl2          = "" ;
                    user.e_orgtx          = "노경지원팀" ;
                    user.e_is_chief       = "N" ;
                    user.e_stras          = "서울 강서구 등촌동" ;
                    user.e_locat          = "10-100" ;
                    user.e_regno          = "7003221057787" ;
                    user.e_oversea        = "" ;
                    user.e_phone_num      = "" ;
                    user.e_trfar          = "02" ;
                    user.e_trfgr          = "Ⅱ-2급" ;
                    user.e_trfst          = personData.E_TRFST ;
                    user.e_vglgr          = "년차" ;
                    user.e_vglst          = "02" ;
                    user.e_dat03          = "2005-01-01" ;
                    user.e_persk          = "21" ;
                    user.e_deptc          = "";
                    user.e_retir          = "";
                    user.e_grup_numb      = "01" ;
                    user.e_gansa          = "Y" ;          // 20030623 CYH 추가함.
                    user.e_orgeh          = "50000187";           // 20050214 추가함.
                    user.e_representative = "Y";  // 20050214 추가함.
                    user.e_authorization  = "EHW";   // 20050214 추가함.
                    user.e_objid          = "50000187" ;          // 20050412 추가함.
                    user.e_obtxt          = "노경지원팀" ;          // 20050412 추가함.
                    user.e_werks          = "AA00";          // 20050413 추가함. 인사영역(EC00 이면 해외법인)
                    user.e_recon          = "";          // 20050414 추가함. 퇴직구분('D'-사망'S'-미혼'Y'-퇴직)
                    user.e_reday          = "0000-00-00";          // 20050414 추가함. 퇴직일자
                    user.e_mail           = "kyuyong@lgchem.com"  ;          // 20050420 추가.
Logger.debug.println(this,"=======GQS TEST Exception ex======>");

                    // 사용자 권한 그룹 설정
                    if ( upperID.equals("EADMIN") ) {  // 관리자 메뉴 접근 권한 
                        user.user_group = "01";
                    } else if ( upperID.substring(0,6).equals("EMANAG") ) {
                        //conn = DBUtil.getTransaction("HRIS");
                        
                        //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization); 
                        //@v1.0 메뉴관련 db를 oracle에서 sap로 이관
                        /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                        user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/
                        isCommit = true;
                    } else {
                        //String msg = "허용된 아이디가 아닙니다.";
                        msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");                        
                    }
                    Logger.debug.println(this ,personData);
                    
                    DataUtil.fixNull(user);
                    session = req.getSession(true);
  Logger.debug.println(this ,"session:"+session);
                  
                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
  Logger.debug.println(this ,"maxSessionTime:"+maxSessionTime);
                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user",user);

                    Logger.debug.println(this, "ok login.. user : "+user.toString() );  
                    String dest = WebUtil.JspURL+"main.jsp";
                    printJspPage(req, res, dest);
                                    
                    //Logger.debug.println(this,"Data Not Found");
                    //String msg = "접속 중 오류가 발생하였습니다.";
                    //String url = "history.back();";
                    //req.setAttribute("msg", msg);
                    //req.setAttribute("url", url);
                    //printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                }
                //if( phonenumdata.E_BUKRS==null|| phonenumdata.E_BUKRS.equals("") ) {
                //
                //    String msg = "사원번호를 확인하여 주십시요.";
                //    String url = "history.back();";
                //    req.setAttribute("msg", msg);
                //    req.setAttribute("url", url);
                //    printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                ////@년말정산 workshop때문에 임시로 개발서버에만 막음
		//} else if(!userIP.equals(remoteIP)||userIP.equals("")) {
                //
                //    String msg = "[보안] 허가된 PC가 아닙니다.";
                //    String url = "history.back();";
                //    req.setAttribute("msg", msg);
                //    req.setAttribute("url", url);
                //    printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                //    Logger.debug.println(this ,"[보안] : "+remoteIP);
                //} else if ( !phonenumdata.E_BUKRS.equals("C100") ) {
                //
                //    String msg = "화학 사용자가 아닙니다.";
                //    String url = "history.back();";
                //    req.setAttribute("msg", msg);
                //    req.setAttribute("url", url);
                //    printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                //} else {
                    user.login_stat       = "Y";
                personInfoRFC.setSessionUserData(personData, user);
//////////////////////////
                    user.login_stat       = "Y";
                    user.companyCode      = "C100" ;

                    user.ename            = "임규용" ;
                    user.e_titel          = "과장" ;
                    user.e_titl2          = "" ;
                    user.e_orgtx          = "노경지원팀" ;
                    user.e_is_chief       = "N" ;
                    user.e_stras          = "서울 강서구 등촌동" ;
                    user.e_locat          = "10-100" ;
                    user.e_regno          = "7003221057787" ;
                    user.e_oversea        = "" ;
                    user.e_phone_num      = "" ;
                    user.e_trfar          = "02" ;
                    user.e_trfgr          = "Ⅱ-2급" ;
                    user.e_trfst          = personData.E_TRFST ;
                    user.e_vglgr          = "년차" ;
                    user.e_vglst          = "02" ;
                    user.e_dat03          = "2005-01-01" ;
                    user.e_persk          = "21" ;
                    user.e_deptc          = "";
                    user.e_retir          = "";
                    user.e_grup_numb      = "01" ;
                    user.e_gansa          = "Y" ;          // 20030623 CYH 추가함.
                    user.e_orgeh          = "50000187";           // 20050214 추가함.
                    user.e_representative = "Y";  // 20050214 추가함.
                    user.e_authorization  = "EHW";   // 20050214 추가함.
                    user.e_objid          = "50000187" ;          // 20050412 추가함.
                    user.e_obtxt          = "노경지원팀" ;          // 20050412 추가함.
                    user.e_werks          = "AA00";          // 20050413 추가함. 인사영역(EC00 이면 해외법인)
                    user.e_recon          = "8";          // 20050414 추가함. 퇴직구분('D'-사망'S'-미혼'Y'-퇴직)
                    user.e_reday          = "0000-00-00";          // 20050414 추가함. 퇴직일자
                    user.e_mail           = "kyuyong@lgchem.com"  ;          // 20050420 추가.
Logger.debug.println(this,"=======GQS TEST 위해 임시로 설정 ex======>");

                    // 사용자 권한 그룹 설정
                    if ( upperID.equals("EADMIN") ) {  // 관리자 메뉴 접근 권한 
                        user.user_group = "01";
                    } else if ( upperID.substring(0,6).equals("EMANAG") ) {
                        //conn = DBUtil.getTransaction("HRIS");
                        
                        //user.user_group =   (new CommonCodeDB(conn)).getAuthGroup(user.e_authorization); 
                        //@v1.0 메뉴관련 db를 oracle에서 sap로 이관
                        /*SysAuthGroupRFC rfc_Auth         = new SysAuthGroupRFC();
                        user.user_group = rfc_Auth.getAuthGroup(user.e_authorization);*/
                        isCommit = true;
                    } else {
                        //String msg = "허용된 아이디가 아닙니다.";
                        msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");                        
                    }
                    Logger.debug.println(this ,personData);
                    
                    DataUtil.fixNull(user);
                    session = req.getSession(true);

//                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
//                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user",user);

                    Logger.debug.println(this, "ok login.. user : "+user.toString() );  
                    String dest = WebUtil.JspURL+"main.jsp";
                    printJspPage(req, res, dest);
                //}
            } else {
                //String msg = "비밀번호가 일치하지 않습니다. ";
                msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
			}
        }catch(Exception e){
            throw new GeneralException(e);
        }finally {
            //DBUtil.close(conn ,isCommit);  
        } // end try        
    }

}