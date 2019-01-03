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
import hris.J.J03JobCreate.J03ObjectCreData;
import hris.J.J03JobCreate.rfc.*;

/**
 * J01CompetencyReqSV.java
 * Competency Requirements �󼼳��� ���� ��ȸ�Ѵ�. 
 *
 * @author  �赵��
 * @version 1.0, 2003/02/13 
 */
public class J03CompetencyReqBuildSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            Box                 box            = WebUtil.getBox(req);
            
            
            J03RequireLevelRFC  rfc                = new J03RequireLevelRFC();
            Vector              ret                = rfc.getDetail();
            Vector              J03RequireLevel_vt = (Vector)ret.get(0);
            Vector              J03QK_vt           = (Vector)ret.get(1);            
            Vector              J03Q_vt           = new Vector();
            Vector              J03D_vt           = new Vector();            
            
            String              i_jobid        = "";
            String              i_objid        = "";
            String              i_sobid        = "";
            String              i_pernr        = "";
            String              i_idx          = "";
            String              dest           = "";                            
            int                 i_comm_size    = 0;
            int                 i_spec_size    = 0;   
                                                      
            i_jobid    = box.get("jobid");                                  
            i_objid    = box.get("OBJID");
            i_sobid    = box.get("SOBID");
            i_pernr    = box.get("PERNR");   
            i_idx      = box.get("IMGIDX");
            String            i_begda        = box.get("BEGDA");            
            String            i_link_chk     = box.get("i_link_chk");                       
            String            i_Create       = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�            
            i_comm_size= box.getInt("comm_size");   
            i_spec_size= box.getInt("spec_size");   
                        
            
            if( i_jobid.equals("") ){
                i_jobid = "first";
                i_comm_size    = 4;
                i_spec_size    = 4;
            }
            
            if( i_jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.                  
                                                      //add line ��������� ó�� 
                if ( i_comm_size  > 4  || i_spec_size > 4 ){
                  
                   for ( int i = 0; i < i_comm_size + i_spec_size ; i++ ){
                       J01CompetencyReqData ReqData_h         = new J01CompetencyReqData();

                       ReqData_h.OBJID_G       = box.get("QKID" + i );
                       ReqData_h.STEXT         = box.get("STEXT" + i );
                       ReqData_h.SOBID         = box.get("SOBID" + i );
                       
                       if ( !ReqData_h.SOBID.equals("")) {
                          ReqData_h.STEXT_Q    = box.get("STEXT_Q" + i ); 
                          ReqData_h.SUBTY      = box.get("SELECTED" + i );
                                                    
                          J03Q_vt.addElement(ReqData_h); 
                          
                          for ( int j=0; j < J03RequireLevel_vt.size(); j++){
                             J01CompetencyReqData ReqData_d         = new J01CompetencyReqData();
                             ReqData_d.SOBID     = box.get("SOBID" + i );                            
                             ReqData_d.ZLEVEL    = box.get("ZLEVEL_S" + i + j);
                             ReqData_d.STEXT_KEY = box.get("STEXT_KEY_S" + i + j);                             
                             ReqData_d.TLINE     = box.get("TLINE_S" + i + j);
                             
                             J03D_vt.addElement(ReqData_d);
                          }
                      }
                  }
                }  
                req.setAttribute("jobid",          i_jobid);                                       
                req.setAttribute("i_objid",        i_objid);
                req.setAttribute("i_sobid",        i_sobid);
                req.setAttribute("i_pernr",        i_pernr); 
                req.setAttribute("i_imgidx",       i_idx);
                req.setAttribute("i_begda",        i_begda);
                req.setAttribute("i_link_chk", i_link_chk);
                req.setAttribute("i_Create",   i_Create);
                req.setAttribute("comm_size",      Integer.toString(i_comm_size));
                req.setAttribute("spec_size",      Integer.toString(i_spec_size));
                req.setAttribute("J03Q_vt",           J03Q_vt);
                req.setAttribute("J03D_vt",           J03D_vt);                
                req.setAttribute("J03RequireLevel_vt",  J03RequireLevel_vt);
                req.setAttribute("J03QK_vt",  J03QK_vt);                
                dest = WebUtil.JspURL+"J/J03JobCreate/J03CompetencyReqBuild.jsp";                
                
            } else if( i_jobid.equals("create") ) {   //requirement �������
              
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();
                J03ObjectCreData   j03HRP1001    = null;
                Vector             j03HRP1001_vt = new Vector();                //���� ����(HRP1001)                                              
//              ���� rfc ���ϰ�
                Vector ret_r         = new Vector();
                Vector j03Message_vt = new Vector();
                String E_SUBRC       = "";

//              ���� ����(HRP1001) -  ��з�(15)

                for ( int i = 0; i < i_comm_size + i_spec_size ; i++ ){
                    int    chara      = 0;                  
                    j03HRP1001       = new J03ObjectCreData();                  

                    j03HRP1001.SOBID  = box.get("SOBID" + i ); // ���ÿ�����Ʈ ID
                    
                    if ( !j03HRP1001.SOBID.equals("") ) {
                        j03HRP1001.OTYPE  = "T";                   // ������Ʈ����
                        j03HRP1001.OBJID  = i_sobid;               // ������Ʈ ID
                        j03HRP1001.BEGDA  = i_begda;               // ������
                        j03HRP1001.ENDDA  = "99991231";            // ������
                        j03HRP1001.RSIGN  = "A";                   // ������(A, B)
                        j03HRP1001.RELAT  = "031";                 // ������Ʈ���� ����
                        j03HRP1001.SUBTY  = "A031";                // SUBTY                        
                        j03HRP1001.SCLAS  = "Q";                   // ���õ� ������Ʈ����
                        j03HRP1001.PRIOX  = "1";                   // �켱����      

                        chara             = box.getInt("SELECTED" + i );
                        chara = chara + 1;

                        j03HRP1001.CHARA  = Integer.toString(chara);     //�䱸����
                        j03HRP1001_vt.addElement(j03HRP1001);
                     }   
                }

                ret_r         = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                j03Message_vt = (Vector)ret_r.get(0);                          //�۾� ��� �޽���
                E_SUBRC       = (String)ret_r.get(1);                          //�۾� ��� FLAG
//              error�� ó���ϱ� ���ؼ� �Է°��� ȭ������ �ٽ� �����ش�.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 || i_sobid.equals("") || i_sobid.equals("00000000") ) {
                  
                   for ( int i = 0; i < i_comm_size + i_spec_size ; i++ ){
                       J01CompetencyReqData ReqData_h         = new J01CompetencyReqData();

                       ReqData_h.OBJID_G       = box.get("QKID" + i );
                       ReqData_h.STEXT         = box.get("STEXT" + i );
                       ReqData_h.SOBID         = box.get("SOBID" + i );
                       ReqData_h.STEXT_Q       = box.get("STEXT_Q" + i ); 
                       
                       
                          ReqData_h.SUBTY      = box.get("SELECTED" + i );
                                                    
                          J03Q_vt.addElement(ReqData_h); 
                          
                          for ( int j=0; j < J03RequireLevel_vt.size(); j++){
                             J01CompetencyReqData ReqData_d         = new J01CompetencyReqData();
                             ReqData_d.SOBID     = box.get("SOBID" + i );                            
                             ReqData_d.ZLEVEL    = box.get("ZLEVEL_S" + i + j);
                             ReqData_d.STEXT_KEY = box.get("STEXT_KEY_S" + i + j);                             
                             ReqData_d.TLINE     = box.get("TLINE_S" + i + j);
                             
                             J03D_vt.addElement(ReqData_d);
                          }
                      }
                      req.setAttribute("jobid",          i_jobid);                                       
                      req.setAttribute("i_objid",        i_objid);
                      req.setAttribute("i_sobid",        i_sobid);
                      req.setAttribute("i_pernr",        i_pernr); 
                      req.setAttribute("i_imgidx",       i_idx);
                      req.setAttribute("i_begda",        i_begda);
                      req.setAttribute("i_link_chk",     i_link_chk);   
                      req.setAttribute("i_Create",   i_Create);                                         
                      req.setAttribute("comm_size",      Integer.toString(i_comm_size));
                      req.setAttribute("spec_size",      Integer.toString(i_spec_size));
                      req.setAttribute("J03Q_vt",           J03Q_vt);
                      req.setAttribute("J03D_vt",           J03D_vt);
                      req.setAttribute("J03RequireLevel_vt",  J03RequireLevel_vt);
                      req.setAttribute("J03QK_vt",  J03QK_vt);
//                      error �߻� ����                                    
                      req.setAttribute("i_error",         "Y");          
                      req.setAttribute("j03Message_vt",   j03Message_vt);
                      
                      dest = WebUtil.JspURL+"J/J03JobCreate/J03CompetencyReqBuild.jsp";
                  } else {
                    String msg = "msg013";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.J.J03JobCreate.J03FileUpDownLoadBuildSV?OBJID="+i_objid+"&SOBID="+i_sobid+"&BEGDA="+i_begda+"&i_link_chk="+i_link_chk+"&IMGIDX=3';";
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
