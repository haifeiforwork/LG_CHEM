package	servlet.hris.A.A13Address;

import com.common.constant.Area;
import com.google.common.collect.Collections2;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.WebUtil;
import hris.A.A13Address.A13AddressListData;
import hris.A.A13Address.rfc.*;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * A13AddressBuildSV.java
 * 을 할수 있도록 하는 Class
 *
 * @author 김도신   
 * @version 1.0, 2001/12/26
 */
public class A13AddressBuildSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="12";

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection con = null;

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            String jobid = "";

            Box box = WebUtil.getBox(req);
            box.put("I_PERNR", user.empNo);

            jobid = box.get("jobid", "first");
            
            String subty1 = box.get("subty1");

            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            
            Vector a13AddressListData_vt = new Vector();
            
            if( jobid.equals("first") ) {           //제일처음 입력화면에 들어온경우.
                a13AddressListData_vt = (new A13AddressListRFC()).getAddressList(box);
                req.setAttribute("a13AddressListData_vt", a13AddressListData_vt);

                req.setAttribute("subty1", subty1);

                Vector<CodeEntity> subTypeList = (new A13AddressTypeRFC()).getAddressType(user.area.getMolga());

                if(user.area == Area.KR) {
                    subTypeList = new Vector<CodeEntity>(Collections2.filter(subTypeList, new com.google.common.base.Predicate<CodeEntity>() {
                        public boolean apply(CodeEntity codeEntity) {
                            return !StringUtils.equals(codeEntity.code, "1") && !StringUtils.equals(codeEntity.code, "2");
                        }
                    }));
                    req.setAttribute ("addressLiveType", (new A13AddressLiveTypeRFC()).getAddressLiveType());
                    req.setAttribute ("addressNation", (new A13AddressNationRFC()).getAddressNation());
                } else if(user.area == Area.HK) {
                    req.setAttribute("addressType", (new A13AddressAreaTypeRFC2()).getAddressType());
                }

                req.setAttribute("subTypeList", subTypeList);
                
                printJspPage(req, res, WebUtil.JspURL+"A/A13Address/A13AddressBuild_" + user.area +".jsp");
            } else if( jobid.equals("create") ) {   //입력화면에서 저장버튼을 누른경우.
                A13AddressListRFC   rfc                   = new A13AddressListRFC();
                A13AddressListData  a13AddressListData    = new A13AddressListData();

                box.copyToEntity(a13AddressListData);

                a13AddressListData_vt.addElement(a13AddressListData);
                
                // 신청 RFC Call
                rfc.build(box, a13AddressListData_vt );

                if(rfc.getReturn().isSuccess()) {
                    moveMsgPage(req, res, "msg008", "location.href = '" + WebUtil.ServletURL + "hris.A.A13Address.A13AddressListSV';");
                } else {
                    moveMsgPage(req, res, rfc.getReturn().MSGTX, "history.back();");
                }
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } 
            
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}