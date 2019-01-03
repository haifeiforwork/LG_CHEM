package servlet.hris.E.E17Hospital;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.E.E17Hospital.E17BillData;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.E17GuenCodeRFC;
import hris.E.E17Hospital.rfc.E17HospitalRFC;
import hris.common.AppLineData;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


/**
 * E17BillControlSV.java
 * ������꼭�� �ۼ�/����/����/����Ʈ �Ҽ� �ֵ��� �ϴ� Class
 *
 * @author �輺��   
 * @version 1.0, 2002/01/10
 */
public class E17BillControlSV extends EHRBaseServlet {

    private String UPMU_TYPE ="03";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest        = "";
            String jobid       = "";
            String fromJsp     = "";
            String radio_index = "";
            String ThisJspName = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            fromJsp     = box.get("fromJsp");
            radio_index = box.get("radio_index");
            ThisJspName = box.get("ThisJspName");

//////////////////////////////////////////////////////////////////////////////////////////////////// 2005.05.31
//          �ڳฮ��Ʈ ��ȸ - ��� jobid�� ���� ���������� ������ �ٴϴ� ��������� ����Ʈ�� �Ź� ��ȸ��.
            Vector         E17ChildData_vt = new Vector();
            E17GuenCodeRFC child_rfc       = new E17GuenCodeRFC();
           
            E17ChildData_vt = child_rfc.getChildList( user.empNo );
            
            req.setAttribute("E17ChildData_vt", E17ChildData_vt);
//////////////////////////////////////////////////////////////////////////////////////////////////// 2005.05.31

            if( jobid.equals("detail_first") ) {

                int radio_inx = box.getInt("radio_index"); // ������ư �ε����� �ƴ϶� ��꼭���� �ε����� �޴´�.
                // �����
                E17BillData e17BillData = new E17BillData();
                
                String      idx         = Integer.toString(radio_inx);

                e17BillData.AINF_SEQN = box.get("AINF_SEQN"    );    // ������ȣ           
                e17BillData.CTRL_NUMB = box.get("CTRL_NUMB"+idx);    // ������ȣ           
                e17BillData.RCPT_NUMB = box.get("x_RCPT_NUMB"+idx);    // ��������ȣ   
                e17BillData.TOTL_WONX = box.get("TOTL_WONX"+idx);    // �� �����          
                e17BillData.ASSO_WONX = box.get("ASSO_WONX"+idx);    // ���� �δ��        
                e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+idx);    // ���� �δ��        
                e17BillData.MEAL_WONX = box.get("MEAL_WONX"+idx);    // �Ĵ�               
                e17BillData.APNT_WONX = box.get("APNT_WONX"+idx);    // ���� �����        
                e17BillData.ROOM_WONX = box.get("ROOM_WONX"+idx);    // ��� ���Ƿ� ����   
                e17BillData.CTXX_WONX = box.get("CTXX_WONX"+idx);    // C T �˻��         
                e17BillData.MRIX_WONX = box.get("MRIX_WONX"+idx);    // M R I �˻��       
                e17BillData.SWAV_WONX = box.get("SWAV_WONX"+idx);    // ������ �˻��
                e17BillData.DISC_WONX = box.get("DISC_WONX"+idx);    // ���αݾ�
                e17BillData.ETC1_WONX = box.get("ETC1_WONX"+idx);    // ��Ÿ1 �� �ݾ�      
                e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+idx);    // ��Ÿ1 �� �׸��    
                e17BillData.ETC2_WONX = box.get("ETC2_WONX"+idx);    // ��Ÿ2 �� �ݾ�      
                e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+idx);    // ��Ÿ2 �� �׸��    
                e17BillData.ETC3_WONX = box.get("ETC3_WONX"+idx);    // ��Ÿ3 �� �ݾ�      
                e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+idx);    // ��Ÿ3 �� �׸��    
                e17BillData.ETC4_WONX = box.get("ETC4_WONX"+idx);    // ��Ÿ4 �� �ݾ�      
                e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+idx);    // ��Ÿ4 �� �׸��    
                e17BillData.ETC5_WONX = box.get("ETC5_WONX"+idx);    // ��Ÿ5 �� �ݾ�      
                e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+idx);    // ��Ÿ5 �� �׸��
                e17BillData.WAERS     = box.get("WAERS"+idx);        // ��ȭŰ

                Logger.debug.println(this, e17BillData.toString());

                req.setAttribute("e17BillData" , e17BillData);

                dest = WebUtil.JspURL+"E/E17Hospital/E17BillDetail.jsp";

            } else if( jobid.equals("print_bill") ) {               //��â���

                String AINF_SEQN = box.get("AINF_SEQN");
                String RCPT_NUMB = box.get("RCPT_NUMB");
                
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.E.E17Hospital.E17BillControlSV?jobid=print&AINF_SEQN="+AINF_SEQN+"&RCPT_NUMB="+RCPT_NUMB);
                dest = WebUtil.JspURL+"common/printFrame.jsp";

            } else if( jobid.equals("print") ) {

                E17HospitalRFC      rfc                 = new E17HospitalRFC();
                E17BillData         e17BillData         = null;
                E17HospitalResultData returnAll           = null;
                Vector              E17BillData_vt      = null;
                String              AINF_SEQN           = box.get("AINF_SEQN");
                String              RCPT_NUMB           = box.get("RCPT_NUMB");

                rfc.setDetailInput(user.empNo, "3", box.get("AINF_SEQN"));
                returnAll = rfc.detail();
                Logger.debug.println(this, returnAll);

                E17BillData_vt     = returnAll.T_ZHRW006A;
               // �Ƿ�� ���ڷ�  *��û�ÿ� �߰��Ǿ�� �� �׸�� 
                
                if(E17BillData_vt.size() < 1){
                    String msg = "print �� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                    boolean flag = false;
                    for( int i = 0 ; i < E17BillData_vt.size() ; i++){
                        e17BillData = (E17BillData)E17BillData_vt.get(i);
                        if( e17BillData.RCPT_NUMB.equals(RCPT_NUMB) ){
                            flag = true;
                            break;
                        }
                    }
                    if(flag){
                        req.setAttribute("e17BillData" , e17BillData);
                        dest = WebUtil.JspURL+"E/E17Hospital/E17BillPrintPpage.jsp";

                    }else{
                        String msg = "print �� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        dest = WebUtil.JspURL+"common/msg.jsp";
                    }
                }
                
            } else if( jobid.equals("print_form") ) {               //��â���(��������)

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.E.E17Hospital.E17BillControlSV?jobid=print_form_print");
                dest = WebUtil.JspURL+"common/printFrame.jsp";

            } else if( jobid.equals("print_form_print") ) {

                dest = WebUtil.JspURL+"E/E17Hospital/E17BillPrintForm.jsp";

            } else {

                E17SickData      e17SickData        = new E17SickData();
                E17SickData      hidden_e17SickData = new E17SickData();
                Vector           E17HospitalData_vt = new Vector();
                Vector           E17BillData_vt     = new Vector();
                Vector           AppLineData_vt     = new Vector();

                // �Ƿ�� ���ڷ�  *��û�ÿ� �߰��Ǿ�� �� �׸�� 
                box.copyToEntity(e17SickData);
                
                hidden_e17SickData.CTRL_NUMB  = box.get("hidden_CTRL_NUMB");    //
                hidden_e17SickData.SICK_NAME  = box.get("hidden_SICK_NAME");    //
                hidden_e17SickData.GUEN_CODE  = box.get("hidden_GUEN_CODE");    //
                hidden_e17SickData.SICK_DESC1 = box.get("hidden_SICK_DESC1");    //
                hidden_e17SickData.SICK_DESC2 = box.get("hidden_SICK_DESC2");    //
                hidden_e17SickData.SICK_DESC3 = box.get("hidden_SICK_DESC3");    //
                hidden_e17SickData.SICK_DESC4 = box.get("hidden_SICK_DESC4");    //

                // �Ƿ��
                int rowcount_hospital = box.getInt("RowCount_hospital");
                for( int i = 0; i < rowcount_hospital; i++) {
                    E17HospitalData e17HospitalData = new E17HospitalData();
                    String          idx             = Integer.toString(i);

                    if( box.get("use_flag"+idx).equals("N") ) continue;
                    e17HospitalData.CTRL_NUMB = box.get("CTRL_NUMB"    );    // ������ȣ           
                    e17HospitalData.MEDI_NAME = box.get("MEDI_NAME"+idx);    // �Ƿ���           
                    e17HospitalData.TELX_NUMB = box.get("TELX_NUMB"+idx);    // ��ȭ��ȣ           
                    e17HospitalData.EXAM_DATE = box.get("EXAM_DATE"+idx);    // ������             
                    e17HospitalData.MEDI_CODE = box.get("MEDI_CODE"+idx);    // �Կ�/�ܷ�          
                    e17HospitalData.MEDI_TEXT = box.get("MEDI_TEXT"+idx);    // �Կ�/�ܷ�          
                    e17HospitalData.RCPT_CODE = box.get("RCPT_CODE"+idx);    // ������ ����        
                    e17HospitalData.RCPT_TEXT = box.get("RCPT_TEXT"+idx);    // ������ ����        
                    e17HospitalData.RCPT_NUMB = box.get("RCPT_NUMB"+idx);    // No. ��������ȣ     
                    e17HospitalData.EMPL_WONX = box.get("EMPL_WONX"+idx);    // ���� �ǳ��ξ�      
//                  2004�� �������� ���� ����ڵ�Ϲ�ȣ �ʵ� �߰� (3.7)
                    e17HospitalData.MEDI_NUMB = box.get("MEDI_NUMB"+idx);    // �Ƿ��� ����ڵ�Ϲ�ȣ

                    E17HospitalData_vt.addElement(e17HospitalData);
                }
                
                // �����
                //int rowcount_report = box.getInt("RowCount_report");
                int rowcount_report = box.getInt("RowCount_hospital");
                for( int i = 0; i < rowcount_report; i++) {
                    E17BillData e17BillData = new E17BillData();
                    String      idx         = Integer.toString(i);

                    e17BillData.CTRL_NUMB = box.get("CTRL_NUMB"    );    // ������ȣ           
                    e17BillData.RCPT_NUMB = box.get("x_RCPT_NUMB"+idx);    // ��������ȣ   
                    e17BillData.TOTL_WONX = box.get("TOTL_WONX"+idx);    // �� �����          
                    e17BillData.ASSO_WONX = box.get("ASSO_WONX"+idx);    // ���� �δ��        
                    e17BillData.EMPL_WONX = box.get("x_EMPL_WONX"+idx);    // ���� �δ��        
                    e17BillData.MEAL_WONX = box.get("MEAL_WONX"+idx);    // �Ĵ�               
                    e17BillData.APNT_WONX = box.get("APNT_WONX"+idx);    // ���� �����        
                    e17BillData.ROOM_WONX = box.get("ROOM_WONX"+idx);    // ��� ���Ƿ� ����   
                    e17BillData.CTXX_WONX = box.get("CTXX_WONX"+idx);    // C T �˻��         
                    e17BillData.MRIX_WONX = box.get("MRIX_WONX"+idx);    // M R I �˻��       
                    e17BillData.SWAV_WONX = box.get("SWAV_WONX"+idx);    // ������ �˻��
                    e17BillData.DISC_WONX = box.get("DISC_WONX"+idx);    // ���αݾ�
                    e17BillData.ETC1_WONX = box.get("ETC1_WONX"+idx);    // ��Ÿ1 �� �ݾ�      
                    e17BillData.ETC1_TEXT = box.get("ETC1_TEXT"+idx);    // ��Ÿ1 �� �׸��    
                    e17BillData.ETC2_WONX = box.get("ETC2_WONX"+idx);    // ��Ÿ2 �� �ݾ�      
                    e17BillData.ETC2_TEXT = box.get("ETC2_TEXT"+idx);    // ��Ÿ2 �� �׸��    
                    e17BillData.ETC3_WONX = box.get("ETC3_WONX"+idx);    // ��Ÿ3 �� �ݾ�      
                    e17BillData.ETC3_TEXT = box.get("ETC3_TEXT"+idx);    // ��Ÿ3 �� �׸��    
                    e17BillData.ETC4_WONX = box.get("ETC4_WONX"+idx);    // ��Ÿ4 �� �ݾ�      
                    e17BillData.ETC4_TEXT = box.get("ETC4_TEXT"+idx);    // ��Ÿ4 �� �׸��    
                    e17BillData.ETC5_WONX = box.get("ETC5_WONX"+idx);    // ��Ÿ5 �� �ݾ�      
                    e17BillData.ETC5_TEXT = box.get("ETC5_TEXT"+idx);    // ��Ÿ5 �� �׸��    

                    E17BillData_vt.addElement(e17BillData);
                }
                
                // ����
                int rowcount = box.getInt("RowCount");
                for( int i = 0; i < rowcount; i++) {
                    AppLineData appLine = new AppLineData();
                    String      idx     = Integer.toString(i);

                    appLine.APPL_MANDT     = box.get("APPL_MANDT"+idx); 
                    appLine.APPL_BUKRS     = box.get("APPL_BUKRS"+idx); 
                    appLine.APPL_AINF_SEQN = box.get("APPL_AINF_SEQN" +idx); 
                    appLine.APPL_BEGDA     = box.get("APPL_BEGDA"+idx); 
                    appLine.APPL_UPMU_FLAG = box.get("APPL_UPMU_FLAG"+idx); 
                    appLine.APPL_UPMU_TYPE = box.get("APPL_UPMU_TYPE"+idx); 
                    appLine.APPL_APPU_NUMB = box.get("APPL_APPU_NUMB"+idx); 
                                                               
                    appLine.APPL_APPR_TYPE = box.get("APPL_APPR_TYPE"+idx); 
                    appLine.APPL_APPU_TYPE = box.get("APPL_APPU_TYPE"+idx); 
                    appLine.APPL_APPU_NAME = box.get("APPL_APPU_NAME"+idx); 
                    appLine.APPL_APPR_SEQN = box.get("APPL_APPR_SEQN"+idx); 
                    appLine.APPL_PERNR     = box.get("APPL_PERNR"+idx); 
                    appLine.APPL_ENAME     = box.get("APPL_ENAME"+idx); 
                    appLine.APPL_ORGTX     = box.get("APPL_ORGTX"+idx); 
                    appLine.APPL_TITEL     = box.get("APPL_TITEL"+idx); 
                    appLine.APPL_TITL2     = box.get("APPL_TITL2"+idx); 
                    appLine.APPL_OTYPE     = box.get("APPL_OTYPE"+idx); 
                    appLine.APPL_OBJID     = box.get("APPL_OBJID"+idx); 
                    appLine.APPL_STEXT     = box.get("APPL_STEXT"+idx); 
                    appLine.APPL_APPR_DATE = box.get("APPL_APPR_DATE"+idx); 
                    appLine.APPL_APPR_STAT = box.get("APPL_APPR_STAT"+idx);
                    appLine.APPL_TELNUMBER = box.get("APPL_TELNUMBER"+idx); 

                    AppLineData_vt.addElement(appLine);
                }
                Logger.debug.println(this, AppLineData_vt.toString());

                req.setAttribute("last_RCPT_NUMB"    , box.get("last_RCPT_NUMB") );
//                req.setAttribute("P_Flag"            , box.get("P_Flag") );
                req.setAttribute("COMP_sum"          , box.get("COMP_sum") );
                
                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("hidden_e17SickData", hidden_e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
                req.setAttribute("AppLineData_vt"    , AppLineData_vt);
                req.setAttribute("fromJsp"           , fromJsp);
                req.setAttribute("radio_index"       , radio_index);
                req.setAttribute("ThisJspName"       , ThisJspName);

                if( jobid.equals("build_first") ) {
                    dest = WebUtil.JspURL+"E/E17Hospital/E17BillBuild.jsp";
                } else if( jobid.equals("change_first") ) {
                    dest = WebUtil.JspURL+"E/E17Hospital/E17BillChange.jsp";
                } else if( jobid.equals("back_fromJsp") ) {
                    dest = WebUtil.JspURL+"E/E17Hospital/" + fromJsp;
                } else {
                    throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
                }
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}