package	servlet.hris.A.A21ExecutivePledge;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A10Annual.A10AnnualData;
import hris.A.A10Annual.rfc.A10AnnualRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A21EPViewSV.java
 * �ӿ����� ���༭�� ��ȸ �� �� �ֵ��� �ϴ� Class
 *
 * @author ������
 * @version 1.0, 2016-03-09      [CSR ID:3006173] �ӿ� ������༭ Onlineȭ�� ���� �ý��� ���� ��û
 *                   : 2017-04-07      eunha [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��
 */
public class A21EPViewSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest   = "";

            Logger.debug.println(this, " [user] : "+user.toString() );

            String ZYEAR = DataUtil.getCurrentYear(); //�÷��� �߰�
            int    year  = Integer.parseInt(ZYEAR);

//          2003.01.02. - 03�� �����ϰ�� �۳� ������༭�� �����ش�.
            String ZMONTH = DataUtil.getCurrentMonth();
            int    month  = Integer.parseInt(ZMONTH);
            if( month < 3 ) {
                year = year - 1;
            }

            Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user.empNo );//���, ���糯¥
            if ( A10AnnualData_vt.size() == 0 ) {
                Logger.debug.println(this, "Data Not Found");
                String msg = "msg004";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
            } else {
                //�ش翬���� ������ �ִ��� �������� �˻�
//                for( int i = 0; i < A10AnnualData_vt.size(); i++ ){
//                  2003.04.15 - ���� �ֱ��� ������ ��ȸ�Ѵ�.
                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(0);
                    year = Integer.parseInt(data.ZYEAR);
//                if( year == Integer.parseInt( data.ZYEAR ) ){

//                        if( (data.BETRG).equals("0.0") ){
//                            year = year - 1;
//                        }
//                    }
//                }
                ZYEAR = year+"";
              //2017-04-07    eunha  [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��(local�ϵ��ڵ�����) start
               // if(WebUtil.isLocal(req)) ZYEAR = "2016";
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A21ExecutivePledge.A21EPListSV?jobid=print&ZYEAR="+ZYEAR );
                //2017-04-07    eunha  [CSR ID:3348752] �ӿ� ������� �� �����ӿ����༭ �¶��� ¡�� ���� ���� ��û�� ��(local�ϵ��ڵ�����) end
                req.setAttribute( "isPopUp", "false" );
                dest = WebUtil.JspURL+"common/printFrame.jsp";
                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A21ExecutivePledge.A21EPListSV?jobid=print&ZYEAR="+ZYEAR );
            }

            Logger.debug.println( this, " destributed = " + dest );
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}