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
import hris.J.J03JobCreate.J03ObjectCreData;

/**
 * J03LevelingSheetBuildSV.java
 * Job Leveling Sheet를 생성한다. << Job 생성 >>
 *
 * @author  김도신
 * @version 1.0, 2003/06/18
 */
public class J03LevelingSheetBuildSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session         = req.getSession(false);
            WebUserData         user            = (WebUserData)session.getAttribute("user");
                                                
            Box                 box             = WebUtil.getBox(req);
                                                
            J01LevelingSheetRFC rfc             = new J01LevelingSheetRFC();
            J01LevelListRFC     rfc_List        = new J01LevelListRFC();
                                                
            Vector              ret             = new Vector();
            Vector              j01Result_vt    = new Vector();
            Vector              j01Result_D_vt  = new Vector();
            Vector              j01Result_L_vt  = new Vector();
            Vector              j01LevelList_vt = new Vector();

            String              jobid           = box.get("jobid");
            String              i_objid         = box.get("OBJID");                //Objective ID
            String              i_sobid         = box.get("SOBID");                //Job ID
            String              i_pernr         = box.get("PERNR");                //사원번호
            String              i_link_chk      = box.get("i_link_chk");           //link 여부
            String              i_idx           = box.get("IMGIDX");               //메뉴 Index
            String              i_begda         = box.get("BEGDA");                //Job 생성일
						String              i_Create        = box.get("i_Create");         //생성화면인지 조회,수정화면인지 menu에서 구분하기 위해서
//          Job Profile화면에서 이미 선택된 Job Leveling 결과, count 정보.
            String              SOBID_L         = box.get("SOBID_L");
            int                 count_L         = box.getInt("count_L");           //Job Leveling Sheet count
            String              dest            = "";
            
            if( jobid.equals("") ){
                jobid = "first";
            }

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
//              Leveling Sheet 조회
                ret            = rfc.getDetail( i_objid, i_sobid, "99991231" );

                j01Result_vt    = (Vector)ret.get(0);        // 대분류, 평가요소, Level
                j01Result_D_vt  = (Vector)ret.get(1);        // 직무평가요소 정의
                j01Result_L_vt  = (Vector)ret.get(2);        // Leveling 등급 List

//              Leveling 결과 점수관리
                j01LevelList_vt = rfc_List.getDetail( "99991231" );
//              Job Profile화면에서 이미 선택된 Job Leveling 정보를 읽는다.
                for( int i = 0 ; i < count_L ; i++ ) {
                    J03ObjectCreData  j03Data = new J03ObjectCreData();
                    String            idx     = Integer.toString(i);

                    j03Data.SUBTY      = box.get("SUBTY_L"+idx);
                    j03Data.LEVEL_CODE = box.get("LCODE_L"+idx);                                     //default "00000000" - 생성시

//                  LEVEL_CODE0에 선택된 값을 넣어준다.
                    for( int j = 0 ; j < j01Result_vt.size() ; j++ ) {
                        J01LevelingSheetData data = (J01LevelingSheetData)j01Result_vt.get(j);
                        if( j03Data.SUBTY.equals(data.DSORT_CODE + data.ELEME_CODE) ) {
                            data.LEVEL_CODE0 = j03Data.LEVEL_CODE;
                        }
                    }
                }

//              Job Leveling Sheet
                req.setAttribute("j01Result_vt",    j01Result_vt);
                req.setAttribute("j01Result_D_vt",  j01Result_D_vt);
                req.setAttribute("j01Result_L_vt",  j01Result_L_vt);
//              Job Leveling 결과 점수관리
                req.setAttribute("j01LevelList_vt", j01LevelList_vt);
//              Objective ID, Job ID
                req.setAttribute("i_objid",         i_objid);
                req.setAttribute("i_sobid",         i_sobid);
                req.setAttribute("i_pernr",         i_pernr);
                req.setAttribute("i_link_chk",      i_link_chk);                        
                req.setAttribute("i_imgidx",        i_idx);
                req.setAttribute("i_begda",         i_begda);
    						req.setAttribute("i_Create",        i_Create);
                req.setAttribute("SOBID_L",         SOBID_L);
    
//              Job Leveling 생성인 경우
                dest = WebUtil.JspURL+"J/J03JobCreate/J03LevelingSheetBuild.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
              
        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
