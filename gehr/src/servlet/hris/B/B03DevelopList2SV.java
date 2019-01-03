/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인재개발협의결과입력                                        */
/*   Program Name : 인재개발협의결과입력                                        */
/*   Program ID   : B03DevelopList2SV                                           */
/*   Description  : 인재개발 협의결과 입력                                      */
/*   Note         :                                                             */
/*   Creation     : 최영호                                                      */
/*   Update       : 2005-01-26  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.B;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.B.B03DevelopBuildData;
import hris.B.B03DevelopData;
import hris.B.B03DevelopData2;
import hris.B.rfc.*;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class B03DevelopList2SV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try
        {
            HttpSession session = req.getSession(false);
            WebUserData webuserdata = (WebUserData)session.getAttribute("user");
            String jobid = "";
            String dest= "";
            String s3 = "";
            String s4 = "";
            String s5 = "";
            String s6 = "";
            String s8 = "";
            String s9 = "";
            String s10 = "";
            String s52 = "";
            String empNo = " ";
            String ORGTX = " ";
            String TITEL = " ";
            String TITL2 = " ";
            String ENAME = " ";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            s8 = box.get("empNo");
            s3 = box.get("page");
            s4 = box.get("begDa");
            s4 = DataUtil.removeStructur(s4, ".");
            s5 = box.get("command");
            s6 = box.get("seqnr");
            s9 = box.get("sect");
            s10 = box.get("sect2");
            s52 = box.get("auth");

            empNo = box.get("empNo");
            ORGTX = box.get("ORGTX");
            TITEL = box.get("TITEL");
            TITL2 = box.get("TITL2");
            ENAME = box.get("ENAME");

            Logger.debug.println(this, "[jobid]**** = " + jobid + " [user] : " + webuserdata.toString());

            if(jobid.equals(""))
                jobid = "first";

            Logger.debug.println(this, " [jobid] = " + jobid + " [user] : " + webuserdata.toString());
            Logger.debug.println(this, " command = " + s5);
            Logger.debug.println(this, " [begDa] = " + s4);
            Logger.debug.println(this, " [empNo] = " + s8);
            Logger.debug.println(this, " [seqnr] = " + s6);

            if(jobid.equals("first")) {
                B03DevelopList2RFC b03developlist2rfc = new B03DevelopList2RFC();
                Vector vector = b03developlist2rfc.getDevelopList(s8, s4, "000", "1");
                req.setAttribute("page", s3);
                req.setAttribute("empNo", s8);
                
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);
                
                req.setAttribute("B03Develop_vt", vector);
                Logger.debug.println(this, "B03Develop_vt(first) : " + vector.toString());
                dest= WebUtil.JspURL + "B/B03DevelopList2.jsp";

            } else if(jobid.equals("detail")) {
                B03DevelopList2RFC b03developlist2rfc1 = new B03DevelopList2RFC();
                Vector vector1 = b03developlist2rfc1.getDevelopList(s8, s4, "000", "2");
                req.setAttribute("begDa", s4);
                req.setAttribute("empNo", s8);
                req.setAttribute("command", s5);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);
                
                req.setAttribute("B03DevelopDetail_vt", vector1);
                Logger.debug.println(this, "B03DevelopDetail_vt : " + vector1.toString());
                dest= WebUtil.JspURL + "B/B03DevelopDetail3.jsp";

            } else if(jobid.equals("print")) {
                B03DevelopList2RFC b03developlist2rfc2 = new B03DevelopList2RFC();
                Vector vector2 = b03developlist2rfc2.getDevelopList(s8, s4, s6, "2");
                req.setAttribute("begDa", s4);
                req.setAttribute("empNo", s8);
                req.setAttribute("command", s5);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);
                
                req.setAttribute("B03DevelopDetail_vt", vector2);
                Logger.debug.println(this, "B03DevelopDetail_vt : " + vector2.toString());
                req.setAttribute("print_page_name", WebUtil.ServletURL + "hris.B.B03DevelopList2SV?jobid=print_m&begDa=" + s4 + "&empNo=" + s8 + "&command=" + s5);
                dest= WebUtil.JspURL + "common/printFrame.jsp";

            } else if(jobid.equals("print_m")) {
                B03DevelopList2RFC b03developlist2rfc3 = new B03DevelopList2RFC();
                B03DevelopList2RFC b03developlist2rfc9 = new B03DevelopList2RFC();
                Vector vector11 = b03developlist2rfc3.getDevelopList(s8, s4, s6, "2");
                Vector vector15 = b03developlist2rfc9.getDevelopList(s8, s4, s6, "3");
                req.setAttribute("begDa", s4);
                req.setAttribute("empNo", s8);
                req.setAttribute("command", s5);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);
                
                req.setAttribute("B03DevelopDetail_vt", vector11);
                req.setAttribute("B03DevelopDetail2_vt", vector15);
                Logger.debug.println(this, "B03DevelopDetail_vt : " + vector11.toString());
                if(webuserdata.companyCode.equals("C100"))
                    dest= WebUtil.JspURL + "B/B03DevelopResult.jsp";
                else
                    dest= WebUtil.JspURL + "B/B03DevelopResult_n100.jsp";

            } else if(jobid.equals("detailD")) {
                B03DevelopList2RFC b03developlist2rfc4 = new B03DevelopList2RFC();
                Vector vector3 = b03developlist2rfc4.getDevelopList(s8, s4, s6, "3");
                req.setAttribute("begDa", s4);
                req.setAttribute("empNo", s8);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);

                req.setAttribute("B03DevelopDetail2_vt", vector3);
                Logger.debug.println(this, "B03DevelopDetail2_vt : " + vector3.toString());
                dest= WebUtil.JspURL + "B/B03DevelopDetail2.jsp";

            } else if(jobid.equals("build")) {
                B03DevelopChiefInfoRFC b03developchiefinforfc = new B03DevelopChiefInfoRFC();
                Vector vector4 = b03developchiefinforfc.getChief(webuserdata.companyCode, "01");
                Vector vector12 = b03developchiefinforfc.getChief(webuserdata.companyCode, "02");
                Vector vector16 = b03developchiefinforfc.getChief(webuserdata.companyCode, "03");
                B03DevelopSectInfoRFC b03developsectinforfc = new B03DevelopSectInfoRFC();
                Vector vector23 = b03developsectinforfc.getComm(s9, webuserdata.empNo, s8);
                B03DevelopAuthChkRFC b03developauthchkrfc = new B03DevelopAuthChkRFC();
                s52 = b03developauthchkrfc.getAuth(webuserdata.companyCode, webuserdata.empNo);
                req.setAttribute("B03DevelopChiefInfo_vt", vector4);
                req.setAttribute("B03DevelopChiefInfo2_vt", vector12);
                req.setAttribute("B03DevelopChiefInfo3_vt", vector16);
                req.setAttribute("B03DevelopSectInfo_vt", vector23);
                req.setAttribute("com_num", "");
                req.setAttribute("com_nam", "");
                req.setAttribute("com_typ", "");
                req.setAttribute("com1_nam1", "");
                req.setAttribute("com2_nam2", "");
                req.setAttribute("com3_nam3", "");
                req.setAttribute("com4_nam4", "");
                req.setAttribute("com1_num1", "");
                req.setAttribute("com2_num2", "");
                req.setAttribute("com3_num3", "");
                req.setAttribute("com4_num4", "");
                req.setAttribute("empNo", s8);
                req.setAttribute("seqnr", s5);
                req.setAttribute("auth", s52);
                
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                Logger.debug.println(this, "B03DevelopChiefInfo_vt : " + vector4.toString());
                Logger.debug.println(this, "B03DevelopSectInfo_vt.size() : " + vector23.size());
                dest= WebUtil.JspURL + "B/B03DevelopBuild.jsp";

            } else if(jobid.equals("sect")) {
                String s12 = box.get("com_num");
                String s14 = box.get("com_nam");
                String s16 = box.get("com_typ");
                String s19 = box.get("com1_nam1");
                String s21 = box.get("com2_nam2");
                String s23 = box.get("com3_nam3");
                String s25 = box.get("com4_nam4");
                String s27 = box.get("com1_num1");
                String s30 = box.get("com2_num2");
                String s33 = box.get("com3_num3");
                String s36 = box.get("com4_num4");
                s52 = box.get("auth");
                B03DevelopChiefInfoRFC b03developchiefinforfc1 = new B03DevelopChiefInfoRFC();
                Vector vector5 = b03developchiefinforfc1.getChief(webuserdata.companyCode, "01");
                Vector vector13 = b03developchiefinforfc1.getChief(webuserdata.companyCode, "02");
                Vector vector17 = b03developchiefinforfc1.getChief(webuserdata.companyCode, "03");
                B03DevelopSectInfoRFC b03developsectinforfc1 = new B03DevelopSectInfoRFC();
                Vector vector24 = b03developsectinforfc1.getComm(s9, webuserdata.empNo, s8);
                req.setAttribute("B03DevelopChiefInfo_vt", vector5);
                req.setAttribute("B03DevelopChiefInfo2_vt", vector13);
                req.setAttribute("B03DevelopChiefInfo3_vt", vector17);
                req.setAttribute("B03DevelopSectInfo_vt", vector24);
                req.setAttribute("com_num", s12);
                req.setAttribute("com_nam", s14);
                req.setAttribute("com_typ", s16);
                req.setAttribute("com1_nam1", s19);
                req.setAttribute("com2_nam2", s21);
                req.setAttribute("com3_nam3", s23);
                req.setAttribute("com4_nam4", s25);
                req.setAttribute("com1_num1", s27);
                req.setAttribute("com2_num2", s30);
                req.setAttribute("com3_num3", s33);
                req.setAttribute("com4_num4", s36);
                req.setAttribute("empNo", s8);
                req.setAttribute("seqnr", s6);
                req.setAttribute("auth", s52);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                Logger.debug.println(this, "B03DevelopSectInfo_vt : " + vector24.toString());
                Logger.debug.println(this, "B03DevelopChiefInfo_vt : " + vector5.toString());
                Logger.debug.println(this, "B03DevelopChiefInfo2_vt : " + vector13.toString());
                Logger.debug.println(this, "B03DevelopChiefInfo3_vt : " + vector17.toString());
                Logger.debug.println(this, "B03DevelopSectInfo_vt.size() : " + vector24.size());
                dest= WebUtil.JspURL + "B/B03DevelopBuild.jsp";

            } else if(jobid.equals("develop")) {
                String s39 = box.get("perno");
                String s46 = box.get("m_begda");
                s6 = box.get("seqnr");
                Logger.debug.println(this, " [perno]## = " + s39);
                Logger.debug.println(this, " [m_begda]## = " + s46);
                Logger.debug.println(this, " [seqnr]## = " + s6);
                req.setAttribute("perno", s39);
                req.setAttribute("m_begda", s46);
                req.setAttribute("seqnr", s6);
                req.setAttribute("empNo", s8);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                dest= WebUtil.JspURL + "B/B03DevelopCareer.jsp";

            } else if(jobid.equals("creat")) {
                String s40 = box.get("perno");
                String s44 = box.get("begda");
                String s47 = DataUtil.removeStructur(s44, ".");
                Logger.debug.println(this, " [perno] = " + s40);
                B03DevelopBuildRFC b03developbuildrfc = new B03DevelopBuildRFC();
                B03DevelopBuildData b03developbuilddata = new B03DevelopBuildData();
                box.copyToEntity(b03developbuilddata);
                Logger.debug.println(this, box.toString());
                b03developbuilddata.PERNR = s40;
                b03developbuilddata.BEGDA = s47;
                Logger.debug.println(this, b03developbuilddata.toString());
                b03developbuildrfc.build(b03developbuilddata, "1");
                jobid = "develop";
                String s92 = "msg008";
                String s94 = "location.href = '" + WebUtil.ServletURL + "hris.B.B03DevelopList2SV?jobid=" + jobid + "&perno=" + s40 + "&m_begda=" + s47 + "&seqnr=" + s6 + "';";
                req.setAttribute("msg", s92);
                req.setAttribute("url", s94);
                dest= WebUtil.JspURL + "common/msg.jsp";

            } else  if(jobid.equals("delete")) {
                B03DevelopList2RFC b03developlist2rfc5 = new B03DevelopList2RFC();
                Vector vector6 = b03developlist2rfc5.getDevelopList(s8, s4, "000", "1");
                B03DevelopBuildRFC b03developbuildrfc2 = new B03DevelopBuildRFC();
                b03developbuildrfc2.delete(s8, s4, s6, "2");
                jobid = "first";
                String s95 = "msg003";
                String s98 = "location.href = '" + WebUtil.ServletURL + "hris.B.B03DevelopList2SV?jobid=" + jobid + "&empNo=" + s8 + "';";
                req.setAttribute("msg", s95);
                req.setAttribute("url", s98);
                dest= WebUtil.JspURL + "common/msg.jsp";

            } else if(jobid.equals("change")) {
                B03DevelopList2RFC b03developlist2rfc6 = new B03DevelopList2RFC();
                Vector vector7 = b03developlist2rfc6.getDevelopList(s8, s4, "000", "2");
                B03DevelopChiefInfoRFC b03developchiefinforfc3 = new B03DevelopChiefInfoRFC();
                Vector vector18 = b03developchiefinforfc3.getChief(webuserdata.companyCode, "01");
                Vector vector21 = b03developchiefinforfc3.getChief(webuserdata.companyCode, "02");
                Vector vector25 = b03developchiefinforfc3.getChief(webuserdata.companyCode, "03");
                B03DevelopSectInfoRFC b03developsectinforfc3 = new B03DevelopSectInfoRFC();
                B03DevelopAuthChkRFC b03developauthchkrfc1 = new B03DevelopAuthChkRFC();
                s52 = b03developauthchkrfc1.getAuth(webuserdata.companyCode, webuserdata.empNo);
                B03DevelopData b03developdata = (B03DevelopData)vector7.get(Integer.parseInt(s5));
                if(s9.equals("")) {
                    Vector vector29 = b03developsectinforfc3.getComm(b03developdata.COMM_TYPE, webuserdata.empNo, s8);
                    req.setAttribute("B03DevelopSectInfo_vt", vector29);
                } else {
                    Vector vector30 = b03developsectinforfc3.getComm(s9, webuserdata.empNo, s8);
                    req.setAttribute("B03DevelopSectInfo_vt", vector30);
                }
                req.setAttribute("B03DevelopChiefInfo_vt", vector18);
                req.setAttribute("B03DevelopChiefInfo2_vt", vector21);
                req.setAttribute("B03DevelopChiefInfo3_vt", vector25);
                req.setAttribute("begDa", s4);
                req.setAttribute("empNo", s8);
                req.setAttribute("command", s5);
                req.setAttribute("auth", s52);
                req.setAttribute("sect", "");
                req.setAttribute("sect2", "");
                req.setAttribute("com1_num1", "");
                req.setAttribute("com2_num2", "");
                req.setAttribute("com3_num3", "");
                req.setAttribute("com4_num4", "");
                req.setAttribute("comm_numb", "");
                req.setAttribute("self_flag", "");
                req.setAttribute("upbr_post", "");
                req.setAttribute("exl1_pont", "");
                req.setAttribute("exl2_pont", "");
                req.setAttribute("spl1_pont", "");
                req.setAttribute("spl2_pont", "");
                req.setAttribute("upb1_crse", "");
                req.setAttribute("upb2_crse", "");
                req.setAttribute("cmt1_text", "");
                req.setAttribute("cmt2_text", "");
                req.setAttribute("cmt3_text", "");
                req.setAttribute("cmt4_text", "");
                req.setAttribute("cmt5_text", "");
                req.setAttribute("cmt6_text", "");
                req.setAttribute("etc1_text", "");
                req.setAttribute("etc2_text", "");
                req.setAttribute("fup1_text", "");
                req.setAttribute("fup2_text", "");
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                req.setAttribute("B03DevelopDetail_vt", vector7);
                Logger.debug.println(this, "B03DevelopDetail_vt : " + vector7.toString());
                dest= WebUtil.JspURL + "B/B03DevelopChange.jsp";

            } else if(jobid.equals("sect1")) {
                String s28 = box.get("com1_num1");
                String s31 = box.get("com2_num2");
                String s34 = box.get("com3_num3");
                String s37 = box.get("com4_num4");
                String s54 = box.get("comm_numb");
                String s56 = box.get("self_flag");
                String s58 = box.get("upbr_post");
                String s60 = box.get("exl1_pont");
                String s62 = box.get("exl2_pont");
                String s64 = box.get("spl1_pont");
                String s66 = box.get("spl2_pont");
                String s68 = box.get("upb1_crse");
                String s70 = box.get("upb2_crse");
                String s72 = box.get("cmt1_text");
                String s74 = box.get("cmt2_text");
                String s76 = box.get("cmt3_text");
                String s78 = box.get("cmt4_text");
                String s80 = box.get("cmt5_text");
                String s82 = box.get("cmt6_text");
                String s84 = box.get("etc1_text");
                String s86 = box.get("etc2_text");
                String s88 = box.get("fup1_text");
                String s90 = box.get("fup2_text");
                s52 = box.get("auth");
                B03DevelopChiefInfoRFC b03developchiefinforfc2 = new B03DevelopChiefInfoRFC();
                Vector vector8 = b03developchiefinforfc2.getChief(webuserdata.companyCode, "01");
                Vector vector14 = b03developchiefinforfc2.getChief(webuserdata.companyCode, "02");
                Vector vector19 = b03developchiefinforfc2.getChief(webuserdata.companyCode, "03");
                B03DevelopSectInfoRFC b03developsectinforfc2 = new B03DevelopSectInfoRFC();
                Vector vector26 = b03developsectinforfc2.getComm(s9, webuserdata.empNo, s8);
                B03DevelopList2RFC b03developlist2rfc11 = new B03DevelopList2RFC();
                Vector vector28 = b03developlist2rfc11.getDevelopList(s8, s4, "000", "2");
                req.setAttribute("B03DevelopChiefInfo_vt", vector8);
                req.setAttribute("B03DevelopChiefInfo2_vt", vector14);
                req.setAttribute("B03DevelopChiefInfo3_vt", vector19);
                req.setAttribute("B03DevelopSectInfo_vt", vector26);
                req.setAttribute("B03DevelopDetail_vt", vector28);
                req.setAttribute("com1_num1", s28);
                req.setAttribute("com2_num2", s31);
                req.setAttribute("com3_num3", s34);
                req.setAttribute("com4_num4", s37);
                req.setAttribute("comm_numb", s54);
                req.setAttribute("empNo", s8);
                req.setAttribute("command", s5);
                req.setAttribute("seqnr", s6);
                req.setAttribute("auth", s52);
                req.setAttribute("sect", s9);
                req.setAttribute("sect2", s10);
                req.setAttribute("begDa", s4);
                req.setAttribute("self_flag", s56);
                req.setAttribute("upbr_post", s58);
                req.setAttribute("exl1_pont", s60);
                req.setAttribute("exl2_pont", s62);
                req.setAttribute("spl1_pont", s64);
                req.setAttribute("spl2_pont", s66);
                req.setAttribute("upb1_crse", s68);
                req.setAttribute("upb2_crse", s70);
                req.setAttribute("cmt1_text", s72);
                req.setAttribute("cmt2_text", s74);
                req.setAttribute("cmt3_text", s76);
                req.setAttribute("cmt4_text", s78);
                req.setAttribute("cmt5_text", s80);
                req.setAttribute("cmt6_text", s82);
                req.setAttribute("etc1_text", s84);
                req.setAttribute("etc2_text", s86);
                req.setAttribute("fup1_text", s88);
                req.setAttribute("fup2_text", s90);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                Logger.debug.println(this, "B03DevelopSectInfo_vt : " + vector26.toString());
                Logger.debug.println(this, "B03DevelopChiefInfo_vt : " + vector8.toString());
                Logger.debug.println(this, "B03DevelopChiefInfo2_vt : " + vector14.toString());
                Logger.debug.println(this, "B03DevelopChiefInfo3_vt : " + vector19.toString());
                Logger.debug.println(this, "B03DevelopSectInfo_vt.size() : " + vector26.size());
                dest= WebUtil.JspURL + "B/B03DevelopChange.jsp";

            } else if(jobid.equals("change_save")) {
                B03DevelopBuildRFC b03developbuildrfc1 = new B03DevelopBuildRFC();
                B03DevelopBuildData b03developbuilddata1 = new B03DevelopBuildData();
                box.copyToEntity(b03developbuilddata1);
                Logger.debug.println(this, b03developbuilddata1.toString());
                String s48 = DataUtil.removeStructur(s4, ".");
                b03developbuilddata1.PERNR = s8;
                b03developbuilddata1.BEGDA = s48;
                b03developbuilddata1.ENDDA = s48;
                b03developbuilddata1.SEQNR = s6;
                b03developbuildrfc1.change(b03developbuilddata1, s8, s48, s6, "4");
                jobid = "change";
                String s93 = "msg008";
                String s96 = "location.href = '" + WebUtil.ServletURL + "hris.B.B03DevelopList2SV?jobid=" + jobid + "&empNo=" + s8 + "&begDa=" + s4 + "&seqnr=" + s6 + "&auth=" + s52 + "&command=" + s5 + "';";
                req.setAttribute("msg", s93);
                req.setAttribute("url", s96);
                dest= WebUtil.JspURL + "common/msg.jsp";

            } else if(jobid.equals("develop_creat")) {
                int i = box.getInt("real_count");
                int j = 1;
                String s41 = box.get("perno");
                String s50 = box.get("begda");
                s6 = box.get("seqnr");
                Logger.debug.println(this, " [perno]## = " + s41);
                Logger.debug.println(this, " [begda]## = " + s50);
                Logger.debug.println(this, " [seqnr]## = " + s6);
                B03DevelopBuildRFC b03developbuildrfc3 = new B03DevelopBuildRFC();
                Vector vector20 = new Vector();
                for(int i1 = 0; i1 < 10; i1++) {
                    B03DevelopData2 b03developdata2_1 = new B03DevelopData2();
                    String s100 = Integer.toString(i1);
                    b03developdata2_1.PERNR = s41;
                    b03developdata2_1.SEQNR = s6;
                    b03developdata2_1.BEGDA = s50;
                    b03developdata2_1.ITEM_INDX = Integer.toString(j);
                    b03developdata2_1.DEVP_TYPE = box.get("DEVP_TYPE" + s100);
                    b03developdata2_1.DEVP_YEAR = box.get("DEVP_YEAR" + s100);
                    b03developdata2_1.DEVP_MNTH = box.get("DEVP_MNTH" + s100);
                    b03developdata2_1.DEVP_TEXT = box.get("DEVP_TEXT" + s100);
                    b03developdata2_1.DEVP_STAT = box.get("DEVP_STAT" + s100);
                    b03developdata2_1.RMRK_TEXT = box.get("RMRK_TEXT" + s100);
                    if(b03developdata2_1.DEVP_TYPE != null && !b03developdata2_1.DEVP_YEAR.equals("")) {
                        vector20.addElement(b03developdata2_1);
                        j++;
                    }
                }

                b03developbuildrfc3.develop_build(vector20, "3");
                WebUserData webuserdata1 = new WebUserData();
                PersonInfoRFC phonenumrfc = new PersonInfoRFC();
                PersonData phonenumdata = new PersonData();
                phonenumdata = (PersonData)phonenumrfc.getPersonInfo(s41);
                webuserdata1.empNo = s41;
                webuserdata1.ename = phonenumdata.E_ENAME;
                Logger.debug.println(this, "user2 : " + webuserdata1.toString());
                String s101 = "\uC778\uC7AC\uAC1C\uBC1C \uD611\uC758\uACB0\uACFC \uC785\uB825";
                //if(webuserdata.companyCode.equals("N100"))
                //    MailMgr2.sendMail(webuserdata1, s41, s101);
                jobid = "first";
                String s102 = "msg008";
                String s105 = "location.href = '" + WebUtil.ServletURL + "hris.B.B03DevelopList2SV?jobid=" + jobid + "&empNo=" + s41 + "';";
                req.setAttribute("msg", s102);
                req.setAttribute("url", s105);
                dest= WebUtil.JspURL + "common/msg.jsp";

            } else if(jobid.equals("develop_change")) {
                B03DevelopList2RFC b03developlist2rfc7 = new B03DevelopList2RFC();
                Vector vector9 = b03developlist2rfc7.getDevelopList(s8, s4, s6, "3");
                req.setAttribute("empNo", s8);
                req.setAttribute("begDa", s4);
                req.setAttribute("seqnr", s6);
                req.setAttribute("item_index", "");
                req.setAttribute("B03DevelopDetail2_vt", vector9);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                Logger.debug.println(this, "B03DevelopDetail2_vt : " + vector9.toString());
                dest= WebUtil.JspURL + "B/B03DevelopCareer_change.jsp";

            } else if(jobid.equals("plus_career")) {
                B03DevelopList2RFC b03developlist2rfc8 = new B03DevelopList2RFC();
                Vector vector10 = b03developlist2rfc8.getDevelopList(s8, s4, s6, "3");
                B03DevelopData2 b03developdata2 = new B03DevelopData2();
                String s97 = Integer.toString(vector10.size());
                int j1 = Integer.parseInt(s97) + 1;
                String s99 = Integer.toString(j1);
                Logger.debug.println(this, "item_index : " + s99);
                b03developdata2.PERNR = s8;
                b03developdata2.SEQNR = s6;
                b03developdata2.BEGDA = s4;
                b03developdata2.ITEM_INDX = "";
                b03developdata2.DEVP_TYPE = "";
                b03developdata2.DEVP_YEAR = "";
                b03developdata2.DEVP_MNTH = "";
                b03developdata2.DEVP_TEXT = "";
                b03developdata2.DEVP_STAT = "";
                b03developdata2.RMRK_TEXT = "";
                vector10.addElement(b03developdata2);
                req.setAttribute("empNo", s8);
                req.setAttribute("begDa", s4);
                req.setAttribute("seqnr", s6);
                req.setAttribute("item_index", s99);
                req.setAttribute("B03DevelopDetail2_vt", vector10);
                req.setAttribute("ORGTX", ORGTX);
                req.setAttribute("TITEL", TITEL);
                req.setAttribute("TITL2", TITL2);
                req.setAttribute("ENAME", ENAME);                
                Logger.debug.println(this, "B03DevelopDetail2_vt : " + vector10.toString());
                dest= WebUtil.JspURL + "B/B03DevelopCareer_change.jsp";

            } else if(jobid.equals("career_save")) {
                String s42 = box.get("perno");
                String s51 = box.get("begda");
                String s7 = box.get("seqnr");
                String s91 = box.get("item_index");
                int k = 0;
                if(s91.equals(""))
                    k = 0;
                else
                    k = Integer.parseInt(s91);

                int l = 1;
                Logger.debug.println(this, " [perno]## = " + s42);
                Logger.debug.println(this, " [begda]## = " + s51);
                Logger.debug.println(this, " [seqnr]## = " + s7);
                B03DevelopList2RFC b03developlist2rfc10 = new B03DevelopList2RFC();
                Vector vector22 = b03developlist2rfc10.getDevelopList(s42, s51, s7, "3");
                B03DevelopBuildRFC b03developbuildrfc4 = new B03DevelopBuildRFC();
                Vector vector27 = new Vector();
                if(k > 0)  {
                    for(int k1 = 0; k1 < k; k1++) {
                        B03DevelopData2 b03developdata2_2 = new B03DevelopData2();
                        String s103 = Integer.toString(k1);
                        b03developdata2_2.PERNR = s42;
                        b03developdata2_2.SEQNR = s7;
                        b03developdata2_2.BEGDA = s51;
                        b03developdata2_2.ITEM_INDX = Integer.toString(l);
                        b03developdata2_2.DEVP_TYPE = box.get("DEVP_TYPE" + s103);
                        b03developdata2_2.DEVP_YEAR = box.get("DEVP_YEAR" + s103);
                        b03developdata2_2.DEVP_MNTH = box.get("DEVP_MNTH" + s103);
                        b03developdata2_2.DEVP_TEXT = box.get("DEVP_TEXT" + s103);
                        b03developdata2_2.DEVP_STAT = box.get("DEVP_STAT" + s103);
                        b03developdata2_2.RMRK_TEXT = box.get("RMRK_TEXT" + s103);
                        if(b03developdata2_2.DEVP_TYPE != null && !b03developdata2_2.DEVP_YEAR.equals("")) {
                            vector27.addElement(b03developdata2_2);
                            l++;
                        }
                    }

                } else {
                    for(int l1 = 0; l1 < vector22.size(); l1++) {
                        B03DevelopData2 b03developdata2_3 = new B03DevelopData2();
                        String s104 = Integer.toString(l1);
                        b03developdata2_3.PERNR = s42;
                        b03developdata2_3.SEQNR = s7;
                        b03developdata2_3.BEGDA = s51;
                        b03developdata2_3.ITEM_INDX = Integer.toString(l);
                        b03developdata2_3.DEVP_TYPE = box.get("DEVP_TYPE" + s104);
                        b03developdata2_3.DEVP_YEAR = box.get("DEVP_YEAR" + s104);
                        b03developdata2_3.DEVP_MNTH = box.get("DEVP_MNTH" + s104);
                        b03developdata2_3.DEVP_TEXT = box.get("DEVP_TEXT" + s104);
                        b03developdata2_3.DEVP_STAT = box.get("DEVP_STAT" + s104);
                        b03developdata2_3.RMRK_TEXT = box.get("RMRK_TEXT" + s104);
                        if(b03developdata2_3.DEVP_TYPE != null && !b03developdata2_3.DEVP_YEAR.equals("")) {
                            vector27.addElement(b03developdata2_3);
                            l++;
                        }
                    }

                }
                b03developbuildrfc4.develop_change(vector27, s42, s51, s7, "5");
                Logger.debug.println(this, "B03DevelopData_vt : " + vector27.toString());
                WebUserData webuserdata2 = new WebUserData();
                PersonInfoRFC phonenumrfc1 = new PersonInfoRFC();
                PersonData phonenumdata1 = new PersonData();
                phonenumdata1 = (PersonData)phonenumrfc1.getPersonInfo(s42);
                webuserdata2.empNo = s42;
                webuserdata2.ename = phonenumdata1.E_ENAME;
                Logger.debug.println(this, "user2 : " + webuserdata2.toString());
                String s106 = "\uC778\uC7AC\uAC1C\uBC1C \uD611\uC758\uACB0\uACFC \uC785\uB825";
                //if(webuserdata.companyCode.equals("N100"))
                //    MailMgr3.sendMail(webuserdata2, s42, s106);
                String s1 = "first";
                String s107 = "msg008";
                String s108 = "location.href = '" + WebUtil.ServletURL + "hris.B.B03DevelopList2SV?jobid=" + s1 + "&empNo=" + s42 + "';";
                req.setAttribute("msg", s107);
                req.setAttribute("url", s108);
                dest= WebUtil.JspURL + "common/msg.jsp";
            } else {
                throw new BusinessException("\uB0B4\uBD80\uBA85\uB839(jobid)\uC774 \uC62C\uBC14\uB974\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.");
            }
            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " +dest);
            Logger.debug.println(this, " res = " + res);

        } catch(Exception exception) {
            throw new GeneralException(exception);
        }
    }
}
