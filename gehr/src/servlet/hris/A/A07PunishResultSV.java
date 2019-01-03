package	servlet.hris.A;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
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
 * PunishSV.java
 * 징계정보를 jsp로 넘겨주는 class
 *
 * @author 이형석
 * @version 1.0, 2001/12/13
 */
public class A07PunishResultSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String jobid = "";
            String dest  = "";

            A07PunishResultRFC func = null;
            Vector PunishData_vt    = new Vector();

            //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH
            MappingPernrRFC  mapfunc = null ;
            MappingPernrData mapData = new MappingPernrData();
            Vector mapData_vt = new Vector() ;
            Vector puData_vt  = new Vector() ;

            mapfunc    = new MappingPernrRFC() ;
            mapData_vt = mapfunc.getPernr( user.empNo ) ;

            if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
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
                PunishData_vt = func.getPunish(user.empNo, "");
            }

            Logger.debug.println(this, "PunishData_vt : "+ PunishData_vt.toString());
            req.setAttribute("PunishData_vt", PunishData_vt);
            dest = WebUtil.JspURL+"A/A07ReprimandDetail.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
