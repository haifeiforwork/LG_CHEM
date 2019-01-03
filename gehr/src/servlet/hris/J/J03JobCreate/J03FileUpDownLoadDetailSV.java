package servlet.hris.J.J03JobCreate;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

import hris.J.J01JobMatrix.*;
import hris.J.J01JobMatrix.rfc.*;

/**
 * J03FileUpDownLoadDetailSV.java
 * Eloffice의 Job Unit별 KSEA, Job Process Image FileName을 조회한다. 
 *
 * @author  김도신
 * @version 1.0, 2003/06/26
 */
public class J03FileUpDownLoadDetailSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01ImageFileNameRFC rfc            = new J01ImageFileNameRFC();

//          PPT가 파일이 등록되었는지 check한다.
            Vector              ret_PPT        = new Vector();
            Vector              j01PPT_vt      = new Vector();
            String              i_PPT          = "";              //등록되어있는경우 "Y"

            Vector              ret            = new Vector();
            Vector              j01Result_vt   = new Vector();
            Vector              j01Result_P_vt = new Vector();
            Vector              j01Result_D_vt = new Vector();

            String              jobid          = box.get("jobid");
            String              i_objid        = box.get("OBJID");
            String              i_sobid        = box.get("SOBID");
            String              i_pernr        = box.get("PERNR");
            String              i_link_chk     = box.get("i_link_chk");
            String              i_idx          = box.get("IMGIDX");
            String              i_begda        = box.get("BEGDA");
						String              i_Create       = box.get("i_Create");         //생성화면인지 조회,수정화면인지 menu에서 구분하기 위해서
            String              dest           = "";
//          paging 처리
            String              page           = "";

//          i_ids = '3'이면 Job Unit별 KSEA, i_ids = '4'이면 Job Process - R/3의 구분자와 맞춰준다.
//          - 이미지화일 조회시 index에서 2를 빼준다.
            String              i_gubun        = Integer.toString(Integer.parseInt(i_idx) - 2);

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " i_begda : "+i_begda);
            
            page  = box.get("page");
            if( page.equals("") || page == null ){
                page = "1";
            }

//          Objective ID, Job ID..
            req.setAttribute("i_objid",        i_objid);
            req.setAttribute("i_sobid",        i_sobid);
            req.setAttribute("i_pernr",        i_pernr);
            req.setAttribute("i_link_chk",     i_link_chk);            
            req.setAttribute("i_imgidx",       i_idx);
            req.setAttribute("i_begda",        i_begda);
						req.setAttribute("i_Create",       i_Create);
            req.setAttribute("page",           page );
            
            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
//              i_gubun = '1'이면 Job Unit별 KSEA, i_gubun = '2'면 Job Process
//              Job Unit별 KSEA, Job Process Image FileName 조회
                ret            = rfc.getDetail( i_gubun, i_objid, i_sobid, i_begda );

                j01Result_vt   = (Vector)ret.get(0);
                j01Result_P_vt = (Vector)ret.get(1);
                j01Result_D_vt = (Vector)ret.get(2);

//              이미지 화일이 없는경우에 PPT 파일이 등록되었을경우와 등록되지 않았을경우에 메시지를 다르게 보여주기위해서
                ret_PPT        = rfc.getDetail( i_idx, i_objid, i_sobid, i_begda );
Logger.debug.println(this, "##################### j01PPT_vt : " + j01PPT_vt);
                j01PPT_vt      = (Vector)ret_PPT.get(0);
Logger.debug.println(this, "##################### j01PPT_vt.size() : " + j01PPT_vt.size());
                if( j01PPT_vt.size() > 0 ) {
                    J01ImageFileNameData data = (J01ImageFileNameData)j01PPT_vt.get(0);
                    if( data.TASK_CODE.equals("00000000") ) {
                        i_PPT = "N";
                    } else {
                        i_PPT = "Y";
                    } 
                }
//              ---------------------------------------------------------------------------------------------------

//              Job Unit별 KSEA, Job Process Image FileName
                req.setAttribute("j01Result_vt",   j01Result_vt);
//              Job Process일경우 Job Objectives와 Position
                req.setAttribute("j01Result_P_vt", j01Result_P_vt);
                req.setAttribute("j01Result_D_vt", j01Result_D_vt);

                req.setAttribute("i_PPT",          i_PPT);
                        
                dest = WebUtil.JspURL+"J/J03JobCreate/J03FileUpDownLoadDetail.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest + "  page : "+ page);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
