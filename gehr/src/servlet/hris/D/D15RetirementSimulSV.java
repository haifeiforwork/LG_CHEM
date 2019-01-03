package servlet.hris.D;

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;
import hris.D.*;
import hris.D.rfc.*;
import hris.D.D09Bond.rfc.*;

/**
 * D15RetirementSimulSV.java
 * �����ݼҵ���� Simulation �� �� �ֵ��� �ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/02/06
 * @update 2014/11/27 [CSR ID:2651601] E-HR ������ �ùķ��̼� �޴� ���� 
 */
public class D15RetirementSimulSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="";            // ���� ����Ÿ��(�����ݼҵ����)
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession  session = req.getSession(false);
            WebUserData  user    = (WebUserData)session.getAttribute("user");
            Box          box     = WebUtil.getBox(req);

            double G_REST_AMNT   = 0.0 ;  // ä�ǰ��з� �ܾ� ��
            double G_O_BONDM     = 0.0 ;  // ä�ǰ��з� ����
            
            D09BondListRFC func1 = new D09BondListRFC();
            
            String dest       = "";
            String jobid      = "";
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            D15RetirementSimulRFC   simulRfc  = new D15RetirementSimulRFC();
            D15RetirementSimulData  d15RetirementSimulData = null;

            // �����޿�,��������(?),�ټӳ�� ���� �����´�.
            String retireDate = box.get("fu_retireDate");
            if(retireDate.equals("")){
                retireDate = DataUtil.getCurrentDate();
            }
            d15RetirementSimulData = (D15RetirementSimulData)simulRfc.getRetirementData( user.empNo, retireDate );
            d15RetirementSimulData.fu_retireDate = retireDate ;
            
//          ===========================================================================================
//          2002.06.20. ä�ǰ��з� ���� = [ ������ �Ѿ�
//                                      - (�������ټ� + �����ֹμ� + ������ȯ�� + (????????������Ư��)) ] / 2
//          ä�ǰ��з� �ݾ��� ���� �ݾ� �ܾ׺��� ������ : ä�ǰ��з� �ܾ��� ������.
//                                               ũ��   : ���� �ݾ��� ������.
//          ===========================================================================================
//          G_REST_AMNT - ZHRP_RFC_BOND_PRESENTSTATE - ä�ǰ��з� �ܾ� ��
            G_REST_AMNT = Double.parseDouble( func1.getG_REST_AMNT( user.empNo ) ) ;
            
//          2002.07.23. ������ ä�ǰ��з��� ������ �ݾ��� �Ѱ��༭ ��꿡 �ݿ��Ѵ�.
//                      RFC ��ǿ����� RT���� ä�ǰ��з��� ������ ������ �ݾ��� üũ���� ���Ѵ�.
            // �ùķ��̼� ����
            Logger.debug.println(this,"Before Simulation for Retirement : "+d15RetirementSimulData.toString());
            d15RetirementSimulData.O_BONDM = Double.toString( G_REST_AMNT );
            d15RetirementSimulData = (D15RetirementSimulData)simulRfc.simulate(d15RetirementSimulData);
            Logger.debug.println(this,"After Simulation for Retirement : "+d15RetirementSimulData.toString());
//-------------------------------------------------------------------------------------------------------------                
            
            if( G_REST_AMNT > 0 ) {
                G_O_BONDM = ( Double.parseDouble(d15RetirementSimulData.GRNT_RSGN)
                                                         - (Double.parseDouble(d15RetirementSimulData._�������ټ�) 
                                                         +  Double.parseDouble(d15RetirementSimulData._�����ֹμ�)
                                                         +  Double.parseDouble(d15RetirementSimulData.O_NAPPR)) ) / 2; 
                if( G_REST_AMNT < G_O_BONDM ) {
                    G_O_BONDM = G_REST_AMNT;
                }
                
                d15RetirementSimulData.O_BONDM = Double.toString(G_O_BONDM);
            } else {
                d15RetirementSimulData.O_BONDM = "0";
            }

//          2002.09.03. ���� ä�ǰ��з� �������� ������ �����Ѿ��� ���� ���ϱ����ؼ� simulate�� �ѹ� �� ȣ���Ѵ�.
//                      �Ŀ� �߰��� �������� �����ϱ� �����Ͽ� �ӽ÷� �ٽ� �ѹ� ȣ����.
            Logger.debug.println(this,"Before Simulation for Retirement : "+d15RetirementSimulData.toString());
            d15RetirementSimulData = (D15RetirementSimulData)simulRfc.simulate(d15RetirementSimulData);
            Logger.debug.println(this,"After Simulation for Retirement : "+d15RetirementSimulData.toString());
//          2002.09.03. ���� ä�ǰ��з� �������� ������ �����Ѿ��� ���� ���ϱ����ؼ� simulate�� �ѹ� �� ȣ���Ѵ�.
            
            req.setAttribute( "d15RetirementSimulData", d15RetirementSimulData);
            
            //20141127 [CSR ID:2651601] E-HR ������ �ùķ��̼� �޴� ���� 
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(user.empNo);
            req.setAttribute("PersonData" , phonenumdata );

            dest = WebUtil.JspURL+"D/D15RetirementSimul.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
