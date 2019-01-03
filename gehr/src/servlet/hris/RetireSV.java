package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * dummy
 * Created by manyjung on 2016-12-04.
 */
public class RetireSV extends EHRBaseServlet {

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {

        String lDoc = StringUtils.defaultString(req.getParameter("lDoc"));
        String SServer = StringUtils.defaultString(req.getParameter("SServer"));

        String dest = "http://eloffice.lgchem.com:8002/intra/owa/neloinit.quick?p_user=" + lDoc + "&p_port=8002&p_svr_name=" + SServer + "&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";

        if(req.getServerName().indexOf("dev") > -1) {
            dest = "http://sundevelope.lgchem.com:8002/intra/owa/neloinit.quick?p_user=" + lDoc + "&p_port=8002&p_svr_name=" + SServer + "&p_curr_urlx=nelomenu_treelink?p_seq=20050329111111";
        } else {

        }

        redirect(res, dest);
        /*printJspPage(req, res, dest);*/
    }
}
