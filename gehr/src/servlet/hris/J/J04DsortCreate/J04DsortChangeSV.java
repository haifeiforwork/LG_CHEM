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

import hris.J.J01JobMatrix.*;
import hris.J.J01JobMatrix.rfc.*;
import hris.J.J03JobCreate.*;
import hris.J.J03JobCreate.rfc.*;
import hris.J.J05JobMove.*;

/**
 * J04DsortChangeSV.java
 * 대분류를 수정한다. << 대분류 수정 >>
 *
 * @author  김도신
 * @version 1.0, 2003/06/26
 */
public class J04DsortChangeSV extends EHRBaseServlet {
		
		protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
		{
				try{

						HttpSession       session        = req.getSession(false);
						WebUserData       user           = (WebUserData)session.getAttribute("user");
						
						Box               box            = WebUtil.getBox(req);

//          생성 rfc 리턴값
            Vector            ret            = new Vector();
            Vector            j03Message_vt  = new Vector();
            String            E_SUBRC        = "";
            String            E_HOLDER       = "";
            Vector            j05Stext_vt    = new Vector();

						String            jobid          = box.get("jobid");
						String            i_objid        = box.get("OBJID");            // Objective ID
						String            i_sobid        = box.get("SOBID");            // 대분류 ID
						String            i_pernr        = box.get("PERNR");            // 사원번호
						String            i_begda        = box.get("BEGDA");
            String            STEXT          = box.get("STEXT");            // 대분류 명
						String            dest           = "";

						if( jobid.equals("") ){
								jobid = "first";
						}
						Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
						
						req.setAttribute("i_objid",         i_objid);         //Objective ID
						req.setAttribute("i_sobid",         i_sobid);         //대분류 ID
						req.setAttribute("i_pernr",         i_pernr);         //사원번호
						req.setAttribute("i_begda",         i_begda);
            req.setAttribute("STEXT_D",         STEXT);

						if( jobid.equals("changeObjective") ) {     //대분류 Objective 변경
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();

                J03ObjectCreData   j03HRP1001    = null;

                Vector             j03HRP1001_vt = new Vector();                //관계 생성(HRP1001)

//              관계 생성(HRP1001) -  Objectives(11)
                j03HRP1001       = new J03ObjectCreData();
                j03HRP1001.OTYPE = "15";
                j03HRP1001.OBJID = i_sobid;
                j03HRP1001.BEGDA = i_begda;                                 //적용일자
                j03HRP1001.ENDDA = "99991231";                              //default "99991231" - 생성시
                j03HRP1001.SUBTY = "AZ11";
                j03HRP1001.RSIGN = "A";
                j03HRP1001.RELAT = "Z11";
                j03HRP1001.SCLAS = "11";
                j03HRP1001.SOBID = i_objid;
    
                j03HRP1001_vt.addElement(j03HRP1001);
Logger.debug.println(this, "### [HRP1001] : " + j03HRP1001_vt);
    
                ret           = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG
                E_HOLDER      = (String)ret.get(2);                          //Holder 한계결정 여부
                j05Stext_vt   = (Vector)ret.get(3);                          //실제 Holder가 삭제된 Job 명칭

Logger.debug.println(this, "### [j03HRP1001]E_SUBRC : " + E_SUBRC + " ### E_HOLDER : " + E_HOLDER);
Logger.debug.println(this, "### [j03HRP1001]j03Message_vt : " + j03Message_vt);

						} else if( jobid.equals("changeName") ) {   //대분류 명 변경
                J03CUDObjectsRFC   rfc_1000      = new J03CUDObjectsRFC();

                J03ObjectCreData   j03HRP1000    = null;

                Vector             j03HRP1000_vt = new Vector();                //오브젝트 생성(HRP1000)

//              오브젝트 생성(HRP1000)
                j03HRP1000       = new J03ObjectCreData();
                j03HRP1000.OTYPE = "15";
                j03HRP1000.OBJID = i_sobid;                                     //대분류 ID
                j03HRP1000.BEGDA = i_begda;                                     //적용일자
                j03HRP1000.ENDDA = "99991231";                                  //default "99991231" - 생성시
                j03HRP1000.SHORT = box.get("SHORT");                            //char 12
                j03HRP1000.STEXT = box.get("STEXT");                            //char 40

                j03HRP1000_vt.addElement(j03HRP1000);
Logger.debug.println(this, "### [HRP1000] : " + j03HRP1000_vt);

                ret           = rfc_1000.Create( user.empNo, j03HRP1000_vt );
                j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG
//                i_sobid       = (String)ret.get(2);                          //생성된 오브젝트 ID

Logger.debug.println(this, "### [j03HRP1000]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1000]j03Message_vt : " + j03Message_vt);
						}

//          error를 처리하기 위해서 입력값을 화면으로 다시 보내준다.
            if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 ) {
//                  error 발생 여부
                req.setAttribute("i_error",       "Y");
                req.setAttribute("j03Message_vt", j03Message_vt);

    						if( jobid.equals("changeObjective") ) {     //대분류 Objective 변경
                    dest = WebUtil.JspURL+"J/J04DsortCreate/J04DsortChangeObjective.jsp";
                } else if( jobid.equals("changeName") ) {   //대분류 명 변경
                    dest = WebUtil.JspURL+"J/J04DsortCreate/J04DsortChangeName.jsp";
                }
//          생성 성공의 경우 Job Matrix 화면으로 이동한다.
            } else {
                String msg = "";
    						if( jobid.equals("changeObjective") && E_HOLDER.equals("Y") ) {     //대분류 Objective 변경
                    msg = "해당 대분류에 속하는 ";

                    for( int i = 0 ; i < j05Stext_vt.size() ; i++ ) {
                        J05JobMoveData j05Stext = (J05JobMoveData)j05Stext_vt.get(i);
                        if( i == (j05Stext_vt.size() - 1) ) {
                            msg += j05Stext.STEXT + "의 ";
                        } else {
                            msg += j05Stext.STEXT + ", ";
                        }
                    }
                    msg += "Job Holder 지정이 삭제 되었습니다.\\nJob Holder를 재지정해 주시기 바랍니다.";
                } else {   //대분류 명 변경, 대분류 Objective 변경에서 Holder 한계결정 No일경우
                    msg = "msg002";
                } 
                String url = "parent.opener.parent.J_right.location.href = '" + WebUtil.ServletURL+"hris.J.J04DsortCreate.J04DsortDetailSV?OBJID="+i_objid+"&SOBID="+i_sobid+"&PERNR="+i_pernr+"&BEGDA="+i_begda+"';self.close();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);

                dest = WebUtil.JspURL+"common/msg.jsp";
            }
						Logger.debug.println(this, " destributed = " + dest);
						printJspPage(req, res, dest);
							
				} catch (Exception e) {
						throw new GeneralException(e);
				}
		}
}
