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
 * J03LevelingSheetChangeSV.java
 * Job Leveling Sheet�� ��ȸ�Ѵ�. 
 *
 * @author  �赵��
 * @version 1.0, 2003/06/23
 */
public class J03LevelingSheetChangeSV extends EHRBaseServlet {
    
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
            String              E_LEVEL         = "";
            Vector              j01LevelList_vt = new Vector();
                                                
            String              jobid           = box.get("jobid");
            String              i_objid         = box.get("OBJID");                // Objective ID
            String              i_sobid         = box.get("SOBID");                // Job ID
            String              i_pernr         = box.get("PERNR");                // �����ȣ
            String              i_link_chk      = box.get("i_link_chk");           // link ���� 
            String              i_idx           = box.get("IMGIDX");               // �޴� Index
            String              i_begda         = box.get("BEGDA");
						String              i_Create        = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�
//          Leveling �������� �̵��� �� �������� check�ϱ����ؼ� �ʿ�
            String              backFromJSP     = box.get("backFromJSP");
            String              dest            = "";

            if( jobid.equals("") ){
                jobid = "first";
            }

//          Objective ID, Job ID
            req.setAttribute("i_objid",     i_objid);
            req.setAttribute("i_sobid",     i_sobid);
            req.setAttribute("i_pernr",     i_pernr);
            req.setAttribute("i_link_chk",  i_link_chk);                        
            req.setAttribute("i_imgidx",    i_idx);
            req.setAttribute("i_begda",     i_begda);
						req.setAttribute("i_Create",    i_Create);
            req.setAttribute("backFromJSP", backFromJSP);

            if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
//              Leveling Sheet ��ȸ
                ret            = rfc.getDetail( i_objid, i_sobid, "99991231" );

                j01Result_vt   = (Vector)ret.get(0);        // ��з�, �򰡿��, Level
                j01Result_D_vt = (Vector)ret.get(1);        // �����򰡿�� ����
                j01Result_L_vt = (Vector)ret.get(2);        // Leveling ��� List
                E_LEVEL        = (String)ret.get(3);        // Job Leveling ���
//              Leveling ��� ��������
                j01LevelList_vt = rfc_List.getDetail( "99991231" );

//              Job Leveling Sheet
                req.setAttribute("j01Result_vt",    j01Result_vt);
                req.setAttribute("j01Result_D_vt",  j01Result_D_vt);
                req.setAttribute("j01Result_L_vt",  j01Result_L_vt);
//              Job Leveling ���                   
                req.setAttribute("E_LEVEL",         E_LEVEL);
//              Job Leveling ��� ��������
                req.setAttribute("j01LevelList_vt", j01LevelList_vt);

                dest = WebUtil.JspURL+"J/J03JobCreate/J03LevelingSheetChange.jsp";

            } else if( jobid.equals("change") ) {   //���� ����
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();
                J03CUDLevelingRFC  rfc_9618      = new J03CUDLevelingRFC();

                J03ObjectCreData   j03HRP1001    = null;
                J03ObjectCreData   j03HRP9618    = null;

                Vector             j03HRP1001_vt = new Vector();                //���� ����(HRP1001)
                Vector             j03HRP9618_vt = new Vector();                //Job Leveling Sheet ����(HRP9618)

//              ���� rfc ���ϰ�
                Vector             ret_R         = new Vector();
                Vector             j03Message_vt = new Vector();
                String             E_SUBRC       = "";

                int                count_L       = box.getInt("count_L");       //Job Leveling Sheet count

//              ���� ����(HRP1001) -  Leveling ���(12)
                j03HRP1001       = new J03ObjectCreData();
                j03HRP1001.OTYPE = "T";
                j03HRP1001.OBJID = i_sobid;                                     //default "00000000" - ������
                j03HRP1001.BEGDA = i_begda;                                     //Leveling ��������
                j03HRP1001.ENDDA = "99991231";                                  //default "99991231" - ������
                j03HRP1001.SUBTY = "AZ20";
                j03HRP1001.RSIGN = "A";
                j03HRP1001.RELAT = "Z20";
                j03HRP1001.SCLAS = "12";
                j03HRP1001.SOBID = box.get("SOBID_L");
    
                j03HRP1001_vt.addElement(j03HRP1001);

                Logger.debug.println(this, "HRP1001 : " + j03HRP1001_vt);
    
                ret           = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
                E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG

//              Job Leveling Sheet ����(HRP9618)
                for( int i = 0 ; i < count_L ; i++ ) {
                    String            idx         = Integer.toString(i);
                    
                    j03HRP9618      = new J03ObjectCreData();
                    j03HRP9618.OTYPE      = "T";
                    j03HRP9618.OBJID      = i_sobid;                                 //������ Job ID
                    j03HRP9618.BEGDA      = i_begda;                                 //Leveling ��������
                    j03HRP9618.ENDDA      = "99991231";                              //default "99991231" - ������
                    j03HRP9618.SUBTY      = box.get("SUBTY"+idx);
                    j03HRP9618.LEVEL_CODE = box.get("LEVEL_CODE"+idx);
                    
                    j03HRP9618_vt.addElement(j03HRP9618);
                }
                Logger.debug.println(this, "HRP9618 : " + j03HRP9618_vt);

                if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
                    ret_R         = rfc_9618.Create( user.empNo, j03HRP9618_vt );
                    j03Message_vt = (Vector)ret_R.get(0);                          //�۾� ��� �޽���
                    E_SUBRC       = (String)ret_R.get(1);                          //�۾� ��� FLAG
                }
Logger.debug.println(this, "### E_SUBRC : " + E_SUBRC);
Logger.debug.println(this, "### j03Message_vt : " + j03Message_vt);
//              error�� ó���ϱ� ���ؼ� �Է°��� ȭ������ �ٽ� �����ش�.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 ) {
//                  Leveling Sheet ��ȸ
                    ret            = rfc.getDetail( i_objid, i_sobid, "99991231" );

                    j01Result_vt   = (Vector)ret.get(0);        // ��з�, �򰡿��, Level
                    j01Result_D_vt = (Vector)ret.get(1);        // �����򰡿�� ����
                    j01Result_L_vt = (Vector)ret.get(2);        // Leveling ��� List
                    E_LEVEL        = (String)ret.get(3);        // Job Leveling ���
//                  Leveling ��� ��������
                    j01LevelList_vt = rfc_List.getDetail( "99991231" );

//                  ����� ���� �־ �ٽ� ����ȭ������ ���ư���.
                    for( int i = 0 ; i < j01Result_vt.size() ; i++ ) {
                        J01LevelingSheetData data_L = (J01LevelingSheetData)j01Result_vt.get(i);
                        String SUBTY_L = data_L.DSORT_CODE + data_L.ELEME_CODE;
                        for( int j = 0 ; j < j03HRP9618_vt.size() ; j++ ) {
                            J03ObjectCreData data = (J03ObjectCreData)j03HRP9618_vt.get(j);
                            if( SUBTY_L.equals(data.SUBTY) ) {
                                data_L.LEVEL_CODE0 = data.LEVEL_CODE;
                                break;
                            }
                        }
                    }

//                  Job Leveling Sheet
                    req.setAttribute("j01Result_vt",    j01Result_vt);
                    req.setAttribute("j01Result_D_vt",  j01Result_D_vt);
                    req.setAttribute("j01Result_L_vt",  j01Result_L_vt);
//                  Job Leveling ���                   
                    req.setAttribute("E_LEVEL",         E_LEVEL);
//                  Job Leveling ��� ��������
                    req.setAttribute("j01LevelList_vt", j01LevelList_vt);
                    req.setAttribute("SOBID_L",         box.get("SOBID_L"));        //Leveling ���
                    req.setAttribute("j01Result_D_vt",  j01Result_D_vt);            //Job Leveling
//                  error �߻� ����
                    req.setAttribute("i_error",         "Y");
                    req.setAttribute("j03Message_vt",   j03Message_vt);

                    dest = WebUtil.JspURL+"J/J03JobCreate/J03LevelingSheetChange.jsp";
//              ���� ������ ��� Competency Requirments�� �����ϱ����ؼ� ȭ���� �̵��Ѵ�.
                } else {
                    String msg = "msg002";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.J.J03JobCreate.J03LevelingSheetDetailSV?OBJID="+i_objid+"&SOBID="+i_sobid+"&BEGDA="+i_begda+"&IMGIDX=5&backFromJSP="+backFromJSP+"';";
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
