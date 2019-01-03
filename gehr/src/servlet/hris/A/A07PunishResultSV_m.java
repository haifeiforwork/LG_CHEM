package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet_m;
import com.sns.jdf.util.WebUtil;
import hris.A.A07PunishResultData;
import hris.A.rfc.A07PunishResultRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A07PunishResultSV_m.java
 * ¡�������� jsp�� �Ѱ��ִ� class
 *
 * @author ������
 * 
 * ��� ����.!!!!!
 * @version 1.0, 2001/12/13
 */
public class A07PunishResultSV_m extends EHRBaseServlet_m {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid = "";
            String dest  = "";
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            A07PunishResultRFC func = null;
            Vector PunishData_vt    = new Vector();

            //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH
            MappingPernrRFC  mapfunc = null ;
            MappingPernrData mapData = new MappingPernrData();
            Vector mapData_vt = new Vector() ;
            Vector puData_vt  = new Vector() ;

            mapfunc    = new MappingPernrRFC() ;
            mapData_vt = mapfunc.getPernr( user_m.empNo ) ;

            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��
                A07PunishResultData data = new A07PunishResultData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    func      = new A07PunishResultRFC() ;
                    puData_vt = func.getPunish( mapData.PERNR , "") ;

                    for( int j = 0 ; j < puData_vt.size() ; j++ ) {
                        data = (A07PunishResultData)puData_vt.get(j);
                        PunishData_vt.addElement(data);
                    }
                }

            } else {
                func          = new A07PunishResultRFC() ;
                PunishData_vt = func.getPunish(user_m.empNo, "");
            }

            Logger.debug.println(this, "PunishData_vt : "+ PunishData_vt.toString());
            req.setAttribute("PunishData_vt", PunishData_vt);
            dest = WebUtil.JspURL+"A/A07ReprimandDetail_m.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
