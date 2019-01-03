package	servlet.hris.A.A13Address;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.A13AddressListData;
import hris.A.A13Address.rfc.A13AddressAreaTypeRFC2;
import hris.A.A13Address.rfc.A13AddressListRFC;
import hris.A.A13Address.rfc.A13AddressLiveTypeRFC;
import hris.A.A13Address.rfc.A13AddressNationRFC;
import hris.common.WebUserData;
import org.springframework.web.bind.ServletRequestUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A13AddressChangeSV.java
 * 을 할수 있도록 하는 Class
 *
 * @author 최영호   
 * @version 1.0, 2001/12/26
 */
public class A13AddressChangeSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            String subView = "";
            
            Box box = WebUtil.getBox(req);
            box.put("I_PERNR", user.empNo);

            jobid = box.get("jobid", "first");
            subView = box.get("subView");
            Vector  a13AddressListData_vt = new Vector();
   
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            if( jobid.equals("first") ) {           //제일처음 수정 화면에 들어온경우.

                a13AddressListData_vt = (new A13AddressListRFC()).getAddressList(box);

                req.setAttribute("resultData", Utils.indexOf(a13AddressListData_vt, ServletRequestUtils.getIntParameter(req, "idx", 0)));

                if(user.area == Area.KR) {
                    req.setAttribute ("addressLiveType", (new A13AddressLiveTypeRFC()).getAddressLiveType());
                    req.setAttribute ("addressNation", (new A13AddressNationRFC()).getAddressNation());
                } else if(user.area == Area.HK) {
                    req.setAttribute("addressType", (new A13AddressAreaTypeRFC2()).getAddressType());
                }
                
                req.setAttribute("idx", box.get("idx"));

                printJspPage(req, res, WebUtil.JspURL+"A/A13Address/A13AddressChange_" + user.area +".jsp");
                            
            } else if( jobid.equals("change") ) {   //수정 화면에서 저장버튼을 누른경우.
                
                A13AddressListRFC   rfc                   = new A13AddressListRFC();
                A13AddressListData  a13AddressListData    = new A13AddressListData();

                box.copyToEntity(a13AddressListData);

                a13AddressListData_vt.addElement(a13AddressListData);
                
                Logger.debug.println(this, a13AddressListData_vt.toString());

                rfc.change(box , a13AddressListData_vt);

                if(rfc.getReturn().isSuccess()) {
                    moveMsgPage(req, res, "msg002", "location.href = '" + WebUtil.ServletURL + "hris.A.A13Address.A13AddressListSV?subView=" + subView + "';");
                } else {
                    req.setAttribute("msg2", rfc.getReturn().MSGTX);
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.UPDATE.FAIL"), "history.back();");
                }
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);


        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
	}

}