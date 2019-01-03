/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인재개발 협의결과 조회                                      */
/*   Program Name : 인재개발 협의결과 조회                                      */
/*   Program ID   : B03DevelopListSV_m                                          */
/*   Description  : 인재개발 협의결과 정보를 jsp로 넘겨주는 class               */
/*   Note         : 없음                                                        */
/*   Creation     : 2002-01-29  이형석                                          */
/*   Update       : 2003-06-23  최영호                                          */
/*                  2005-01-11  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.B;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.* ;
import hris.B.B03DevelopData;
import hris.B.B03DevelopData2;
import hris.B.rfc.*;

public class B03DevelopListSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid2   = "";
            String dest    = "";
            String page2   = "";
            String begDa   = "";
            String command = "";
            String seqnr   = "";
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Box box = WebUtil.getBox(req);
            jobid2  = box.get("jobid2");
            page2   = box.get("page2");
            begDa   = box.get("begDa");
            begDa   = DataUtil.removeStructur(begDa,".");
            command = box.get("command");
            seqnr   = box.get("seqnr");

            B03DevelopListRFC func1 = null;
            Vector B03Develop_vt        = new Vector();
            Vector B03DevelopDetail_vt  = new Vector();
            Vector B03DevelopDetail2_vt = new Vector();

            //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
            MappingPernrRFC  mapfunc = null ;
            MappingPernrData mapData = new MappingPernrData();
            Vector mapData_vt     = new Vector() ;
            Vector firstData_vt   = new Vector() ;
            Vector detailData_vt  = new Vector() ;
            Vector detail2Data_vt = new Vector() ;

            if( jobid2.equals("") ){
                jobid2 = "first";
            }

            Logger.debug.println(this, " command = " + command);
            Logger.debug.println(this, " [begDa] = " + begDa);

            if( jobid2.equals("first") ){

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid] = "+jobid2 + " [user_m] : "+user_m.toString());
                    //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                        B03DevelopData data = new B03DevelopData();

                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);

                            func1        = new B03DevelopListRFC() ;
                            firstData_vt = func1.getDevelopList(mapData.PERNR, begDa, "000", "1");

                            for( int j = 0 ; j < firstData_vt.size() ; j++ ) {
                                data = (B03DevelopData)firstData_vt.get(j);
                                B03Develop_vt.addElement(data);
                            }
                        }

                    } else {
                        func1         = new B03DevelopListRFC();
                        B03Develop_vt = func1.getDevelopList(user_m.empNo, begDa, "000", "1");
                    }
                }

                req.setAttribute("page2", page2);
                req.setAttribute("B03Develop_vt", B03Develop_vt);

                dest = WebUtil.JspURL+"B/B03DevelopList_m.jsp";

            } else if( jobid2.equals("detail")){

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid] = "+jobid2 + " [user_m] : "+user_m.toString());
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                        B03DevelopData data = new B03DevelopData();

                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);

                            func1         = new B03DevelopListRFC() ;
                            detailData_vt = func1.getDevelopList(mapData.PERNR, begDa, "000", "2");

                            for( int j = 0 ; j < detailData_vt.size() ; j++ ) {
                                data = (B03DevelopData)detailData_vt.get(j);
                                B03DevelopDetail_vt.addElement(data);
                            }
                        }

                    } else {
                        func1 = new B03DevelopListRFC();
                        B03DevelopDetail_vt = func1.getDevelopList(user_m.empNo, begDa, "000", "2");
                    }
                }

                req.setAttribute("begDa", begDa);
                req.setAttribute("command", command);
                req.setAttribute("B03DevelopDetail_vt", B03DevelopDetail_vt);
                Logger.debug.println(this, "B03DevelopDetail_vt : "+ B03DevelopDetail_vt.toString());

                dest = WebUtil.JspURL+"B/B03DevelopDetail_m.jsp";
            } else if( jobid2.equals("detailD")){

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid] = "+jobid2 + " [user_m] : "+user_m.toString());
                    //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    
                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                        B03DevelopData2 data = new B03DevelopData2();
                         
                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);

                            func1          = new B03DevelopListRFC() ;
                            detail2Data_vt = func1.getDevelopList(mapData.PERNR, begDa, "000", "3");

                            for( int j = 0 ; j < detail2Data_vt.size() ; j++ ) {
                                data = (B03DevelopData2)detail2Data_vt.get(j);
                                B03DevelopDetail2_vt.addElement(data);
                            }
                        }

                    } else {
                        func1 = new B03DevelopListRFC();
                        B03DevelopDetail2_vt = func1.getDevelopList(user_m.empNo, begDa, "000", "3");
                    }
                }

                req.setAttribute("begDa", begDa);
                req.setAttribute("B03DevelopDetail2_vt", B03DevelopDetail2_vt);
                Logger.debug.println(this, "B03DevelopDetail2_vt : "+ B03DevelopDetail2_vt.toString());

                dest = WebUtil.JspURL+"B/B03DevelopDetail2_m.jsp";
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println("dest=="+dest);
            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
            Logger.debug.println(this, " res = " + res);
        } catch( Exception e) {
            throw new GeneralException(e);
        }
    }
}
