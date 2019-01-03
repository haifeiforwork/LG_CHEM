package servlet.hris.J.J05JobMove;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

import hris.J.J03JobCreate.*;
import hris.J.J03JobCreate.rfc.*;
import hris.J.J05JobMove.*;
import hris.J.J05JobMove.rfc.*;

/**
 * J05JobMoveSV.java
 * JobMove 수행한다. << 대분류 생성 >>
 *
 * @author  김도신
 * @version 1.0, 2003/06/27
 */
public class J05JobMoveSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession      session        = req.getSession(false);
            WebUserData      user           = (WebUserData)session.getAttribute("user");
            
            Box              box            = WebUtil.getBox(req);

            J05CUDJobMoveRFC rfc_1001       = new J05CUDJobMoveRFC();
            J05JobMoveRFC    rfc            = new J05JobMoveRFC();

            Vector           j05Result_vt   = new Vector();
            Vector           j05R3_vt       = new Vector();
            Vector           j05SaveData_vt = new Vector();

//          생성 rfc 리턴값
            Vector           ret            = new Vector();
            Vector           j03Message_vt  = new Vector();
            String           E_SUBRC        = "";
            String           E_HOLDER       = "";
            Vector           j05Stext_vt    = new Vector();

            String           jobid          = box.get("jobid");
            String           i_objid        = box.get("OBJID");            // Objective ID
            String           i_sobid        = box.get("SOBID");            // 대분류 ID
            String           i_pernr        = box.get("PERNR");            // 사원번호
            String           i_begda        = box.get("BEGDA");
            String           dest           = "";
//          paging 처리
            String           page           = box.get("page");
            String           inputCheck     = box.get("inputCheck");

            if( jobid.equals("") ){
                jobid = "first";
            }

            if( page.equals("") || page == null ){
                page = "1";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [page] : "+page);
          
            req.setAttribute("i_pernr",    i_pernr);
            req.setAttribute("i_begda",    i_begda);
            req.setAttribute("i_objid",    i_objid);
            req.setAttribute("i_sobid",    i_sobid);
            req.setAttribute("page",       page);
            req.setAttribute("inputCheck", inputCheck);

            if( jobid.equals("first") ) {               //제일처음 생성 화면에 들어온경우.
                j05Result_vt = rfc.getDetail(user.empNo, i_objid, "99991231");

                req.setAttribute("j05Result_vt", j05Result_vt);

                dest = WebUtil.JspURL+"J/J05JobMove/J05JobMove.jsp";

            } else if( jobid.equals("pageChange") ) {   //Page 이동시
                int count = box.getInt("count");
                for( int i = 0 ; i < count ; i++ ) {                            
                    J05JobMoveData j05Jsp = new J05JobMoveData();
                    String         idx    = Integer.toString(i);

                    j05Jsp.OBJID_F = box.get("J_OBJID_F"+idx);
                    j05Jsp.OBJID_O = box.get("J_OBJID_O"+idx);
                    j05Jsp.OBJID_D = box.get("J_OBJID_D"+idx);
                    j05Jsp.OBJID   = box.get("J_OBJID"+idx);
                    j05Jsp.STEXT   = box.get("J_STEXT"+idx);
                    j05Jsp.BEGDA   = box.get("J_BEGDA"+idx);

                    j05Result_vt.addElement(j05Jsp);
                }
                req.setAttribute("j05Result_vt", j05Result_vt);

                dest = WebUtil.JspURL+"J/J05JobMove/J05JobMove.jsp";

            } else if( jobid.equals("create") ) {       //생성
//              기존에 데이터를 읽는다.
                j05R3_vt = rfc.getDetail(user.empNo, i_objid, "99991231");
//              Jsp에서 데이터를 읽는다.
                int count = box.getInt("count");
                for( int i = 0 ; i < count ; i++ ) {                            
                    J05JobMoveData j05Jsp = new J05JobMoveData();
                    String         idx    = Integer.toString(i);

                    j05Jsp.OBJID_F = box.get("J_OBJID_F"+idx);
                    j05Jsp.OBJID_O = box.get("J_OBJID_O"+idx);
                    j05Jsp.OBJID_D = box.get("J_OBJID_D"+idx);
                    j05Jsp.OBJID   = box.get("J_OBJID"+idx);
                    j05Jsp.STEXT   = box.get("J_STEXT"+idx);
                    j05Jsp.BEGDA   = box.get("J_BEGDA"+idx);

                    j05Result_vt.addElement(j05Jsp);
                }

//              기존에 데이터와 현재 jsp에서 넘어온 데이터를 비교하여 작업대상을 구한다.
                for( int i = 0 ; i < count ; i++ ) {
                    J05JobMoveData j05Jsp = (J05JobMoveData)j05Result_vt.get(i);
                    J05JobMoveData j0R3   = (J05JobMoveData)j05R3_vt.get(i);
                    if( j05Jsp.OBJID_F.equals(j0R3.OBJID_F) && j05Jsp.OBJID_O.equals(j0R3.OBJID_O) ) {
                        if( !j05Jsp.OBJID_D.equals(j0R3.OBJID_D) ) {
                            j05SaveData_vt.addElement(j05Jsp);
                        }
                    } else {
                        j05Jsp.HOLDER_FLAG = "Y";
                        j05SaveData_vt.addElement(j05Jsp);
                    }

                }

Logger.debug.println(this, "### j05SaveData_vt : " + j05SaveData_vt + " ### i_objid : " + i_objid);

                ret           = rfc_1001.Create( user.empNo, j05SaveData_vt );
                j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG
                E_HOLDER      = (String)ret.get(2);                          //Holder 삭제 여부 FLAG
                j05Stext_vt   = (Vector)ret.get(3);                          //실제 Holder가 삭제된 Job 명칭

Logger.debug.println(this, "### E_SUBRC : " + E_SUBRC + " ### E_HOLDER : " + E_HOLDER);
Logger.debug.println(this, "### j03Message_vt : " + j03Message_vt);

//              error를 처리하기 위해서 입력값을 화면으로 다시 보내준다.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 ) {
//                  성공한 경우는 반영해주기위해서 다시 조회한다.
                    j05Result_vt = rfc.getDetail(user.empNo, i_objid, "99991231");

                    req.setAttribute("j05Result_vt",  j05Result_vt);
//                  error 발생 여부
                    req.setAttribute("i_error",       "Y");
                    req.setAttribute("j03Message_vt", j03Message_vt);

                    dest = WebUtil.JspURL+"J/J05JobMove/J05JobMove.jsp";
//              생성 성공의 경우 Job Matrix 화면으로 이동한다.
                } else {
                    String msg = "";
Logger.debug.println(this, "################################# j05Stext_vt : " +  j05Stext_vt);
                    if( E_HOLDER.equals("Y") ) {
                        for( int i = 0 ; i < j05Stext_vt.size() ; i++ ) {
                            J05JobMoveData j05Stext = (J05JobMoveData)j05Stext_vt.get(i);
                            if( i == (j05Stext_vt.size() - 1) ) {
                                msg += j05Stext.STEXT + "의 ";
                            } else {
                                msg += j05Stext.STEXT + ", ";
                            }
                        }
                        msg += "Job Holder 지정이 삭제 되었습니다.\\nJob Holder를 재지정해 주시기 바랍니다.";
                    } else {
                        msg = "msg011";
                    }
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.J.J05JobMove.J05JobMoveSV?jobid=first&OBJID="+i_objid+"&PERNR="+i_pernr+"&BEGDA="+i_begda+"';";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);

                    dest = WebUtil.JspURL+"common/msg.jsp";
                }
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
