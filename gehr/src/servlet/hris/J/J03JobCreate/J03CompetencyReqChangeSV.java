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
import hris.J.J03JobCreate.J03QKData;
import hris.J.J03JobCreate.J03RequireLevelData;
import hris.J.J03JobCreate.rfc.*;


/**
 * J01CompetencyReqSV.java
 * Competency Requirements 상세내역 등을 조회한다. 
 *
 * @author  김도신
 * @version 1.0, 2003/02/13 
 */
public class J03CompetencyReqChangeSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession         session        = req.getSession(false);
            WebUserData         user           = (WebUserData)session.getAttribute("user");
            
            Box                 box            = WebUtil.getBox(req);

            J01CompetencyReqRFC rfc            = new J01CompetencyReqRFC();

            Vector              ret            = new Vector();
            Vector              j01Result_Q_vt = new Vector();
            Vector              j01Result_D_vt = new Vector();
            
            J03RequireLevelRFC  rfc_l              = new J03RequireLevelRFC();
            Vector              ret_l              = rfc_l.getDetail();
            Vector              J03RequireLevel_vt = (Vector)ret_l.get(0);
            Vector              J03QK_vt           = (Vector)ret_l.get(1); 
            
            J03QKData data_QK_t0       = (J03QKData)J03QK_vt.get(0);            
            J03QKData data_QK_t1       = (J03QKData)J03QK_vt.get(1);                
            String    comm_objid       = data_QK_t0.OBJID;
            String    spec_objid       = data_QK_t1.OBJID;   
            
            Vector              J03Q_vt           = new Vector();
            Vector              J03D_vt           = new Vector();  

            String              i_objid        = "";
            String              i_sobid        = "";
            String              i_pernr        = "";
            String              i_link_chk     = "";           
            String              i_idx          = "";
            String              i_begda        = "";
            String              dest           = "";
            int                 i_comm_size    = 0;
            int                 i_spec_size    = 0;   
            String              i_jobid        = box.get("jobid");
            String              i_Create       = box.get("i_Create");         //생성화면인지 조회,수정화면인지 menu에서 구분하기 위해서            

            i_objid    = box.get("OBJID");
            i_sobid    = box.get("SOBID");
            i_pernr    = box.get("PERNR");   
            i_link_chk = box.get("i_link_chk");                     
            i_idx      = box.get("IMGIDX");
//          적용일자(조회기준일) 추가
            i_begda    = box.get("BEGDA");
            i_comm_size= box.getInt("comm_size");   
            i_spec_size= box.getInt("spec_size");   
            
            
// 최초 로드시에는 rfc 통해서 데이터 가져온다. 
            if( i_jobid.equals("") ){
                i_jobid = "first";
                i_comm_size    = 0;
                i_spec_size    = 0;
                
                ret            = rfc.getDetail( i_objid, i_sobid, "99991231" );
                j01Result_Q_vt = (Vector)ret.get(0);
                
                for ( int i = 0; i < j01Result_Q_vt.size(); i++ ){
                   J01CompetencyReqData   ReqData_h  = new J01CompetencyReqData();
                   ReqData_h = (J01CompetencyReqData)j01Result_Q_vt.get(i);
                   
                  if ( ReqData_h.OBJID_G.equals(comm_objid)) {
                    i_comm_size++;
                  } else if  ( ReqData_h.OBJID_G.equals(spec_objid)) {
                    i_spec_size++;
                  }
                   
                   int  selected = 0;
                   for ( int j = 0 ; j < J03RequireLevel_vt.size(); j++){
                      J03RequireLevelData  data_L = (J03RequireLevelData)J03RequireLevel_vt.get(j);
                      if ( data_L.PSTEXT.equals(ReqData_h.ZLEVEL) ) {
                          selected = j;
                      }
                   }   
                   ReqData_h.SUBTY = Integer.toString(selected);
                   J03Q_vt.addElement(ReqData_h); 
                   
                   J01CompetencyDetailRFC rfc_d          = new J01CompetencyDetailRFC();
                   Vector                 j02Result_vt   = new Vector();
                   Vector                 j02Result_D_vt = new Vector();
                   Vector ret_d            = rfc_d.getDetail(ReqData_h.SOBID, DataUtil.getCurrentDate() );

                   j02Result_vt   = (Vector)ret_d.get(0);
                   j02Result_D_vt = (Vector)ret_d.get(1);
                   
                   StringBuffer subtype1 = new StringBuffer();
                   StringBuffer subtype2 = new StringBuffer();
                   StringBuffer subtype3 = new StringBuffer();
                   StringBuffer subtype4 = new StringBuffer();
                  
                   for( int j = 0 ; j < j02Result_D_vt.size() ; j++ ) {
                       J01CompetencyDetailData data_D = (J01CompetencyDetailData)j02Result_D_vt.get(j);    
                       if( data_D.SUBTY.equals("0001") ) {
                           subtype1.append(data_D.TLINE+"<br>");
                       } else if( data_D.SUBTY.equals("0002") ) {
                           subtype2.append(data_D.TLINE+"<br>");
                       } else if( data_D.SUBTY.equals("0003") ) {
                           subtype3.append(data_D.TLINE+"<br>");
                       } else if( data_D.SUBTY.equals("0004") ) {
                           subtype4.append(data_D.TLINE+"<br>");
                       } 
                   } 
                   
                   for ( int j=0; j < J03RequireLevel_vt.size(); j++){ 
                     J01CompetencyDetailData data = (J01CompetencyDetailData)j02Result_vt.get(j); 
                     J01CompetencyReqData ReqData_d         = new J01CompetencyReqData();
                     
                     ReqData_d.SOBID     = ReqData_h.SOBID;                            
                     ReqData_d.ZLEVEL    = data.ZLEVEL;
                     ReqData_d.STEXT_KEY = data.STEXT_KEY;
                     if ( j == 0 ) {
                       ReqData_d.TLINE     = subtype1.toString();
                     }else if ( j == 1 ) {
                       ReqData_d.TLINE     = subtype2.toString();
                     }else if ( j == 2 ) {
                       ReqData_d.TLINE     = subtype3.toString();                        
                     }else if ( j == 3 ) {
                       ReqData_d.TLINE     = subtype4.toString();                        
                     }
                    Logger.debug.println(this, "치치치치치치치치" + ReqData_d);                                        
                     J03D_vt.addElement(ReqData_d);
                  }
                }
                
                if ( i_comm_size < 4 ){
                   i_comm_size = 4; }
                if ( i_spec_size < 4) {
                   i_spec_size = 4; }
                
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
                    Logger.debug.println(this, "@@@@@@@@@@@@" + J03Q_vt);                                                                                       
                req.setAttribute("J03D_vt",           J03D_vt); 
                    Logger.debug.println(this, "############" + J03D_vt);                                                                       
                req.setAttribute("J03RequireLevel_vt",  J03RequireLevel_vt);
                req.setAttribute("J03QK_vt",  J03QK_vt);                
                dest = WebUtil.JspURL+"J/J03JobCreate/J03CompetencyReqChange.jsp";
             } else if( i_jobid.equals("first") ) {   //add line 누른경우의 처리         
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
                dest = WebUtil.JspURL+"J/J03JobCreate/J03CompetencyReqChange.jsp";                
                
            } else if( i_jobid.equals("create") ) {   //requirement 관계생성
              
                J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();
                J03ObjectCreData   j03HRP1001    = null;
                Vector             j03HRP1001_vt = new Vector();                //관계 생성(HRP1001)                                              
//              생성 rfc 리턴값
                Vector ret_r         = new Vector();
                Vector j03Message_vt = new Vector();
                String E_SUBRC       = "";

//              관계 생성(HRP1001) -  대분류(15)
                for ( int i = 0; i < i_comm_size + i_spec_size ; i++ ){
                    int    chara      = 0;                  
                    j03HRP1001       = new J03ObjectCreData();                  

                    j03HRP1001.SOBID  = box.get("SOBID" + i ); // 관련오브젝트 ID
                    
                    if ( !j03HRP1001.SOBID.equals("") ) {
                        j03HRP1001.OTYPE  = "T";                   // 오브젝트유형
                        j03HRP1001.OBJID  = i_sobid;               // 오브젝트 ID
                        j03HRP1001.BEGDA  = i_begda;               // 시작일
                        j03HRP1001.ENDDA  = "99991231";            // 종료일
                        j03HRP1001.RSIGN  = "A";                   // 관계사양(A, B)
                        j03HRP1001.RELAT  = "031";                 // 오브젝트간의 관계
                        j03HRP1001.SUBTY  = "A031";                // SUBTY
                        j03HRP1001.SCLAS  = "Q";                   // 관련된 오브젝트유형
                        j03HRP1001.PRIOX  = "1";                   // 우선순위      

                        chara             = box.getInt("SELECTED" + i );
                        chara = chara + 1;

                        j03HRP1001.CHARA  = Integer.toString(chara);     //요구수준
                        j03HRP1001_vt.addElement(j03HRP1001);
                     }   
                }

//              수정일경우 한건도 지정이 안될수 있다. - 추가
                if( j03HRP1001_vt.size() == 0 ) {
                    j03HRP1001.OTYPE  = "T";                   // 오브젝트유형
                    j03HRP1001.OBJID  = i_sobid;               // 오브젝트 ID
                    j03HRP1001.BEGDA  = i_begda;               // 시작일
                    j03HRP1001.ENDDA  = "99991231";            // 종료일
                    j03HRP1001.RSIGN  = "A";                   // 관계사양(A, B)
                    j03HRP1001.RELAT  = "031";                 // 오브젝트간의 관계
                    j03HRP1001.SUBTY  = "A031";                // SUBTY
                    j03HRP1001.SCLAS  = "Q";                   // 관련된 오브젝트유형
                    j03HRP1001.PRIOX  = "1";                   // 우선순위      

                    j03HRP1001_vt.addElement(j03HRP1001);
                }

                ret_r         = rfc_1001.Create( user.empNo, j03HRP1001_vt );
                j03Message_vt = (Vector)ret_r.get(0);                          //작업 결과 메시지
                E_SUBRC       = (String)ret_r.get(1);                          //작업 결과 FLAG
//              error를 처리하기 위해서 입력값을 화면으로 다시 보내준다.
                if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 || i_sobid.equals("") || i_sobid.equals("00000000") ) {
                  
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
//                   error 발생 여부                                    
                   req.setAttribute("i_error",         "Y");          
                   req.setAttribute("j03Message_vt",   j03Message_vt);
                      
                      dest = WebUtil.JspURL+"J/J03JobCreate/J03CompetencyReqChange.jsp";
                  } else {                    
                    String msg = "msg002";
                    String url = "location.href = '" + WebUtil.ServletURL+"hris.J.J03JobCreate.J03CompetencyReqDetailSV?OBJID="+i_objid+"&SOBID="+i_sobid+"&i_link_chk="+i_link_chk+"&BEGDA="+i_begda+"&IMGIDX=2';";
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
