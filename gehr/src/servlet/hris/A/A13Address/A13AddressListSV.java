package	servlet.hris.A.A13Address;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.rfc.A13AddressListRFC;
import hris.A.A13Address.rfc.A13AddressTypeRFC;
import hris.common.WebUserData;
import org.springframework.web.bind.ServletRequestUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Vector;

/**
 * A13AddressListSV.java
 * 을 할수 있도록 하는 Class
 *
 * @author 김도신   
 * @version 1.0, 2001/12/26
 * //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
 */
public class A13AddressListSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

        try{
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String subty = "";

            Box box = WebUtil.getBox(req, user);
            box.put("I_PERNR", user.empNo);
            String jobid = box.get("jobid", "first");

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            Vector a13AddressListData_vt = null;
            
            if( jobid.equals("first") ) {           //제일처음 신청 화면에 들어온경우.
                a13AddressListData_vt = (new A13AddressListRFC()).getAddressList(box);

                req.setAttribute("a13AddressListData_vt", a13AddressListData_vt);

                //입력 가능 지역
                if( a13AddressListData_vt.size() == 0 && Arrays.asList("KR", "CN", "TW", "HK").contains(user.area.name())) {
//                    dest = WebUtil.JspURL+"A/A13Address/A13AddressBuild_" + user.area + ".jsp";
                    dest = WebUtil.ServletURL+"hris.A.A13Address.A13AddressBuildSV";
                } else {
                    req.setAttribute("a13AddressTypeData_vt", (new A13AddressTypeRFC()).getAddressType(user.area.getMolga()));
                    dest = WebUtil.JspURL+"A/A13Address/A13AddressList.jsp";
                }

            } else if( jobid.equals("detail") ) {   //처음 화면에서 조회버튼을 누른경우.
                a13AddressListData_vt = (new A13AddressListRFC()).getAddressList(box);

                req.setAttribute("resultData", Utils.indexOf(a13AddressListData_vt, ServletRequestUtils.getIntParameter(req, "idx", 0)));
              
                //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
                if(user.area.equals(Area.MX)){
                	dest = WebUtil.JspURL+"A/A13Address/A13AddressDetail_US.jsp";
                }else{
                	dest = WebUtil.JspURL+"A/A13Address/A13AddressDetail_" + user.area + ".jsp";
                }
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
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