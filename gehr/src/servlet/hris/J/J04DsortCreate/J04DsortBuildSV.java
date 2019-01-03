package servlet.hris.J.J04DsortCreate;

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

/**
 * J04DsortBuildSV.java
 * 대분류를 생성한다. << 대분류 생성 >>
 *
 * @author  김도신
 * @version 1.0, 2003/06/25
 */
public class J04DsortBuildSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession       session        = req.getSession(false);
            WebUserData       user           = (WebUserData)session.getAttribute("user");
            
            Box               box            = WebUtil.getBox(req);

            String            jobid          = box.get("jobid");
            String            i_objid        = box.get("OBJID");            // Objective ID
            String            i_sobid        = box.get("SOBID");            // 대분류 ID
            String            i_pernr        = box.get("PERNR");            // 사원번호
            String            i_begda        = box.get("BEGDA");
            String            dest           = "";

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            req.setAttribute("i_pernr", i_pernr);
            req.setAttribute("i_begda", i_begda);

            if( jobid.equals("first") ) {           //제일처음 생성 화면에 들어온경우.
                req.setAttribute("i_objid", i_objid);         //생성된경우 Objectives가 변경된다.
                req.setAttribute("i_sobid", i_sobid);         //생성된경우 대분류가 변경된다.

                dest = WebUtil.JspURL+"J/J04DsortCreate/J04DsortBuild.jsp";

            } else if( jobid.equals("create") ) {   //생성
                J03CUDObjectsRFC   rfc_1000      = new J03CUDObjectsRFC();
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();

                J03ObjectCreData   j03HRP1000    = null;
                J03ObjectCreData   j03HRP1001    = null;

                Vector             j03HRP1000_vt = new Vector();                //오브젝트 생성(HRP1000)
                Vector             j03HRP1001_vt = new Vector();                //관계 생성(HRP1001)

//              생성 rfc 리턴값
                Vector             ret           = new Vector();
                Vector             j03Message_vt = new Vector();
                String             E_SUBRC       = "";

//              오브젝트 생성(HRP1000)
                j03HRP1000       = new J03ObjectCreData();
                j03HRP1000.OTYPE = "15";
                if( i_sobid.equals("") || i_sobid.equals("00000000") ) {
                    j03HRP1000.OBJID = "00000000";                              //default "00000000" - 생성시
                } else {
                    j03HRP1000.OBJID = i_sobid;                                 //생성된 대분류 ID
                }
                j03HRP1000.BEGDA = i_begda;                                     //적용일자
                j03HRP1000.ENDDA = "99991231";                                  //default "99991231" - 생성시
                j03HRP1000.SHORT = box.get("SHORT");                            //char 12
                j03HRP1000.STEXT = box.get("STEXT");                            //char 40

                j03HRP1000_vt.addElement(j03HRP1000);
Logger.debug.println(this, "### [HRP1000] : " + j03HRP1000_vt);

                ret           = rfc_1000.Create( user.empNo, j03HRP1000_vt );
                j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG
                i_sobid       = (String)ret.get(2);                          //생성된 오브젝트 ID

Logger.debug.println(this, "### [j03HRP1000]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1000]j03Message_vt : " + j03Message_vt);

//              오브젝트 생성에 성공한 경우
                if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 && !i_sobid.equals("") && !i_sobid.equals("00000000") ) {
//                  관계 생성(HRP1001) -  Objectives(11)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.OTYPE = "15";
                    j03HRP1001.OBJID = i_sobid;
                    j03HRP1001.BEGDA = i_begda;                                 //적용일자
                    j03HRP1001.ENDDA = "99991231";                              //default "99991231" - 생성시
                    j03HRP1001.SUBTY = "AZ11";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "Z11";
                    j03HRP1001.SCLAS = "11";
                    j03HRP1001.SOBID = box.get("SOBID_O");
    
                    j03HRP1001_vt.addElement(j03HRP1001);
Logger.debug.println(this, "### [HRP1001] : " + j03HRP1001_vt);
    
                    ret           = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                    j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                    E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG

Logger.debug.println(this, "### [j03HRP1001]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1001]j03Message_vt : " + j03Message_vt);

                }           //1001생성

                i_objid = box.get("SOBID_O");
                req.setAttribute("i_objid", i_objid);                   //생성된경우 Objectives가 변경된다.
                req.setAttribute("i_sobid", i_sobid);                   //생성된경우 대분류가 변경된다.

//              error를 처리하기 위해서 입력값을 화면으로 다시 보내준다.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 || i_sobid.equals("") || i_sobid.equals("00000000") ) {
                    req.setAttribute("STEXT",         box.get("STEXT"));          //대분류명
                    req.setAttribute("SOBID_F",       box.get("SOBID_F"));        //Function ID
                    req.setAttribute("SOBID_O",       box.get("SOBID_O"));        //Objective ID
//                  error 발생 여부
                    req.setAttribute("i_error",       "Y");
                    req.setAttribute("j03Message_vt", j03Message_vt);

                    dest = WebUtil.JspURL+"J/J04DsortCreate/J04DsortBuild.jsp";
//              생성 성공의 경우 Job Matrix 화면으로 이동한다.
                } else {
                    String msg = "msg014";
                    String url = "parent.J_leftDown.location.href = '" + WebUtil.ServletURL+"hris.J.J01JobMatrix.J01GetPersonsSV?i_objid="+i_objid+"&gubun=C';";
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
