package servlet.hris.D.D11TaxAdjust;

import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.db.*;
import hris.common.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;
/**
 * D11TaxAdjustEduSV.java
 * �������� - Ư������ ������ ��û/����/��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2002/11/20
 */
public class D11TaxAdjustEduSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession              session    = req.getSession(false);
            WebUserData              user       = (WebUserData)session.getAttribute("user");
            Box                      box        = WebUtil.getBox(req);
            
            D11TaxAdjustEduRFC       rfc        = new D11TaxAdjustEduRFC();
            D11TaxAdjustYearCheckRFC rfc_o      = new D11TaxAdjustYearCheckRFC();
            D11TaxAdjustHouseHoleCheckRFC   rfcHS      = new D11TaxAdjustHouseHoleCheckRFC();
            Vector                   edu_vt     = new Vector(); 

            String                   dest       = "";
            String                   jobid      = "";
            String                   targetYear = box.get("targetYear");
            String                   flag       = "";
            String                   o_flag     = "";

            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            
            if(jobid.equals("first")){
              
                flag   = rfc.getE_FLAG( user.empNo, targetYear );
                edu_vt = rfc.getEdu( user.empNo, targetYear );

//              2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                 // if( flag.equals("X") ) {          // ��ȸ
                if( edu_vt != null && edu_vt.size() > 0 ) {    // ��ȸ
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduDetail.jsp";
                } else {                          // �ű�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduBuild.jsp";
                }

                req.setAttribute( "rowCount"  , "8"        );
                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"    , edu_vt     );
                req.setAttribute( "flag"      , flag       );
                req.setAttribute( "o_flag"    , o_flag     );
                
            } else if(jobid.equals("build")){
              
                int rowCount = box.getInt("rowCount");
                for( int i = 0 ; i < rowCount ; i++ ) {
                    D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
                    String          idx             = Integer.toString(i);

                    data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // �������� ����               
                    data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // �����ڵ�                        
                    data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // ���� �ؽ�Ʈ                     
                    data.SUBTY      = box.get("SUBTY"+idx)     ;   // �Ϻ�����                        
                    data.STEXT      = box.get("STEXT"+idx)     ;   // �Ϻ������̸�                    
                    data.ENAME      = box.get("ENAME"+idx)     ;   // ��� �Ǵ� �������� �����̸�     
                    data.REGNO      = box.get("REGNO"+idx)     ;   // �ֹε�Ϲ�ȣ                    
                    data.FASAR      = box.get("FASAR"+idx)     ;   // ������������ �з�               
                    data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR �޿�����: �ݾ�               
                    data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR �޿�����: �ݾ�               
                    data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR �޿�����: �ݾ�               
                    data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // �ڵ��г���                      
                    data.GOJE_FLAG  = box.get("GOJE_FLAG")     ;   // �÷���                          
                    data.FTEXT      = box.get("FTEXT"+idx)     ;   // �ʵ��ؽ�Ʈ                      
                    data.FLAG       = box.get("FLAG"+idx)      ;    
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2����û��������
                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //���� �÷���
                    data.EXSTY    = box.get("EXSTY"+idx); //@2011 �������Ժ��
                  
                    edu_vt.addElement(data);
                }
                
                rfc.change( user.empNo, targetYear, edu_vt );

                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);
                String msg = "msg007";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustEduSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";
                
            } else if(jobid.equals("change_first")){
              
                edu_vt = rfc.getEdu( user.empNo, targetYear );
                
                dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduChange.jsp";
                
                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"    , edu_vt     );
                req.setAttribute( "rowCount"  , "8"        );
                
            } else if(jobid.equals("change")){
              
                int rowCount = box.getInt("rowCount");
                for( int i = 0 ; i < rowCount ; i++ ) {
                    D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
                    String          idx             = Integer.toString(i);

                    data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // �������� ����               
                    data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // �����ڵ�                        
                    data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // ���� �ؽ�Ʈ                     
                    data.SUBTY      = box.get("SUBTY"+idx)     ;   // �Ϻ�����                        
                    data.STEXT      = box.get("STEXT"+idx)     ;   // �Ϻ������̸�                    
                    data.ENAME      = box.get("ENAME"+idx)     ;   // ��� �Ǵ� �������� �����̸�     
                    data.REGNO      = box.get("REGNO"+idx)     ;   // �ֹε�Ϲ�ȣ                    
                    data.FASAR      = box.get("FASAR"+idx)     ;   // ������������ �з�               
                    data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR �޿�����: �ݾ�               
                    data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR �޿�����: �ݾ�               
                    data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR �޿�����: �ݾ�               
                    data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // �ڵ��г���                      
                    data.GOJE_FLAG  = box.get("GOJE_FLAG")     ;   // �÷���                          
                    data.FTEXT      = box.get("FTEXT"+idx)     ;   // �ʵ��ؽ�Ʈ                      
                    data.FLAG       = box.get("FLAG"+idx)      ;    
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2����û��������
                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //���� �÷���
                    data.EXSTY    = box.get("EXSTY"+idx); //@2011 �������Ժ��

                    edu_vt.addElement(data);
                }
                
                rfc.change( user.empNo, targetYear, edu_vt );
                String FSTID     = box.get("FSTID")      ;    //������üũ����
                rfcHS.build(user.empNo,targetYear,targetYear+"0101",targetYear+"1231",FSTID);
                req.setAttribute( "rowCount"  , "8"        );

                String msg = "msg002";
                String url = "location.href = '" + WebUtil.ServletURL+"hris.D.D11TaxAdjust.D11TaxAdjustEduSV?targetYear="+targetYear+"';";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                
                dest = WebUtil.JspURL+"common/msg.jsp";
            } else if(jobid.equals("AddorDel")){

                int    edu_count = box.getInt("edu_count");
                String curr_job   = box.getString("curr_job");
                String rowCount   = box.getString("rowCount");      //@v1.2

//              2002.12.04. �������� Ȯ������ ��ȸ
                o_flag = rfc_o.getO_FLAG( user.empNo, targetYear );

                for( int i = 0 ; i < edu_count ; i++ ) {
                	D11TaxAdjustDeductData data = new D11TaxAdjustDeductData();
                    String idx = Integer.toString(i);

                    data.SUBTY = box.get("SUBTY"+idx)   ;   // ���� ����
                    String GOJE_FLAG = box.get("GOJE_FLAG");
                    if ( GOJE_FLAG.equals("")  ) {
                    	 data.GOJE_FLAG = "1"   ;   // ���� ���� 
                    }                   
                    else            
                        data.GOJE_FLAG  = GOJE_FLAG;   // �÷���                     
                    
                    if ( data.SUBTY.equals("") || data.SUBTY.equals(" ") ) {
                        continue;
                    }
                    if( box.get("use_flag"+idx).equals("N") ) continue; // 

                    data.GUBN_CODE  = box.get("GUBN_CODE"+idx) ;   // �������� ����               
                    data.GOJE_CODE  = box.get("GOJE_CODE"+idx) ;   // �����ڵ�                        
                    data.GUBN_TEXT  = box.get("GUBN_TEXT"+idx) ;   // ���� �ؽ�Ʈ                     
                    data.SUBTY      = box.get("SUBTY"+idx)     ;   // �Ϻ�����                        
                    data.STEXT      = box.get("STEXT"+idx)     ;   // �Ϻ������̸�                    
                    data.ENAME      = box.get("ENAME"+idx)     ;   // ��� �Ǵ� �������� �����̸�     
                    data.REGNO      = box.get("REGNO"+idx)     ;   // �ֹε�Ϲ�ȣ                    
                    data.FASAR      = box.get("FASAR"+idx)     ;   // ������������ �з�               
                    data.ADD_BETRG  = box.get("ADD_BETRG"+idx) ;   // HR �޿�����: �ݾ�               
                    data.ACT_BETRG  = box.get("ACT_BETRG"+idx) ;   // HR �޿�����: �ݾ�               
                    data.AUTO_BETRG = box.get("AUTO_BETRG"+idx);   // HR �޿�����: �ݾ�               
                    data.AUTO_TEXT  = box.get("AUTO_TEXT"+idx) ;   // �ڵ��г���                
                    data.FTEXT      = box.get("FTEXT"+idx)     ;   // �ʵ��ؽ�Ʈ                      
                    data.FLAG       = box.get("FLAG"+idx)      ;    
                    data.CHNTS      = box.get("CHNTS"+idx)    ;   // @v1.2����û��������
                    data.OMIT_FLAG    = box.get("OMIT_FLAG"+idx); //���� �÷���
                    data.EXSTY    = box.get("EXSTY"+idx); //@2011 �������Ժ��

                    edu_vt.addElement(data);
                }

                req.setAttribute( "targetYear", targetYear );
                req.setAttribute( "edu_vt"   , edu_vt    );
                req.setAttribute( "o_flag"    , o_flag     );
                req.setAttribute( "rowCount"  , rowCount );

                if ( curr_job.equals("build") ) {    // �Է�ȭ��
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduBuild.jsp";
                } else {                             // �Է�
                    dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustEduChange.jsp";
                }

            } else {
              
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
                
            }
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}