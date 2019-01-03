/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ���޿�                                                      */
/*   Program Name : ���޿�                                                      */
/*   Program ID   : D08RetroDetailSV_m                                          */
/*   Description  : ���μұ޳����� ���� �󼼳����� ��ȸ�Ͽ� ���� �Ѱ��ִ� class */
/*   Note         :                                                             */
/*   Creation     : 2002-01-23  �ֿ�ȣ                                          */
/*   Update       : 2005-01-18  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.D.D08RetroDetailData;
import hris.D.rfc.*;
import hris.common.WebUserData;
 

public class D08RetroDetailSV_m extends EHRBaseServlet_m {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String dest    = "";
            String jobid_m = "";
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Box box = WebUtil.getBox(req);
            //  ���޿���ȸ���� �Ѱܹ���
            String year1  = box.get("year1");
            String month1 = box.get("month1");
            //---4�� 12�� ����----
            String ocrsn1 = box.get("ocrsn1");
            //--------------------
            String year = year1 + month1;

            D08RetroDetailRFC  rfc   = null;
            D08RetroDetailData data  = new D08RetroDetailData();//ó�� ������ ����Ÿ
            D08RetroDetailData data1 = new D08RetroDetailData();//�����ұޱݾ��� ���� ���� ������
            D08RetroDetailData data2 = new D08RetroDetailData();//���޼ұޱݾ��� ���� ���� ������
            D08RetroDetailData data3 = new D08RetroDetailData();//��ü�ش���߿��� �ϴϾ��� ��󳻱����� ������
            D08RetroDetailData data4 = new D08RetroDetailData();//��ü�ش���߿��� �ϴϾ��� ��󳻱����� ������
            D08RetroDetailData data5 = new D08RetroDetailData();//

            Vector D08RetroDetailData_vt  = null;
            Vector D08RetroDetailData1_vt = new Vector();//���������� ���� ����
            Vector D08RetroDetailData2_vt = new Vector();//���޳����� ���� ����
            Vector D08RetroDetailData3_vt = new Vector();//��ü�ش���� 1������ ���� ����

            int sum1 = 0;
            int sum2 = 0;

            if ( user_m != null ) {
                // D08RetroDetailRFC ���μұ޳��� ��ȸ
                rfc = new D08RetroDetailRFC();
                // 4�� 12�� ��������. �޿����¸� �߰��� �Ѱ���.
                D08RetroDetailData_vt = rfc.getRetroDetail(user_m.empNo, year, ocrsn1, user_m.area);
                //��ü�ش���� 1������ ���� ����
                
                if ( D08RetroDetailData_vt.size() == 0 ) {
                    Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";
                    printJspPage(req, res, dest);
                }
                
                data5 = (D08RetroDetailData)D08RetroDetailData_vt.get(0);
                D08RetroDetailData3_vt.addElement(data5);
                
                for( int i = 1 ; i < D08RetroDetailData_vt.size() ; i++ ) {
                    data3 = (D08RetroDetailData)D08RetroDetailData_vt.get(i-1);
                    data4 = (D08RetroDetailData)D08RetroDetailData_vt.get(i);
                    
                    if( ! data3.FPPER.equals(data4.FPPER) || ! data3.OCRSN.equals(data4.OCRSN)  ) {
                        D08RetroDetailData3_vt.addElement(data4);
                    }
                }
                Logger.debug.println(this, "D08RetroDetailData3_vt : "+ D08RetroDetailData3_vt.toString());
                
                //���������� ���޳����� �����ؼ� ���Ϳ� ����
                for( int i = 0 ; i < D08RetroDetailData_vt.size() ; i++ )
                {
                    data = (D08RetroDetailData)D08RetroDetailData_vt.get(i);
                    // GUBUN CODE�� 1�̸� ����  2�̸� ����
                    if( data.GUBUN.equals("1") ) {
                        D08RetroDetailData1_vt.addElement(data);
                    }else if( data.GUBUN.equals("2") ) {
                        D08RetroDetailData2_vt.addElement(data);
                    }
                }
                //�����ұ� �ݾ��� ���� ��� ����
                for( int i = 0 ; i < D08RetroDetailData1_vt.size() ; i++ ){
                    
                    data1 = (D08RetroDetailData)D08RetroDetailData1_vt.get(i);
                    sum1 += Double.parseDouble(data1.SOGUP_AMNT);
                }
                Logger.debug.println(this, "SUM1 : "+ sum1);
                //���޼ұ� �ݾ��� ��� ����
                for( int i = 0 ; i < D08RetroDetailData2_vt.size() ; i++ ) {
                    
                    data2 = (D08RetroDetailData)D08RetroDetailData2_vt.get(i);
                    sum2 += Double.parseDouble(data2.SOGUP_AMNT);
                }
                
                Logger.debug.println(this, "SUM2 : "+ sum2);
            } //  if ( user_m != null ) end

            if ( D08RetroDetailData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
            } else {
                Logger.debug.println(this, "D08RetroDetailData_vt : "+ D08RetroDetailData_vt.toString());
                Logger.debug.println(this, "D08RetroDetailData_vt.size : "+ D08RetroDetailData_vt.size());
                Logger.debug.println(this, "D08RetroDetailData1_vt : "+ D08RetroDetailData1_vt.toString());
                Logger.debug.println(this, "D08RetroDetailData1_vt.size : "+ D08RetroDetailData1_vt.size());
                Logger.debug.println(this, "D08RetroDetailData2_vt : "+ D08RetroDetailData2_vt.toString());
                Logger.debug.println(this, "D08RetroDetailData2_vt.size : "+ D08RetroDetailData2_vt.size());

                req.setAttribute("D08RetroDetailData_vt", D08RetroDetailData_vt);
                req.setAttribute("D08RetroDetailData1_vt", D08RetroDetailData1_vt);
                req.setAttribute("D08RetroDetailData2_vt", D08RetroDetailData2_vt);
                req.setAttribute("total1", Integer.toString(sum1));
                req.setAttribute("total2", Integer.toString(sum2));
                req.setAttribute("D08RetroDetailData3_vt", D08RetroDetailData3_vt);

                dest = WebUtil.JspURL+"D/D08RetroDetail_m.jsp";
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