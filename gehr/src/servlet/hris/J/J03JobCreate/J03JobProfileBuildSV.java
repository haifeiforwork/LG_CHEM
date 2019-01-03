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
import hris.J.J03JobCreate.*;
import hris.J.J03JobCreate.rfc.*;

/**
 * J03JobProfileBuildSV.java
 * Job Profile을 생성한다. << Job 생성 >>
 *
 * @author  김도신
 * @version 1.0, 2003/06/12
 */
public class J03JobProfileBuildSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession       session        = req.getSession(false);
            WebUserData       user           = (WebUserData)session.getAttribute("user");
            
            Box               box            = WebUtil.getBox(req);

            String            jobid          = box.get("jobid");
            String            i_objid        = box.get("OBJID");            // Objective ID
            String            i_sobid        = box.get("SOBID");            // Job ID
            String            i_pernr        = box.get("PERNR");            // 사원번호
            String            i_idx          = box.get("IMGIDX");
            String            i_link_chk     = box.get("i_link_chk");           
            String            i_begda        = box.get("BEGDA");
            String            i_Create       = box.get("i_Create");         //생성화면인지 조회,수정화면인지 menu에서 구분하기 위해서
            String            dest           = "";

            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            req.setAttribute("i_objid",    i_objid);
            req.setAttribute("i_pernr",    i_pernr);
            req.setAttribute("i_imgidx",   i_idx);
            req.setAttribute("i_link_chk", i_link_chk);
            req.setAttribute("i_begda",    i_begda);
            req.setAttribute("i_Create",   i_Create);

            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
                req.setAttribute("i_sobid",    i_sobid);

                dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileBuild.jsp";

            } else if( jobid.equals("create") ) {   //생성
                J03CUDObjectsRFC   rfc_1000      = new J03CUDObjectsRFC();
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();
                J03CUDContentsRFC  rfc_1002      = new J03CUDContentsRFC();
                J03CUDLevelingRFC  rfc_9618      = new J03CUDLevelingRFC();

                J03ObjectCreData   j03HRP1000    = null;
                J03ObjectCreData   j03HRP1001    = null;
                J03ObjectCreData   j03HRP1002    = null;
                J03ContentsCreData j03HRT1002    = null;
                J03ObjectCreData   j03HRP9618    = null;

                Vector             j03HRP1000_vt = new Vector();                //오브젝트 생성(HRP1000)
                Vector             j03HRP1001_vt = new Vector();                //관계 생성(HRP1001)
                Vector             j03HRP1002_vt = new Vector();                //내역 생성(HRP1002)
                Vector             j03HRT1002_vt = new Vector();                //내역 상세 입력사항 내용(HRT1002)
                Vector             j03HRP9618_vt = new Vector();                //Job Leveling Sheet 생성(HRP9618)
                Vector             j01Holder_vt  = new Vector();

//              생성 rfc 리턴값
                Vector             ret           = new Vector();
                Vector             j03Message_vt = new Vector();
                String             E_SUBRC       = "";

                int                count         = box.getInt("count");         //Job Holder count
                int                count_L       = box.getInt("count_L");       //Job Leveling Sheet count
                int                count_D       = box.getInt("count_D");       //내역 count

//              오브젝트 생성(HRP1000)
                j03HRP1000       = new J03ObjectCreData();
                j03HRP1000.OTYPE = "T";
                if( i_sobid.equals("") || i_sobid.equals("00000000") ) {
                    j03HRP1000.OBJID = "00000000";                              //default "00000000" - 생성시
                } else {
                    j03HRP1000.OBJID = i_sobid;                                 //생성된 Job ID
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

//              내역 상세 입력사항 내용(HRT1002)
                for( int i = 0 ; i < count_D ; i++ ) {
                    String            idx         = Integer.toString(i);

                    j03HRT1002       = new J03ContentsCreData();
                    j03HRT1002.SUBTY = box.get("SUBTY_D"+idx);                  //내역 구분
                    j03HRT1002.SEQNO = box.get("SEQNO_D"+idx);                  //순번
                    j03HRT1002.TLINE = box.get("TLINE_D"+idx);                  //내역상세

                    j03HRT1002_vt.addElement(j03HRT1002);
                }
//              Job Leveling Sheet 생성(HRP9618)
                for( int i = 0 ; i < count_L ; i++ ) {
                    String            idx         = Integer.toString(i);

                    j03HRP9618            = new J03ObjectCreData();
                    j03HRP9618.SUBTY      = box.get("SUBTY_L"+idx);
                    j03HRP9618.LEVEL_CODE = box.get("LCODE_L"+idx);

                    j03HRP9618_vt.addElement(j03HRP9618);
                }

//              오브젝트 생성에 성공한 경우
                if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 && !i_sobid.equals("") && !i_sobid.equals("00000000") ) {
//                  관계 생성(HRP1001) -  J-Project(T)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.SUBTY = "A007";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "007";
                    j03HRP1001.SCLAS = "T";
                    j03HRP1001.SOBID = "";                      //R3에서 J-Project 과업에 해당하는 ID를 넣어준다.
    
                    j03HRP1001_vt.addElement(j03HRP1001);
//                  관계 생성(HRP1001) -  대분류(15)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.SUBTY = "AZ12";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "Z12";
                    j03HRP1001.SCLAS = "15";
                    j03HRP1001.SOBID = box.get("SOBID_D");

                    j03HRP1001_vt.addElement(j03HRP1001);
//                  관계 생성(HRP1001) -  포지션(Job Holder)(S)
                    for( int i = 0 ; i < count ; i++ ) {                            
                        String            idx         = Integer.toString(i);

                        j03HRP1001       = new J03ObjectCreData();
                        j03HRP1001.BEGDA = box.get("BEGDA_S"+idx);                  //Job 시작일
                        j03HRP1001.SUBTY = "A007";
                        j03HRP1001.RSIGN = "A";
                        j03HRP1001.RELAT = "007";
                        j03HRP1001.SCLAS = "S";
                        j03HRP1001.SOBID = box.get("SOBID_S"+idx);

                        j03HRP1001_vt.addElement(j03HRP1001);
                    }
//                  관계 생성(HRP1001) -  Leveling 결과(12)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.SUBTY = "AZ20";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "Z20";
                    j03HRP1001.SCLAS = "12";
                    j03HRP1001.SOBID = box.get("SOBID_L");
    
                    j03HRP1001_vt.addElement(j03HRP1001);
//                  생성된 관계 데이터에 공통 데이터를 채워준다.
                    for( int i = 0 ; i < j03HRP1001_vt.size() ; i++ ) {
                        J03ObjectCreData data = (J03ObjectCreData)j03HRP1001_vt.get(i);

                        data.OTYPE = "T";
                        data.OBJID = i_sobid;                                     //default "00000000" - 생성시
//                      포지션이 아닌 경우 적용일자를 시작일에 반영한다.
                        if( !(data.RSIGN.equals("A") && data.RELAT.equals("007") && data.SCLAS.equals("S")) ) {
                            data.BEGDA = i_begda;                                 //적용일자
                        }
                        data.ENDDA = "99991231";                                  //default "99991231" - 생성시
                    }
Logger.debug.println(this, "### [HRP1001] : " + j03HRP1001_vt);
    
                    ret           = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                    j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                    E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG

Logger.debug.println(this, "### [j03HRP1001]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1001]j03Message_vt : " + j03Message_vt);

                    if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
//                      내역 생성(HRP1002)
                        String old_SUBTY = "";
                        for( int i = 0 ; i < j03HRT1002_vt.size() ; i++ ) {
                            J03ContentsCreData data = (J03ContentsCreData)j03HRT1002_vt.get(i);

//                          내역 상세 입력사항 내용(HRT1002)
                            data.OBJID = i_sobid;
                            if( !old_SUBTY.equals(data.SUBTY) ) {
                                j03HRP1002       = new J03ObjectCreData();
                                j03HRP1002.OTYPE = "T";
                                j03HRP1002.OBJID = data.OBJID;                              //default "00000000" - 생성시
                                j03HRP1002.BEGDA = i_begda;                                 //적용일자
                                j03HRP1002.ENDDA = "99991231";                              //default "99991231" - 생성시
                                j03HRP1002.SUBTY = data.SUBTY;
        
                                j03HRP1002_vt.addElement(j03HRP1002);
    
                                old_SUBTY = data.SUBTY;
                            }
                        }
Logger.debug.println(this, "### [HRP1002] : " + j03HRP1002_vt);
Logger.debug.println(this, "### [HRT1002] : " + j03HRT1002_vt);

                        ret           = rfc_1002.Create( user.empNo, j03HRP1002_vt, j03HRT1002_vt );
                        j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                        E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG

Logger.debug.println(this, "### [j03HRP1002]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1002]j03Message_vt : " + j03Message_vt);

                        if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
//                          Job Leveling Sheet 생성(HRP9618)
                            for( int i = 0 ; i < j03HRP9618_vt.size() ; i++ ) {
                                J03ObjectCreData data = (J03ObjectCreData)j03HRP9618_vt.get(i);
    
                                data.OTYPE      = "T";
                                data.OBJID      = i_sobid;                                 //default "00000000" - 생성시
                                data.BEGDA      = i_begda;                                 //적용일자
                                data.ENDDA      = "99991231";                              //default "99991231" - 생성시
                            }
Logger.debug.println(this, "### [HRP9618] : " + j03HRP9618_vt);

                            ret           = rfc_9618.Create( user.empNo, j03HRP9618_vt );
                            j03Message_vt = (Vector)ret.get(0);                          //작업 결과 메시지
                            E_SUBRC       = (String)ret.get(1);                          //작업 결과 FLAG
                        }   //9618생성
                    }       //1002생성
                }           //1001생성

Logger.debug.println(this, "### [j03HRP9618]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP9618]j03Message_vt : " + j03Message_vt);
//              error를 처리하기 위해서 입력값을 화면으로 다시 보내준다.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 || i_sobid.equals("") || i_sobid.equals("00000000") ) {
                    req.setAttribute("STEXT",           box.get("STEXT"));          //오브젝트 명
                    req.setAttribute("SOBID_D",         box.get("SOBID_D"));        //대분류 ID
//                  Job Holder
                    for( int i = 0 ; i < count ; i++ ) {                            
                        J01PersonsData j01Holder = new J01PersonsData();
                        String         idx       = Integer.toString(i);
                        j01Holder.TITEL = box.get("TITEL_S"+idx);
                        j01Holder.ENAME = box.get("ENAME_S"+idx);
                        j01Holder.BEGDA = box.get("BEGDA_S"+idx);
                        j01Holder.PERNR = box.get("PERNR_S"+idx);
                        j01Holder.OBJID = box.get("SOBID_S"+idx);

                        j01Holder_vt.addElement(j01Holder);
                    }
                    req.setAttribute("i_sobid",         i_sobid);                   //생성된 후 Job ID를 보내준다.
                    req.setAttribute("j01Holder_vt",    j01Holder_vt);              //Job Holder
                    req.setAttribute("SOBID_L",         box.get("SOBID_L"));        //Leveling 결과
                    req.setAttribute("j03HRT1002_vt",   j03HRT1002_vt);             //내역상세
                    req.setAttribute("j03HRP9618_vt",   j03HRP9618_vt);             //Job Leveling
//                  error 발생 여부
                    req.setAttribute("i_error",         "Y");
                    req.setAttribute("j03Message_vt",   j03Message_vt);

                    dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileBuild.jsp";
//              생성 성공의 경우 Competency Requirments를 생성하기위해서 화면을 이동한다.
                } else {
                    String msg = "msg012";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.J.J03JobCreate.J03CompetencyReqBuildSV?OBJID="+i_objid+"&SOBID="+i_sobid+"&BEGDA="+i_begda+"&i_link_chk="+i_link_chk+"&IMGIDX=2';";
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
