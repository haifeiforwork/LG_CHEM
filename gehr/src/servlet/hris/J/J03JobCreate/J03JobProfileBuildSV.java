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
 * Job Profile�� �����Ѵ�. << Job ���� >>
 *
 * @author  �赵��
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
            String            i_pernr        = box.get("PERNR");            // �����ȣ
            String            i_idx          = box.get("IMGIDX");
            String            i_link_chk     = box.get("i_link_chk");           
            String            i_begda        = box.get("BEGDA");
            String            i_Create       = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�
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

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
                req.setAttribute("i_sobid",    i_sobid);

                dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileBuild.jsp";

            } else if( jobid.equals("create") ) {   //����
                J03CUDObjectsRFC   rfc_1000      = new J03CUDObjectsRFC();
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();
                J03CUDContentsRFC  rfc_1002      = new J03CUDContentsRFC();
                J03CUDLevelingRFC  rfc_9618      = new J03CUDLevelingRFC();

                J03ObjectCreData   j03HRP1000    = null;
                J03ObjectCreData   j03HRP1001    = null;
                J03ObjectCreData   j03HRP1002    = null;
                J03ContentsCreData j03HRT1002    = null;
                J03ObjectCreData   j03HRP9618    = null;

                Vector             j03HRP1000_vt = new Vector();                //������Ʈ ����(HRP1000)
                Vector             j03HRP1001_vt = new Vector();                //���� ����(HRP1001)
                Vector             j03HRP1002_vt = new Vector();                //���� ����(HRP1002)
                Vector             j03HRT1002_vt = new Vector();                //���� �� �Է»��� ����(HRT1002)
                Vector             j03HRP9618_vt = new Vector();                //Job Leveling Sheet ����(HRP9618)
                Vector             j01Holder_vt  = new Vector();

//              ���� rfc ���ϰ�
                Vector             ret           = new Vector();
                Vector             j03Message_vt = new Vector();
                String             E_SUBRC       = "";

                int                count         = box.getInt("count");         //Job Holder count
                int                count_L       = box.getInt("count_L");       //Job Leveling Sheet count
                int                count_D       = box.getInt("count_D");       //���� count

//              ������Ʈ ����(HRP1000)
                j03HRP1000       = new J03ObjectCreData();
                j03HRP1000.OTYPE = "T";
                if( i_sobid.equals("") || i_sobid.equals("00000000") ) {
                    j03HRP1000.OBJID = "00000000";                              //default "00000000" - ������
                } else {
                    j03HRP1000.OBJID = i_sobid;                                 //������ Job ID
                }

                j03HRP1000.BEGDA = i_begda;                                     //��������
                j03HRP1000.ENDDA = "99991231";                                  //default "99991231" - ������
                j03HRP1000.SHORT = box.get("SHORT");                            //char 12
                j03HRP1000.STEXT = box.get("STEXT");                            //char 40

                j03HRP1000_vt.addElement(j03HRP1000);
Logger.debug.println(this, "### [HRP1000] : " + j03HRP1000_vt);

                ret           = rfc_1000.Create( user.empNo, j03HRP1000_vt );
                j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
                E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG
                i_sobid       = (String)ret.get(2);                          //������ ������Ʈ ID

Logger.debug.println(this, "### [j03HRP1000]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1000]j03Message_vt : " + j03Message_vt);

//              ���� �� �Է»��� ����(HRT1002)
                for( int i = 0 ; i < count_D ; i++ ) {
                    String            idx         = Integer.toString(i);

                    j03HRT1002       = new J03ContentsCreData();
                    j03HRT1002.SUBTY = box.get("SUBTY_D"+idx);                  //���� ����
                    j03HRT1002.SEQNO = box.get("SEQNO_D"+idx);                  //����
                    j03HRT1002.TLINE = box.get("TLINE_D"+idx);                  //������

                    j03HRT1002_vt.addElement(j03HRT1002);
                }
//              Job Leveling Sheet ����(HRP9618)
                for( int i = 0 ; i < count_L ; i++ ) {
                    String            idx         = Integer.toString(i);

                    j03HRP9618            = new J03ObjectCreData();
                    j03HRP9618.SUBTY      = box.get("SUBTY_L"+idx);
                    j03HRP9618.LEVEL_CODE = box.get("LCODE_L"+idx);

                    j03HRP9618_vt.addElement(j03HRP9618);
                }

//              ������Ʈ ������ ������ ���
                if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 && !i_sobid.equals("") && !i_sobid.equals("00000000") ) {
//                  ���� ����(HRP1001) -  J-Project(T)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.SUBTY = "A007";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "007";
                    j03HRP1001.SCLAS = "T";
                    j03HRP1001.SOBID = "";                      //R3���� J-Project ������ �ش��ϴ� ID�� �־��ش�.
    
                    j03HRP1001_vt.addElement(j03HRP1001);
//                  ���� ����(HRP1001) -  ��з�(15)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.SUBTY = "AZ12";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "Z12";
                    j03HRP1001.SCLAS = "15";
                    j03HRP1001.SOBID = box.get("SOBID_D");

                    j03HRP1001_vt.addElement(j03HRP1001);
//                  ���� ����(HRP1001) -  ������(Job Holder)(S)
                    for( int i = 0 ; i < count ; i++ ) {                            
                        String            idx         = Integer.toString(i);

                        j03HRP1001       = new J03ObjectCreData();
                        j03HRP1001.BEGDA = box.get("BEGDA_S"+idx);                  //Job ������
                        j03HRP1001.SUBTY = "A007";
                        j03HRP1001.RSIGN = "A";
                        j03HRP1001.RELAT = "007";
                        j03HRP1001.SCLAS = "S";
                        j03HRP1001.SOBID = box.get("SOBID_S"+idx);

                        j03HRP1001_vt.addElement(j03HRP1001);
                    }
//                  ���� ����(HRP1001) -  Leveling ���(12)
                    j03HRP1001       = new J03ObjectCreData();
                    j03HRP1001.SUBTY = "AZ20";
                    j03HRP1001.RSIGN = "A";
                    j03HRP1001.RELAT = "Z20";
                    j03HRP1001.SCLAS = "12";
                    j03HRP1001.SOBID = box.get("SOBID_L");
    
                    j03HRP1001_vt.addElement(j03HRP1001);
//                  ������ ���� �����Ϳ� ���� �����͸� ä���ش�.
                    for( int i = 0 ; i < j03HRP1001_vt.size() ; i++ ) {
                        J03ObjectCreData data = (J03ObjectCreData)j03HRP1001_vt.get(i);

                        data.OTYPE = "T";
                        data.OBJID = i_sobid;                                     //default "00000000" - ������
//                      �������� �ƴ� ��� �������ڸ� �����Ͽ� �ݿ��Ѵ�.
                        if( !(data.RSIGN.equals("A") && data.RELAT.equals("007") && data.SCLAS.equals("S")) ) {
                            data.BEGDA = i_begda;                                 //��������
                        }
                        data.ENDDA = "99991231";                                  //default "99991231" - ������
                    }
Logger.debug.println(this, "### [HRP1001] : " + j03HRP1001_vt);
    
                    ret           = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                    j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
                    E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG

Logger.debug.println(this, "### [j03HRP1001]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1001]j03Message_vt : " + j03Message_vt);

                    if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
//                      ���� ����(HRP1002)
                        String old_SUBTY = "";
                        for( int i = 0 ; i < j03HRT1002_vt.size() ; i++ ) {
                            J03ContentsCreData data = (J03ContentsCreData)j03HRT1002_vt.get(i);

//                          ���� �� �Է»��� ����(HRT1002)
                            data.OBJID = i_sobid;
                            if( !old_SUBTY.equals(data.SUBTY) ) {
                                j03HRP1002       = new J03ObjectCreData();
                                j03HRP1002.OTYPE = "T";
                                j03HRP1002.OBJID = data.OBJID;                              //default "00000000" - ������
                                j03HRP1002.BEGDA = i_begda;                                 //��������
                                j03HRP1002.ENDDA = "99991231";                              //default "99991231" - ������
                                j03HRP1002.SUBTY = data.SUBTY;
        
                                j03HRP1002_vt.addElement(j03HRP1002);
    
                                old_SUBTY = data.SUBTY;
                            }
                        }
Logger.debug.println(this, "### [HRP1002] : " + j03HRP1002_vt);
Logger.debug.println(this, "### [HRT1002] : " + j03HRT1002_vt);

                        ret           = rfc_1002.Create( user.empNo, j03HRP1002_vt, j03HRT1002_vt );
                        j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
                        E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG

Logger.debug.println(this, "### [j03HRP1002]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP1002]j03Message_vt : " + j03Message_vt);

                        if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
//                          Job Leveling Sheet ����(HRP9618)
                            for( int i = 0 ; i < j03HRP9618_vt.size() ; i++ ) {
                                J03ObjectCreData data = (J03ObjectCreData)j03HRP9618_vt.get(i);
    
                                data.OTYPE      = "T";
                                data.OBJID      = i_sobid;                                 //default "00000000" - ������
                                data.BEGDA      = i_begda;                                 //��������
                                data.ENDDA      = "99991231";                              //default "99991231" - ������
                            }
Logger.debug.println(this, "### [HRP9618] : " + j03HRP9618_vt);

                            ret           = rfc_9618.Create( user.empNo, j03HRP9618_vt );
                            j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
                            E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG
                        }   //9618����
                    }       //1002����
                }           //1001����

Logger.debug.println(this, "### [j03HRP9618]E_SUBRC : " + E_SUBRC + " ### i_sobid : " + i_sobid);
Logger.debug.println(this, "### [j03HRP9618]j03Message_vt : " + j03Message_vt);
//              error�� ó���ϱ� ���ؼ� �Է°��� ȭ������ �ٽ� �����ش�.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 || i_sobid.equals("") || i_sobid.equals("00000000") ) {
                    req.setAttribute("STEXT",           box.get("STEXT"));          //������Ʈ ��
                    req.setAttribute("SOBID_D",         box.get("SOBID_D"));        //��з� ID
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
                    req.setAttribute("i_sobid",         i_sobid);                   //������ �� Job ID�� �����ش�.
                    req.setAttribute("j01Holder_vt",    j01Holder_vt);              //Job Holder
                    req.setAttribute("SOBID_L",         box.get("SOBID_L"));        //Leveling ���
                    req.setAttribute("j03HRT1002_vt",   j03HRT1002_vt);             //������
                    req.setAttribute("j03HRP9618_vt",   j03HRP9618_vt);             //Job Leveling
//                  error �߻� ����
                    req.setAttribute("i_error",         "Y");
                    req.setAttribute("j03Message_vt",   j03Message_vt);

                    dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileBuild.jsp";
//              ���� ������ ��� Competency Requirments�� �����ϱ����ؼ� ȭ���� �̵��Ѵ�.
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
